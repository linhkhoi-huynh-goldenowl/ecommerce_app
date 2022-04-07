import 'package:e_commerce_app/modules/models/color_cloth.dart';

class ProductHelper {
  List getNewsProducts(List products) {
    return products
        .where((element) =>
            (element.createdDate.month == DateTime.now().month &&
                element.createdDate.year == DateTime.now().year))
        .toList();
  }

  List getSaleProducts(List products) {
    return products.where((element) => element.salePercent != null).toList();
  }

  static int getIndexOfColor(String color, List<ColorCloth> listColor) {
    for (var element in listColor) {
      if (element.color == color) {
        return listColor.indexOf(element);
      }
    }
    return 0;
  }
}
