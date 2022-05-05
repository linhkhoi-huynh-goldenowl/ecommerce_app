import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/review_model.dart';
import '../../repositories/domain.dart';
import '../../repositories/x_result.dart';

part 'review_user_state.dart';

class ReviewUserCubit extends Cubit<ReviewUserState> {
  ReviewUserCubit() : super(const ReviewUserState()) {
    fetchReviewByProduct();
  }

  void fetchReviewByProduct() async {
    try {
      emit(state.copyWith(status: ReviewUserStatus.loading));
      XResult<List<ReviewModel>> reviewsRes =
          await Domain().review.getReviewsByUser();
      if (reviewsRes.isSuccess) {
        final reviews =
            await Domain().review.setReviewList(reviewsRes.data ?? []);

        emit(state.copyWith(
            status: ReviewUserStatus.success,
            reviews: reviews,
            errMessage: ""));
      } else {
        emit(state.copyWith(
            status: ReviewUserStatus.failure, errMessage: reviewsRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: ReviewUserStatus.failure, errMessage: "Something wrong"));
    }
  }
}
