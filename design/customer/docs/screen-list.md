# 화면 목록

대표 화면 76개와 원본 피그마 파일(☆고객용-APP_Design)의 프레임 번호 대응표예요.
원본의 상태 변형(입력 중, 오류, 내역 없음 등)과 팝업은 대표 화면 하나로 합치거나 `components/patterns.html`의 공통 패턴으로 정리했어요.

## 01 시작·계정

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 01-01 | 스플래시 | `screens/01-account/01-01-splash.html` | 0-0 스플래시 |
| 01-02 | 로그인 | `screens/01-account/01-02-login.html` | 1-1~1-5 로그인, *1-2 이메일 선택, *1-6 휴면계정 해제 |
| 01-03 | 아이디 찾기 | `screens/01-account/01-03-find-id.html` | 2-1~2-5 아이디 찾기(개인·법인, 결과 없음 팝업) |
| 01-04 | 아이디 찾기 결과 | `screens/01-account/01-04-find-id-result.html` | 2-6~2-8 아이디 찾기 결과(개인·소셜·법인) |
| 01-05 | 비밀번호 찾기 | `screens/01-account/01-05-find-pw.html` | 2-11~2-13 비밀번호 찾기, 2-16~2-18 법인계정 별도 문의 |
| 01-06 | 비밀번호 재설정 | `screens/01-account/01-06-reset-pw.html` | 2-9~2-10, 2-14~2-15 비밀번호 재설정·변경, 완료 팝업 |
| 01-07 | 회원가입 유형 | `screens/01-account/01-07-join-type.html` | 3-1 회원유형 선택 |
| 01-08 | 약관 동의 | `screens/01-account/01-08-join-terms.html` | 3-2~3-4, 3-16~3-18, 3-29~3-31 약관(개인·법인·14세 미만) |
| 01-09 | 본인인증 | `screens/01-account/01-09-join-verify.html` | 3-5~3-8, 3-32~3-34 본인인증, *3-6 인증 실패, *3-33 법정대리인 안내 |
| 01-10 | 정보 입력 | `screens/01-account/01-10-join-info.html` | 3-9~3-14, 3-35~3-39 정보 입력(아이디·비밀번호 상태) |
| 01-11 | 법인 정보 입력 (세로 1060px) | `screens/01-account/01-11-join-corp.html` | 3-19~3-27 법인 회원가입 정보 입력·인증 |
| 01-12 | 가입 완료 | `screens/01-account/01-12-join-done.html` | 3-15, 3-28, 3-40 가입 완료 |

## 02 홈·알림·검색

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 02-01 | 홈 (세로 2000px) | `screens/02-home/02-01-home.html` | 4-1~4-4 홈(로그아웃·일반·법인, footer 펼침) |
| 02-02 | 전체 메뉴 | `screens/02-home/02-02-home-menu.html` | 4-7~4-8 홈 카테고리 |
| 02-03 | 테마 가게 전체보기 | `screens/02-home/02-03-rank-list.html` | 4-9~4-11, 4-14~4-15 단골수·좋아요·할인·신상·이벤트 전체보기 |
| 02-04 | 프랜차이즈 | `screens/02-home/02-04-franchise.html` | 4-12~4-13 프랜차이즈 전체보기·브랜드별 |
| 02-05 | 지역 설정 | `screens/02-home/02-05-region-sheet.html` | *4-5 지역 추가 플로팅, *4-6 지역 추가 옵션 |
| 02-06 | 알림센터 | `screens/02-home/02-06-notifications.html` | 5-1~5-9 알림센터(수신동의, 편집, 삭제, 공지, 이벤트) |
| 02-07 | 검색 | `screens/02-home/02-07-search.html` | 6-1~6-4 찾기(최근·추천·인기 검색어) |
| 02-08 | 검색 결과 | `screens/02-home/02-08-search-result.html` | 6-5~6-6 검색 결과 있음·없음 |

## 03 가게찾기·찜

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 03-01 | 가게찾기 | `screens/03-shop-likes/03-01-shop.html` | 7-1~7-6 SHOP 가게검색 |
| 03-02 | 지도로 찾기 | `screens/03-shop-likes/03-02-map.html` | 7-7~7-9 지도검색 |
| 03-03 | 업종 필터 | `screens/03-shop-likes/03-03-filter.html` | 7-10~7-12 검색필터 FOOD·LIFE, 필터 적용 |
| 03-04 | 찜한 가게 | `screens/03-shop-likes/03-04-likes.html` | 26-1~26-3 LIKE 찜한 가게, 리스트 설정 |
| 03-05 | 찜 리스트 관리 | `screens/03-shop-likes/03-05-like-lists.html` | 26-4~26-8 관심가게 리스트 관리·추가·수정·삭제 |

