import 'package:flutter/material.dart';

import '../../core/tokens.dart';

class StoreTabs extends StatelessWidget {
  const StoreTabs({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        spacing: 20,
        children: [
          Semantics(
            selected: true,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.textPrimary, width: 2),
                ),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '이용 중인 가게 '),
                    TextSpan(
                      text: '$count',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                style: AppText.inputBold,
              ),
            ),
          ),
          InkWell(
            onTap: () {}, // TODO: 이전 가게
            child: SizedBox(
              height: 44,
              child: Center(
                child: Text(
                  '이전 가게',
                  style: AppText.inputMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
