import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_cropper/cropper/image_croper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _pickAndCrop() async {
    final result = await ImageCroper.pickAndCrop(context);
    byteImage = result;
    setState(() {});
  }

  Uint8List? byteImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cropper Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (byteImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10000),
                child: Image.memory(
                  byteImage!,
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 10)
            ],
            ElevatedButton(
              onPressed: _pickAndCrop,
              child: const Text("Choose Image"),
            )
          ],
        ),
      ),
    );
  }
}
