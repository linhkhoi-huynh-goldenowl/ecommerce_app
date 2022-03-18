import 'package:ecommerce_app/modules/cubit/dashboard/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Dashboard Screen"),
            TextButton(
              child: const Text('sign out'),
              onPressed: () =>
                  BlocProvider.of<DashboardCubit>(context).signOut(),
            )
          ],
        ),
      ),
    );
  }
}
