class ListaDePersonajes {
  String url = "https://swapi.dev/api/people/1/";
  String name;
  String gender;
  String height;
  String mass;
  String hairColor;
  String eyeColor;

  String birthYear;

  ListaDePersonajes(name,gender,birthYear,height,mass,hairColor,eyeColor) {
    this.name = name;
    this.gender = gender;
    this.birthYear = birthYear;
    this.height = height;
    this.mass = mass;
    this.hairColor = hairColor;
    this.eyeColor = eyeColor;
  }
  
}