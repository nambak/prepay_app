<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\WalletController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// 같은 ip에서 1분안에 5번까지만 시도할 수 있음. (비밀번호 무작의 대입 방지)
Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:5,1');

// 여기부터는 로그인해서 받은 토큰이 있어야 함.
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', fn(Request $request) => $request->user());
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/wallet', WalletController::class);
});
