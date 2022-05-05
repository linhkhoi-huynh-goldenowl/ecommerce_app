import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/review_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/review_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/review_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../x_result.dart';

class ReviewRepositoryImpl extends ReviewRepository {
  List<ReviewModel> _listReviews = [];
  final List<String> _listImage = [];
  final ReviewProvider _reviewProvider = ReviewProvider();
  @override
  Future<XResult<ReviewModel>> addReviewToProduct(ReviewModel item) async {
    final account = await Domain().profile.getProfile();
    item.accountAvatar = account.imageUrl;
    item.accountName = account.name;
    item.createdDate = Timestamp.now();
    item.accountId = account.id;
    item.id = "${item.accountName}-${item.productId}- ${item.createdDate}";

    return await _reviewProvider.addReviewToProduct(item);
  }

  @override
  Future<List<ReviewModel>> addReviewToLocal(ReviewModel item) async {
    _listReviews.add(item);
    return _listReviews;
  }

  @override
  Future<XResult<List<ReviewModel>>> getReviewsFromProduct(
      String productId) async {
    return await _reviewProvider.getReviewByProduct(productId);
  }

  @override
  Future<List<ReviewModel>> setReviewList(List<ReviewModel> reviews) async {
    _listReviews = reviews;
    _listReviews.sort(
      (a, b) => b.createdDate!.toDate().compareTo(a.createdDate!.toDate()),
    );
    return _listReviews;
  }

  @override
  Future<List<ReviewModel>> getReviewsFromProductWithImage(bool isImage) async {
    if (isImage) {
      return _listReviews
          .where((element) => element.images.isNotEmpty)
          .toList();
    } else {
      return _listReviews;
    }
  }

  @override
  Future<XResult<ReviewModel>> addLikeToReview(
      ReviewModel item, String userId) async {
    final indexLikeUser = item.like.indexWhere((element) => element == userId);
    if (indexLikeUser < 0) {
      item.like.add(userId);
    } else {
      item.like.removeAt(indexLikeUser);
    }

    return await _reviewProvider.addReviewToProduct(item);
  }

  @override
  Future<List<ReviewModel>> addLikeToLocal(ReviewModel item) async {
    final indexList =
        _listReviews.indexWhere((element) => element.id == item.id);
    _listReviews[indexList] == item;

    return _listReviews;
  }

  @override
  Future<List<String>> addImageToList(String path) async {
    _listImage.add(path);
    return _listImage;
  }

  @override
  Future<List<String>> getImage() async {
    return _listImage;
  }

  @override
  Future<List<String>> removeImageToList(String path) async {
    _listImage.removeWhere((element) => element == path);
    return _listImage;
  }

  @override
  Future<List<String>> clearImage() async {
    _listImage.clear();
    return _listImage;
  }

  @override
  Future<XResult<List<ReviewModel>>> getReviewsByUser() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return await _reviewProvider.getReviewByUser(userId!);
  }
}
