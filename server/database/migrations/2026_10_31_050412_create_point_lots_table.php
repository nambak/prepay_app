<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('point_lots', function (Blueprint $table) {
            $table->id();
            // 포인트 기록이 있는 회원·가게는 지울 수 없게 막는다.
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->foreignId('store_id')->constrained()->restrictOnDelete();
            $table->string('type');
            $table->unsignedInteger('amount');
            $table->unsignedInteger('balance');
            $table->unsignedInteger('paid_won')->nullable();
            $table->date('expires_on');
            $table->timestamps();

            $table->index(['user_id', 'expires_on']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('point_lots');
    }
};
