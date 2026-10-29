<?php

it('지갑 캐시를 리턴한다', function () {
    $this->getJson('/api/wallet')
        ->assertOk()
        ->assertJsonPath('charge', 320000)
        ->assertJsonCount(2, 'stores');
});
