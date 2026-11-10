# 디자인 명세

prepay-app 고객 앱 화면을 고치거나 새로 만들 때 따르는 기준이에요. 값은 `tokens/tokens.css`(또는 `tokens.json`)가 기준이고, 실제 모양은 `components/patterns.html`과 `screens/05-wallet-pay/05-01-wallet.html`(기준 화면)에서 확인할 수 있어요.

## 1. 서비스와 용어

동네 가게에 할인된 금액으로 미리 충전하고, 가족·친구·그룹과 나눠 쓰고, 가게에서 QR이나 금액 입력으로 쓰는 앱이에요.

| 용어 | 뜻 | 쓰는 곳 |
|---|---|---|
| 즐겨찾는 가게 | 서비스 이름이자, 포인트가 남아 있는 가게 목록 | 로고, 화면 제목. 하단 탭에서는 줄여서 **내 가게** |
| 포인트 | 가게에 충전해 둔 잔액. 단위는 P | `50,000P` |
| 충전포인트 | 내가 할인된 금액으로 충전한 포인트, 기한 없음 | 빨간 점 |
| 공유포인트 | 다른 회원이나 그룹에게서 받은 포인트 | 보라 점 |
| 서비스포인트 | 가게가 감사의 뜻으로 준 포인트, 기한 있음 | 주황 점 |
| 그룹 / 그룹장 / 그룹원 | 포인트를 함께 쓰는 사람들의 모임 | 그룹 화면 전체 |
| 찜한 가게 | 관심만 표시한 가게 (포인트와 무관) | 하단 탭 **좋아요** |

- 잔액은 **포인트(P)**, 실제로 결제하는 돈은 **원**이에요. 두 단위를 섞지 않아요. (예: `150,000P`를 `127,500원`에 충전)
- 상표 문제로 원본의 '단골', '머니', '모임'은 쓰지 않아요. 새 문구에도 다시 넣지 않아요.

## 2. 디자인 원칙

1. **빨강은 한 화면에 한 곳.** 주요 버튼(배경 `#DA2F2E`)과 할인율 배지에만 써요. 헤더, 탭, 토글, 금액, 체크박스는 잉크색과 회색으로 그려요.
2. **숫자가 주인공.** 잔액·할인은 크게(32px Bold), 나머지 정보는 회색 보조 문구로 낮춰요.
3. **접어서 보여주기.** 가게별 포인트 상세, 공유 목록처럼 긴 정보는 접어 두고 필요할 때 펼쳐요.
4. **툴팁 대신 용어 설명 시트.** 말풍선 툴팁을 여러 개 띄우지 않고, ⓘ 버튼 하나가 설명 시트를 열어요.

## 3. 화면 틀

- 화면 크기는 390×844. 긴 화면은 세로만 늘리고 내용은 `flex:1; min-height:0; overflow:hidden` 영역에서 잘리게 해요(스크롤을 뜻함).
- 목록·허브 화면은 바탕 `#F2F4F6` 위에 흰 카드, 입력·상세 화면은 흰 바탕이에요.
- 카드: 흰색, 모서리 24px(큰 카드) / 20px / 16px(작은 카드). 그림자와 테두리는 쓰지 않아요.
- 좌우 여백: 화면 20px, 카드 16px. 간격은 8 / 12 / 16 / 20 / 24px.
- 누를 수 있는 곳은 최소 44×44px.
- 하단 탭바(`<app-tab-bar>`)는 최상위 화면 5곳(홈, 가게찾기, 내 가게, 좋아요, 내 정보)에만 붙여요.

## 4. 글자

- 시안은 Noto Sans KR, 구현은 원본과 같은 Pretendard를 권장해요. 크기와 굵기는 그대로 맞아요.
- 잔액 32 Bold(자간 -0.8px) · 화면 제목 24 Bold · 섹션 18 Bold · 카드 제목 17 Bold · 본문 15(입력값 16) · 보조 13~14 · 배지 12 Medium.
- 같은 크기에서 굵기만 바꿔 쓰기도 해요. 본문 15와 입력 16은 Medium(500)·Bold(700), 라벨 14와 보조 13은 Medium(500)이에요. 고객 앱은 `AppText.bodyBold`처럼 이름을 붙여 두고 써요.
- 12px보다 작은 글자는 쓰지 않아요. 금액에는 `font-variant-numeric: tabular-nums`를 줘요.
- 색: 본문 `#191F28`, 보조 `#4E5968`, 흐린 글자 `#636D7A`. `#8B95A1`은 아이콘과 큰 글자에만 써요(작은 글자는 대비가 부족해요).

