import 'package:e_commerce_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile Screen"),
            TextButton(
                child: const Text('sign out'),
                onPressed: () {
                  BlocProvider.of<AuthenticationCubit>(context).signOut();
                })
          ],
        ),
      ),
    );
  }
}
