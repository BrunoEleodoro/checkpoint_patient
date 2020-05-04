import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

import 'home.dart';

class CriarCarteiraPage extends StatefulWidget {
  @override
  _CriarCarteiraPageState createState() => _CriarCarteiraPageState();
}

class _CriarCarteiraPageState extends State<CriarCarteiraPage> {
  bool isLoading = false;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      if (prefs.getString('privKey') != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        criarConta();
      }
    });
  }

  void criarConta() async {
    var rng = Random.secure();
    Credentials creds = EthPrivateKey.createRandom(rng);
    Wallet wallet = Wallet.createNew(creds, "UhYSmaUD8XtBZw5TKTPtags3Wz6gAngJJHLYgqf8y9E", rng);
    var address = await creds.extractAddress();
    var add = EthereumAddress.fromHex(address.toString());
    String ppk = HEX.encode(wallet.privateKey.privateKey);
    prefs.setString('pubKey', add.toString());
    prefs.setString('privKey', ppk);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Estamos criando sua carteira'),
      ),
    );
  }
}
