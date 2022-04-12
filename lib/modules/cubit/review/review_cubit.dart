import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/review_model.dart';
import 'package:e_commerce_app/utils/helpers/review_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/domain.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit({required this.productId}) : super(const ReviewState()) {
    fetchReviewByProduct(productId);
  }
  final String productId;
  void fetchReviewByProduct(String productId) async {
    try {
      emit(state.copyWith(status: ReviewStatus.loading));
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getString("userId");
      var reviews = <ReviewModel>[];
      if (state.withPhoto) {
        reviews =
            await Domain().review.getReviewsFromProductWithImage(productId);
      } else {
        reviews = await Domain().review.getReviewsFromProduct(productId);
      }
      final total = reviews.length;
      final reviewCount = ReviewHelper.getReviewDetail(reviews);
      final avgReview = ReviewHelper.getAvgReviews(reviews);
      final percentReview = ReviewHelper.getReviewPercent(reviews);

      emit(state.copyWith(
          status: ReviewStatus.success,
          reviews: reviews,
          totalReviews: total,
          avgReviews: avgReview,
          reviewCount: reviewCount,
          reviewPercent: percentReview,
          userId: userId));
    } catch (_) {
      emit(state.copyWith(status: ReviewStatus.failure));
    }
  }

  void changeWithImageSelect() async {
    try {
      emit(state.copyWith(status: ReviewStatus.loading));
      bool checkImage = !state.withPhoto;
      var reviews = <ReviewModel>[];
      if (checkImage) {
        reviews =
            await Domain().review.getReviewsFromProductWithImage(productId);
      } else {
        reviews = await Domain().review.getReviewsFromProduct(productId);
      }
      emit(state.copyWith(
          status: ReviewStatus.success,
          withPhoto: checkImage,
          reviews: reviews));
    } catch (_) {
      emit(state.copyWith(status: ReviewStatus.failure));
    }
  }

  void likeReview(ReviewModel reviewModel) async {
    try {
      emit(state.copyWith(status: ReviewStatus.loading));
      final reviews =
          await Domain().review.addLikeToReview(reviewModel, state.userId);
      emit(state.copyWith(status: ReviewStatus.success, reviews: reviews));
    } catch (_) {
      emit(state.copyWith(status: ReviewStatus.failure));
    }
  }
}
