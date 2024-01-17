import 'dart:ui';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ptsi/global.dart';

class Matieres {
  String name;
  String logo;
  String edtname;
  Color? color;
  double time = 0.5;

  String subtitle = "Cours";

  Matieres(
      {required this.name,
      required this.edtname,
      required this.logo,
      required this.color,
      this.time = 0.5});

  void setSubtitle(String subtitle) {
    this.subtitle = subtitle;
  }

  void setTime(double time) {
    this.time = time;
  }
}

class EDT {
  //définir l'emplacement du fichier excel qui se trouve dans le dossier assets du projet
  static String path = "assets/data/emploi_du_temps.xlsx";

  // ignore: non_constant_identifier_names
  static var RealDay = DateTime.now().weekday;



  static var jourActuel = DateTime.now().weekday - 1;
  static var nbJour = DateTime.now().day;
  static var nbMonth = DateTime.now().month;

  static var jour = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche"
  ];

  static var dayPerMonth = {
    1: 31,
    2: 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31
  };

  static void increaseDay() {
    jourActuel++;
    if (jourActuel > 6) {
      jourActuel = 0;
    }

    nbJour++;
    if (nbJour > dayPerMonth[nbMonth]!) {
      nbJour = 1;
      nbMonth++;
      if (nbMonth > 12) {
        nbMonth = 1;
      }
    }
  }

  static void decreaseDay() {
    jourActuel--;
    if (jourActuel < 0) {
      jourActuel = 6;
    }

    nbJour--;
    if (nbJour < 1) {
      nbMonth--;
      if (nbMonth < 1) {
        nbMonth = 12;
      }
      nbJour = dayPerMonth[nbMonth]!;
    }
  }

  static void setToday() {
    jourActuel = RealDay - 1;
    nbJour = DateTime.now().day;
    nbMonth = DateTime.now().month;
  }

  static var coursParJour = {
    "Lundi": [],
    "Mardi": [],
    "Mercredi": [],
    "Jeudi": [],
    "Vendredi": [],
    "Samedi": [],
    "Dimanche": [],
  };

  static Future<Map<String, List<dynamic>>> getNewEDT() async {
    //lire le fichier excel
    var bytes = await rootBundle.load(path);
    var excel = Excel.decodeBytes(bytes.buffer.asUint8List());

    //créer une liste de liste qui contiendra toutes les données du fichier excel
    var data = [];

    //écrire le nom des feuilles du excel
    // print(excel.tables.keys.toList());

    //parcourir uniquement les lignes la feuille de la semaine actuelle
    var row = excel.tables["$semaine"]!.rows;

    for (var i = 0; i < row.length; i++) {
      data.add([]);
    }

    //parcourir toutes les lignes et ajouter les valeurs des cellules à la liste data de facon a avoir une sous liste par colonne
    for (var i = 0; i < row.length; i++) {
      int j = 0;
      for (var cell in row[i]) {
        data[j].add(cell?.value);
        j++;
      }
    }


    coursParJour = {
      "Lundi": [],
      "Mardi": [],
      "Mercredi": [],
      "Jeudi": [],
      "Vendredi": [],
      "Samedi": [],
      "Dimanche": [],
    };

    //filtrer les données pour mettre chaque cours dans la liste correspondant à son jour sachant le nombre de colonnes pour chaque jour
    //un cours est composé de 5 lignes respectivement: matière, prof, salle, durée, groupe

//i correspond au ligne et j correspond au colonne
    int totalColonne = 0;
    String jour = "Lundi";
    for (var i = 0; i < 16; i++) {
      //print(data.length); j'ai mis 16 car le data lenght compte 26 colonnes alors que le excel en a 15

      if (i == 3) {
        jour = "Mardi";
        totalColonne = 0;

      }
      if (i == 6) {
        jour = "Mercredi";
        totalColonne = 0;
      }
      if (i == 9) {
        jour = "Jeudi";
        totalColonne = 0;
      }
      if (i == 12) {
        jour = "Vendredi";
        totalColonne = 0;
      }

       coursParJour[jour]?.add([]);

      for (int j = 0; j < 5; j++) {
              //on ajoute une liste vide pour chaque jour pour ajouter chaque colonne

       
        String matiere = data[i][(j) * 5 + 1].toString();
        String prof = data[i][(j) * 5 + 2].toString();
        String salle = data[i][(j) * 5 + 3].toString();
        String duree = data[i][(j) * 5 + 4].toString();
        // ignore: avoid_print
        
        String groupe = data[i][(j) * 5 + 5].toString();
        coursParJour[jour]?[totalColonne].add([matiere, prof, salle, duree, groupe]);

        
      }
      totalColonne++;
    }


    return coursParJour;
  }

  static Future<Map<String, List<dynamic>>> getEDT() async {
    //lire le fichier excel
    var bytes = await rootBundle.load(path);
    var excel = Excel.decodeBytes(bytes.buffer.asUint8List());

    //créer une liste de liste qui contiendra toutes les données du fichier excel
    var data = [];

    //créer un dictionnaire qui repertorie le nombre de colonnes pour chaque jour
    final dict = {
      "Lundi": 4,
      "Mardi": 4,
      "Mercredi": 4,
      "Jeudi": 2,
      "Vendredi": 2,
      "Samedi": 1,
      "Dimanche": 0,
    };

    //parcourir toutes les feuilles
    for (var table in excel.tables.keys) {
      //parcourir toutes les lignes
      var index = 0;
      for (var row in excel.tables[table]!.rows) {
        //parcourir toutes les cellules
        data.add([]);
        for (var cell in row) {
          //ajouter la valeur de la cellule à la liste data
          data[index].add(cell?.value);
        }
        index++;
      }
    }

    coursParJour = {
      "Lundi": [],
      "Mardi": [],
      "Mercredi": [],
      "Jeudi": [],
      "Vendredi": [],
      "Samedi": [],
      "Dimanche": [],
    };
    //filtrer les données pour mettre chaque cours dans la liste correspondant à son jour sachant le nombre de colonnes pour chaque jour
    for (var jour in dict.keys) {
      //calcul du numéro de la colonne de début du jour
      var debut = 1;
      for (var i = 0; i < dict.keys.toList().indexOf(jour); i++) {
        debut += dict[dict.keys.toList()[i]]!;
      }

      var index = 0;
      for (var i = 0; i < data.length; i++) {
        coursParJour[jour]?.add([]);
        for (var j = debut; j < dict[jour]! + debut; j++) {
          coursParJour[jour]?[index]?.add(data[i][j]);
        }
        index++;
      }
    }

    return coursParJour;
  }

  void getDay(int day) {}
}
