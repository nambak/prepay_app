import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point_history.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/primary_button.dart';

// 기간 선택 시트. 고른 기간을 돌려주고, 그냥 닫으면 null
// latest보다 뒤의 달과 해는 고를 수 없다
Future<HistoryPeriod?> showPeriodSheet(
  BuildContext context, {
  required HistoryPeriod selected,
  required HistoryPeriod latest,
}) => showModalBottomSheet<HistoryPeriod>(
  context: context,
  // 글자를 키우면 시트가 길어져서 화면 높이까지 쓸 수 있게 한다
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => PeriodSheet(selected: selected, latest: latest),
);

// 월별은 달을 누르면 바로 고르고, 연도별은 해를 고른 뒤 '확인'을 누른다
class PeriodSheet extends StatefulWidget {
  const new({super.key, required this.selected, required this.latest});

  final HistoryPeriod selected;
  final HistoryPeriod latest;

  @override
  State<PeriodSheet> createState() => _PeriodSheetState();
}

class _PeriodSheetState extends State<PeriodSheet> {
  // 시트를 여는 동안만 쓰는 값. 지금 고른 기간에서 시작한다
  late bool _yearly = widget.selected.month == null;
  late int _year = widget.selected.year;

  bool get _isLatestYear => _year >= widget.latest.year;

  // 이번 해에서는 이번 달 뒤의 달을 고를 수 없다
  bool _canPick(int month) =>
      !_isLatestYear || month <= (widget.latest.month ?? 12);

  void _pick(HistoryPeriod period) => Navigator.pop(context, period);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(AppSpace.gutter, 0, AppSpace.gutter, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 14,
          children: [
            _UnitSwitch(
              yearly: _yearly,
              onChanged: (yearly) => setState(() => _yearly = yearly),
            ),
            Row(
              children: [
                _YearArrow(
                  AppIcons.back,
                  label: '이전 해',
                  onPressed: () => setState(() => _year--),
                ),
                Expanded(
                  child: Text(
                    '$_year년',
                    textAlign: TextAlign.center,
                    style: AppText.inputBold,
                  ),
                ),
                _YearArrow(
                  AppIcons.chevronRight,
                  label: '다음 해',
                  onPressed: _isLatestYear
                      ? null
                      : () => setState(() => _year++),
                ),
              ],
            ),
            if (_yearly)
              PrimaryButton(
                label: '확인',
                onPressed: () => _pick(HistoryPeriod(_year)),
              )
            else
              // 1~12월을 4열로
              Column(
                spacing: 6,
                children: [
                  for (final row in [1, 5, 9])
                    Row(
                      spacing: 6,
                      children: [
                        for (var month = row; month < row + 4; month++)
                          Expanded(
                            child: _MonthButton(
                              month,
                              selected:
                                  _year == widget.selected.year &&
                                  month == widget.selected.month,
                              onPressed: _canPick(month)
                                  ? () => _pick(HistoryPeriod(_year, month))
                                  : null,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// 월별 | 연도별. 회색 바탕 안에서 고른 칸만 흰색으로
// 눌리는 높이는 바탕 높이(44)와 같고, 흰 칸은 그 안에 36으로 그린다
class _UnitSwitch extends StatelessWidget {
  const new({required this.yearly, required this.onChanged});

  final bool yearly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.bgField,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final (value, label) in [(false, '월별'), (true, '연도별')])
            Expanded(
              child: Semantics(
                container: true,
                button: true,
                selected: value == yearly,
                child: InkWell(
                  onTap: () => onChanged(value),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      constraints: BoxConstraints(minHeight: 36),
                      alignment: Alignment.center,
                      decoration: value == yearly
                          ? BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(9),
                            )
                          : null,
                      child: Text(
                        label,
                        style: value == yearly
                            ? AppText.label.copyWith(
                                fontWeight: FontWeight.w700,
                              )
                            : AppText.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                      ),
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

// 이전 해 · 다음 해. 고를 수 없으면 회색
class _YearArrow extends StatelessWidget {
  const new(this.icon, {required this.label, required this.onPressed});

  final String icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      constraints: BoxConstraints.tight(Size.square(AppSize.touchTarget)),
      padding: EdgeInsets.zero,
      icon: SvgIcon(
        icon,
        size: 18,
        strokeWidth: 2,
        color: onPressed == null ? AppColors.iconMuted : AppColors.textPrimary,
      ),
    );
  }
}

// 달 버튼. 고른 달은 잉크 바탕에 흰 글자, 고를 수 없는 달은 회색 글자
class _MonthButton extends StatelessWidget {
  const new(this.month, {required this.selected, required this.onPressed});

  final int month;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      enabled: onPressed != null,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: BoxConstraints(minHeight: AppSize.touchTarget),
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
          child: Text(
            '$month월',
            style: switch ((selected, onPressed)) {
              (true, _) => AppText.label.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.surface,
              ),
              (false, null) => AppText.label.copyWith(
                color: AppColors.iconMuted,
              ),
              (false, _) => AppText.label,
            },
          ),
        ),
      ),
    );
  }
}
