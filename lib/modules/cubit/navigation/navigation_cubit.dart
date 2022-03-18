import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavbarItem.home, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(const NavigationState(NavbarItem.home, 0));
        break;

      case NavbarItem.shop:
        emit(const NavigationState(NavbarItem.shop, 1));
        break;
      case NavbarItem.bag:
        emit(const NavigationState(NavbarItem.bag, 2));
        break;
      case NavbarItem.favorites:
        emit(const NavigationState(NavbarItem.favorites, 3));
        break;
      case NavbarItem.profile:
        emit(const NavigationState(NavbarItem.profile, 4));
        break;
    }
  }
}
