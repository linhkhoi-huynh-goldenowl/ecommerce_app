import 'package:e_commerce_shop_app/modules/models/size_cloth.dart';

class ColorCloth {
  final String color;
  final List<SizeCloth> sizes;

  ColorCloth({required this.color, required this.sizes});

  factory ColorCloth.fromJson(Map<String, dynamic> parsedJson) {
    var sizeObjJson = parsedJson['sizes'] as List;
    List<SizeCloth> _sizes =
        sizeObjJson.map((sizeJson) => SizeCloth.fromJson(sizeJson)).toList();
    return ColorCloth(
      color: parsedJson['color'],
      sizes: _sizes,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> sizesList =
        sizes.map((i) => i.toJson()).toList();
    return {
      'color': color,
      'sizes': sizesList,
    };
  }
}
