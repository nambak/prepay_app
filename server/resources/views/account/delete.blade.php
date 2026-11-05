{{-- 웹 탈퇴 안내(Google Play 계정 삭제 요건): 앱 이름, 탈퇴 방법, 지워지는 정보와 남는 정보를 적는다. 대괄호 값은 출시 전에 채운다. --}}
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ config('app.name') }} 회원 탈퇴</title>
    <style>
        body { margin: 0; background: #FFFFFF; color: #191F28; font-family: Pretendard, -apple-system, 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif; font-size: 15px; line-height: 1.6; word-break: keep-all; }
        main { max-width: 640px; margin: 0 auto; padding: 40px 20px 64px; }
        h1 { margin: 0 0 8px; font-size: 24px; line-height: 1.4; }
        h2 { margin: 32px 0 8px; font-size: 18px; }
        p, li { color: #4E5968; }
        ol, ul { margin: 0; padding-left: 20px; }
        li + li { margin-top: 4px; }
        strong { color: #191F28; }
    </style>
</head>
<body>
<main>
    <h1>{{ config('app.name') }} 회원 탈퇴</h1>
    <p>{{ config('app.company_name') }}에서 운영하는 {{ config('app.name') }} 계정을 지우는 방법이에요.</p>

    <h2>앱에서 탈퇴하기</h2>
    <ol>
        <li>앱에서 <strong>내 정보 › 환경설정</strong>으로 가요.</li>
        <li><strong>회원 탈퇴</strong>를 눌러요.</li>
        <li>남은 포인트를 확인하고 동의한 뒤 <strong>탈퇴하기</strong>를 눌러요.</li>
    </ol>

    <h2>앱을 쓸 수 없다면</h2>
    <p><strong>[고객센터 이메일]</strong>로 가입한 이메일 주소를 적어 탈퇴를 요청해 주세요. 본인인지 확인한 뒤 1일 안에 탈퇴를 처리하고 메일로 알려 드려요.</p>

    <h2>탈퇴하면 지워지는 정보</h2>
    <ul>
        <li>이름, 이메일, 비밀번호</li>
        <li>로그인 정보 (모든 기기에서 로그아웃돼요)</li>
    </ul>

    <h2>탈퇴해도 남는 정보</h2>
    <ul>
        <li>충전·결제와 포인트 기록: 관련 법에 따라 지정된 기간 동안 보관한 뒤 지워요. 이름·이메일과는 연결되지 않아요.</li>
    </ul>

    <h2>탈퇴하기 전에 알아 두세요</h2>
    <ul>
        <li>남은 포인트(충전·공유·서비스)는 탈퇴하면 사라지고, 다시 가입해도 돌아오지 않아요.</li>
        <li>충전포인트 환불은 탈퇴하기 전에 신청해 주세요.</li>
    </ul>
</main>
</body>
</html>
