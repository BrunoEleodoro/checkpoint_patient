import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:checkpoint_patient/pages/cadastro/verificacao_de_identidade.dart';
import 'package:checkpoint_patient/secrets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicInformation extends StatefulWidget {
  @override
  _BasicInformationState createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation> {
  TextEditingController cpfController =
      new MaskedTextController(mask: '000.000.000-00');
  TextEditingController dataController =
      new MaskedTextController(mask: '00/00/0000');
  TextEditingController telefoneController =
      new MaskedTextController(mask: '(00) 00000-0000');
  bool isLoading = false;

  void getInformationFromGrid() async {
    var res = await Dio().get(
        'https://gateway.gr1d.io/sandbox/dadoscadastrais/v1/consultas/v2/L0001/' +
            cpfController.text,
        options: Options(headers: {'X-Api-Key': grid_key}));
    // var json = jsoncode(res.data);
    // print(jsonDecode(res.data[2]));
    if (res.data['code'] == "000") {
      var meu_cpf = cpfController.text;
      meu_cpf = meu_cpf.replaceAll('.', '');
      meu_cpf = meu_cpf.replaceAll('-', '');
      // print(meu_cpf);
      // print(res.data['content']['nome']['conteudo']['documento']);
      // print(res.data['content']['nome']['conteudo']['data_nascimento']);
      var telefone = "+55"+res.data['content']['pesquisa_telefones']['conteudo']['outros'][0]['ddd']+""+res.data['content']['pesquisa_telefones']['conteudo']['outros'][0]['telefone'];
      print(telefone);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('telephoneNumber', telefone);
      if (meu_cpf.trim() ==
              res.data['content']['nome']['conteudo']['documento'].trim() &&
          dataController.text.trim() ==
              res.data['content']['nome']['conteudo']['data_nascimento']
                  .trim()) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VerificacaoDeIdentidade()));
      } else {
        AwesomeDialog(context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            tittle: 'Dados Incorretos',
            desc: 'Verifique seus dados!',
            btnCancelOnPress: () {},
            btnOkOnPress: () {}).show();
      }
    }
//         var myHeaders = new Headers();
// myHeaders.append("X-Api-Key", "");

// var requestOptions = {
//   method: 'GET',
//   headers: myHeaders,
//   redirect: 'follow'
// };

// fetch("", requestOptions)
//   .then(response => response.text())
//   .then(result => console.log(result))
//   .catch(error => console.log('error', error));
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
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: cpfController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                labelText: 'CPF',
                                labelStyle: TextStyle(),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: dataController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Data de Nascimento',
                                labelStyle: TextStyle(),
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                )),
                          ),
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
              getInformationFromGrid();
            },
            child: Text(
              'Próximo >',
              style: TextStyle(),
            ),
            minWidth: double.maxFinite,
          ),
        ),
      )
    ]));
  }
}
