import 'package:http/http.dart';

class ListaDePersonajes {
  String url = "https://swapi.dev/api/people/1/";
  String name;
  String gender;
  String birth_year;

  ListaDePersonajes(name,gender,birth_year) {
    this.name = name;
    this.gender = gender;
    this.birth_year = birth_year;
  }
  
}