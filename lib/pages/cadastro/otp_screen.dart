import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:checkpoint_patient/pages/criar_carteira.dart';
import 'package:checkpoint_patient/secrets.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BuildContext _context;
  String verifier = "";
  final PageController _pageController = PageController(initialPage: 1);
  int _pageIndex = 0;
  Widget onlySelectedBorderPinPut() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5),
    );

    return PinPut(
      fieldsCount: 5,
      textStyle: TextStyle(fontSize: 25, color: Colors.black),
      eachFieldWidth: 45,
      eachFieldHeight: 55,
      onSubmit: (String pin) => _showSnackBar(pin),
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration.copyWith(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: Color.fromRGBO(160, 215, 220, 1),
          )),
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var str = getRandomNumber();
      setState(() {
        verifier = str;
      });
      sendSMS(str);
    });
  }

  String getRandomNumber() {
    var res = "";
    var rng = new Random();
    for (var i = 0; i < 5; i++) {
      res += rng.nextInt(10).toString();
    }
    return res;
  }

  void sendSMS(msg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cred =
        'AC099bcf0139d066d1ef92a2c0f28a0552:${token}';

    var bytes = utf8.encode(cred);

    var base64Str = base64.encode(bytes);

    var url =
        'https://api.twilio.com/2010-04-01/Accounts/AC099bcf0139d066d1ef92a2c0f28a0552/Messages.json';

    var response = await http.post(url, headers: {
      'Authorization': 'Basic ${base64Str}'
    }, body: {
      'From': '+17737410743', //twilio number
      'To': prefs.getString('telephoneNumber'),
      'Body': msg
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    getRandomNumber();
    List<Widget> _pinPuts = [
      onlySelectedBorderPinPut(),
    ];

    List<Color> _bgColors = [
      Colors.white,
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Builder(
              builder: (context) {
                _context = context;
                return AnimatedContainer(
                  color: _bgColors[_pageIndex],
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(40),
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    children: _pinPuts.map((p) {
                      return FractionallySizedBox(
                        heightFactor: 1,
                        child: Center(child: p),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String pin) {
    if (pin == verifier) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CriarCarteiraPage()));
    } else {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              tittle: 'Dados Incorretos',
              desc: 'Verifique o codigo!',
              btnCancelOnPress: () {},
              btnOkOnPress: () {})
          .show();
    }
    // final snackBar = SnackBar(
    //   duration: Duration(seconds: 3),
    //   content: Container(
    //       height: 80.0,
    //       child: Center(
    //         child: Text(
    //           'Pin Submitted. Value: $pin',
    //           style: TextStyle(fontSize: 25.0),
    //         ),
    //       )),
    //   backgroundColor: Colors.deepPurpleAccent,
    // );
    // Scaffold.of(_context).hideCurrentSnackBar();
    // Scaffold.of(_context).showSnackBar(snackBar);
  }
}
