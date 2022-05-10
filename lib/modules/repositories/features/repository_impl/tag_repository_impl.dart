import 'package:e_commerce_shop_app/modules/models/tag_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/tag_provider.dart';

import '../../x_result.dart';
import '../repository/tag_repository.dart';

class TagRepositoryImpl extends TagRepository {
  final TagProvider _tagProvider = TagProvider();

  @override
  Stream<XResult<List<TagModel>>> getTagStream() {
    return _tagProvider.snapshotsAll();
  }
}
