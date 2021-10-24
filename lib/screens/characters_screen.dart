import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import 'package:psychonauts_app/components/loader_component.dart';
import 'package:psychonauts_app/helpers/api_helper.dart';
import 'package:psychonauts_app/models/character.dart';
import 'package:psychonauts_app/models/response.dart';


class CharactersScreen extends StatefulWidget {
  const CharactersScreen({ Key? key }) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> _character = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personajes'),
        centerTitle : true,
        actions: <Widget>[
          _isFiltered
          ? IconButton(
              onPressed: _removeFilter, 
              icon: Icon(Icons.filter_none)
            )
          : IconButton(
              onPressed: _showFilter, 
              icon: Icon(Icons.filter_alt)
            )
        ],
      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      ),
    );
  }

  Future<Null> _getCharacters() async {
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

    setState(() {
      _character = response.result;
    });
  }

  Widget _getContent() {
    return _character.length == 0 
      ? _noContent()
      : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay ningun personaje con ese criterio de búsqueda.'
          : 'No hay personajes registrados.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getCharacters,
      child: ListView(
        children: _character.map((e) {
          return Card(
            child: InkWell(
              // onTap: () => _goEdit(e),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white, 
                ),
                padding: EdgeInsets.all(5),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar (
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                    radius: 32,
                    backgroundImage: NetworkImage(e.img),
                  ),
                  title: Text(
                    e.name.titleCase,
                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Filtrar Personajes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Escriba las primeras letras del nombre'),
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  _search = value;
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: Text('Filtrar')
            ),
          ],
        );
      });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getCharacters();
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<Character> filteredList = [];
    for (var procedure in _character) {
      if (procedure.name.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(procedure);
      }
    }

    setState(() {
      _character = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  // void _goEdit(Procedure procedure) async {
  //   String? result = await Navigator.push(
  //     context, 
  //     MaterialPageRoute(
  //       builder: (context) => ProcedureScreen(
  //         token: widget.token, 
  //         procedure: procedure,
  //       )
  //     )
  //   );
  //   if (result == 'yes') {
  //     _getProcedures();
  //   }
  // }
}
