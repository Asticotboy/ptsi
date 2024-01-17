// ignore: file_names
import 'package:flutter/material.dart';
import 'package:ptsi/global.dart';

class TableauNotes extends StatefulWidget {
  const TableauNotes({super.key, required this.id});

  final String id;
  
  @override
  State<TableauNotes> createState() => _TableauNotesState();
}

class _TableauNotesState extends State<TableauNotes> {

  DataTable construireTableau(List<String> matiere, List<String> notes, String id) {
    // ignore: unnecessary_null_comparison
    if (notes == null) {
      return DataTable(
        columns: const [
          DataColumn(label: Text('Erreur')),
        ],
        rows: const [DataRow(cells: [])],
      );
    }

    if(id=="si"){
      //remplace les 4 premier élément par ["Nom", "Prénom", "Classement", "Moyenne"]
      matiere.replaceRange(0, 4, ["Nom", "Prénom", "Classement", "Moyenne"]);
    }

    
    

    // Créez un widget DataTable
    return DataTable(
      // Définissez les colonnes
      columns: const [
        DataColumn(label: Text('Matière')),
        DataColumn(label: Text('Note')),
      ],
      // Définissez les lignes
      rows: <DataRow>[
        for (var i = 0; i < notes.length; i++)
          //si les deux sont null, alors on ne fait rien
          if (notes[i] != "" || matiere[i] != "")
          DataRow(
            cells: <DataCell>[
              DataCell(Text(() {
                try {
                  return matiere[i];
                } catch (e) {
                  return "Erreur";
                }
              }())),
              DataCell(Text(notes[i])),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PTSI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: 
      widget.id == 'si' ? construireTableau(siNomEvaluation, siNotes, widget.id) : const Placeholder(),
      ),
      
    );
  }
}
