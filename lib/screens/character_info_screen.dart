import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import 'package:psychonauts_app/components/loader_component.dart';
import 'package:psychonauts_app/helpers/api_helper.dart';
import 'package:psychonauts_app/models/PsiPower.dart';
import 'package:psychonauts_app/models/character.dart';
import 'package:psychonauts_app/models/response.dart';


class CharacterInfoScreen extends StatefulWidget {
  final Character character;

  CharacterInfoScreen({required this.character});

  @override
  _CharacterInfoScreenState createState() => _CharacterInfoScreenState();
}

class _CharacterInfoScreenState extends State<CharacterInfoScreen> {
  bool _showLoader = false;
  late Character _character;

  @override
  void initState() {
    super.initState();
    _character = widget.character;
    _getCharacter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_character.name.titleCase),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _showLoader 
          ? LoaderComponent(text: 'Por favor espere...',) 
          : _getContent(),
      ),
      
    );
  }

  Widget _showCharacterInfo() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        _character.img,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Genero: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              _character.gender, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              '# Poderes: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              _character.psiPowers.length.toString(), 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<Null> _getCharacter() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Response response = await ApiHelper.getCharacters();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }
  }


  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showCharacterInfo(),
        Expanded(
          child: _character.psiPowers.length == 0 ? _noContent() : _getListView(),
        ),
      ],
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getCharacter,
      child: ListView(
        children: _character.psiPowers.map((e) {
          return Card(
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        e.img,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.name.titleCase,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 17.0),
                                ),
                                Row(
                                  children: [
                                   Container(
                                        constraints: BoxConstraints(maxWidth: 200),
                                          child: Text(
                                            (e.description == null) ? " ": e.description,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.0),
                                              textAlign: TextAlign.center,
                                          ),
                                    ),
                                    SizedBox(width: 5,),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ), 
    );
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'El personaje no tiene poderes.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}