## 5. 컴포넌트 조각

화면에 그대로 붙여 쓸 수 있는 HTML이에요. 모양은 `components/patterns.html`에서 볼 수 있어요.

### 앱바 (하위 화면)
```html
<header style="flex:none;height:56px;position:relative;display:flex;align-items:center;justify-content:space-between;padding:0 4px">
  <a href="이전화면.html" aria-label="뒤로 가기" style="width:44px;height:44px;display:flex;align-items:center;justify-content:center;color:#191F28">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 5l-7 7 7 7"/></svg>
  </a>
  <h1 style="position:absolute;left:60px;right:60px;margin:0;text-align:center;font-size:17px;font-weight:700">화면 제목</h1>
  <span style="width:44px;height:44px;display:block"></span>
</header>
```

### 큰 제목 (입력 화면)
```html
<h2 style="margin:0;padding:8px 20px 28px;font-size:24px;line-height:1.4;font-weight:700">가입한 아이디를<br>입력해 주세요</h2>
```

### 하단 주요 버튼
```html
<div style="flex:none;padding:12px 20px 34px;background:#FFFFFF">
  <a href="다음화면.html" style="height:56px;border-radius:16px;background:#DA2F2E;color:#FFFFFF;font-size:17px;font-weight:700;display:flex;align-items:center;justify-content:center">다음</a>
</div>
```
- 두 버튼일 때: 보조(배경 `#F2F4F6`, 잉크 글자, 500) `flex:1` + 주요 `flex:2`, 간격 8px.
- 아직 누를 수 없는 상태: 배경 `#F2F4F6`, 글자 `#8B95A1`. 꼭 필요할 때만 써요.

### 입력창
```html
<label style="display:flex;flex-direction:column;gap:8px">
  <span style="font-size:14px;font-weight:500;color:#4E5968">이메일 아이디</span>
  <input type="email" placeholder="hana@email.com" style="height:52px;box-sizing:border-box;border:1.5px solid transparent;border-radius:14px;background:#F2F4F6;padding:0 16px;font-family:inherit;font-size:16px;color:#191F28;outline:none">
</label>
```
| 상태 | 바꿀 값 |
|---|---|
| 입력 중 | `background:#FFFFFF; border-color:#191F28` |
| 오류 | `background:#FFFFFF; border-color:#D42A2A` + 아래 `13px #D42A2A` 안내 |
| 확인 완료 | 아래 `13px #2C7445` 안내 (체크 아이콘 14px) |

필수 표시 `*`는 빨강이 아니라 라벨과 같은 색으로 써요.

### 세그먼트 (2~3개 중 하나)
```html
<div role="group" aria-label="회원 유형" style="display:flex;background:#F2F4F6;border-radius:12px;padding:4px">
  <button type="button" aria-pressed="true" style="flex:1;height:40px;border:0;border-radius:9px;background:#FFFFFF;font-family:inherit;font-size:15px;font-weight:700;color:#191F28">개인</button>
  <button type="button" aria-pressed="false" style="flex:1;height:40px;border:0;border-radius:9px;background:transparent;font-family:inherit;font-size:15px;font-weight:500;color:#4E5968">법인</button>
</div>
```

