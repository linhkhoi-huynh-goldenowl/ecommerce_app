import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/screens/bag_screen.dart';
import 'package:e_commerce_app/modules/screens/home_screen.dart';
import 'package:e_commerce_app/modules/screens/favorite_screen.dart';
import 'package:e_commerce_app/modules/screens/profile_screen.dart';
import 'package:e_commerce_app/modules/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/navigation/navigation_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NavigationCubit(), child: _buildBody());
  }

  Widget _buildBody() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(13),
                    topLeft: Radius.circular(13)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(13),
                  topLeft: Radius.circular(13),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: state.index,
                  showUnselectedLabels: true,
                  unselectedItemColor: const Color(0xffadadad),
                  selectedItemColor: Colors.red,
                  selectedFontSize: 14,
                  unselectedFontSize: 14,
                  selectedLabelStyle: ETextStyle.metropolis(),
                  unselectedLabelStyle: ETextStyle.metropolis(),
                  items: const [
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/icons/home_fill.png"),
                        size: 38,
                      ),
                      icon: ImageIcon(
                        AssetImage("assets/images/icons/home.png"),
                        size: 38,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/icons/shop_fill.png"),
                        size: 38,
                      ),
                      icon: ImageIcon(
                        AssetImage("assets/images/icons/shop.png"),
                        size: 38,
                      ),
                      label: 'Shop',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/icons/bag_fill.png"),
                        size: 38,
                      ),
                      icon: ImageIcon(
                        AssetImage("assets/images/icons/bag.png"),
                        size: 38,
                      ),
                      label: 'Bag',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/icons/heart_fill.png"),
                        size: 38,
                      ),
                      icon: ImageIcon(
                        AssetImage("assets/images/icons/hear_outline.png"),
                        size: 38,
                      ),
                      label: 'favorites',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                        AssetImage("assets/images/icons/person_fill.png"),
                        size: 38,
                      ),
                      icon: ImageIcon(
                        AssetImage("assets/images/icons/person.png"),
                        size: 38,
                      ),
                      label: 'Profile',
                    ),
                  ],
                  onTap: (index) {
                    if (index == 0) {
                      BlocProvider.of<NavigationCubit>(context)
                          .getNavBarItem(NavbarItem.home);
                    } else if (index == 1) {
                      BlocProvider.of<NavigationCubit>(context)
                          .getNavBarItem(NavbarItem.shop);
                    } else if (index == 2) {
                      BlocProvider.of<NavigationCubit>(context)
                          .getNavBarItem(NavbarItem.bag);
                    } else if (index == 3) {
                      BlocProvider.of<NavigationCubit>(context)
                          .getNavBarItem(NavbarItem.favorites);
                    } else if (index == 4) {
                      BlocProvider.of<NavigationCubit>(context)
                          .getNavBarItem(NavbarItem.profile);
                    }
                  },
                ),
              ),
            );
          },
        ),
        body: BlocBuilder<NavigationCubit, NavigationState>(
            buildWhen: (previous, current) => previous.index != current.index,
            builder: (context, state) {
              switch (state.navbarItem) {
                case NavbarItem.home:
                  return HomeScreen();
                case NavbarItem.shop:
                  return ShopScreen();
                case NavbarItem.bag:
                  return const BagScreen();
                case NavbarItem.favorites:
                  return const FavoriteScreen();
                case NavbarItem.profile:
                  return ProfileScreen();
              }
            }),
      ),
    );
  }
}
