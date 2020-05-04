import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:checkpoint_patient/pages/passos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var address = "a";
  SharedPreferences prefs;
  bool viewCode = false;
  List hospitals = List();
  HashMap<String, List> hospitals_steps = HashMap();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        address = prefs.getString('pubKey');
      });
      getSteps();
    });
  }

  void getSteps() async {
    final client = Web3Client(
        "https://rinkeby.infura.io/v3/6c35b5b0fa1b4010be4f0db6e60002cb",
        http.Client());
    rootBundle.loadString('assets/standardToken.json').then((abi) async {
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, "StandardTOken"),
          EthereumAddress.fromHex(
              "0x2C4e20CE742FA3Fc194B5fB0745Fe90ca81cb807"));
      var transfer = contract.function('getActions');

      Credentials credentials =
          EthPrivateKey.fromHex('0x' + prefs.getString('privKey'));
      hospitals.clear();
      hospitals_steps.clear();
      List information = await client.call(
          sender: await credentials.extractAddress(),
          contract: contract,
          function: transfer,
          params: []);
      information = information[0];
      var i = 0;
      while (i < information.length) {
        var hospitalName = information[i][2].toString();
        var description = information[i][3];
        var dataHora = information[i][4];
        if (hospitals.indexOf(hospitalName) == -1) {
          hospitals.add(hospitalName);
        }
        if (hospitals_steps[hospitalName] == null) {
          hospitals_steps[hospitalName] = List();
        }
        hospitals_steps[hospitalName]
            .add({'title': description, 'data': dataHora, 'hora': dataHora});
        i++;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // getSteps();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    'Seja bem vindo(a)!',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      IconButton(icon: Icon(Icons.refresh), onPressed: () {
                        getSteps();
                      }),
                )
              ],
            ),
            Center(
                child: Text(
              'CHAVE DE ATENDIMENTO!',
              style: TextStyle(color: Color(0XFFCCCCCC)),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                child: QrImage(
                  data: address,
                  version: QrVersions.auto,
                  size: 180.0,
                ),
              ),
            ),
            Text((viewCode) ? address : ""),
            Center(
              child: Container(
                width: 100,
                child: Divider(
                  thickness: 2,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 80,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 60,
                      height: 60,
                      child: Card(
                        elevation: 3,
                        child: Center(
                          child: Image.asset('assets/print.png'),
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        viewCode = !viewCode;
                      });
                    },
                    child: Container(
                        width: 60,
                        height: 60,
                        child: Card(
                          elevation: 3,
                          color: (viewCode) ? Colors.grey : Colors.white,
                          child: Center(
                            child: Image.asset('assets/view_code.png'),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: 100,
                child: Divider(
                  thickness: 2,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 120,
                      height: 120,
                      child: Card(
                        elevation: 3,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/add.png'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Nova Consulta')
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: 120,
                      height: 120,
                      child: Card(
                        elevation: 3,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/add_view.png'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Acesso')
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Center(
              child: Container(
                width: 100,
                child: Divider(
                  thickness: 2,
                ),
              ),
            ),
            Text(
              'Últimas Consultas:',
              style: TextStyle(color: Color(0XFFA5A5A5)),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: hospitals.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PassosPage(
                                      consulta: {
                                        'steps':
                                            hospitals_steps[hospitals[index]]
                                      },
                                    )));
                      },
                      child: Container(
                        height: 60,
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 10),
                        child: Card(
                            color: Color(0xFFA4D266),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.greenAccent,
                                      child:
                                          Text(hospitals[index].toString()[0]),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      hospitals[index],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
