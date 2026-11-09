<?php

use App\Models\PointLot;
use App\Models\User;

beforeEach(function () {
    $email = 'hana@example.com';
    $password = 'password1234';

    User::factory()->create([
        'email' => $email,
        'password' => $password,
    ]);

    $this->credentials = [
        'email' => $email,
        'password' => $password,
        'device_name' => 'test',
    ];

    $this->wrongCredentials = [...$this->credentials, 'password' => 'wrong-password'];
});

it('맞는 이메일과 비밀번호면 토큰을 돌려준다', function () {
    $this->postJson('/api/login', $this->credentials)
        ->assertOk()
        ->assertJsonStructure(['token']);
});

it('비밀번호가 틀리면 422와 안내 문구를 돌려준다', function () {
    $this->postJson('/api/login', $this->wrongCredentials)
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['email' => '이메일 또는 비밀번호가 맞지 않아요.']);
});

it('토큰이 없으면 지갑을 볼 수 없다', function () {
    $this->getJson('/api/wallet')->assertUnauthorized();
});

it('받은 토큰으로 지갑을 보고, 로그아웃하면 그 토큰은 더이상 사용할 수 없다', function () {
    $token = $this->postJson('/api/login', $this->credentials)->json('token');

    $this->withToken($token)->getJson('/api/wallet')->assertOk();
    $this->withToken($token)->postJson('/api/logout')->assertNoContent();

    // 테스트에서는 앞 요청의 로그인 정보가 남아 있어서 비워줘야 함.
    $this->app['auth']->forgetGuards();
    $this->withToken($token)->getJson('/api/wallet')->assertUnauthorized();
});

it('같은 이메일로 1분에 5번 넘게 시도하면 막는다', function () {
    foreach (range(1, 5) as $i) {
        $this->postJson('/api/login', $this->wrongCredentials)->assertUnprocessable();
    }

    $this->postJson('/api/login', $this->wrongCredentials)->assertTooManyRequests();
});

it('같은 IP라도 다른 이메일은 막지 않는다', function () {
    foreach (range(1, 5) as $i) {
        $this->postJson('/api/login', $this->wrongCredentials)->assertUnprocessable();
    }

    $this->postJson('/api/login', [...$this->wrongCredentials, 'email' => 'other@example.com'])->assertUnprocessable();
});

it('Accept 헤더 없이 요청해도 로그인 화면으로 보내지 않고 401을 리턴한다', function () {
    $this->get('/api/wallet')->assertUnauthorized();
});

it('이메일이 문자열이 아니면 500이 아니라 422를 돌려준다', function () {
    $this->postJson('/api/login', [...$this->credentials, 'email' => ['hana@example.com']])
        ->assertUnprocessable();
});

it('검증 문구를 한국어로 돌려준다', function () {
    $this->postJson('/api/login', [...$this->credentials, 'email' => 'not-an-email'])
        ->assertJsonValidationErrors(['email' => '이메일 형식이 맞지 않아요.']);
});

it('같은 IP에서 이메일을 바꿔 가며 1분에 30번 넘게 시도하면 막는다', function () {
    foreach (range(1, 30) as $i) {
        $this->postJson('/api/login', [...$this->wrongCredentials, 'email' => "user{$i}@example.com"])
            ->assertUnprocessable();
    }

    $this->postJson('/api/login', [...$this->wrongCredentials, 'email' => 'user31@example.com'])
        ->assertTooManyRequests();
});

it('탈퇴하면 개인정보를 비우고 모든 기기의 토큰을 지운다', function () {
    $token = $this->postJson('/api/login', $this->credentials)->json('token');
    $this->postJson('/api/login', [...$this->credentials, 'device_name' => 'other']);

    $this->withToken($token)->deleteJson('/api/user')->assertNoContent();

    $user = User::first();
    expect($user->name)->toBeNull()
        ->and($user->email)->toBeNull()
        ->and($user->password)->toBeNull()
        ->and($user->withdrawn_at)->not->toBeNull()
        ->and($user->tokens()->count())->toBe(0);

    // 테스트에서는 앞 요청의 로그인 정보가 남아 있어서 비워줘야 함
    $this->app['auth']->forgetGuards();
    $this->withToken($token)->getJson('/api/wallet')->assertUnauthorized();
    $this->postJson('/api/login', $this->credentials)->assertUnprocessable();
});

it('포인트 기록이 있어도 탈퇴할 수 있고 포인트 묶음은 남는다', function () {
    $user = User::first();
    PointLot::factory()->for($user)->create();
    $token = $user->createToken('test')->plainTextToken;

    $this->withToken($token)->deleteJson('/api/user')->assertNoContent();

    expect(PointLot::where('user_id', $user->id)->count())->toBe(1);
});

it('탈퇴한 회원은 토큰이 남아 있어도 쓸 수 없다', function () {
    // 탈퇴와 로그인이 동시에 들어와 탈퇴 뒤에 토큰이 생긴 경우
    $user = User::first();
    $user->forceFill(['withdrawn_at' => now()])->save();
    $token = $user->createToken('test')->plainTextToken;

    $this->withToken($token)->getJson('/api/wallet')->assertUnauthorized();
});

it('웹 탈퇴 안내 페이지는 로그인 없이 열린다', function () {
    $this->get('/account/delete')
        ->assertOk()
        ->assertSee('앱에서 탈퇴하기')
        ->assertSee('탈퇴해도 남는 정보');
});
