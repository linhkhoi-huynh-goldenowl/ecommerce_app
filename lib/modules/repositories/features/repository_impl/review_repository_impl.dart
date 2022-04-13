import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modules/models/review_model.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/review_repository.dart';
import 'package:e_commerce_app/modules/repositories/provider/review_provider.dart';

import '../../x_result.dart';

class ReviewRepositoryImpl extends ReviewRepository {
  List<ReviewModel> _listReviews = [];
  final ReviewProvider _reviewProvider = ReviewProvider();
  @override
  Future<List<ReviewModel>> addReviewToProduct(ReviewModel item) async {
    final account = await Domain().profile.getProfile();
    item.accountAvatar = account.imageUrl;
    item.accountName = account.name;
    item.createdDate = Timestamp.now();
    item.id = "${item.accountName}-${item.productId}- ${item.createdDate}";

    XResult<ReviewModel> result =
        await _reviewProvider.addReviewToProduct(item);
    _listReviews.add(result.data!);

    return _listReviews;
  }

  @override
  Future<List<ReviewModel>> getReviewsFromProduct(String productId) async {
    XResult<List<ReviewModel>> result =
        await _reviewProvider.getReviewByProduct(productId);
    _listReviews = result.data ?? [];
    return _listReviews;
  }

  @override
  Future<List<ReviewModel>> getReviewsFromProductWithImage(
      String productId) async {
    return _listReviews.where((element) => element.images.isNotEmpty).toList();
  }

  @override
  Future<List<ReviewModel>> addLikeToReview(
      ReviewModel item, String userId) async {
    final indexLikeUser = item.like.indexWhere((element) => element == userId);
    if (indexLikeUser < 0) {
      item.like.add(userId);
    } else {
      item.like.removeAt(indexLikeUser);
    }

    await _reviewProvider.addReviewToProduct(item);
    final indexList =
        _listReviews.indexWhere((element) => element.id == item.id);
    _listReviews[indexList] == item;

    return _listReviews;
  }
}
