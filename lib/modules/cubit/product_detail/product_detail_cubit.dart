import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:equatable/equatable.dart';

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
}
