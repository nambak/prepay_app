import 'package:flutter/widgets.dart';

import '../view_model.dart';

// 화면이 떠 있는 동안 view model을 한 번만 만든다.
// go_router는 위에 화면을 열고 닫을 때 아래 화면의 builder를 다시 부르는데,
// 그때마다 view model을 새로 만들면 불러온 목록이 사라지고 서버에 다시 요청한다.
class ViewModelScope<T extends ViewModel> extends StatefulWidget {
  const ViewModelScope({
    super.key,
    required this.create,
    required this.builder,
  });

  final T Function() create;
  final Widget Function(T viewModel) builder;

  @override
  State<ViewModelScope<T>> createState() => _ViewModelScopeState<T>();
}

class _ViewModelScopeState<T extends ViewModel>
    extends State<ViewModelScope<T>> {
  // 처음 그릴 때 만든다. 만들다 실패하면 null로 남아서, dispose에서 다시 만들지 않는다.
  T? _viewModel;

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(_viewModel ??= widget.create());
}
