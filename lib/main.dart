import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapi/models/characterList.dart';
import 'package:http/http.dart' as http;
import 'package:swapi/models/selectedCharacter.dart';
import 'package:swapi/views/character.dart';

void main() {
  runApp(MaterialApp(
   title: 'Star wars Characters',
   home: MyApp(),
 ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pagina = 1;
  bool _favoritos = true;
  Future<List<ListaDePersonajes>> _listadoDeNombres;
  List favoriteCharacters = [];

  Future<List<ListaDePersonajes>> _getNombres(int pagina) async {
    final respuesta = await http.get(Uri.parse("https://swapi.dev/api/people/?page=" + pagina.toString()));

    List<ListaDePersonajes> nombres = [];
    List<ListaDePersonajes> nombresFiltrados = [];

    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      final jsonData = jsonDecode(body);
      
      for (var item in jsonData["results"]) {
        nombres.add(ListaDePersonajes(item["name"],item["gender"],item["birth_year"]));
      }
      
      return nombres;
      
    } else {
      throw Exception("Dio error nro: " + respuesta.statusCode.toString()); //ni idea si se puede pasar a string
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listadoDeNombres = _getNombres(_pagina);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFF151026)),
      home: Scaffold 
      (
        appBar: AppBar(title: Text("Star wars Characters"), backgroundColor: Color(0xFF151026),),
        body:
      FutureBuilder( 
        future: _listadoDeNombres, 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(child: GridView.count(
              crossAxisCount: 2,
              children: _listPersonajes(snapshot.data)
            ),);
          }
          else if (snapshot.hasError) {
            print (snapshot.error);
            return Text("no funca");
          }
          return Text("Cargando...");
        }),
        floatingActionButton: 
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: _pagina > 1,
              child: 
                FloatingActionButton(
                  backgroundColor: Colors.amber[600],
                  onPressed: () {
                    setState(() {
                      _pagina--;
                      _listadoDeNombres = _getNombres(_pagina);
                    });
                  },
                  child: const Icon(Icons.arrow_back)
              ),
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              backgroundColor: Colors.amber[600],
              onPressed: () {
                //que crack que soy
                setState(() {
                  _pagina++;
                  _listadoDeNombres = _getNombres(_pagina);
                });
              },
              child: const Icon(Icons.arrow_forward)
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              backgroundColor: Colors.amber[600],
              onPressed: () {
                setState(() {
                _favoritos = !_favoritos;
                _listadoDeNombres = _getNombres(1);
              });
            },
            child: const Icon(Icons.star)
            )
          ]
        ),
      )
    );
  }
  List<Widget> _listPersonajes(data) {
    List<Widget> personajes = [];
    
    for(var personaje in data) {
      personajes.add(
          GestureDetector(
            onTap: () {
              SelectedCharacter.name = personaje.name;
              SelectedCharacter.gender = personaje.gender;
              SelectedCharacter.birth_year = personaje.birth_year;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Character()),
              );
            },
            child: Card(
              color: Color(0xFF151026),
              child: Column(
                children: [
                  SizedBox(height:10),
                  Text(personaje.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[600])),
                  Text("Gender: " + personaje.gender, style: TextStyle(color: Colors.amber[600])),
                  Text(personaje.birth_year, style: TextStyle(color: Colors.amber[600]))
              ]
            )
            ),
          ),
      );
    }
    return personajes;
  }
}