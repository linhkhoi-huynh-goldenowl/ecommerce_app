import 'dart:io';

import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/e_cached_image.dart';

class AvatarChangeImage extends StatelessWidget {
  const AvatarChangeImage(
      {Key? key,
      required this.imgUrl,
      required this.funcGallery,
      required this.funcCamera,
      required this.imgUser})
      : super(key: key);
  final VoidCallback funcGallery;
  final VoidCallback funcCamera;
  final String imgUrl;
  final String imgUser;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => showDialog(
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
            }),
        child: Stack(
          children: [
            imgUrl != ""
                ? CircleAvatar(
                    backgroundImage: FileImage(
                      File(imgUrl),
                    ),
                    radius: 44,
                  )
                : (imgUser != ""
                    ? SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ECachedImage(img: imgUser)),
                      )
                    : SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "assets/images/default-avatar.jpg",
                              fit: BoxFit.cover,
                            )),
                      )),
            const Positioned(
              child: Icon(
                CupertinoIcons.camera_fill,
                color: Colors.red,
              ),
              bottom: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