### 그 밖의 조각
- **밑줄 탭**: 선택 16/700 잉크 + 아래 2px 잉크 선, 나머지 16/500 `#636D7A`. 다른 화면으로 가면 `<a>`, 같은 화면이면 `<button aria-pressed>`.
- **칩**: 높이 36, 모서리 18, 좌우 14px, 14px 글자. 기본은 흰색(회색 바탕 위) 또는 `#F2F4F6`(흰 바탕 위), 선택은 `#191F28` 배경 + 흰 글자.
- **정렬 버튼**: 글자 버튼 "가까운 순" + 아래 꺾쇠 16px, `#4E5968`.
- **목록 행**: 높이 56, 좌우 20px, 16px 글자, 오른쪽 꺾쇠 18px `#8B95A1`. 흰 카드로 묶고 묶음 제목은 13/500 `#636D7A`.
- **토글**: 48×28, 켜짐 `#191F28` / 꺼짐 `#D1D6DB`, 흰 손잡이 22px. `<button aria-pressed>`.
- **체크박스·라디오**: 기본 입력에 `accent-color:#191F28`, 22px.
- **정보 버튼**: 28×28 투명 버튼 + ⓘ 아이콘 18px `#8B95A1`, `aria-label="OO 설명 보기"`.
- **수량 스테퍼**: 높이 40, 모서리 12, 배경 `#F2F4F6`, −/+ 버튼 40×40, 숫자 16/700. 고객 앱은 누르는 영역 44px에 맞춰 높이와 버튼을 44로, 모서리는 토큰 14(`--radius-field`)로 그려요.
- **포인트 점**: 8×8 원. 충전 `#EE3E3D`, 공유 `#6E5DA8`, 서비스 `#F2A14A`. 글자색으로는 쓰지 않아요.
- **배지**(12/500, 모서리 6, 안쪽 2px 7px):

| 종류 | 배경 / 글자 | 예 |
|---|---|---|
| 할인 | `#FFF0F0` / `#C42726` | 최대 30%, 5% 할인, 취소 가능 |
| 중립 | `#F2F4F6` / `#4E5968` | 가성비, 취소 불가, 환불 완료, 고객 차감 |
| 완료 | `#ECF7EF` / `#2C7445` | 결제 완료, 답변 완료 |
| 그룹 | `#F1EFFA` / `#5A4A95` | 그룹 |
| 서비스·진행 중 | `#FFF4E6` / `#A35A00` | D-100, 환불 진행 중 |

### 바텀시트
```html
<!-- 화면 루트에 position:relative. 아래 화면을 간단히 그린 뒤 -->
<div aria-hidden="true" style="position:absolute;inset:0;background:rgba(25,31,40,0.5)"></div>
<section role="dialog" aria-modal="true" aria-label="시트 제목" style="position:absolute;left:0;right:0;bottom:0;background:#FFFFFF;border-radius:28px 28px 0 0;padding:12px 20px 34px;display:flex;flex-direction:column;gap:16px">
  <span aria-hidden="true" style="align-self:center;width:40px;height:4px;border-radius:2px;background:#D1D6DB;display:block"></span>
  <h2 style="margin:0;font-size:20px;font-weight:700">시트 제목</h2>
  <!-- 내용, 주요 버튼 -->
</section>
```

### 가운데 다이얼로그
같은 어두운 배경 위에 `left:40px; right:40px; top:50%; transform:translateY(-50%)`, 흰색 모서리 24px, 제목 19/700, 본문 15 `#4E5968`, 버튼 줄(취소 보조 + 확인 주요, 높이 52, 모서리 14).

### 빈 화면
가운데 정렬: 72px 원(`#F2F4F6`) 안에 32px 아이콘 `#8B95A1`, 제목 17/700, 설명 14 `#636D7A`, 필요하면 보조 버튼. 원본의 '내역 없음' 화면은 모두 이 패턴으로 그려요.

### 완료 화면
가운데에 64~72px 원(`#ECF7EF`) + 체크 아이콘 `#2C7445`, 제목 24/700, 요약 카드(`#F2F4F6`, 모서리 20, 왼쪽 라벨 `#636D7A` / 오른쪽 값), 하단 버튼.

### 공통 컴포넌트
`components/components.js`에 정의돼 있고, 화면 맨 아래에서 스크립트를 불러와 태그로 써요. 사용법은 `components/preview.html`에 있어요.
```html
<app-tab-bar tab="home"></app-tab-bar>
<store-row store="하루카페 강남점" cat="카페" area="서울시 행복구" rate="30%" dist="88m" likes="999" liked="n" value="y" tone="a" kind="cafe" href="../04-store-charge/04-01-store.html"></store-row>
<store-tile store="하루카페 강남점" cat="카페" dist="88m" rate="30%" tone="a" kind="cafe" liked="n" href="../04-store-charge/04-01-store.html"></store-tile>
<script src="../../components/components.js"></script>
```

## 6. 아이콘

24 viewBox 선 아이콘이에요. 아래처럼 감싸서 써요. 이모지와 외부 아이콘 폰트는 쓰지 않아요.
```html
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">…</svg>
```

