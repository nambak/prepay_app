<?php

use App\Models\Admin;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

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

it('관리자는 회원 목록을 볼 수 있다', function (){
    $admin = createAdminAccount();

    User::factory()->create(['email' => 'customer@example.com']);

    $this->actingAs($admin, 'admin')
        ->get('/admin/users')
        ->assertOk()
        ->assertSee('customer@example.com')
        ->assertSee('가입일');
});
