import 'package:ecommerce_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:ecommerce_app/modules/cubit/category/category_cubit.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:ecommerce_app/modules/repositories/category_repository.dart';
import 'package:ecommerce_app/modules/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/router.dart';
import 'modules/repositories/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => AuthRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AuthenticationCubit(authRepo: context.read<AuthRepository>()),
            ),
            BlocProvider(
              create: (context) =>
                  ProductCubit(productRepository: ProductRepository()),
            ),
            BlocProvider(
              create: (context) =>
                  CategoryCubit(categoryRepository: CategoryRepository()),
            ),
          ],
          child: const MaterialApp(
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: Routes.landing,
          ),
        ));
  }
}