| 이름 | path |
|---|---|
| 뒤로 | `<path d="M15 5l-7 7 7 7"/>` |
| 오른쪽 꺾쇠 | `<path d="M9 6l6 6-6 6"/>` |
| 아래 꺾쇠 | `<path d="M6 9l6 6 6-6"/>` |
| 위 꺾쇠 | `<path d="M6 15l6-6 6 6"/>` |
| 닫기 | `<path d="M6 6l12 12M18 6L6 18"/>` |
| 더하기 | `<path d="M12 5v14M5 12h14"/>` |
| 빼기 | `<path d="M5 12h14"/>` |
| 체크 | `<path d="M5 12.5l4.5 4.5L19 7.5"/>` |
| 검색 | `<circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/>` |
| 알림 | `<path d="M6 16v-5a6 6 0 0112 0v5l1.5 2h-15z"/><path d="M10 20.5a2 2 0 004 0"/>` |
| 정보 | `<circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 7.8h.01"/>` |
| 설정 | `<circle cx="12" cy="12" r="3"/><path d="M12 3v2.5M12 18.5V21M3 12h2.5M18.5 12H21M5.6 5.6l1.8 1.8M16.6 16.6l1.8 1.8M5.6 18.4l1.8-1.8M16.6 7.4l1.8-1.8"/>` |
| 필터 | `<path d="M4 7h9M17 7h3M4 17h3M11 17h9"/><circle cx="15" cy="7" r="2"/><circle cx="9" cy="17" r="2"/>` |
| 위치 | `<path d="M12 21s-7-6.2-7-11a7 7 0 0114 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/>` |
| 지도 | `<path d="M9 4L3 6v14l6-2 6 2 6-2V4l-6 2z"/><path d="M9 4v14M15 6v14"/>` |
| 내 위치 | `<circle cx="12" cy="12" r="6.5"/><circle cx="12" cy="12" r="2"/><path d="M12 2.5v3M12 18.5v3M2.5 12h3M18.5 12h3"/>` |
| 하트 | `<path d="M12 20s-7.5-4.6-7.5-10.2A4.3 4.3 0 0112 7.2a4.3 4.3 0 017.5 2.6C19.5 15.4 12 20 12 20z"/>` |
| 공유 | `<circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="6" r="2.5"/><circle cx="18" cy="18" r="2.5"/><path d="M8.2 10.8l7.6-3.6M8.2 13.2l7.6 3.6"/>` |
| 전화 | `<path d="M5 4h4l2 5-2.5 1.5a11 11 0 005 5L15 13l5 2v4a2 2 0 01-2 2A16 16 0 013 6a2 2 0 012-2z"/>` |
| 복사 | `<rect x="9" y="9" width="11" height="11" rx="2"/><path d="M15 9V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7a2 2 0 002 2h3"/>` |
| 소식 | `<path d="M4 10v4h3l7 4V6l-7 4z"/><path d="M18 9a4 4 0 010 6"/>` |
| 영수증 | `<path d="M6 3h12v18l-3-2-3 2-3-2-3 2z"/><path d="M9 8h6M9 12h6M9 16h3"/>` |
| 여러 사람 | `<circle cx="9" cy="8" r="3.5"/><path d="M3 20a6 6 0 0112 0"/><path d="M16 4.5a3.5 3.5 0 010 7M18 14a6 6 0 013 6"/>` |
| 사람 | `<circle cx="12" cy="8.5" r="3.8"/><path d="M4.5 20a7.5 7.5 0 0115 0"/>` |
| 건물(법인) | `<path d="M5 20V5h9v15M14 9h5v11M3 20h18M8 8.5h3M8 12h3M8 15.5h3"/>` |
| 선물 | `<rect x="4" y="10" width="16" height="10" rx="2"/><path d="M3 7h18v3H3zM12 7v13"/><path d="M12 7c-1.5-3-5-3-4.5-.5M12 7c1.5-3 5-3 4.5-.5"/>` |
| 쿠폰 | `<path d="M4 7h16v3a2 2 0 000 4v3H4v-3a2 2 0 000-4z"/><path d="M14 8v8"/>` |
| 별 | `<path d="M12 4l2.4 5 5.6.8-4 3.9 1 5.5-5-2.7-5 2.7 1-5.5-4-3.9 5.6-.8z"/>` |
| 달력 | `<rect x="4" y="5" width="16" height="15" rx="2"/><path d="M4 10h16M9 3v4M15 3v4"/>` |
| 수정 | `<path d="M4 20h4L19 9l-4-4L4 16z"/>` |
| 삭제 | `<path d="M5 7h14M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/>` |
| 왕관(그룹장) | `<path d="M4 8l4 4 4-6 4 6 4-4-2 11H6z"/>` |
| 메시지 | `<path d="M5 5h14v11H9l-4 4z"/>` |
| 카메라 | `<path d="M4 8h3l2-3h6l2 3h3v11H4z"/><circle cx="12" cy="13" r="3.5"/>` |
| 새로 고침 | `<path d="M20 11a8 8 0 10-2 6"/><path d="M20 5v6h-6"/>` |
| 자물쇠 | `<rect x="5" y="11" width="14" height="9" rx="2"/><path d="M8 11V8a4 4 0 018 0v3"/>` |
| 보낸 | `<path d="M7 17L17 7M9 7h8v8"/>` |
| 받은 | `<path d="M17 7L7 17M15 17H7V9"/>` |
| 사진 | `<rect x="4" y="5" width="16" height="14" rx="2"/><circle cx="9" cy="10" r="1.5"/><path d="M4 17l5-4 4 3 3-2 4 3"/>` |
| 메뉴 | `<path d="M4 7h16M4 12h16M4 17h16"/>` |
| 물음표 | `<circle cx="12" cy="12" r="9"/><path d="M9.5 9.5a2.5 2.5 0 114 2c-1 .6-1.5 1-1.5 2M12 17h.01"/>` |
| 더보기(세로 점) | `<circle cx="12" cy="5.5" r="1.2" fill="currentColor"/><circle cx="12" cy="12" r="1.2" fill="currentColor"/><circle cx="12" cy="18.5" r="1.2" fill="currentColor"/>` |
| 동전 | `<circle cx="12" cy="12" r="8"/><path d="M9.5 9.5h4a1.75 1.75 0 010 3.5h-3a1.75 1.75 0 000 3.5h4M12 8v1.5M12 16.5V18"/>` |
| 로그아웃 | `<path d="M10 5H6a2 2 0 00-2 2v10a2 2 0 002 2h4M15 8l4 4-4 4M19 12H9"/>` |

