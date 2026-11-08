import '../../../data/repositories/store_repository.dart';
import '../../../domain/models/store.dart';
import '../../core/load_view_model.dart';

// 가게찾기
class ShopViewModel extends LoadViewModel<List<StoreSummary>> {
  ShopViewModel({required this._storeRepository});

  final StoreRepository _storeRepository;

  List<StoreSummary>? get stores => data;

  @override
  Future<List<StoreSummary>> fetch() => _storeRepository.getStores();
}
