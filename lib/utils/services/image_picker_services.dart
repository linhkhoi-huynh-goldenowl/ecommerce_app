import 'package:e_commerce_app/dialogs/setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/styles/text_style.dart';

class ImagePickerService {
  static Future<String> handleImageFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    var status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      SettingDialog.permissionCamera(context);
    } else {
      pickedImage = await picker.pickImage(source: ImageSource.camera);
    }

    return pickedImage!.path;
  }

  static Future<String> handleImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    var status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      SettingDialog.permissionCamera(context);
    } else {
      pickedImage = await picker.pickImage(source: ImageSource.gallery);
    }

    return pickedImage!.path;
  }

  static void showDialogCamera(BuildContext context, VoidCallback funcGallery,
          VoidCallback funcCamera) =>
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              elevation: 11,
              title: Text(
                'Update Image',
                textAlign: TextAlign.center,
                style: ETextStyle.metropolis(
                    fontSize: 20, weight: FontWeight.w600),
              ),
              children: <Widget>[
                SimpleDialogOption(
                  child: const Text('Image from camera'),
                  onPressed: funcCamera,
                ),
                SimpleDialogOption(
                  child: const Text('Image from gallery'),
                  onPressed: funcGallery,
                ),
                SimpleDialogOption(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
}
