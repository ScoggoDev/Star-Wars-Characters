import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapi/models/selectedCharacter.dart';
import 'package:favorite_button/favorite_button.dart';

class Character extends StatefulWidget {
  @override
  _CharacterState createState() => _CharacterState();
}

Future<void> guardarDatos(name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(SelectedCharacter.name, SelectedCharacter.name);
}

removeFavorite(key) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

class _CharacterState extends State<Character> {
  bool favorito = SelectedCharacter.favoriteCharacters.contains(SelectedCharacter.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Star wars Characters"), backgroundColor: Color(0xFF151026),),
      body:
        SafeArea(child: 
          Center(child:
            Column(
              children: [
                SizedBox(height:50),
                Text(SelectedCharacter.name, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height:10),
                Text("Gender: " + SelectedCharacter.gender),
                SizedBox(height:10),
                Text("Birth year: " + SelectedCharacter.birthYear),
                SizedBox(height:10),
                Text("Height: " + SelectedCharacter.height),
                SizedBox(height:10),
                Text("Mass: " + SelectedCharacter.mass),
                SizedBox(height:10),
                Text("Hair color: " + SelectedCharacter.hairColor),
                SizedBox(height:10),
                Text("Eye color: " + SelectedCharacter.eyeColor),
                SizedBox(height:20),
                StarButton(
                  isStarred: SelectedCharacter.favoriteCharacters.contains(SelectedCharacter.name),
                  valueChanged: (_favorito) {
                    if (favorito){
                      removeFavorite(SelectedCharacter.name);
                    }
                    else {
                      guardarDatos(SelectedCharacter.name);
                    }
                  },
                ),
              ],
            )
          ) 
        )
    );
  }
}

