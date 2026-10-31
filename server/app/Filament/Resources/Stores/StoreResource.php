<?php

namespace App\Filament\Resources\Stores;

use App\Filament\Resources\Stores\Pages\ManageStores;
use App\Models\Store;
use App\StoreKind;
use BackedEnum;
use Filament\Actions\EditAction;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

/**
 * 가게 목록: 추가·수정만 한다. 포인트 기록이 있는 가게는 DB가 지우지 못하게 막아서 삭제 버튼은 두지 않는다.
 */
class StoreResource extends Resource
{
    protected static ?string $model = Store::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedBuildingStorefront;

    protected static ?string $modelLabel = '가게';

    protected static ?string $pluralModelLabel = '가게';

    protected static ?string $recordTitleAttribute = 'name';

    public static function form(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->label('이름')
                    ->required()
                    ->maxLength(255),
                Select::make('kind')
                    ->label('업종')
                    ->options(StoreKind::class)
                    ->required(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('name')
            ->columns([
                TextColumn::make('name')
                    ->label('이름')
                    ->searchable(),
                TextColumn::make('kind')
                    ->label('업종'),
                TextColumn::make('created_at')
                    ->label('등록일')
                    ->dateTime('Y-m-d H:i')
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->recordActions([
                EditAction::make(),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => ManageStores::route('/'),
        ];
    }
}
