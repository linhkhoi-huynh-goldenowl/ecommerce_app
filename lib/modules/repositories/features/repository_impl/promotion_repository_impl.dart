import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/promotion_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/promotion_provider.dart';

class PromotionRepositoryImpl extends PromotionRepository {
  List<PromoModel> _listPromo = [];
  final PromotionProvider _promotionProvider = PromotionProvider();
  @override
  Future<bool> checkContainPromo(String code) async {
    return _listPromo
        .where((element) => element.id == code)
        .toList()
        .isNotEmpty;
  }

  @override
  Future<PromoModel> getPromoById(String code) async {
    return _listPromo.firstWhere((element) => element.id == code);
  }

  @override
  Future<List<PromoModel>> getPromotion() async {
    final res = await _promotionProvider.getPromotion();
    _listPromo = res.data ?? [];
    _listPromo
        .where((element) =>
            element.endDate.toDate().compareTo(DateTime.now()) >= 0)
        .toList();
    return _listPromo;
  }
}
