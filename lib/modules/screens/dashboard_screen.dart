import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/screens/bag_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/favorite_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/profile_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart/cart_cubit.dart';
import '../cubit/favorite/favorite_cubit.dart';
import '../cubit/navigation/navigation_cubit.dart';
import 'home_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<NavigationCubit>(
        create: (BuildContext context) => NavigationCubit(),
      ),
      BlocProvider<FavoriteCubit>(
          create: (BuildContext context) => FavoriteCubit()),
      BlocProvider<CartCubit>(create: (BuildContext context) => CartCubit()),
    ], child: _buildBody());
  }

  Widget _buildBody() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: _bottomNavBar(),
        body: _bodyDisplay(),
      ),
    );
  }
}

Widget _bodyDisplay() {
  return BlocBuilder<NavigationCubit, NavigationState>(
    buildWhen: (previous, current) => previous.index != current.index,
    builder: (context, state) {
      return IndexedStack(
        children: <Widget>[
          HomeScreen(),
          ShopScreen(),
          const BagScreen(),
          const FavoriteScreen(),
          ProfileScreen()
        ],
        index: state.index,
      );
    },
  );
}

Widget _bottomNavBar() {
  return BlocBuilder<NavigationCubit, NavigationState>(
    buildWhen: (previous, current) => previous.index != current.index,
    builder: (context, state) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(13), topLeft: Radius.circular(13)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
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
            selectedLabelStyle:
                ETextStyle.metropolis(fontSize: 10, weight: FontWeight.w600),
            unselectedLabelStyle:
                ETextStyle.metropolis(fontSize: 10, weight: FontWeight.w600),
            items: _listItem,
            onTap: (index) {
              switch (index) {
                case 0:
                  BlocProvider.of<NavigationCubit>(context)
                      .getNavBarItem(NavbarItem.home);
                  break;
                case 1:
                  BlocProvider.of<NavigationCubit>(context)
                      .getNavBarItem(NavbarItem.shop);
                  break;
                case 2:
                  BlocProvider.of<NavigationCubit>(context)
                      .getNavBarItem(NavbarItem.bag);
                  break;
                case 3:
                  BlocProvider.of<NavigationCubit>(context)
                      .getNavBarItem(NavbarItem.favorites);
                  break;
                case 4:
                  BlocProvider.of<NavigationCubit>(context)
                      .getNavBarItem(NavbarItem.profile);
                  break;
              }
            },
          ),
        ),
      );
    },
  );
}

List<BottomNavigationBarItem> _listItem = const [
  BottomNavigationBarItem(
    activeIcon: ImageIcon(
      AssetImage("assets/images/icons/home_fill.png"),
      size: 30,
    ),
    icon: ImageIcon(
      AssetImage("assets/images/icons/home.png"),
      size: 30,
    ),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    activeIcon: ImageIcon(
      AssetImage("assets/images/icons/shop_fill.png"),
      size: 30,
    ),
    icon: ImageIcon(
      AssetImage("assets/images/icons/shop.png"),
      size: 30,
    ),
    label: 'Shop',
  ),
  BottomNavigationBarItem(
    activeIcon: ImageIcon(
      AssetImage("assets/images/icons/bag_fill.png"),
      size: 30,
    ),
    icon: ImageIcon(
      AssetImage("assets/images/icons/bag.png"),
      size: 30,
    ),
    label: 'Bag',
  ),
  BottomNavigationBarItem(
    activeIcon: ImageIcon(
      AssetImage("assets/images/icons/heart_fill.png"),
      size: 30,
    ),
    icon: ImageIcon(
      AssetImage("assets/images/icons/heart.png"),
      size: 30,
    ),
    label: 'Favorites',
  ),
  BottomNavigationBarItem(
    activeIcon: ImageIcon(
      AssetImage("assets/images/icons/person_fill.png"),
      size: 30,
    ),
    icon: ImageIcon(
      AssetImage("assets/images/icons/person.png"),
      size: 30,
    ),
    label: 'Profile',
  ),
];
