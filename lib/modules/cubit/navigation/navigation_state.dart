part of 'navigation_cubit.dart';

enum NavbarItem { home, shop, bag, favorites, profile }

class NavigationState extends Equatable {
  final NavbarItem navbarItem;
  final int index;

  NavigationState(this.navbarItem, this.index);

  final Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
    4: GlobalKey(),
  };

  @override
  List<Object> get props => [navbarItem, index, navigatorKeys];
}
