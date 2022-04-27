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

  void addReview(String productId) async {
    try {
      emit(state.copyWith(addStatus: AddReviewStatus.loading));
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
      var reviews = await Domain().review.addReviewToProduct(reviewModel);
      if (reviews.isSuccess) {
        fetchReviewByProduct(productId);
        var clearImage = await Domain().review.clearImage();
        ProductItem? productItem =
            await Domain().product.getProductById(productId);
        if (productItem != null) {
          productItem.reviewStars = state.avgReviews.round();
          productItem.numberReviews = state.reviews.length;
          await Domain().product.updateProduct(productItem);
        }

        emit(state.copyWith(addStatus: AddReviewStatus.success));
        emit(state.copyWith(
            addStatus: AddReviewStatus.initial,
            reviews: reviews.data,
            imageLocalPaths: clearImage,
            likeStatus: LikeReviewStatus.initial,
            reviewContent: "",
            contentStatus: ContentReviewStatus.initial,
            starNum: 0,
            starStatus: StarReviewStatus.initial,
            imageStatus: ImageStatus.initial));
      } else {
        emit(state.copyWith(addStatus: AddReviewStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(addStatus: AddReviewStatus.failure));
    }
  }

  void likeReview(ReviewModel reviewModel) async {
    try {
      emit(state.copyWith(likeStatus: LikeReviewStatus.loading));
      final reviews =
          await Domain().review.addLikeToReview(reviewModel, state.userId);
      emit(state.copyWith(
          likeStatus: LikeReviewStatus.success, reviews: reviews));
    } catch (_) {
      emit(state.copyWith(likeStatus: LikeReviewStatus.failure));
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
      emit(state.copyWith(imageStatus: ImageStatus.failure));
    }
  }

  void removeImage(String path) async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));

      var listImage = await Domain().review.removeImageToList(path);

      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageLocalPaths: listImage));
    } catch (_) {
      emit(state.copyWith(imageStatus: ImageStatus.failure));
    }
  }
}
