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
        // 포인트 사용 1건
        Schema::create('point_uses', function (Blueprint $table) {
            $table->id();
            // 포인트 기록이 있는 회원·가게는 지울 수 없게 막는다.
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->foreignId('store_id')->constrained()->restrictOnDelete();
            $table->string('method');
            $table->unsignedInteger('amount');
            $table->timestamps();

            $table->index(['user_id', 'store_id']);
        });

        // 포인트 사용 1건에서 묶음마다 뺀 포인트. 포인트 사용을 취소하면 이대로 돌려놓는다.
        Schema::create('point_use_lots', function (Blueprint $table) {
            $table->foreignId('point_use_id')->constrained()->cascadeOnDelete();
            $table->foreignId('point_lot_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('amount');

            $table->primary(['point_use_id', 'point_lot_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('point_use_lots');
        Schema::dropIfExists('point_uses');
    }
};
