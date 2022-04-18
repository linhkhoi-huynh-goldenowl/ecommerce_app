import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingDialog {
  static void permissionCamera(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Camera Permission was denied"),
          content: const Text("Do you want to grant permission?"),
          actions: [
            CupertinoDialogAction(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
                child: const Text("Yes"),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  static void permissionGallery(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Gallery Permission was denied"),
          content: const Text("Do you want to grant permission?"),
          actions: [
            CupertinoDialogAction(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
                child: const Text("Yes"),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