## 04 가게상세·충전

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 04-01 | 가게 상세 · 충전상품 (세로 1520px) | `screens/04-store-charge/04-01-store.html` | 8-1~8-3 가게상세, 가게소식, 충전상품 |
| 04-02 | 가게 상세 · 메뉴 (세로 1160px) | `screens/04-store-charge/04-02-store-menu.html` | 8-16 가게상세_메뉴 |
| 04-03 | 가게 상세 · 가게소개 (세로 1240px) | `screens/04-store-charge/04-03-store-info.html` | 8-17 가게소개, 8-19~8-20 가게정보 오류신고 |
| 04-04 | 가게 상세 · 리뷰 (세로 1240px) | `screens/04-store-charge/04-04-store-review.html` | 8-18 리뷰 |
| 04-05 | 충전 상품 선택 | `screens/04-store-charge/04-05-charge-sheet.html` | 8-4~8-7 결제옵션 수량선택 |
| 04-06 | 원하는 금액 충전 | `screens/04-store-charge/04-06-custom-amount.html` | 8-8~8-10 원하는 금액으로 선결제·정책위반 |
| 04-07 | 충전 결제 (세로 1380px) | `screens/04-store-charge/04-07-checkout.html` | 8-11~8-15 단골머니 충전(포인트·쿠폰·이용안내) |
| 04-08 | 충전 완료 | `screens/04-store-charge/04-08-charge-done.html` | 8-16 결제완료(충전완료) |

## 05 즐겨찾는 가게·차감

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 05-01 | 즐겨찾는 가게 (세로 1480px) | `screens/05-wallet-pay/05-01-wallet.html` | 9-1~9-3, 9-11 내단골(공유한·공유받은, 단골가게 없음) |
| 05-02 | QR로 쓰기 | `screens/05-wallet-pay/05-02-qr.html` | 9-14 내단골 QR, 18-26 단골모임 QR |
| 05-03 | 금액 입력해서 쓰기 | `screens/05-wallet-pay/05-03-pay-sheet.html` | 9-4~9-5 보유머니 차감하기 |
| 05-04 | 메뉴 골라서 쓰기 (세로 1060px) | `screens/05-wallet-pay/05-04-pay-menu.html` | 9-7~9-8 메뉴 확인 차감·금액 확인 |
| 05-05 | 사용 내용 확인 | `screens/05-wallet-pay/05-05-pay-confirm.html` | *9-6 차감 내용 확인 |
| 05-06 | 사용 완료 | `screens/05-wallet-pay/05-06-pay-done.html` | 9-9 차감완료 |
| 05-07 | 프랜차이즈 지점 선택 | `screens/05-wallet-pay/05-07-branch.html` | 9-12~9-14 프랜차이즈 지점 선택·차감 |
| 05-08 | 이전 가게 | `screens/05-wallet-pay/05-08-past-stores.html` | 9-10 이전 단골가게 |

## 06 공유하기

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 06-01 | 받는 분 찾기 (세로 960px) | `screens/06-share/06-01-share-form.html` | 10-1~10-5, 10-12 공유하기(입력, 검색결과 없음, 연락처 권한) |
| 06-02 | 개인에게 공유 (세로 1240px) | `screens/06-share/06-02-share-found.html` | 10-6~10-7, 10-9 개인 검색결과, 공유머니 유의사항 |
| 06-03 | 그룹에 공유 (세로 1100px) | `screens/06-share/06-03-share-group.html` | 10-8 단골모임 검색결과 |
| 06-04 | 공유 완료 | `screens/06-share/06-04-share-done.html` | 10-10~10-11 공유 완료 |
| 06-05 | 메시지 카드 | `screens/06-share/06-05-message-card.html` | 10-13~10-14 메시지 카드 보기 |

## 07 포인트 내역

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 07-01 | 충전포인트 결제내역 (세로 1180px) | `screens/07-point-history/07-01-history.html` | 11-1, 11-17, 14-1, 14-10 충전머니 결제내역 |
| 07-02 | 가게 이용내역 (세로 1120px) | `screens/07-point-history/07-02-usage.html` | 11-13, 11-18, 14-6, 14-11 가게이용내역 |
| 07-03 | 이용 메뉴 보기 | `screens/07-point-history/07-03-used-menu.html` | 11-14~11-16, 14-7~14-9, 18-8~18-20, 30-3~30-5 이용 메뉴 보기 |
| 07-04 | 결제 상세 | `screens/07-point-history/07-04-pay-detail.html` | 11-4~11-9, 14-2~14-5 상세 결제·환불 내역 |
| 07-05 | 환불 신청 (세로 1420px) | `screens/07-point-history/07-05-refund-apply.html` | 11-10~11-12 환불신청, 계좌 없는 경우 |
| 07-06 | 공유포인트 (세로 1060px) | `screens/07-point-history/07-06-shared-point.html` | 12-1~12-6, 15-1~15-6 공유머니(공유한·받은·편집) |
| 07-07 | 서비스포인트 | `screens/07-point-history/07-07-service-point.html` | 13-1~13-2, 16-1~16-2 서비스머니 |

