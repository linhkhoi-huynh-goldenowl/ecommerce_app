import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    ? CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(imgUser),
                        radius: 44,
                      )
                    : const CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                        radius: 44,
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
