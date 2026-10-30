# 인증 설계

고객 앱(`customer_app/`), 서버(`server/`), 관리자 웹(`server/` 안 Filament)의 로그인·회원 구조를 정리한 문서예요.
정해진 것과 아직 정할 것을 나눠 적었어요. 정책 값이 정해지면 이 문서부터 고쳐요.

## 1. 지금 범위

| 항목 | 상태 |
|---|---|
| 이메일 로그인 (서버 API + 앱 로그인 화면) | **지금 구현** |
| 관리자 로그인 (Filament, `admins` 테이블) | 구현됨 |
| 소셜 로그인 (Apple·Google·카카오) | 설계만. 앱 ID·개발자 계정 준비 후 Apple부터 |
| 회원가입 (01-07~01-10, 본인인증 포함) | 설계만. 본인인증 업체 연동과 함께 |
| 회원 탈퇴 | 설계만. **스토어 제출 전 필수** |

테스트 계정은 회원가입이 생기기 전까지 `php artisan tinker`로 만들어요.

## 2. 로그인 흐름 (이메일)

Laravel Sanctum의 토큰 방식을 써요. 모든 로그인 방식은 마지막에 같은 토큰을 받아요.

```
앱 → POST /api/login { email, password, device_name } → { token }
앱 → GET  /api/wallet   헤더 Authorization: Bearer {token}
앱 → POST /api/logout   지금 쓰는 토큰만 지움 (다른 기기 로그인은 그대로)
```

- **토큰이 필요한 API**: `/api/user`, `/api/wallet`, `/api/logout`은 `auth:sanctum`으로 막아요. 토큰이 없으면 401이에요.
- **틀린 이메일·틀린 비밀번호**: 같은 문구("이메일 또는 비밀번호가 맞지 않아요.")로 422를 돌려줘요. 어떤 이메일이 가입돼 있는지 밖에서 알 수 없게 하려는 거예요.
- **시도 제한**: 같은 IP에서 1분에 5번까지예요(`throttle:5,1`). 넘으면 429예요. 이 값은 임시 기본값이라 정책이 정해지면 바꿔요.
- **토큰 만료**: 지금은 만료 없음(`config/sanctum.php`의 `expiration => null`)이에요. 로그아웃하거나 탈퇴하면 지워요.
- **앱의 토큰 보관**: 기기의 안전한 저장소(iOS 키체인, Android 키스토어)에 둬요. 앱을 다시 켜도 로그인이 유지돼요.

### 서버 주소 (앱)

앱은 빌드할 때 `API_BASE_URL`을 받아요. 주소 끝에 `/`나 `/api`를 붙이지 않아요.

| 어디서 | 주소 |
|---|---|
| iOS 시뮬레이터 | 기본값 `http://127.0.0.1:8000` (`php artisan serve`) |
| Herd | `http://prepay-server.test` (Mac 안에서만 열려요) |
| Android 에뮬레이터 | `http://10.0.2.2:8000` |
| 실제 휴대폰 | `http://<Mac IP>:8000`, 서버는 `--host=0.0.0.0` |

넘기는 방법은 `--dart-define=API_BASE_URL=...` 또는 `--dart-define-from-file=.env`예요. `customer_app/.env`는 git에서 빼요.
**앱에 넣은 값은 앱을 내려받은 사람이 꺼내 볼 수 있어요.** 비밀 키는 `server/.env`에만 둬요.

## 3. 스토어 정책

| 정책 | 내용 | 이 앱에서 |
|---|---|---|
| Apple 4.8 로그인 서비스 | 외부 소셜 로그인을 하나라도 넣으면, 개인정보 보호형 로그인(Apple 로그인)을 같은 자리에 함께 제공해야 해요. 자체 계정만 쓰면 의무 없음 | 시안에 네이버·카카오·Facebook·Google이 있으니 **iOS는 Apple 로그인 필수** |
| Google Play | Google 로그인 의무 없음 | Google 로그인은 선택 |
| Apple 5.1.1(v) | 앱에서 가입할 수 있으면 앱 안에서 탈퇴할 수 있어야 해요 | 필수 |
| Google Play 계정 삭제 | 앱 안 탈퇴 경로 + 웹에서 탈퇴를 요청하는 링크 | 필수 |
| Apple 로그인 가입자 탈퇴 | 탈퇴할 때 서버가 Apple 토큰도 철회해요 | Apple 로그인을 붙일 때 같이 |
| Apple 로그인 직후 | 이름·이메일을 다시 묻지 않아요. 심사에서 거절된 사례가 많아요 | 가입 절차에서 주의 |

