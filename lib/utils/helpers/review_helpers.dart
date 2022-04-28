import 'package:e_commerce_app/modules/models/review_model.dart';
import 'dart:math' as math;

class ReviewHelper {
  static List<int> getReviewDetail(List<ReviewModel> reviews) {
    List<int> result = [0, 0, 0, 0, 0];
    for (var review in reviews) {
      switch (review.star) {
        case 1:
          result[0] = result[0] + 1;
          break;
        case 2:
          result[1] = result[1] + 1;
          break;
        case 3:
          result[2] = result[2] + 1;
          break;
        case 4:
          result[3] = result[3] + 1;
          break;
        case 5:
          result[4] = result[4] + 1;
          break;
      }
    }
    return result;
  }

  static List<double> getReviewPercent(List<ReviewModel> reviews) {
    final reviewCount = getReviewDetail(reviews);
    int max = reviewCount.reduce(math.max);
    List<double> result = [0, 0, 0, 0, 0];
    for (var i = 0; i < reviewCount.length; i++) {
      result[i] = (reviewCount[i].toDouble() / max) * 10;
    }
    return result;
  }

  static double getAvgReviews(List<ReviewModel> reviews) {
    double avg = 0;
    final reviewDetail = getReviewDetail(reviews);
    for (var i = 0; i < reviewDetail.length; i++) {
      avg += reviewDetail[i] * (i + 1);
    }
    avg = avg / reviews.length;
    return avg;
  }

  static bool checkLike(List<String> listIdLike, String id) {
    return listIdLike.where((element) => element == id).isNotEmpty;
  }
}
