import '../../../data/repositories/store_repository.dart';
import '../../../domain/models/store.dart';
import '../../core/load_view_model.dart';

// 가가 상세
class StoreViewModel extends LoadViewModel<StoreDetail> {
  StoreViewModel({required this._storeRepository, required this.storeId});

  final StoreRepository _storeRepository;
  final String storeId;

  StoreDetail? get store => data;

  @override
  Future<StoreDetail> fetch() => _storeRepository.getStore(storeId);
}
