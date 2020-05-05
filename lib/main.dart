import 'dart:math';

import 'package:checkpoint_patient/pages/criar_carteira.dart';
import 'package:checkpoint_patient/pages/home.dart';
import 'package:checkpoint_patient/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CheckPoint',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: GoogleFonts.reemKufi().fontFamily
        ),
        debugShowCheckedModeBanner: false,
        // home: HomePage());
        // home: HomePage());
        // home: CriarCarteiraPage());
        home: LoginPage());
  }
}
