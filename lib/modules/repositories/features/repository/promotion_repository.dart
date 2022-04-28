import 'package:e_commerce_shop_app/modules/models/promo_model.dart';

import '../../x_result.dart';

abstract class PromotionRepository {
  Future<XResult<List<PromoModel>>> getPromotion();
  Future<List<PromoModel>> setPromotion(List<PromoModel> promos);
  Future<bool> checkContainPromo(String code);
  Future<PromoModel> getPromoById(String code);
}
