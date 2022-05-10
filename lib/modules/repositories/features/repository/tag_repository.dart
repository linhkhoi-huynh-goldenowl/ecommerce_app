import '../../../models/tag_model.dart';
import '../../x_result.dart';

abstract class TagRepository {
  Stream<XResult<List<TagModel>>> getTagStream();
}
