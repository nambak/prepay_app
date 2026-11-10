import 'package:flutter/foundation.dart';

// 화면 view model의 바탕. ViewModelScope가 화면을 닫을 때 dispose한다.
// 서버 요청이 화면을 닫은 뒤에 끝나면 dispose된 뒤에 알리게 되는데, 그때는 알리지 않는다.
abstract class ViewModel extends ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
