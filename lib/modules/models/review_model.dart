import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/base_model.dart';

class ReviewModel extends BaseModel {
  final String comment;
  final int star;
  final String productId;
  final List<String> images;
  Timestamp? createdDate;
  String? accountName;
  String? accountId;
  String? accountAvatar;
  List<String> like;

  ReviewModel(
      {String? id,
      this.accountName,
      this.accountAvatar,
      this.accountId,
      required this.comment,
      required this.star,
      required this.productId,
      required this.images,
      this.createdDate,
      required this.like})
      : super(id: id);

  factory ReviewModel.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    return ReviewModel(
        id: id ?? parsedJson['id'],
        comment: parsedJson['comment'],
        star: parsedJson['star'],
        productId: parsedJson['productId'],
        like: parsedJson['like'].cast<String>(),
        createdDate: parsedJson['createdDate'],
        images: parsedJson['images'].cast<String>(),
        accountName: parsedJson['accountName'],
        accountId: parsedJson['accountId'],
        accountAvatar: parsedJson['accountAvatar']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'star': star,
      'productId': productId,
      'like': like,
      'createdDate': createdDate,
      'images': images,
      'accountName': accountName,
      'accountAvatar': accountAvatar,
      'accountId': accountId
    };
  }
}
