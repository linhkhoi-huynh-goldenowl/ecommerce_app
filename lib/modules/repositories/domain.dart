import 'package:e_commerce_shop_app/modules/repositories/features/repository/address_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/cart_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/category_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/credit_card_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/delivery_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/favorite_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/order_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/product_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/profile_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/promotion_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/review_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/address_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/cart_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/category_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/credit_card_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/delivery_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/favorite_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/order_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/product_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/profile_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/promotion_repository_impl.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository_impl/review_repository_impl.dart';

import 'features/repository/auth_repository.dart';
import 'features/repository_impl/auth_repository_impl.dart';

class Domain {
  static Domain? _internal;
  Domain._() {
    auth = AuthRepositoryImpl();
    favorite = FavoriteRepositoryImpl();
    product = ProductRepositoryImpl();
    category = CategoryRepositoryImpl();
    profile = ProfileRepositoryImpl();
    cart = CartRepositoryImpl();
    review = ReviewRepositoryImpl();
    promo = PromotionRepositoryImpl();
    address = AddressRepositoryImpl();
    creditCard = CreditCardRepositoryImpl();
    delivery = DeliveryRepositoryImpl();
    order = OrderRepositoryImpl();
  }
  factory Domain() {
    _internal ??= Domain._();
    return _internal!;
  }
  late final AuthRepository auth;
  late final FavoriteRepository favorite;
  late final ProductRepository product;
  late final CategoryRepository category;
  late final ProfileRepository profile;
  late final CartRepository cart;
  late final ReviewRepository review;
  late final PromotionRepository promo;
  late final AddressRepository address;
  late final CreditCardRepository creditCard;
  late final DeliveryRepository delivery;
  late final OrderRepository order;
}