업종 아이콘(카페·음식·베이커리·뷰티·가게)은 `components/components.js`의 `KIND_ICONS`에 있어요.

SNS 로그인은 회사 로고를 그리지 않고 48px 원 안에 이니셜만 써요: 카카오 K(`#FEE500`, 글자 `#191919`), 애플 A(`#191F28`), 구글 G(흰 바탕 + 1px `#E5E8EB` 테두리). 네이버·페이스북 로그인은 넣지 않아요(레포 `docs/auth-design.md` 8장).

## 7. 접근성

- 누르는 것은 실제 `<button type="button">` 또는 `<a href>`로 만들어요. `div`에 클릭을 붙이지 않아요.
- `<a>` 안에 `<button>`이나 `<input>`을 넣지 않아요.
- 아이콘만 있는 버튼에는 `aria-label`, 장식용 SVG에는 `aria-hidden="true"`를 붙여요.
- 입력창은 `<label>`로 감싸요. 라벨을 화면에 안 보이게 할 때는 `position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0 0 0 0)` 스팬을 써요.
- 글자 대비 4.5:1 이상. 흰 글자 위 주요 버튼은 `#EE3E3D`가 아니라 `#DA2F2E`를 써요(3.9:1 → 4.7:1).
- 시트·다이얼로그는 `<section role="dialog" aria-modal="true">`.

## 8. 문구

- 해요체로 짧게 써요. "~하시겠습니까?" 대신 "~할까요?".
- 버튼은 동사로 끝나요: "충전하기", "쓰기", "보내기".
- 오류는 무슨 일인지와 할 일을 한 문장으로: "이메일 형식을 확인해 주세요".
- 정해지지 않은 정책 값은 지어내지 않고 `[N]`처럼 대괄호 자리표시로 남겨요.
- 예시 데이터: 김하나(사용자), 하루카페 강남점, 행복식당 1, 서울시 행복구 하늘동, 010-1234-5678, 2026년 날짜.
