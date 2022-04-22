import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/base_collection.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';

class ProductProvider extends BaseCollectionReference<ProductItem> {
  ProductProvider()
      : super(FirebaseFirestore.instance.collection('products').withConverter<
                ProductItem>(
            fromFirestore: (snapshot, options) =>
                ProductItem.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (product, _) => product.toJson()));

  Future<XResult<ProductItem>> updateProduct(ProductItem productItem) async {
    final XResult<ProductItem> res = await set(productItem);
    return res;
  }

  Future<XResult<List<ProductItem>>> getAllProduct() async {
    final XResult<List<ProductItem>> res = await query();
    return res;
  }

  Future<XResult<ProductItem>> getProduct(String id) async {
    final XResult<ProductItem> res = await get(id);
    return res;
  }
}
