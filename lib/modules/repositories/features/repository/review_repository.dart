import 'package:e_commerce_shop_app/modules/models/review_model.dart';

import '../../x_result.dart';

abstract class ReviewRepository {
  Future<XResult<ReviewModel>> addReviewToProduct(ReviewModel item);
  Future<List<ReviewModel>> addReviewToLocal(ReviewModel item);
  Future<XResult<ReviewModel>> addLikeToReview(ReviewModel item, String userId);
  Future<List<ReviewModel>> addLikeToLocal(ReviewModel item);

  Future<XResult<List<ReviewModel>>> getReviewsFromProduct(String productId);
  Future<List<ReviewModel>> setReviewList(List<ReviewModel> reviews);
  Future<List<ReviewModel>> getReviewsFromProductWithImage(bool isImage);
  Future<List<String>> getImage();
  Future<List<String>> addImageToList(String path);
  Future<List<String>> removeImageToList(String path);
  Future<List<String>> clearImage();
}
