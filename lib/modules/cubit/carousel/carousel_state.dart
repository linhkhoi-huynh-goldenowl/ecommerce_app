part of 'carousel_cubit.dart';

class CarouselState extends Equatable {
  const CarouselState(this.index);
  final int index;

  @override
  List<Object> get props => [index];
}
