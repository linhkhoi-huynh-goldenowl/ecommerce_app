import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modules/models/review_model.dart';
import 'package:e_commerce_app/modules/repositories/provider/base_collection.dart';

import '../x_result.dart';

class ReviewProvider extends BaseCollectionReference<ReviewModel> {
  ReviewProvider()
      : super(FirebaseFirestore.instance.collection('reviews').withConverter<
                ReviewModel>(
            fromFirestore: (snapshot, options) =>
                ReviewModel.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (review, _) => review.toJson()));

  Future<XResult<ReviewModel>> addReviewToProduct(
      ReviewModel reviewModel) async {
    return await set(reviewModel);
  }

  Future<XResult<List<ReviewModel>>> getReviewByProduct(String id) async {
    final XResult<List<ReviewModel>> res = await queryWhereId('productId', id);

    return res;
  }
}
