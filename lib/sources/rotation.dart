//importations
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ptsi/global.dart';

class Rotation {
  //définir l'emplacement du fichier excel qui se trouve dans le dossier assets du projet
  static String path = "assets/data/rotation.xlsx";

  static String getMondayDate(now) {
    // DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    var month = monday.month.toString();
    if (month.length == 1) {
      month = "0" + month;
    }

    String mondayDate =
        "${monday.day}/$month/${monday.year}";

    return mondayDate;
  }

  static Future<List> getGroupe(jour) async {
    //récupérer le fichier excel
    var bytes = await rootBundle.load(path);
    var excel = Excel.decodeBytes(bytes.buffer.asUint8List());

    //récupérer la feuille de calcul qui nous intéresse
    var sheet = excel.tables['Table 2']!;
    var rows = sheet.rows;
    var monday = getMondayDate(jour);

    var data = [];

    int? ligneIndice;
    // parcourir les lignes de la feuille de calcul
    for (var i = 0; i < rows.length; i++) {
      data.add([]);
    }

    //parcourir toutes les lignes et ajouter les valeurs des cellules à la liste data de facon a avoir une sous liste par colonne
    for (var i = 0; i < rows.length; i++) {
      int j = 0;
      for (var cell in rows[i]) {
        data[j].add(cell?.value);
        j++;
      }
    }

    //parcourir la liste data et récupérer la ligne qui correspond à la date du jour
    for (var i = 0; i < data[1].length; i++) {
      if (data[1][i] == null) {
        continue;
      }
      DateTime excelBase =
          DateTime(1899, 12, 30); // La base de Excel est le 30 décembre 1899

      //     print(data[1][i].toString());
      // double excelNumber = data[1][i]; // Le nombre de jours depuis la base

      // DateTime date = excelBase.add(Duration(days: excelNumber.toInt()));

      DateTime date = DateTime.parse(data[1][i].toString());

      var month = date.month.toString();
      if (month.length == 1) {
        month = "0$month";
      }
      var dateRecup = "${date.day}/$month/${date.year}";

      if (dateRecup == monday) {
        ligneIndice = i;
      }
    }

    if (data[2][ligneIndice!].toString() == "A") {
      semaine = 0;
    } else if (data[2][ligneIndice!].toString() == "B") {
      semaine = 1;
    }
    else{
      semaine = 2;
    }



    return [data, ligneIndice];
  }
}
