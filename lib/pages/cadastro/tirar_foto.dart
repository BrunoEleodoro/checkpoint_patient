// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TirarFotoPage extends StatefulWidget {
  @override
  _TirarFotoPageState createState() => _TirarFotoPageState();
}

class _TirarFotoPageState extends State<TirarFotoPage> {
  CameraController controller;
  List<CameraDescription> cameras;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
        cameras = await availableCameras();
        
      controller = CameraController(cameras[1], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  void tirarFoto() async {
    await controller.takePicture('frontal.png');
    
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
