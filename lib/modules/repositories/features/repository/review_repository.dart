import 'package:e_commerce_shop_app/modules/models/review_model.dart';

import '../../x_result.dart';

abstract class ReviewRepository {
  Future<XResult<List<ReviewModel>>> addReviewToProduct(ReviewModel item);
  Future<List<ReviewModel>> addLikeToReview(ReviewModel item, String userId);
  Future<List<ReviewModel>> getReviewsFromProduct(String productId);
  Future<List<ReviewModel>> getReviewsFromProductWithImage(String productId);
  Future<List<String>> getImage();
  Future<List<String>> addImageToList(String path);
  Future<List<String>> removeImageToList(String path);
  Future<List<String>> clearImage();
}
