import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/styles/text_style.dart';

class ImagePickerService {
  static Future<String> handleImageFromCamera() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);

    return pickedImage!.path;
  }

  static Future<String> handleImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
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
