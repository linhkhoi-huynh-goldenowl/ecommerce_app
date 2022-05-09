import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/tag_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/base_collection.dart';

class TagProvider extends BaseCollectionReference<TagModel> {
  TagProvider()
      : super(FirebaseFirestore.instance
            .collection('tags')
            .withConverter<TagModel>(
                fromFirestore: (snapshot, options) =>
                    TagModel.fromJson(snapshot.data() as Map<String, dynamic>),
                toFirestore: (tag, _) => tag.toJson()));
}
