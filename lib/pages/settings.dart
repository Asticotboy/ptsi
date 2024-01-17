import 'package:flutter/material.dart';
import 'package:ptsi/global.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ptsi/db/ptsi_database.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void changeColor(Color color) {
    setState(() => mainTheme = color);
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
      body: SingleChildScrollView(child: Column(
        
        children: <Widget>[
        const SizedBox(height: 20),
        SizedBox(
          width: 400,
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nom Prénom',
            ),
          ),
        ),

        //Input pour le groupe G
        SizedBox(
          width: 400,
          child: TextField(
            controller: groupeGController,
            onTapOutside: (event) {
              groupe_G = groupeGController.text;
            
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Groupe G',
            ),
          ),
        ),

        //Input pour le groupe TP

        SizedBox(
          width: 400,
          child: TextField(
            controller: groupeTPController,
            onTapOutside: (event) {
              groupe_TP = groupeTPController.text;
            
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Groupe TP',
            ),
          ),
        ),




        const SizedBox(height: 20),
        const Text("Couleur principale :"),
        SizedBox(
          width: 300,
          height: 200,

          child: BlockPicker(
            pickerColor: mainTheme,
            onColorChanged: changeColor,
          ),
        ),



        const SizedBox(height: 20),

        //lien dropbox
        SizedBox(
          width: 400,
          child: TextField(
            controller: dropboxController,
            onTapOutside: (event) {
              dropboxLink = dropboxController.text;
            
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Lien Dropbox',
            ),
          ),
        ),

        const SizedBox(height: 20),
        SizedBox(
          width: 400,
          child: TextField(
            controller: siController,
            onTapOutside: (event) {
              siLink = siController.text;
            
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Lien SI',
            ),
          ),
        ),

        const SizedBox(height: 20),
        SizedBox(
          width: 400,
          child: TextField(
            controller: infoController,
            onTapOutside: (event) {
              infoLink = infoController.text;
            
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Lien Info',
            ),
          ),
        ),

        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Valider'),
          ),
        ),
        const SizedBox(height: 40),
        //bouton réinitialiser
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () async{
              await PTSIDatabase.instance.deleteAll();
            },
            child: const Text('Réinitialiser'),
          ),
        ),

        
      ]),)
    );
  }
}
