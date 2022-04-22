import 'dart:io';

import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<XResult> uploadToFirebase(String filePath, String fileName) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName);
    File file = File(filePath);
    try {
      await ref.putFile(file);
      String imageUrl = await ref.getDownloadURL();
      return XResult.success(imageUrl);
    } catch (_) {
      return XResult.error("Upload Failed");
    }
  }
}
