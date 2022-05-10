import 'package:e_commerce_shop_app/modules/models/base_model.dart';

class TagModel extends BaseModel {
  final String name;
  TagModel({
    String? id,
    required this.name,
  }) : super(id: id);

  factory TagModel.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    return TagModel(id: id ?? parsedJson['id'], name: parsedJson['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
