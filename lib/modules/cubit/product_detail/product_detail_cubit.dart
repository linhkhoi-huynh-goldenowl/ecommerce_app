import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/utils/services/dynamic_link_services.dart';
import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required this.category})
      : super(const ProductDetailState());
  final String category;
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
}
