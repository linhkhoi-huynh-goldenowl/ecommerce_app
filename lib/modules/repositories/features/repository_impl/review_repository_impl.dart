import 'package:e_commerce_shop_app/modules/models/review_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/review_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/review_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../x_result.dart';

class ReviewRepositoryImpl extends ReviewRepository {
  final List<String> _listImage = [];
  final ReviewProvider _reviewProvider = ReviewProvider();
  @override
  Future<XResult<ReviewModel>> addReviewToProduct(ReviewModel item) async {
    return await _reviewProvider.addReviewToProduct(item);
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
  Stream<XResult<List<ReviewModel>>> getReviewsFromProductStream(
      String productId) {
    return _reviewProvider.snapshotsAllQuery("productId", productId);
  }

  @override
  Future<Stream<XResult<List<ReviewModel>>>> getReviewsByUserStream() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return _reviewProvider.snapshotsAllQuery("accountId", userId!);
  }
}
