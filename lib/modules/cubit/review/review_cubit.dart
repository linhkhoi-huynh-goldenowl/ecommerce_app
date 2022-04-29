import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/models/review_model.dart';
import 'package:e_commerce_shop_app/utils/helpers/review_helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/services/firebase_storage.dart';
import '../../../utils/services/image_picker_services.dart';
import '../../repositories/domain.dart';
import '../../repositories/x_result.dart';
import 'package:path/path.dart' as p;
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

      XResult<List<ReviewModel>> reviewsRes =
          await Domain().review.getReviewsFromProduct(productId);
      if (reviewsRes.isSuccess) {
        final reviews =
            await Domain().review.setReviewList(reviewsRes.data ?? []);
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
            userId: userId,
            errMessage: ""));
      } else {
        emit(state.copyWith(
            status: ReviewStatus.failure, errMessage: reviewsRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: ReviewStatus.failure, errMessage: "Something wrong"));
    }
  }

  void changeWithImageSelect() async {
    try {
      emit(state.copyWith(status: ReviewStatus.loading));
      bool checkImage = !state.withPhoto;
      var reviews =
          await Domain().review.getReviewsFromProductWithImage(checkImage);

      emit(state.copyWith(
          status: ReviewStatus.success,
          withPhoto: checkImage,
          reviews: reviews,
          errMessage: ""));
    } catch (_) {
      emit(state.copyWith(
          status: ReviewStatus.failure, errMessage: "Something wrong"));
    }
  }

  void addReview(String productId) async {
    try {
      emit(state.copyWith(
          addStatus: AddReviewStatus.loading, status: ReviewStatus.loading));
      List<String> pathImageNetwork = [];
      var pathLocal = await Domain().review.getImage();
      for (var path in pathLocal) {
        XResult result = await FirebaseStorageService().uploadToFirebase(path,
            "${state.userId}-${DateTime.now().toIso8601String()}${p.extension(path)}");
        if (result.isSuccess) {
          pathImageNetwork.add(result.data);
        } else {
          throw Exception(result.error);
        }
      }
      ReviewModel reviewModel = ReviewModel(
          comment: state.reviewContent,
          star: state.starNum,
          productId: productId,
          images: pathImageNetwork,
          like: []);
      XResult<ReviewModel> reviewsRes =
          await Domain().review.addReviewToProduct(reviewModel);
      if (reviewsRes.isSuccess) {
        var clearImage = await Domain().review.clearImage();
        final reviewsAdd =
            await Domain().review.addReviewToLocal(reviewsRes.data!);
        ProductItem? productItem =
            await Domain().product.getProductById(productId);
        if (productItem != null) {
          final total = reviewsAdd.length;

          final reviewCount = ReviewHelper.getReviewDetail(reviewsAdd);
          final avgReview = ReviewHelper.getAvgReviews(reviewsAdd);
          final percentReview = ReviewHelper.getReviewPercent(reviewsAdd);

          productItem.reviewStars = avgReview.round();
          productItem.numberReviews = total;

          XResult<ProductItem> productRes =
              await Domain().product.updateProduct(productItem);
          if (productRes.isSuccess) {
            emit(state.copyWith(addStatus: AddReviewStatus.success));

            emit(state.copyWith(
                totalReviews: total,
                avgReviews: avgReview,
                reviewCount: reviewCount,
                reviewPercent: percentReview,
                addStatus: AddReviewStatus.initial,
                imageLocalPaths: clearImage,
                likeStatus: LikeReviewStatus.initial,
                reviewContent: "",
                contentStatus: ContentReviewStatus.initial,
                starNum: 0,
                starStatus: StarReviewStatus.initial,
                imageStatus: ImageStatus.initial,
                errMessage: "",
                status: ReviewStatus.success));
          } else {
            emit(state.copyWith(
                addStatus: AddReviewStatus.failure,
                errMessage: productRes.error,
                status: ReviewStatus.failure));
          }
        } else {
          emit(state.copyWith(
              addStatus: AddReviewStatus.failure,
              errMessage: "Can't get product to update reviews",
              status: ReviewStatus.failure));
        }
      } else {
        emit(state.copyWith(
            addStatus: AddReviewStatus.failure,
            errMessage: reviewsRes.error,
            status: ReviewStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(
          addStatus: AddReviewStatus.failure,
          errMessage: "Something wrong",
          status: ReviewStatus.failure));
    }
  }

  void likeReview(ReviewModel reviewModel) async {
    try {
      emit(state.copyWith(likeStatus: LikeReviewStatus.loading));
      XResult<ReviewModel> reviewsRes =
          await Domain().review.addLikeToReview(reviewModel, state.userId);
      if (reviewsRes.isSuccess) {
        final reviews = await Domain().review.addLikeToLocal(reviewsRes.data!);
        emit(state.copyWith(
            likeStatus: LikeReviewStatus.success,
            reviews: reviews,
            errMessage: ""));
      } else {
        emit(state.copyWith(
            likeStatus: LikeReviewStatus.failure,
            errMessage: reviewsRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          likeStatus: LikeReviewStatus.failure, errMessage: "Something wrong"));
    }
  }

  void setUnselectStar() async {
    emit(state.copyWith(starStatus: StarReviewStatus.unselected));
  }

  void starChange(int star) async {
    emit(state.copyWith(starStatus: StarReviewStatus.selected, starNum: star));
  }

  void setUntypedContent() async {
    emit(state.copyWith(contentStatus: ContentReviewStatus.untyped));
  }

  void contentReviewChanged(String content) {
    emit(
      state.copyWith(
          reviewContent: content, contentStatus: ContentReviewStatus.typed),
    );
  }

  @override
  Future<void> close() async {
    await Domain().review.clearImage();
    return super.close();
  }

  void getImageFromGallery(BuildContext context) async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));
      final imageUrl = await ImagePickerService.handleImageFromGallery(context);
      var listImage = await Domain().review.addImageToList(imageUrl);
      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageLocalPaths: listImage));
    } catch (_) {
      emit(state.copyWith(imageStatus: ImageStatus.failure));
    }
  }

  void getImageFromCamera(BuildContext context) async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));
      final imageUrl = await ImagePickerService.handleImageFromCamera(context);
      var listImage = await Domain().review.addImageToList(imageUrl);
      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageLocalPaths: listImage));
    } catch (_) {
      emit(state.copyWith(
          imageStatus: ImageStatus.failure, errMessage: "Something wrong"));
    }
  }

  void removeImage(String path) async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));

      var listImage = await Domain().review.removeImageToList(path);

      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageLocalPaths: listImage));
    } catch (_) {
      emit(state.copyWith(
          imageStatus: ImageStatus.failure, errMessage: "Something wrong"));
    }
  }
}
