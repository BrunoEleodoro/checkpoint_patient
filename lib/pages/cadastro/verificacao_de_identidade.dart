import 'dart:io';

import 'package:camera/camera.dart';
import 'package:checkpoint_patient/pages/cadastro/otp_screen.dart';
import 'package:checkpoint_patient/pages/cadastro/tirar_foto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class VerificacaoDeIdentidade extends StatefulWidget {
  @override
  _VerificacaoDeIdentidadeState createState() =>
      _VerificacaoDeIdentidadeState();
}

class _VerificacaoDeIdentidadeState extends State<VerificacaoDeIdentidade> {
  CameraController controller;
  List<CameraDescription> cameras;
  bool nextStep = false;
  bool displayCamera = false;
  File _image;
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {

    // });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  void takePicture() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      SingleChildScrollView(
          child: Container(
              width: double.maxFinite,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'assets/logo.png',
                      width: 120,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Verificação de Identidade',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              'Para a verificação dos dados precisamos de algumas fotos',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              width: 100,
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Tire uma selfie com o documento em sua mão:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            child: (_image != null)
                                ? Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(_image),
                                            fit: BoxFit.cover)),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      await Permission.camera.request();
                                      if (await Permission.camera.isGranted) {
                                        getImage();
                                      } else {}
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.camera_alt,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Escolher foto',
                                              style: TextStyle(
                                                  color: Color(0XFFCCCCCC)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    )
                  ]))),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: MaterialButton(
            color: Colors.greenAccent,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OTPScreen()));
            },
            child: Text(
              'Próximo >',
              style: TextStyle(),
            ),
            minWidth: double.maxFinite,
          ),
        ),
      ),
    ]));
  }
}
