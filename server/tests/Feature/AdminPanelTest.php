<?php

use App\Filament\Resources\Stores\Pages\ManageStores;
use App\Filament\Resources\Users\Pages\ManageUsers;
use App\Models\PointLot;
use App\Models\Store;
use App\Models\User;
use Filament\Actions\Testing\TestAction;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;

uses(RefreshDatabase::class);

it('로그인 하지 않으면 관리자 로그인 화면으로 이동', function () {
    $this->get('/admin')->assertRedirect('/admin/login');
});

it('고객 계정으로는 관리자 웹에 들어갈 수 없다', function () {
    $this->actingAs(User::factory()->create())
        ->get('/admin')
        ->assertRedirect('/admin/login');
});

it('관리자는 관리자 웹에 들어갈 수 있어야 한다', function () {
    $admin = createAdminAccount();

    $this->actingAs($admin, 'admin')->get('/admin')->assertOk();
});

it('관리자는 회원 목록을 볼 수 있다', function () {
    $admin = createAdminAccount();

    User::factory()->create(['email' => 'customer@example.com']);

    $this->actingAs($admin, 'admin')
        ->get('/admin/users')
        ->assertOk()
        ->assertSee('customer@example.com')
        ->assertSee('가입일');
});

it('관리자는 가게를 추가할 수 있다', function () {
    $this->actingAs(createAdminAccount(), 'admin');

    Livewire::test(ManageStores::class)
        ->callAction('create', ['name' => '행복식당 1', 'kind' => 'food'])
        ->assertHasNoActionErrors();

    $this->assertDatabaseHas('stores', ['name' => '행복식당 1', 'kind' => 'food']);
});

it('회원과 가게는 관리자 웹에서 지울 수 없다', function () {
    $this->actingAs(createAdminAccount(), 'admin');

    Livewire::test(ManageUsers::class)
        ->assertActionDoesNotExist(TestAction::make('delete')->table(User::factory()->create()));
    Livewire::test(ManageStores::class)
        ->assertActionDoesNotExist(TestAction::make('delete')->table(Store::factory()->create()));
});

it('관리자는 포인트 목록에서 회원·가게·남은 포인트를 볼 수 있다', function () {
    $admin = createAdminAccount();

    PointLot::factory()
        ->for(User::factory()->create(['name' => '김하나']))
        ->for(Store::factory()->create(['name' => '하루카페2']))
        ->create(['balance' => 20000]);

    $this->actingAs($admin, 'admin')
        ->get('/admin/point-lots')
        ->assertOk()
        ->assertSee('김하나')
        ->assertSee('하루카페2')
        ->assertSee('20,000P');
});
