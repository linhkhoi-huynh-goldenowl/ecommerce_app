part of 'review_cubit.dart';

enum ReviewStatus { initial, loading, success, failure }
enum LikeReviewStatus { initial, loading, success, failure }

class ReviewState extends Equatable {
  const ReviewState(
      {this.status = ReviewStatus.initial,
      this.reviews = const <ReviewModel>[],
      this.withPhoto = false,
      this.totalReviews = 0,
      this.avgReviews = 0,
      this.reviewCount = const <int>[],
      this.reviewPercent = const <double>[],
      this.userId = "",
      this.likeStatus = LikeReviewStatus.initial});
  final ReviewStatus status;
  final List<ReviewModel> reviews;
  final String userId;
  final bool withPhoto;
  final int totalReviews;
  final double avgReviews;
  final List<double> reviewPercent;
  final List<int> reviewCount;
  final LikeReviewStatus likeStatus;
  ReviewState copyWith(
      {ReviewStatus? status,
      List<ReviewModel>? reviews,
      bool? withPhoto,
      int? totalReviews,
      double? avgReviews,
      List<int>? reviewCount,
      List<double>? reviewPercent,
      String? userId,
      LikeReviewStatus? likeStatus}) {
    return ReviewState(
        reviews: reviews ?? this.reviews,
        status: status ?? this.status,
        withPhoto: withPhoto ?? this.withPhoto,
        avgReviews: avgReviews ?? this.avgReviews,
        totalReviews: totalReviews ?? this.totalReviews,
        reviewCount: reviewCount ?? this.reviewCount,
        reviewPercent: reviewPercent ?? this.reviewPercent,
        userId: userId ?? this.userId,
        likeStatus: likeStatus ?? this.likeStatus);
  }

  @override
  List<Object> get props => [
        status,
        reviews,
        withPhoto,
        totalReviews,
        avgReviews,
        reviewCount,
        reviewPercent,
        userId,
        likeStatus
      ];
}
