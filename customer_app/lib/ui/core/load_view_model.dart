import 'package:flutter/cupertino.dart';

// 화면을 열 때 서버에서 데이터를 불러와서 보여 주는 view model.
// 불러오기 전과 불러오는 중에는 data가 null이고, 실패하면 failed가 true가 된다.
abstract class LoadViewModel<T> extends ChangeNotifier {
  T? _data;

  T? get data => _data;

  bool _failed = false;

  bool get failed => _failed;

  bool get loading => _data == null && !_failed;

  // 무엇을 불러올지. 화면에서는 부르지 말고 load()를 부른다.
  @protected
  Future<T> fetch();

  Future<void> load() async {
    _failed = false;
    notifyListeners();

    try {
      _data = await fetch();
    } catch (error) {
      debugPrint('$runtimeType 불러오기 실패: $error');
      _failed = true;
    }
    notifyListeners();
  }
}
