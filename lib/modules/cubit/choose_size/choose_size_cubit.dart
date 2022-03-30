import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'choose_size_state.dart';

class ChooseSizeCubit extends Cubit<ChooseSizeState> {
  ChooseSizeCubit() : super(const ChooseSizeState());

  void chooseSize(String size) {
    emit(state.copyWith(size: size));
  }
}
