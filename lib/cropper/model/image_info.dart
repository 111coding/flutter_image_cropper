import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageInfo {
  Uint8List bytes;
  ui.Image image;
  double ratio;
  double ratioWidth;
  double ratioHeight;

  ImageInfo({
    required this.bytes,
    required this.image,
    required this.ratio,
    required this.ratioWidth,
    required this.ratioHeight,
  });

  static Future<ImageInfo?> fromPath({required BuildContext context, required String path}) async {
    try {
      var bytes = await File(path).readAsBytes();
      var image = await decodeImageFromList(bytes);
      double width = image.width.toDouble();
      double height = image.height.toDouble();
      double ratio = height / width;

      double ratioWidth = MediaQuery.of(context).size.width;
      double ratioHeight = ratioWidth * ratio;

      return ImageInfo(bytes: bytes, image: image, ratio: ratio, ratioWidth: ratioWidth, ratioHeight: ratioHeight);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ImageInfo?> fromBytes({required BuildContext context, required Uint8List bytes}) async {
    try {
      var image = await decodeImageFromList(bytes);
      double width = image.width.toDouble();
      double height = image.height.toDouble();
      double ratio = height / width;

      double ratioWidth = MediaQuery.of(context).size.width;
      double ratioHeight = ratioWidth * ratio;

      return ImageInfo(bytes: bytes, image: image, ratio: ratio, ratioWidth: ratioWidth, ratioHeight: ratioHeight);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
