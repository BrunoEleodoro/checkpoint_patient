import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EthereumAddress publicKey;
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
    });
    // return ppk;
  }

  void registrarAction() async {
    final client = Web3Client(
        "https://rinkeby.infura.io/v3/6c35b5b0fa1b4010be4f0db6e60002cb",
        http.Client());
    await rootBundle.loadString('assets/standardToken.json').then((abi) async {
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, "StandardTOken"),
          EthereumAddress.fromHex(
              "0x4D2071dE2A7e2AA144c1fB64E066Ee6AA38D2b41"));
      print(contract.functions[1].name);
      var performAction = contract.function('performAction');
      
     client.call(
          contract: contract,
          function: performAction ,
          params: [publicKey],
        ).then((performAction){
          print(performAction);
          // print(performAction.first);
          // BigInt vr = BigInt.from(balance.first/BigInt.from(1000000000000000));

          // double bal = vr.toDouble()/1000.0;
          // print("bal:"+bal.toString());
          // retbal=bal;
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
              decoration:
                  InputDecoration(border: OutlineInputBorder(), labelText: 'Descricao'),
            ),
          ),

        ],
      ),
    );
  }
}
