import 'dart:math';

import 'package:checkpoint_patient/pages/criar_carteira.dart';
import 'package:checkpoint_patient/pages/home.dart';
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
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.reemKufi().fontFamily
        ),
        debugShowCheckedModeBanner: false,
        // home: HomePage());
        // home: HomePage());
        home: CriarCarteiraPage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EthereumAddress publicKey;
  String privateKey;
  TextEditingController controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void criarConta() async {

    var rng = Random.secure();
    Credentials creds = EthPrivateKey.createRandom(rng);
    Wallet wallet = Wallet.createNew(creds, "qwerty", rng);
    var address = await creds.extractAddress();
    print("address:" + address.toString());
    var add = EthereumAddress.fromHex(address.toString());
    print(add);
    String ppk = HEX.encode(wallet.privateKey.privateKey);
    print(address.toString());
    print(ppk.toString());
    setState(() {
      publicKey = address;
      privateKey = ppk;
    });

    // return ppk;
  }

  void registrarAction() async {
    final client = Web3Client(
        "https://rinkeby.infura.io/v3/6c35b5b0fa1b4010be4f0db6e60002cb",
        http.Client());
     rootBundle.loadString('assets/standardToken.json').then((abi) async {
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, "StandardTOken"),
          EthereumAddress.fromHex(
              "0x5C988A2974f2F7aD911Ec3d4CFA93A68C6cA2085"));
      // print(contract.functions[1].name);
      // var performAction = contract.function('performAction');
      Credentials credentials = EthPrivateKey.fromHex("77f35d2bd18850ca37a9b0f76a77cf7d54818cbeb2d7cb5d7194b78ae00020ae");
              var transfer = contract.function('performAction');
              var timestamp = new DateTime.now().millisecondsSinceEpoch;
    print((await credentials.extractAddress()).hex);
      await client
          .sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: transfer,
            parameters: [
              EthereumAddress.fromHex("0x741359Ba7179080F06f1AFC1958b5d39d2A2c815"),
              "Nome do Hospital X",
              controller.text,
              BigInt.from(timestamp),
              BigInt.from(timestamp)
            ]),
        chainId: 4
      )
          .then((hash) {
        print(hash);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Center(
            child: Text('Hello World!'),
          ),
          SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: () {
              criarConta();
            },
            child: Text('El Brabo'),
            color: Colors.orange,
          ),
          MaterialButton(
            onPressed: () {
              registrarAction();
            },
            child: Text('ver Brabo'),
            color: Colors.orange,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Descricao'),
            ),
          ),
        ],
      ),
    );
  }
}
