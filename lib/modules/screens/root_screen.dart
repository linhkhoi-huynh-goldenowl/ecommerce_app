import 'package:ecommerce_app/modules/screens/bag_screen.dart';
import 'package:ecommerce_app/modules/screens/dashboard_screen.dart';
import 'package:ecommerce_app/modules/screens/favorite_screen.dart';
import 'package:ecommerce_app/modules/screens/profile_screen.dart';
import 'package:ecommerce_app/modules/screens/shop_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/navigation/navigation_cubit.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(13), topLeft: Radius.circular(13)),
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
                currentIndex: state.index,
                showUnselectedLabels: true,
                unselectedItemColor: const Color(0xffadadad),
                selectedItemColor: Colors.red,
                selectedFontSize: 14,
                unselectedFontSize: 14,
                selectedLabelStyle: const TextStyle(fontFamily: "Metropolis"),
                unselectedLabelStyle: const TextStyle(fontFamily: "Metropolis"),
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
                      AssetImage("assets/images/icons/heart.png"),
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
          builder: (context, state) {
        if (state.navbarItem == NavbarItem.home) {
          return const DashboardScreen();
        } else if (state.navbarItem == NavbarItem.shop) {
          return const ShopScreen();
        } else if (state.navbarItem == NavbarItem.bag) {
          return const BagScreen();
        } else if (state.navbarItem == NavbarItem.favorites) {
          return const FavoriteScreen();
        } else if (state.navbarItem == NavbarItem.profile) {
          return const ProfileScreen();
        }
        return Container();
      }),
    );
  }
}
