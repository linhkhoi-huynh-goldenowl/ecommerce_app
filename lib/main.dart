import 'package:device_preview/device_preview.dart';
import 'package:e_commerce_shop_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_shop_app/utils/services/navigator_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Add device preview to see UI on IOS device
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
        create: (BuildContext context) => AuthenticationCubit(),
        child: MaterialApp(
          //Add device preview to see UI on IOS device
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: Routes.landing,
        ));
  }
}
