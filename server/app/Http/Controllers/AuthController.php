<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request): array
    {
        $credentials = $request->validate([
            'email'       => ['required', 'email'],
            'password'    => ['required', 'string'],
            'device_name' => ['required', 'string', 'max:255'],
        ]);

        $user = User::where('email', $credentials['email'])->first();

        if (!$user || !Hash::check($credentials['password'], $user->password)) {
            throw ValidationException::withMessages([
                'email' => '이메일 또는 비밀번호가 맞지 않아요.'
            ]);
        }

        return [
            'token' => $user->createToken($credentials['device_name'])->plainTextToken,
        ];
    }

    // 지금 쓰고있는 토큰을 삭제. 다른 기기의 로그인은 그대로임.
    public function logout(Request $request): Response
    {
        $request->user()->currentAccessToken()->delete();

        return response()->noContent();
    }

    // 탈퇴: 회원 행은 남기고 개인정보만 바꾼다. 포인트 묶음(결제 기록)은 그대로 둔다.
    public function withdraw(Request $request): Response
    {
        $user = $request->user();

        DB::transaction(function () use ($user) {
            $user->tokens()->delete();
            $user->forceFill([
                'name'              => null,
                'email'             => null,
                'email_verified_at' => null,
                'password'          => null,
                'remember_token'    => null,
                'withdrawn_at'      => now(),
            ])->save();
        });

        return response()->noContent();
    }
}
