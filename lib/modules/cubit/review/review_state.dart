part of 'review_cubit.dart';

enum ReviewStatus { initial, loading, success, failure }
enum LikeReviewStatus { initial, loading, success, failure }
enum StarReviewStatus { initial, selected, unselected }
enum ContentReviewStatus { initial, typed, untyped }
enum ImageStatus { initial, loading, success, failure }
enum AddReviewStatus { initial, loading, success, failure }

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
      this.likeStatus = LikeReviewStatus.initial,
      this.starNum = 0,
      this.starStatus = StarReviewStatus.initial,
      this.imageLocalPaths = const <String>[],
      this.reviewContent = "",
      this.imageStatus = ImageStatus.initial,
      this.addStatus = AddReviewStatus.initial,
      this.contentStatus = ContentReviewStatus.initial,
      this.errMessage = ""});
  final ReviewStatus status;
  final List<ReviewModel> reviews;
  final String userId;
  final bool withPhoto;
  final int totalReviews;
  final double avgReviews;
  final List<double> reviewPercent;
  final List<int> reviewCount;
  final LikeReviewStatus likeStatus;
  final int starNum;
  final StarReviewStatus starStatus;
  final String reviewContent;
  final ContentReviewStatus contentStatus;
  final ImageStatus imageStatus;
  final List<String> imageLocalPaths;
  final AddReviewStatus addStatus;

  final String errMessage;
  List<ReviewModel> get reviewsToShow => withPhoto
      ? reviews.where((element) => element.images.isNotEmpty).toList()
      : reviews;

  ReviewState copyWith(
      {ReviewStatus? status,
      List<ReviewModel>? reviews,
      bool? withPhoto,
      int? totalReviews,
      double? avgReviews,
      List<int>? reviewCount,
      List<double>? reviewPercent,
      String? userId,
      LikeReviewStatus? likeStatus,
      int? starNum,
      StarReviewStatus? starStatus,
      List<String>? imageLocalPaths,
      String? reviewContent,
      ImageStatus? imageStatus,
      AddReviewStatus? addStatus,
      ContentReviewStatus? contentStatus,
      String? errMessage}) {
    return ReviewState(
        reviews: reviews ?? this.reviews,
        status: status ?? this.status,
        withPhoto: withPhoto ?? this.withPhoto,
        avgReviews: avgReviews ?? this.avgReviews,
        totalReviews: totalReviews ?? this.totalReviews,
        reviewCount: reviewCount ?? this.reviewCount,
        reviewPercent: reviewPercent ?? this.reviewPercent,
        userId: userId ?? this.userId,
        likeStatus: likeStatus ?? this.likeStatus,
        starNum: starNum ?? this.starNum,
        starStatus: starStatus ?? this.starStatus,
        imageLocalPaths: imageLocalPaths ?? this.imageLocalPaths,
        reviewContent: reviewContent ?? this.reviewContent,
        imageStatus: imageStatus ?? this.imageStatus,
        addStatus: addStatus ?? this.addStatus,
        contentStatus: contentStatus ?? this.contentStatus,
        errMessage: errMessage ?? this.errMessage);
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
        likeStatus,
        starNum,
        starStatus,
        imageLocalPaths,
        reviewContent,
        imageStatus,
        addStatus,
        contentStatus,
        errMessage
      ];
}
