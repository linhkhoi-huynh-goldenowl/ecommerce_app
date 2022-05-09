import 'package:e_commerce_shop_app/modules/models/promo_model.dart';

import '../../x_result.dart';

abstract class PromotionRepository {
  Future<Stream<XResult<List<PromoModel>>>> getPromotionStream();
}
