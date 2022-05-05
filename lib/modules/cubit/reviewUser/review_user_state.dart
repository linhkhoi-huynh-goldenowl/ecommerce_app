part of 'review_user_cubit.dart';

enum ReviewUserStatus { initial, loading, success, failure }

class ReviewUserState extends Equatable {
  const ReviewUserState(
      {this.status = ReviewUserStatus.initial,
      this.reviews = const <ReviewModel>[],
      this.errMessage = ""});

  final ReviewUserStatus status;
  final List<ReviewModel> reviews;
  final String errMessage;

  ReviewUserState copyWith(
      {ReviewUserStatus? status,
      List<ReviewModel>? reviews,
      String? errMessage}) {
    return ReviewUserState(
        reviews: reviews ?? this.reviews,
        status: status ?? this.status,
        errMessage: errMessage ?? this.errMessage);
  }

  @override
  List<Object> get props => [status, reviews, errMessage];
}
