<?php

// 서버에서 쓰는 검증 규칙만 옮김. 없는 규칙은 영어로 나오니, 새 규칙을 쓰면 여기도 추가한다.
return [
    'required'   => ':attribute 항목을 입력해 주세요.',
    'email'      => ':attribute 형식이 맞지 않아요.',
    'string'     => ':attribute 항목은 글자로 입력해 주세요.',
    'numeric'    => ':attribute 항목은 숫자로 입력해 주세요.',
    'max'        => [
        'string' => ':attribute 항목은 :max자까지 입력할 수 있어요.',
    ],
    'attributes' => [
        'email'       => '이메일',
        'password'    => '비밀번호',
        'device_name' => '기기 이름'
    ]
];
