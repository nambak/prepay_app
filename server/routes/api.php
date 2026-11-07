<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\StoreController;
use App\Http\Controllers\WalletController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// 같은 이메일 + IP로 1분에 5번까지 (AppServiceProvider의 'login', 비밀번호 무작위 대입 방지)
Route::post('/login',[AuthController::class, 'login'])->middleware('throttle:login');

// 여기부터는 로그인해서 받은 토큰이 있어야 함.
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', fn(Request $request) => $request->user());
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/wallet', WalletController::class);
    Route::get('/stores', [StoreController::class, 'index']);
    Route::get('/stores/{store}', [StoreController::class, 'show']);

    // 탈퇴: 개인정보를 비우고 모든 기기의 토큰을 지움.
    Route::delete('/user', [AuthController::class, 'withdraw']);
});
