import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/router.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavbarItem.home, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(NavigationState(NavbarItem.home, 0));
        break;

      case NavbarItem.shop:
        emit(NavigationState(NavbarItem.shop, 1));
        break;
      case NavbarItem.bag:
        emit(NavigationState(NavbarItem.bag, 2));
        break;
      case NavbarItem.favorites:
        emit(NavigationState(NavbarItem.favorites, 3));
        break;
      case NavbarItem.profile:
        emit(NavigationState(NavbarItem.profile, 4));
        break;
    }
  }

  Future<bool> checkBackButton() async {
    if (!await Navigator.maybePop(
        state.navigatorKeys[state.index]!.currentState!.context)) {
      if (ModalRoute.of(
                  state.navigatorKeys[state.index]!.currentState!.context)!
              .settings
              .name !=
          Routes.dashboard) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