## 08 그룹

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 08-01 | 그룹 목록 (세로 960px) | `screens/08-group/08-01-groups.html` | 17-1~17-4 단골모임 목록(순서 편집, 비활동) |
| 08-02 | 그룹 상세 (세로 1380px) | `screens/08-group/08-02-group-detail.html` | 18-1~18-4 단골모임 상세보기 |
| 08-03 | 그룹 전체 내역 (세로 1160px) | `screens/08-group/08-03-group-history.html` | 18-5~18-25, 19-1~21-2 모임 전체 내역·모임 가게 내역 |
| 08-04 | 그룹 공지사항 | `screens/08-group/08-04-group-notice.html` | 22-1~22-5 모임 공지사항, 댓글 |
| 08-05 | 그룹 설정 (세로 1180px) | `screens/08-group/08-05-group-settings.html` | 23-1~23-6 모임 설정 |
| 08-06 | 그룹원 관리 | `screens/08-group/08-06-group-members.html` | 24-1~24-7 활동 모임원, 내보내기, 모임장 위임 |
| 08-07 | 그룹 만들기 · 이름 | `screens/08-group/08-07-create-name.html` | 25-1~25-2 단골모임 만들기 이름 |
| 08-08 | 그룹 만들기 · 관계 | `screens/08-group/08-08-create-relation.html` | 25-3~25-5 관계 선택 |
| 08-09 | 그룹 만들기 · 초대 (세로 1100px) | `screens/08-group/08-09-create-invite.html` | 25-6~25-10 모임원 초대 |
| 08-10 | 그룹 만들기 완료 | `screens/08-group/08-10-create-done.html` | 25-11~25-12 만들기 완료, 메시지카드 |

## 09 내 정보

| 번호 | 화면 | 파일 | 원본 프레임 |
|---|---|---|---|
| 09-01 | 내 정보 (세로 1300px) | `screens/09-my/09-01-my.html` | 27-1~27-2 마이페이지, 프로필 이미지 |
| 09-02 | 결제내역 (세로 1060px) | `screens/09-my/09-02-payments.html` | 28-1~28-2 결제내역 |
| 09-03 | 환불내역 (세로 1000px) | `screens/09-my/09-03-refunds.html` | 29-1~29-2 환불내역 |
| 09-04 | 가게이용 리뷰 (세로 1060px) | `screens/09-my/09-04-reviews.html` | 31-1~31-4, 31-8~31-13, 11-19~11-22 가게이용 리뷰, 블라인드 |
| 09-05 | 리뷰 쓰기 (세로 1400px) | `screens/09-my/09-05-write-review.html` | 31-5~31-7, 11-16~11-18 리뷰 작성 |
| 09-07 | 쿠폰 | `screens/09-my/09-07-coupons.html` | 33-1~33-5 쿠폰 |
| 09-08 | 회원정보 수정 (세로 1360px) | `screens/09-my/09-08-profile.html` | 34-1~34-9 회원정보 수정, 비밀번호·계좌 수정 |
| 09-09 | 환경설정 (세로 1140px) | `screens/09-my/09-09-settings.html` | 35-1 환경설정 |
| 09-10 | 1:1 문의 | `screens/09-my/09-10-inquiry.html` | 36-1~36-6 1:1 문의 |
| 09-11 | 가게 추천 | `screens/09-my/09-11-recommend.html` | 37-1~37-4 단골가게 추천 |
| 09-12 | 자주 묻는 질문 | `screens/09-my/09-12-faq.html` | 39-1~39-2 FAQ |
| 09-13 | 오류 화면 | `screens/09-my/09-13-error.html` | 41 에러페이지 |
| 09-14 | 회원 탈퇴 | `screens/09-my/09-14-withdraw.html` | 원본 없음. 레포 `docs/auth-design.md` 8장의 탈퇴 정책에 맞춰 새로 만듦 |

## 이번에 따로 그리지 않은 원본 화면

- 38-1~38-4 가게정보 오류신고(마이페이지): 09-10 1:1 문의와 같은 구성이라 별도 화면 없이 재사용해요.
- 40-1 이용약관: 텍스트만 있는 화면이라 01-08 약관 동의의 "보기" 링크 대상으로만 남겨 두었어요.
