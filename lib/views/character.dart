import 'package:flutter/material.dart';
import 'package:swapi/models/selectedCharacter.dart';

class Character extends StatefulWidget {
  @override
  _CharacterState createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
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
                Text(SelectedCharacter.name),
                SizedBox(height:10),
                Text(SelectedCharacter.gender),
                SizedBox(height:10),
                Text(SelectedCharacter.birth_year)
              ],
            )
          ) 
        )
    );
  }
}