import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/icons.dart';
import '../../core/tokens.dart';

// 주소(복사 버튼)와 전화번호. 없는 것은 줄을 그리지 않는다.
class StoreContact extends StatelessWidget {
  const StoreContact({super.key, this.address, this.phone});

  final String? address;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (address case final address?)
          _ContactRow(AppIcons.location, address, action: _CopyButton(address)),
        // TODO: 전화걸기 (url_launcher)
        if (phone case final phone?) _ContactRow(AppIcons.phone, phone),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow(this.icon, this.text, {this.action});

  final String icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.gutter),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          spacing: 10,
          children: [
            SvgIcon(icon, size: 20, color: AppColors.textMuted),
            Expanded(child: Text(text, style: AppText.body)),
            ?action,
          ],
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('주소를 복사했어요')));
      },
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 32),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: AppColors.bgField,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        '복사',
        style: AppText.secondary.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
