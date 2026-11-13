import 'package:material_ui/material_ui.dart';

import '../../core/tokens.dart';

class WithdrawNotice extends StatelessWidget {
  const WithdrawNotice({super.key});

  static const _notices = [
    '사라진 포인트는 다시 가입해도 돌아오지 않아요.',
    '결제 기록은 관련 법에서 정한 기간 동안 보관한 뒤 지워요.',
    '탈퇴하면 모든 기기에서 로그아웃돼요.',
  ];

  @override
  Widget build(BuildContext context) {
    final noticeStyle = AppText.label.copyWith(
      color: AppColors.textSecondary,
      height: 1.55,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: 환불 신청 화면이 생기면 오른쪽에 '환불 신청' 버튼을 단다.
        Text('충전포인트는 환불받을 수 있어요', style: AppText.bodyBold),
        Text(
          '탈퇴하기 전에 환불을 신청해 주세요',
          style: AppText.secondary.copyWith(color: AppColors.textMuted),
        ),
        SizedBox(height: 24),
        for (final notice in _notices)
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text('•', style: noticeStyle),
                Expanded(child: Text(notice, style: noticeStyle)),
              ],
            ),
          ),
      ],
    );
  }
}
