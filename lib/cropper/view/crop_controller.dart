import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_cropper/cropper/model/image_info.dart' as img_info;
import 'package:image/image.dart' as img;

class CropController extends ChangeNotifier {
  CropController({Key? key, required this.imageInfo}) {
    _center = Offset(imageInfo.ratioWidth / 2, imageInfo.ratioHeight / 2);
    _rectSize = min(imageInfo.ratioWidth, imageInfo.ratioHeight);
  }

  final img_info.ImageInfo imageInfo;

  bool isLeft = false;
  bool isTop = false;

  final _minRectSize = 100;
  void dragBegin(DragDownDetails details) {
    isLeft = details.localPosition.dx < rectSize / 2;
    isTop = details.localPosition.dy < rectSize / 2;
  }

  void dragUpdate(DragUpdateDetails details, double imageWidth, double imageHeight) {
    double dx = details.delta.dx;
    double dy = details.delta.dy;

    dx = isLeft ? -dx : dx;
    dy = isTop ? -dy : dy;

    double nextRectSize = rectSize + dx + dy;
    if (nextRectSize < _minRectSize) {
      return;
    }

    double newCenterDx = center.dx;
    double newCenterDy = center.dy;

    if (nextRectSize > min(imageWidth, imageHeight)) {
      nextRectSize = min(imageWidth, imageHeight);
    }

    if (center.dx - nextRectSize / 2 < 0) {
      newCenterDx = nextRectSize / 2;
    } else if (center.dx + nextRectSize / 2 > imageWidth) {
      newCenterDx = imageWidth - nextRectSize / 2;
    }

    if (center.dy - nextRectSize / 2 < 0) {
      newCenterDy = nextRectSize / 2;
    } else if (center.dy + nextRectSize / 2 > imageHeight) {
      newCenterDy = imageHeight - nextRectSize / 2;
    }

    _center = Offset(newCenterDx, newCenterDy);
    _rectSize = nextRectSize;
    notifyListeners();
  }

  void offsetUpdate(DragUpdateDetails details, double imageWidth, double imageHeight) {
    double newDx = center.dx + details.delta.dx;
    double newDy = center.dy + details.delta.dy;

    if (!(newDx - rectSize / 2 > 0 && newDx + rectSize / 2 < imageWidth)) {
      newDx = 0;
    } else {
      newDx = details.delta.dx;
    }
    if (!(newDy - rectSize / 2 > 0 && newDy + rectSize / 2 < imageHeight)) {
      newDy = 0;
    } else {
      newDy = details.delta.dy;
    }

    _center = Offset(center.dx + newDx, center.dy + newDy);
    notifyListeners();
  }

  final double paddingPercent = 0.15;

  Offset _center = const Offset(0, 0);
  Offset get center => _center;

  double _rectSize = 10;
  double get rectSize => _rectSize;

  void crop(BuildContext context) {
    var imageOrigin = img.decodeImage(imageInfo.bytes);
    if (imageOrigin == null) return;
    double originRatio = imageInfo.image.width / imageInfo.ratioWidth;
    int size = (originRatio * rectSize).floor();
    int x = ((center.dx - rectSize / 2) * originRatio).floor();
    int y = ((center.dy - rectSize / 2) * originRatio).floor();
    var cropedImage = img.copyCrop(imageOrigin, x, y, size, size);

    var cropedBytes = Uint8List.fromList(img.encodeJpg(cropedImage));
    Navigator.pop(context, cropedBytes);
  }
}
