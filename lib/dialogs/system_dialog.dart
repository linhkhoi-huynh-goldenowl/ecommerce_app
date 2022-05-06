import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/cupertino.dart';

class SystemDialog {
  static void showConfirmDialog(
      {required BuildContext context,
      required VoidCallback func,
      required String title,
      required String content}) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: ETextStyle.metropolis(),
          ),
          content: Text(content, maxLines: 2, style: ETextStyle.metropolis()),
          actions: [
            CupertinoDialogAction(
                child: Text("No", style: ETextStyle.metropolis()),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
                child: Text("Yes", style: ETextStyle.metropolis()),
                onPressed: () {
                  func();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
