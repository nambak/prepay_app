<?php

use App\Models\Admin;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/*
|--------------------------------------------------------------------------
| Test Case
|--------------------------------------------------------------------------
|
| The closure you provide to your test functions is always bound to a specific PHPUnit test
| case class. By default, that class is "PHPUnit\Framework\TestCase". Of course, you may
| need to change it using the "pest()" function to bind different classes or traits.
|
*/

pest()->extend(TestCase::class)
    ->use(RefreshDatabase::class)
    ->in('Feature');

/*
|--------------------------------------------------------------------------
| Expectations
|--------------------------------------------------------------------------
|
| When you're writing tests, you often need to check that values meet certain conditions. The
| "expect()" function gives you access to a set of "expectations" methods that you can use
| to assert different things. Of course, you may extend the Expectation API at any time.
|
*/

expect()->extend('toBeOne', function () {
    return $this->toBe(1);
});

/*
|--------------------------------------------------------------------------
| Functions
|--------------------------------------------------------------------------₩
|
| Pest는 기본적으로 매우 강력한 기능을 제공하지만, 프로젝트에 특화된 테스트 코드가 있을 수 있습니다.
| 이러한 코드는 모든 파일에 반복해서 작성하고 싶지 않을 수 있습니다.
| 이러한 경우, 헬퍼 함수를 전역 함수로 노출하여 테스트 파일의 코드 줄 수를 줄일 수 있습니다.
|
*/

function createAdminAccount()
{
    return Admin::create([
        'name' => '관리자',
        'email' => 'admin@example.com',
        'password' => 'password1234',
    ]);
}
