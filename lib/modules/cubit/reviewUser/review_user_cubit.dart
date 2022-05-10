import 'dart:async';

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
  StreamSubscription? reviewSubscription;
  @override
  Future<void> close() async {
    reviewSubscription?.cancel();
    await Domain().review.clearImage();
    return super.close();
  }

  void fetchReviewByProduct() async {
    try {
      emit(state.copyWith(status: ReviewUserStatus.loading));

      final Stream<XResult<List<ReviewModel>>> reviewStream =
          await Domain().review.getReviewsByUserStream();

      reviewSubscription = reviewStream.listen((event) async {
        emit(state.copyWith(status: ReviewUserStatus.loading));
        if (event.isSuccess) {
          emit(state.copyWith(
              status: ReviewUserStatus.success,
              reviews: event.data,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: ReviewUserStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: ReviewUserStatus.failure, errMessage: "Something wrong"));
    }
  }

  void changeReviewSort(ReviewUserSort sort) {
    emit(state.copyWith(sort: sort));
  }
}