출처: [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), [Google Play 계정 삭제 요구사항](https://support.google.com/googleplay/android-developer/answer/13327111)

## 4. 데이터 구조

**회원(사람)과 로그인 방법을 다른 테이블에 둬요.**

```
users (회원 = 사람 한 명)                  social_accounts (로그인 방법)
- id                                      - user_id → users.id (회원 탈퇴 시 함께 삭제)
- name        본인인증 이름                 - provider          apple, google, kakao
- email       이메일 로그인 아이디 (없을 수 있음) - provider_user_id  그 서비스의 고유 번호 (바뀌지 않음)
- password    (없을 수 있음)                 - email             그 서비스가 알려 준 이메일 (참고용, 없을 수 있음)
- (본인인증 붙일 때) 휴대폰, 생년월일, 연계정보   - unique(provider, provider_user_id)
                                          - unique(user_id, provider)
```

| 가입 방법 | `users` | `social_accounts` |
|---|---|---|
| 이메일 | 이름, 이메일, 비밀번호 | 없음 |
| 소셜 | 이름 (이메일·비밀번호 비움) | provider, provider_user_id, email |
| 가입 후 다른 방법 연결 | 그대로 (이메일 로그인 추가면 이메일·비밀번호 채움) | 한 줄 추가 |

- **소셜 가입은 두 테이블을 한 트랜잭션으로 저장해요.** 하나만 저장되면 다시 들어올 방법이 없는 회원이 생겨요.
- **소셜 로그인은 `provider_user_id`로 회원을 찾아요.** 이메일로 찾지 않아요. Apple은 대신 받는 주소(`...@privaterelay.appleid.com`)를 주고 이메일·이름을 처음 한 번만 줘요. 카카오는 동의하지 않으면 이메일을 안 줘요. 이메일은 사용자가 바꿀 수도 있어요.
- **`users.email`은 이메일 로그인 아이디로만 써요.** 소셜 서비스가 준 이메일은 `social_accounts.email`에만 둬요.
- **비밀번호가 없는 회원**은 비밀번호 로그인이 항상 실패해요(`Hash::check`가 `false`). 따로 막는 코드는 필요 없어요.
- **관리자**는 `admins` 테이블과 `admin` 가드로 따로 로그인해요. 고객 계정으로는 관리자 웹에 들어갈 수 없어요.
- `users.email`·`password`를 비울 수 있게 바꾸는 마이그레이션과 `social_accounts` 테이블은 **소셜 로그인을 붙일 때 적용**해요.

## 5. 가입 절차

```
이메일 가입: 01-08 약관 → 01-09 본인인증 → 01-10 이메일·비밀번호 → users 저장
소셜 가입:   소셜 로그인 → (처음이면) 01-08 약관 → 01-09 본인인증 → users + social_accounts 저장
```

소셜 로그인을 처음 한 사람은 그 자리에서 바로 회원을 만들지 않아요. 약관과 본인인증을 마친 뒤에 저장해요.

## 6. 회원 관리 (관리자 웹)

- **목록은 하나**예요. 이메일 회원과 소셜 회원을 나누지 않아요. 캐시와 거래 내역은 로그인 방법이 아니라 회원에 붙어요.
- **로그인 방법 열**: `[이메일] [Apple] [카카오]`처럼 배지로 보여주고, 로그인 방법으로 거를 수 있어요.
- **관리 기준은 회원번호와 본인인증 정보(이름·휴대폰·생년월일)**예요. 이메일은 로그인 수단 겸 보조 검색어예요. 이메일 검색은 `social_accounts.email`까지 찾아요.
- **회원 삭제 버튼은 두지 않아요.** 회원을 지우면 캐시·거래 기록까지 사라질 수 있어요. 탈퇴 정책이 정해진 뒤 그 규칙대로 만들어요.
- **개인정보 열람 기록**: 회원 상세 화면을 만들 때 누가 언제 어떤 회원을 봤는지 남기는 것을 함께 검토해요.

## 7. 검색 성능

서버 복사본의 SQLite로 관리자 검색(이름·이메일·소셜 이메일 부분 검색, 전체 개수 + 최신 10명)을 재 본 결과예요.

| 회원 수 | 검색 1번 |
|---|---|
| 10만 명 | 약 0.05초 |
| 100만 명 | 약 0.55초 |
| 100만 명, 이메일 정확히 일치 | 약 0.0003초 |

- **느려지는 원인은 조인이 아니라 `LIKE '%검색어%'`예요.** 인덱스를 못 쓰고 회원 전체를 훑어요. `social_accounts` 조인은 `unique(user_id, provider)` 인덱스로 바로 찾아가요.
- **대비 순서**: ① 휴대폰·회원번호·이메일은 정확히 일치로 찾고, 이름만 부분 검색으로 둬요(`searchable(isIndividual: true)`). ② MySQL `FULLTEXT`(ngram). ③ Laravel Scout + Meilisearch.
- **휴대폰 번호 검색은 처음부터 정확히 일치 + 인덱스**로 만들어요.

## 8. 아직 정할 것

| 항목 | 선택지 / 메모 |
|---|---|
| 소셜 로그인 구성 | ① 이메일+Apple+Google ② 이메일+Apple+Google+카카오 (추천) ③ 시안 그대로 (+네이버·Facebook) |
| 앱 ID 확정 | 지금 iOS `com.unwanted.prepayApp`, Android `com.unwanted.prepay_app`. 스토어 등록 뒤에는 못 바꿔요 |
| 개발자 계정 | Apple Developer Program, Google Cloud OAuth 클라이언트(iOS·Android·서버용) |
| 같은 사람을 찾는 기준 | 본인인증으로 찾기 (추천, 시안 01-09) / 확인된 이메일로 합치기 |
| 소셜 가입자의 약관·본인인증 | 이메일 가입과 같이 거칠지 |
| 탈퇴할 때 남은 캐시 | [환불 / 소멸 / 기타] |
| 로그인 시도 제한 | 지금 1분에 5번 (임시) |
| 본인인증 업체 | [업체명] |
