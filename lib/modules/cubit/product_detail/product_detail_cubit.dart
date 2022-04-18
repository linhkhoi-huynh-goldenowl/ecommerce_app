import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required this.category})
      : super(const ProductDetailState()) {
    setRelatedList();
  }
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
    emit(state.copyWith(color: color));
  }

  void setRelatedList() async {
    try {
      emit(state.copyWith(relatedStatus: RelatedStatus.loading));
      final relatedList =
          await Domain().product.getProductsByCategory(TypeList.all, category);
      emit(state.copyWith(
          relatedStatus: RelatedStatus.success, relatedList: relatedList));
    } catch (_) {
      emit(state.copyWith(relatedStatus: RelatedStatus.failure));
    }
  }
}
