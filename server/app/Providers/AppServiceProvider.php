<?php

namespace App\Providers;

use Carbon\CarbonImmutable;
use Filament\Support\Facades\FilamentTimezone;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Str;
use Illuminate\Validation\Rules\Password;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        $this->configureDefaults();

        // DB에는 UTC로 저장하고, 관리자 웹에서는 한국 시간으로 보여준다.
        FilamentTimezone::set('Asia/Seoul');

        // 로그인 시도 제한: 같은 이메일 + IP로 1분에 5번. 통신사 망은 여러 휴대폰이 IP 하나를 함께 써서 IP만 보지 않는다.
        // 같은 IP에서 이메일을 바꿔 가며 시도하는 것은 IP 전체 1분에 30번으로 한다.
        RateLimiter::for('login', function (Request $request) {
            $email = $request->input('email');

            return [
                Limit::perMinute(5)
                    ->by((is_string($email) ? Str::lower($email) : '') . '|' . $request->ip()),
                Limit::perMinute(30)
                    ->by($request->ip()),
            ];
        });
    }

    /**
     * Configure default behaviors for production-ready applications.
     */
    protected function configureDefaults(): void
    {
        Date::use(CarbonImmutable::class);

        DB::prohibitDestructiveCommands(
            app()->isProduction(),
        );

        Password::defaults(fn(): ?Password => app()->isProduction()
            ? Password::min(12)
                ->mixedCase()
                ->letters()
                ->numbers()
                ->symbols()
                ->uncompromised()
            : null,
        );
    }
}
