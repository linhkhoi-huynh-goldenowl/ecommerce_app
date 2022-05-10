part of 'review_user_cubit.dart';

enum ReviewUserStatus { initial, loading, success, failure }
enum ReviewUserSort { starAsc, starDesc, createDateAsc, createDateDesc }

class ReviewUserState extends Equatable {
  const ReviewUserState(
      {this.status = ReviewUserStatus.initial,
      this.reviews = const <ReviewModel>[],
      this.errMessage = "",
      this.sort = ReviewUserSort.starAsc});

  final ReviewUserStatus status;
  final List<ReviewModel> reviews;
  final String errMessage;
  final ReviewUserSort sort;

  List<ReviewModel> get reviewsToShow {
    List<ReviewModel> reviewsFilter = List.from(reviews);
    switch (sort) {
      case ReviewUserSort.createDateAsc:
        {
          reviewsFilter.sort((a, b) =>
              a.createdDate!.toDate().compareTo(b.createdDate!.toDate()));
          break;
        }
      case ReviewUserSort.createDateDesc:
        {
          reviewsFilter.sort((b, a) =>
              a.createdDate!.toDate().compareTo(b.createdDate!.toDate()));
          break;
        }
      case ReviewUserSort.starAsc:
        {
          reviewsFilter.sort((a, b) => a.star.compareTo(b.star));
          break;
        }
      case ReviewUserSort.starDesc:
        {
          reviewsFilter.sort((b, a) => a.star.compareTo(b.star));
          break;
        }
    }
    return reviewsFilter;
  }

  ReviewUserState copyWith(
      {ReviewUserStatus? status,
      List<ReviewModel>? reviews,
      String? errMessage,
      ReviewUserSort? sort}) {
    return ReviewUserState(
        reviews: reviews ?? this.reviews,
        status: status ?? this.status,
        errMessage: errMessage ?? this.errMessage,
        sort: sort ?? this.sort);
  }

  @override
  List<Object> get props => [status, reviews, errMessage, sort];
}
