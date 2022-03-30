part of 'choose_size_cubit.dart';

class ChooseSizeState extends Equatable {
  const ChooseSizeState({this.size = ""});
  final String size;

  ChooseSizeState copyWith({String? size}) {
    return ChooseSizeState(size: size ?? this.size);
  }

  @override
  List<Object> get props => [size];
}
