import 'package:e_commerce_shop_app/modules/models/promo_model.dart';

abstract class PromotionRepository {
  Future<List<PromoModel>> getPromotion();
  Future<bool> checkContainPromo(String code);
  Future<PromoModel> getPromoById(String code);
}
