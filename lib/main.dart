import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapi/models/characterList.dart';
import 'package:http/http.dart' as http;
import 'package:swapi/models/selectedCharacter.dart';
import 'package:swapi/views/character.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sp;

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
  bool _favoritos = false;
  bool isFavorite = false;
  String favoriteCharacters;
  Future<List<ListaDePersonajes>> _listadoDeNombres;

  Future<List<ListaDePersonajes>> _getNombres(int pagina) async {
    final respuesta = await http.get(Uri.parse("https://swapi.dev/api/people/?page=" + pagina.toString()));

    List<ListaDePersonajes> nombres = [];

    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      final jsonData = jsonDecode(body);
      
      for (var item in jsonData["results"]) {
        nombres.add(ListaDePersonajes(item["name"],item["gender"],item["birth_year"],item["height"],item["mass"],item["hair_color"],item["eye_color"]));
      }

      return nombres;
      
    } else {
      throw Exception("Dio error nro: " + respuesta.statusCode.toString());
    }
  }

  @override
  void initState() {
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

  fetchDataFromSharedPreferences() async{
    final prefs = await SharedPreferences.getInstance();
                        final keys = prefs.getKeys();

                        final prefsMap = Map<String, dynamic>();
                        for(String key in keys) {
                        prefsMap[key] = prefs.get(key);
                        }
                        favoriteCharacters = prefsMap.toString();
  }

  List<Widget> _listPersonajes(data) {
    List<Widget> personajes = [];
    fetchDataFromSharedPreferences();

    if (_favoritos) {
        for(var personaje in data) {
          
          if(favoriteCharacters.contains(personaje.name)) {
            print(personaje.name + " es favorito ");
              personajes.add(
                GestureDetector(
                  onTap: () {
                    SelectedCharacter.name = personaje.name;
                    SelectedCharacter.favoriteCharacters = favoriteCharacters;
                    SelectedCharacter.gender = personaje.gender;
                    SelectedCharacter.birthYear = personaje.birthYear;
                    SelectedCharacter.height = personaje.height;
                    SelectedCharacter.mass = personaje.mass;
                    SelectedCharacter.hairColor = personaje.hairColor;
                    SelectedCharacter.eyeColor = personaje.eyeColor;
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
                        Text(personaje.birthYear, style: TextStyle(color: Colors.amber[600]))
                    ]
                  )
                  ),
                ),
            );
          }
        
      }
    }    
    else {
      for(var personaje in data) {
      personajes.add(
          GestureDetector(
            onTap: () {
              SelectedCharacter.name = personaje.name;
              SelectedCharacter.favoriteCharacters = favoriteCharacters;
              SelectedCharacter.gender = personaje.gender;
              SelectedCharacter.birthYear = personaje.birthYear;
              SelectedCharacter.height = personaje.height;
              SelectedCharacter.mass = personaje.mass;
              SelectedCharacter.hairColor = personaje.hairColor;
              SelectedCharacter.eyeColor = personaje.eyeColor;
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
                  Text(personaje.birthYear, style: TextStyle(color: Colors.amber[600]))
              ]
            )
            ),
          ),
      );
    }
    }
    return personajes;
  }
}