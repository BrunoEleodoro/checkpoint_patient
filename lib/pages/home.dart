import 'package:checkpoint_patient/pages/passos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  var address = "a";
  SharedPreferences prefs;
  bool viewCode = false;
  List consultas = List.from([
    {
      'hospital': "Sirio Libanes",
      'data': '28/04/2020',
      'steps': [
        {'title': 'Chegou ao local', 'data': '28/04/2020', 'hora': '11:32'},
        {
          'title': 'Realizou consulta no clinico geral',
          'data': '28/04/2020',
          'hora': '12:50'
        },
        {
          'title': 'Realizou exame de sangue',
          'data': '28/04/2020',
          'hora': '13:12'
        },
      ]
    },
    {
      'hospital': "Sirio Libanes",
      'data': '28/04/2020',
      'steps': [
        {'title': 'Chegou ao local', 'data': '28/04/2020', 'hora': '11:32'},
        {
          'title': 'Realizou consulta no clinico geral',
          'data': '28/04/2020',
          'hora': '12:50'
        },
        {
          'title': 'Realizou exame de sangue',
          'data': '28/04/2020',
          'hora': '13:12'
        },
      ]
    },
    {
      'hospital': "Sirio Libanes",
      'data': '28/04/2020',
      'steps': [
        {'title': 'Chegou ao local', 'data': '28/04/2020', 'hora': '11:32'},
        {
          'title': 'Realizou consulta no clinico geral',
          'data': '28/04/2020',
          'hora': '12:50'
        },
        {
          'title': 'Realizou exame de sangue',
          'data': '28/04/2020',
          'hora': '13:12'
        },
      ]
    }
  ]);

@override
void initState() { 
  super.initState();
  Future.delayed(Duration.zero, () async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString('pubKey');
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'Seja bem vinda, Cida!',
                style: TextStyle(fontSize: 25),
              ),
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
                  itemCount: consultas.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PassosPage(
                                      consulta: consultas[index],
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
                                      child: Text(consultas[index]['hospital']
                                          .toString()[0]),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      consultas[index]['hospital'],
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
