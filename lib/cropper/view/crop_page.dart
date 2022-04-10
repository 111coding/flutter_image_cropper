import 'package:flutter/material.dart';
import 'package:flutter_image_cropper/cropper/view/crop_controller.dart';
import 'package:flutter_image_cropper/cropper/view/crop_painter.dart';
import 'package:flutter_image_cropper/cropper/view/edge_painter.dart';
import 'package:flutter_image_cropper/cropper/model/image_info.dart' as img_info;

class CropPage extends StatefulWidget {
  const CropPage({Key? key, required this.imageInfo}) : super(key: key);

  final img_info.ImageInfo imageInfo;

  @override
  State<CropPage> createState() => CropPageSate();
}

class CropPageSate extends State<CropPage> {
  final Color bgColor = Colors.black;
  final Color dimColor = Colors.black87;

  late final controller = CropController(imageInfo: widget.imageInfo)
    ..addListener(() {
      setState(() {});
    });

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _circleTouch({required double ratioWidth, required double ratioHeight}) {
    return GestureDetector(
      onPanUpdate: (details) {
        controller.offsetUpdate(details, ratioWidth, ratioHeight);
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      ),
    );
  }

  Widget _backBtn(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 24,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _confirmBtn(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      bottom: 24 + MediaQuery.of(context).padding.bottom,
      child: GestureDetector(
        onTap: () {
          controller.crop(context);
        },
        child: SizedBox(
          width: constraints.maxWidth,
          child: Center(
            child: Container(
              width: 71,
              height: 71,
              decoration: const BoxDecoration(
                color: Colors.amberAccent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.check),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    Container(width: constraints.maxWidth, height: MediaQuery.of(context).padding.top, color: bgColor),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, innerConstraints) {
                          return Stack(
                            children: [
                              // ㅅㅏ지ㄴ
                              Container(
                                width: innerConstraints.maxWidth,
                                height: innerConstraints.maxHeight,
                                color: bgColor,
                                child: Container(
                                  width: controller.imageInfo.ratioWidth,
                                  height: controller.imageInfo.ratioHeight,
                                  alignment: Alignment.center,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.memory(controller.imageInfo.bytes),
                                      // Cropper
                                      Container(
                                        width: controller.imageInfo.ratioWidth,
                                        height: controller.imageInfo.ratioHeight,
                                        child: CustomPaint(
                                          painter: CropPainter(
                                            color: dimColor,
                                            radius: controller.rectSize * (1 - controller.paddingPercent),
                                            center: controller.center,
                                          ),
                                        ),
                                      ),
                                      // TouchBox
                                      Positioned(
                                        top: controller.center.dy - controller.rectSize / 2,
                                        left: controller.center.dx - controller.rectSize / 2,
                                        child: GestureDetector(
                                          onPanDown: (details) {
                                            controller.dragBegin(details);
                                          },
                                          onPanUpdate: (details) {
                                            controller.dragUpdate(details, controller.imageInfo.ratioWidth, controller.imageInfo.ratioHeight);
                                          },
                                          child: Container(
                                            width: controller.rectSize,
                                            height: controller.rectSize,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                                            ),
                                            alignment: Alignment.center,
                                            // 원 이동
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  width: controller.rectSize,
                                                  height: controller.rectSize,
                                                  child: CustomPaint(
                                                    painter: EdgePainter(),
                                                  ),
                                                ),
                                                _circleTouch(ratioWidth: controller.imageInfo.ratioWidth, ratioHeight: controller.imageInfo.ratioHeight),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(width: constraints.maxWidth, height: MediaQuery.of(context).padding.bottom, color: bgColor),
                  ],
                ),
              ),
              _backBtn(context),
              _confirmBtn(context, constraints),
            ],
          );
        },
      ),
    );
  }
}
