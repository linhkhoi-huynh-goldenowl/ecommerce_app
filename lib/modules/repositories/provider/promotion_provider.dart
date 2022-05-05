import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/base_collection.dart';

class PromotionProvider extends BaseCollectionReference<PromoModel> {
  PromotionProvider()
      : super(FirebaseFirestore.instance.collection('promotions').withConverter<
                PromoModel>(
            fromFirestore: (snapshot, options) =>
                PromoModel.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (review, _) => review.toJson()));
}
