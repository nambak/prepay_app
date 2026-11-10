import 'package:flutter/material.dart';

import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';

class ChargeNotice extends StatelessWidget {
  const ChargeNotice({
    super.key,
    required this.agreed,
    required this.onAgreeChanged,
  });

  final bool agreed;
  final ValueChanged<bool> onAgreeChanged;

  static const _notices = [
    '충전한 포인트는 이 가게에서만 쓸 수 있어요.',
    '결제일로부터 1일 안에, 포인트를 쓰기 전이면 결제를 취소할 수 있어요.',
    '그 뒤에는 쓴 포인트와 환불 수수료 1%를 빼고 환불해 드려요.',
  ];

  @override
  Widget build(BuildContext context) {
    final noticeStyle = AppText.label.copyWith(
      color: AppColors.textSecondary,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Text(
                '포인트 이용 안내',
                style: AppText.body.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4),
              for (final notice in _notices)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text('•', style: noticeStyle),
                    Expanded(child: Text(notice, style: noticeStyle)),
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
          child: CheckboxListTile(
            value: agreed,
            onChanged: (value) => onAgreeChanged(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.textPrimary,
            title: Text(
              '이용 안내를 확인했어요 (필수)',
              style: AppText.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
