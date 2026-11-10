import 'package:flutter/material.dart';

import '../tokens.dart';

// 불러오지 못했을 때: 안나 문구와 다시 불러오기 버튼
class LoadError extends StatelessWidget {
  const LoadError(this.message, {super.key, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(
            message,
            style: AppText.body.copyWith(color: AppColors.textSecondary),
          ),
          FilledButton(onPressed: onRetry, child: Text('다시 불러오기')),
        ],
      ),
    );
  }
}
