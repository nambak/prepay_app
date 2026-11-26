import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point.dart';
import '../../../domain/models/point_history.dart';
import '../../core/tokens.dart';
import '../../core/widgets/point_dot.dart';

// 밑줄 탭: 충전포인트, 공유포인트, 서비스포인트
class HistoryTabs extends StatelessWidget {
  const new(this.current, {super.key, required this.onSelect});

  final PointType current;
  final ValueChanged<HistoryTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 가로 스크롤 안에서도 밑줄이 화면 폭을 채우게
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      // 글자를 키우면 한 줄에 다 들어가지 않아서 밀어 본다
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 20,
          children: [
            for (final type in PointType.values)
              if (type == current)
                Semantics(
                  container: true,
                  selected: true,
                  child: Container(
                    height: AppSize.touchTarget,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.textPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                    child: _TabLabel(type, style: AppText.inputBold),
                  ),
                )
              else
                Semantics(
                  container: true,
                  button: true,
                  child: InkWell(
                    onTap: () => onSelect(HistoryTab.of(type)),
                    child: SizedBox(
                      height: AppSize.touchTarget,
                      child: _TabLabel(
                        type,
                        style: AppText.inputMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const new(this.type, {required this.style});

  final PointType type;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        PointDot(type),
        Text(type.label, style: style),
      ],
    );
  }
}
