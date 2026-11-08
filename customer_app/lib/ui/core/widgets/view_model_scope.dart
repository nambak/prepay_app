import 'package:flutter/widgets.dart';

// 화면이 떠 있는 동안 view model을 한 번만 만든다.
// go_router는 위에 화면을 열고 닫을 때 아래 화면의 builder를 다시 부르는데,
// 그때마다 view model을 새로 만들면 불러온 목록이 사라지고 서버에 다시 요청한다.
class ViewModelScope<T extends ChangeNotifier> extends StatefulWidget {
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

class _ViewModelScopeState<T extends ChangeNotifier>
    extends State<ViewModelScope<T>> {
  late final T _viewModel = widget.create();

  @override
  Widget build(BuildContext context) => widget.builder(_viewModel);
}
