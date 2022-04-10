import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_cropper/cropper/view/crop_page.dart';
import 'package:flutter_image_cropper/cropper/model/image_info.dart' as img_info;
import 'package:image_picker/image_picker.dart';

class ImageCroper {
  static Future<Uint8List?> pickAndCrop(BuildContext context, {int imageQuality = 25}) async {
    // if (await Permission.photos.isDenied) {
    //   // print("test");
    //   bool isPhotoPerssionDenied = await Permission.photos.request().isDenied;
    //   if (isPhotoPerssionDenied) {
    //     return null;
    //   }
    // }
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: imageQuality);
    final bytes = await image!.readAsBytes();
    return await ImageCroper.fromBytes(context: context, bytes: bytes);
  }

  static Future<Uint8List?> fromBytes({
    required BuildContext context,
    required Uint8List bytes,
  }) async {
    var imageInfo = await img_info.ImageInfo.fromBytes(context: context, bytes: bytes);

    if (imageInfo == null) return null;

    return await showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) {
        return CropPage(imageInfo: imageInfo);
      },
    );
  }
}
