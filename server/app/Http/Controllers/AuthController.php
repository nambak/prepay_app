<?php

namespace App\Http\Controllers;

use Illuminate\Http\Response;
use Illuminate\Validation\ValidationException;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request): array
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
            'device_name' => ['required', 'string', 'max:255'],
        ]);

        $user = User::where('email', $credentials['email'])->first();

        if (! $user || ! Hash::check($credentials['password'], $user->password)) {
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
}
