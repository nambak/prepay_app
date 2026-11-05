<?php

use Illuminate\Support\Facades\Route;

Route::view('/', 'welcome')->name('home');

// 웹 탈퇴 안내(Google Play 계정 삭제 요건). 로그인 없이 열리고,
// Play Console 데이터 보안 양식에 이 주소를 넣는다.
Route::view('/account/delete', 'account.delete')->name('account.delete');
