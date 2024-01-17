import 'package:flutter/material.dart';
import 'package:ptsi/db/ptsi_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ptsi/sources/matieres.dart';


//configuration des groupes
String groupe_G = "G1";
String groupe_TP = "TP1b";


TextEditingController groupeGController = TextEditingController();
TextEditingController groupeTPController = TextEditingController();








int semaine = 0; //0 = semaine A, 1 = semaine B
Future lireGoogleSheetsSansAuth(String id) async {
  //cherche l'id dans l'url
  //il se situe apres spreadsheets/d/ jusqu'a la prochaine parenthèse

  String newid = "";
  int n = id.indexOf('spreadsheets/d/') + 15;
  while (id[n] != '/') {
    newid += id[n];
    n++;
  }

  String url =
      'https://docs.google.com/spreadsheets/d/$newid/gviz/tq?tqx=out:json';

  // Faites une requête GET à l'URL de l'API
  var response = await http.get(Uri.parse(url));

  // Parsez la réponse JSON pour obtenir les données
  var json = jsonDecode(response.body.substring(47, response.body.length - 2));

  var nom = await PTSIDatabase.instance.getValue(1);
  nom = nom[0]['value'];
  //trois premier lettre de nom en majuscule
  nom = nom[0].toUpperCase() + nom[1].toUpperCase() + nom[2].toUpperCase();

  // ignore: prefer_typing_uninitialized_variables
  var data;
  siNotes = [];
  siNomEvaluation = [];
  // Parcourez toutes les lignes
  for (var row in json['table']['rows']) {
    var ligne = row['c'];
    try {
      if (ligne[0]['v'].substring(0, 3) == nom) {
        //récupérer les notes et les mettre dans la base de donnée
        data = row;
        //récupérer dans la liste chaque clé valeur associé à la clé "v" de chaque dict et l'ajouter à la liste siNotes
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
  if (data != null) {
    for (var i = 0; i < data['c'].length; i++) {
      if (data["c"][i] != null) {
        if (data['c'][i]['v'] != null) {
          siNotes.add(data['c'][i]['v'].toString());
        }
      } else {
        siNotes.add("");
      }
    }
  }

  //parcourssir les colonnes
  for (var i = 0; i < json['table']['cols'].length; i++) {
    if (json['table']['cols'][i]['label'] != null) {
      siNomEvaluation.add(json['table']['cols'][i]['label'].toString());
    }
  }
} // Parcourez toutes les lignes dans une feuille

List<String> siNomEvaluation = [];
List<String> siNotes = [];
TextEditingController nameController = TextEditingController();

Color mainTheme = const Color.fromRGBO(255, 143, 0, 1);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

//configuration du liend dropxbox


String dropboxLink = "";
TextEditingController dropboxController = TextEditingController();

String siLink = "";
TextEditingController siController = TextEditingController();

String infoLink = "";
TextEditingController infoController = TextEditingController();

//configuration des matières chaque matière contient un nom, un logo et une couleur
List<Matieres> matieresStyle = [
  Matieres(
      name: "Mathématiques",
      edtname: "Maths",
      logo: "assets/images/logo_math.png",
      color: Color.lerp(Colors.white, Colors.red, 0.4),),
  Matieres(
      name: "Science de l'ingénieur",
      edtname: "S2i",
      logo: "assets/images/logo_si.png",
      color: Color.lerp(Colors.white, Colors.blue, 0.4)),
  //info
  Matieres(
      name: "Informatique",
      edtname: "Info",
      logo: "assets/images/logo_info.png",
      color: Color.lerp(Colors.white, Colors.yellow, 0.4)),
  //français
  Matieres(
      name: "Français",
      edtname: "Français",
      logo: "assets/images/logo_francais.png",
      color: Color.lerp(Colors.white, Colors.purple, 0.3)),

  //anglais
  Matieres(
      name: "Anglais",
      edtname: "Anglais",
      logo: "assets/images/logo_anglais.png",
      color: Color.lerp(Colors.white, Colors.orange, 0.4)),
  //physique  
  Matieres(
      name: "Physique",
      edtname: "Physique",
      logo: "assets/images/logo_physique.png",
      color: Color.lerp(Colors.white, Colors.green, 0.4)),
  //repas 
  Matieres(
      name: "Repas",
      edtname: "Repas",
      logo: "assets/images/logo_repas.png",
      //degrade de couleur arc en ciel
      color: Color.lerp(Colors.white, Colors.black, 0.4)), 
  //pause
  Matieres(
      name: "Pause",
      edtname: "pause",
      logo: "assets/images/logo_pause.png",
      //degrade de couleur arc en ciel
      color: Color.lerp(Colors.white, Colors.black, 0.4)),
  //TIPE
  Matieres(
      name: "TIPE",
      edtname: "TIPE",
      logo: "assets/images/logo_si.png",
      //degrade de couleur arc en ciel
      color: Color.lerp(Colors.white, const Color.fromARGB(255, 0, 38, 255), 0.4)),

];

