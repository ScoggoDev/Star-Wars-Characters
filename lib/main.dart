import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapi/models/httpService.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pagina = 1;
  Future<List<ListaDePersonajes>> _listadoDeNombres;

  Future<List<ListaDePersonajes>> _getNombres(int pagina) async {
    final respuesta = await http.get(Uri.parse("https://swapi.dev/api/people/?page=" + pagina.toString()));

    List<ListaDePersonajes> nombres = [];

    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      final jsonData = jsonDecode(body);
      
      for (var item in jsonData["results"]) {
        nombres.add(ListaDePersonajes(item["name"],item["gender"],item["birth_year"]));
      }
      return nombres;
      //print(jsonData["results"][0]);
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
                  backgroundColor: Color(0xFF151026),
                  onPressed: () {
                    setState(() {
                      _pagina--;
                      _listadoDeNombres = _getNombres(_pagina);
                    });
                  },
                  child: const Icon(Icons.arrow_back)
              ),
            ),
            FloatingActionButton(
              backgroundColor: Color(0xFF151026),
              onPressed: () {
                //que crack que soy
                setState(() {
                  _pagina++;
                  _listadoDeNombres = _getNombres(_pagina);
                });
              },
              child: const Icon(Icons.arrow_forward)
            ),
            FloatingActionButton(
              backgroundColor: Color(0xFF151026),
              onPressed: () {
                setState(() {
                _pagina++;
                _listadoDeNombres = _getNombres(_pagina);
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
          Card(
            child: Column(
              children: [
            Text(personaje.name),
            Text(personaje.gender + "|" + "Birth date: " +  personaje.birth_year)
            ]
          )
          ),
      );
    }
    return personajes;
  }
}