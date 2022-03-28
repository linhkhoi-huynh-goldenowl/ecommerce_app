import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.profileRepository})
      : super(ProfileState(dateOfBirth: DateTime.now())) {
    profileLoaded();
  }

  final ProfileRepository profileRepository;

  void profileLoaded() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await profileRepository.getProfile();
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: user.name,
        email: user.email,
        dateOfBirth: user.dateOfBirth,
        password: user.password,
        notificationDelivery: user.notificationDelivery,
        notificationNewArrivals: user.notificationNewArrivals,
        notificationSale: user.notificationSale,
        // shippingAddress: user.shippingAddress
      ));
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }
}
