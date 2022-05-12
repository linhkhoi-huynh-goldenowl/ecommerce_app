import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';
import 'package:e_commerce_shop_app/utils/services/dynamic_link_services.dart';
import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required this.productId})
      : super(const ProductDetailState()) {
    fetchRelatedList();
    checkContainFavorite();
  }

  final String productId;

  void fetchRelatedList() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    XResult<List<FavoriteProduct>> resultFavorite =
        await Domain().favorite.getFavoritesByUser(userId!);

    XResult<List<ProductItem>> result = await Domain().product.getProductSale();

    List<Map<ProductItem, bool>> listRelated = [];
    if (result.isSuccess && resultFavorite.isSuccess) {
      for (var e in result.data!) {
        if (resultFavorite.data!
            .where((element) => element.productItem.id == e.id!)
            .isNotEmpty) {
          listRelated.add({e: true});
        } else {
          listRelated.add({e: false});
        }
      }

      emit(state.copyWith(relatedList: listRelated));
    } else {
      emit(state.copyWith(relatedList: []));
    }
  }

  void chooseSize(String size) async {
    emit(state.copyWith(size: size, sizeStatus: SizeStatus.selected));
  }

  void setReviews(int reviewStar, int numReview) async {
    emit(state.copyWith(reviewStars: reviewStar, numReview: numReview));
  }

  void setUnselectSize() async {
    emit(state.copyWith(sizeStatus: SizeStatus.unselected));
  }

  void chooseColor(String color) async {
    emit(state.copyWith(color: color, size: ""));
  }

  void shareProductLink(String id) async {
    String result = await DynamicLinkServices.buildDynamicLinkProduct(id);
    await Share.share(result);
  }

  void checkContainFavorite() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    XResult<List<FavoriteProduct>> listCheck =
        await Domain().favorite.getFavoritesByProductId(productId, userId!);
    if (listCheck.isSuccess) {
      emit(state.copyWith(containFavorite: listCheck.data!.isNotEmpty));
    }
  }
}
