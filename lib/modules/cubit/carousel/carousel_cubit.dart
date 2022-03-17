import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'carousel_state.dart';

class CarouselCubit extends Cubit<CarouselState> {
  CarouselCubit() : super(const CarouselState(0));

  void nextIndex(max) {
    if (state.index < max) {
      emit(CarouselState(state.index + 1));
    } else {
      emit(const CarouselState(0));
    }
  }
}
