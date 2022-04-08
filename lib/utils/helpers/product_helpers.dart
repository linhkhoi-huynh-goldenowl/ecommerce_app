import 'package:e_commerce_app/modules/models/color_cloth.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/models/size_cloth.dart';

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

  static int getIndexOfSize(String size, List<SizeCloth> listSize) {
    for (var element in listSize) {
      if (element.size == size) {
        return listSize.indexOf(element);
      }
    }
    return 0;
  }

  static double getPriceItem(
      ProductItem productItem, String color, String size) {
    int indexColor = getIndexOfColor(color, productItem.colors);
    int indexSize = getIndexOfSize(size, productItem.colors[indexColor].sizes);
    return productItem.colors[indexColor].sizes[indexSize].price;
  }

  static double getPriceWithSaleItem(
      ProductItem productItem, String color, String size) {
    if (productItem.salePercent == null) {
      int indexColor = getIndexOfColor(color, productItem.colors);
      int indexSize =
          getIndexOfSize(size, productItem.colors[indexColor].sizes);
      return productItem.colors[indexColor].sizes[indexSize].price;
    } else {
      int indexColor = getIndexOfColor(color, productItem.colors);
      int indexSize =
          getIndexOfSize(size, productItem.colors[indexColor].sizes);
      double price = productItem.colors[indexColor].sizes[indexSize].price;
      price = price - (price * productItem.salePercent! / 100);
      return price;
    }
  }
}
