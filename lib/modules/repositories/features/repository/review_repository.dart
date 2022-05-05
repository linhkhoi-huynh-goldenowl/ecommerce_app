import 'package:e_commerce_shop_app/modules/models/review_model.dart';

import '../../x_result.dart';

abstract class ReviewRepository {
  Future<XResult<ReviewModel>> addReviewToProduct(ReviewModel item);
  Future<XResult<ReviewModel>> addLikeToReview(ReviewModel item, String userId);

  Stream<XResult<List<ReviewModel>>> getReviewsFromProductStream(
      String productId);
  Future<Stream<XResult<List<ReviewModel>>>> getReviewsByUserStream();

  Future<List<String>> getImage();
  Future<List<String>> addImageToList(String path);
  Future<List<String>> removeImageToList(String path);
  Future<List<String>> clearImage();
}
