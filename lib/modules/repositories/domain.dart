import 'package:e_commerce_app/modules/repositories/features/repository/category_repository.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/favorite_repository.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/product_repository.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/profile_repository.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/category_repository_impl.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/favorite_repository_impl.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/product_repository_impl.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/profile_repository_impl.dart';

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
}
