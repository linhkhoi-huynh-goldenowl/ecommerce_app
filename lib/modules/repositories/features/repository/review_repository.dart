import 'package:e_commerce_app/modules/models/review_model.dart';

abstract class ReviewRepository {
  Future<List<ReviewModel>> addReviewToProduct(ReviewModel item);
  Future<List<ReviewModel>> addLikeToReview(ReviewModel item, String userId);
  Future<List<ReviewModel>> getReviewsFromProduct(String productId);
  Future<List<ReviewModel>> getReviewsFromProductWithImage(String productId);
}
