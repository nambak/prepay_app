import 'package:material_ui/material_ui.dart';

import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../view_models/point_history_view_model.dart';
import 'period_sheet.dart';

// 거르기 줄: 기간 버튼, 가게 찾기, 정렬. 가게 찾기를 누르면 줄 아래에 입력칸이 열린다
class HistoryFilterBar extends StatefulWidget {
  const new(this.viewModel, {super.key});

  final PointHistoryViewModel viewModel;

  @override
  State<HistoryFilterBar> createState() => _HistoryFilterBarState();
}

class _HistoryFilterBarState extends State<HistoryFilterBar> {
  // 입력칸이 열려 있는지. 찾는 글자는 view model이 들고 있다
  bool _searching = false;

  PointHistoryViewModel get _viewModel => widget.viewModel;

  Future<void> _openPeriodSheet() async {
    final period = await showPeriodSheet(
      context,
      selected: _viewModel.period,
      latest: _viewModel.thisMonth,
    );
    if (period != null) _viewModel.changePeriod(period);
  }

  // 닫으면 찾던 글자도 지운다
  void _closeSearch() {
    setState(() => _searching = false);
    _viewModel.search('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
          // 글자를 키워 한 줄에 다 들어가지 않으면 찾기와 정렬이 다음 줄로 내려간다
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              InkWell(
                onTap: _openPeriodSheet,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: AppSize.touchTarget),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      SvgIcon(
                        AppIcons.calendar,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      Text(_viewModel.period.label, style: AppText.bodyMedium),
                      SvgIcon(
                        AppIcons.chevronDown,
                        size: 16,
                        strokeWidth: 2,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: '가게 이름으로 찾기',
                    onPressed: () => setState(() => _searching = true),
                    constraints: BoxConstraints.tight(
                      Size.square(AppSize.touchTarget),
                    ),
                    padding: EdgeInsets.zero,
                    icon: SvgIcon(
                      AppIcons.search,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  _SortButton(
                    newestFirst: _viewModel.newestFirst,
                    onSelected: _viewModel.sortNewestFirst,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_searching)
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpace.gutter,
              4,
              AppSpace.gutter,
              8,
            ),
            child: TextField(
              // 가게 찾기를 눌러서 연 칸이라 바로 입력할 수 있게 한다
              autofocus: true,
              onChanged: _viewModel.search,
              textInputAction: TextInputAction.search,
              style: AppText.body,
              decoration: InputDecoration(
                hintText: '가게 이름',
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.field),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  tooltip: '가게 찾기 닫기',
                  onPressed: _closeSearch,
                  icon: SvgIcon(
                    AppIcons.close,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// 최신 순 ⌄. 누르면 정렬 메뉴(폭 200, 항목 44, 고른 항목은 회색 바탕 + 체크)
class _SortButton extends StatelessWidget {
  const new({required this.newestFirst, required this.onSelected});

  final bool newestFirst;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<bool>(
      tooltip: '정렬 바꾸기',
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      color: AppColors.surface,
      elevation: 0,
      menuPadding: EdgeInsets.all(6),
      constraints: BoxConstraints.tightFor(width: 200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardSm),
        side: BorderSide(color: AppColors.border),
      ),
      itemBuilder: (context) => [
        for (final (value, label) in [(true, '최신 순'), (false, '오래된 순')])
          PopupMenuItem(
            value: value,
            height: AppSize.touchTarget,
            padding: EdgeInsets.zero,
            child: _SortItem(label, selected: value == newestFirst),
          ),
      ],
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: AppSize.touchTarget),
        child: Padding(
          padding: EdgeInsets.only(left: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Text(
                newestFirst ? '최신 순' : '오래된 순',
                style: AppText.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SvgIcon(
                AppIcons.chevronDown,
                size: 16,
                strokeWidth: 2,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortItem extends StatelessWidget {
  const new(this.label, {required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: AppSize.touchTarget),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: selected
          ? BoxDecoration(
              color: AppColors.bgField,
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: selected ? AppText.bodyBold : AppText.body,
            ),
          ),
          if (selected)
            SvgIcon(
              AppIcons.check,
              size: 16,
              strokeWidth: 2.4,
              color: AppColors.textPrimary,
            ),
        ],
      ),
    );
  }
}
