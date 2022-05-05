import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/promotion_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/promotion_provider.dart';

import '../../x_result.dart';

class PromotionRepositoryImpl extends PromotionRepository {
  final PromotionProvider _promotionProvider = PromotionProvider();

  @override
  Future<Stream<XResult<List<PromoModel>>>> getPromotionStream() async {
    return _promotionProvider.snapshotsAll();
  }
}
