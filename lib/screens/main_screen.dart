import 'package:flutter/material.dart';
import 'package:psychonauts_app/screens/characters_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children : <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
              SizedBox( 
                width: 75.0,
                height: 75.0,
              ),
              _showLogo(),
              _showButtons(),
              _showAppDescription(),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _showLogo() {
   return Image(
     image: AssetImage('assets/psychonauts_logo.png'),
     fit: BoxFit.cover
    );
 }

 Widget _showAppDescription() {
  return SingleChildScrollView(
     child: Container(
       margin: EdgeInsets.all(30),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           SizedBox(height: 30,),
           Center(
             child: Text(
               'Psychonauts es un juego de plataformas que incorpora elementos de aventura.​ El jugador controla a Razputin en una vista tridimensional en tercera persona. Raz comienza con habilidades de movimiento básicas como correr y saltar, pero a medida que avanza la trama, adquiere poderes psíquicos como telequinesis, levitación, invisibilidad y piroquinesis. Estas habilidades le permiten al jugador explorar el campamento y luchar contra sus enemigos.',
               style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.bold
               ),
             ),
           ),      
         ],
       ),
     ),
  );
}

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showCharactersButton(),
          SizedBox(width: 20,)
        ],
      ),
    );
  }

 Widget _showCharactersButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Ver Personajes'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Color(0xFFE07C24);
            }
          ),
        ),
        onPressed: () => _characters(), 
      ),
    );
  }

   void _characters() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => CharactersScreen()
      )
    );
  }
}