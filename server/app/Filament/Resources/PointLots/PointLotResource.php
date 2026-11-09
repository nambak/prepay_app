<?php

namespace App\Filament\Resources\PointLots;

use App\Filament\Resources\PointLots\Pages\ManagePointLots;
use App\Models\PointLot;
use App\PointType;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

/**
 * 포인트 묶음 목록: 조회만 한다. 포인트는 충전·지급 기능으로만 생기고, 관리자 웹에서는 만들거나 고치지 않는다.
 */
class PointLotResource extends Resource
{
    protected static ?string $model = PointLot::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedCircleStack;

    protected static ?string $modelLabel = '포인트';

    protected static ?string $pluralModelLabel = '포인트';

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('user.name')
                    ->label('회원')
                    ->placeholder('탈퇴한 회원')
                    ->searchable(),
                TextColumn::make('store.name')
                    ->label('가게')
                    ->searchable(),
                TextColumn::make('type')
                    ->label('종류'),
                TextColumn::make('amount')
                    ->label('받은 포인트')
                    ->numeric()
                    ->suffix('P'),
                TextColumn::make('balance')
                    ->label('남은 포인트')
                    ->numeric()
                    ->suffix('P'),
                TextColumn::make('paid_won')
                    ->label('결제 금액')
                    ->numeric()
                    ->suffix('원')
                    ->placeholder('-'),
                TextColumn::make('expires_on')
                    ->label('유효기간')
                    ->date('Y-m-d')
                    ->placeholder('없음')
                    ->sortable(),
                TextColumn::make('created_at')
                    ->label('받은 날')
                    ->dateTime('Y-m-d H:i')
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                SelectFilter::make('type')
                    ->label('종류')
                    ->options(PointType::class),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => ManagePointLots::route('/'),
        ];
    }
}
