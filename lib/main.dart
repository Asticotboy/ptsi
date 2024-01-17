import 'package:flutter/material.dart';
import 'package:ptsi/global.dart';
import 'package:ptsi/pages/mails.dart';
import 'package:ptsi/pages/settings.dart';
import 'package:ptsi/pages/tableau_notes.dart';
import 'package:ptsi/db/ptsi_database.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ptsi/sources/rotation.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:ptsi/sources/matieres.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Color currentColor = const Color.fromRGBO(255, 143, 0, 1);

  void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTSI',
      theme: ThemeData(
        primarySwatch: createMaterialColor(currentColor),
      ),
      home: MyHomePage(changeColor: changeColor),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function(Color) changeColor;

  //récupérer la taille de l'écran

  const MyHomePage({Key? key, required this.changeColor}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  List<Widget> onglet() {
    switch (_currentIndex) {
      case 0:
        return [
          //créer un widget avec une image bien dimensionné

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const Image(
              image: AssetImage('assets/images/flat_design_home.jpeg'),
              height: 300,
              width: 300,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //message de bienvenue dans une belle police et assez gros et centrer
          //Afficher "Bienvenue PTSI" si le nom n'est pas renseigné
          const Text(
            'Bienvenue cher PTSI',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          //petite présentation de l'application justifier centre et avec une petite marge des bords
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Cette application a été créée pour les élèves de PTSI du lycée Henri Loritz. Elle permet d'accéder à l'emploi du temps et aux notes de l'élève. Elle permet également d'envoyer des mails rapidements",
              textAlign: TextAlign.justify,
            ),
          ),
          //petit message pour dire de ne pas oublier d'aller dans les paramètres
          const Text(
            "N'oubliez pas d'aller dans les paramètres pour renseigner votre nom et votre couleur préférée (et les liens des vos notes)",
            textAlign: TextAlign.center,
          ),
        ];

      case 1:
        return [
          //titre emploi du temps,
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Emploi du temps',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //2 iconbutton cote à cote avec le nom du jour actuel au milieu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    EDT.decreaseDay();
                    if (EDT.jourActuel < 0) {
                      EDT.jourActuel = 6;
                    }
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    EDT.setToday();
                  });
                },
                child: Text(
                  "${EDT.jour[EDT.jourActuel]} ${EDT.nbJour}/${EDT.nbMonth}${EDT.nbJour == DateTime.now().day && EDT.nbMonth == DateTime.now().month ? "\nAujourd'hui" : ""}",
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {
                    EDT.increaseDay();
                    if (EDT.jourActuel > 6) {
                      EDT.jourActuel = 0;
                    }
                  });
                },
              ),
            ],
          ),

          //créer un cadre éloigné des bord  et centré contenant listviewEmploiDuTemps
          SizedBox(
            //faire 70% de la taille de l'écran
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(
                  8.0), // Ajoute un padding de 8 pixels sur tous les côtés
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Ajoute un padding de 8 pixels sur tous les côtés
                  child: FutureBuilder<Widget>(
                    future: listviewNewEmploiDuTemps(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else if (snapshot.hasError) {
                        return Text('Erreur: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ];

      case 2:
        return [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const Image(
              image: AssetImage('assets/images/marks_background.jpeg'),
              height: 300,
              width: 300,
            ),
          ),
          //titre par matière grand et souligner "Notes" centrée et éloigné du bord haut
          const SizedBox(
            height: 20,
          ),

          const Center(
            child: Text(
              'Notes',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          //Text sous titre math écris avec des symboles mathématiques
          const Text(
            'Mathématiques',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          //button pour ouvrir le pdf des notes de math
          ElevatedButton(
            onPressed: () async {
              //ouvrir dans le navigateur le lien dropbox
              // ignore: deprecated_member_use
              await launch(dropboxLink);
            },
            child: const Text('Ouvrir'),
          ),

          const SizedBox(
            height: 20,
          ),
          const Text("Sciences de l'ingénieur",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),

          ElevatedButton(
            onPressed: () async {
              // ignore: deprecated_member_use
              await launch(siLink);
            },
            child: const Text('Ouvrir'),
          ),
          ElevatedButton(
              onPressed: () async {
                await lireGoogleSheetsSansAuth(siLink);
                //ouvrir un tableau avec les notes dans une nouvelle page

                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const TableauNotes(id: "si");
                  }),
                );
              },
              child: const Text(
                  "Voir grâce à un super algo qui m'a rendu zinzin")),
          const SizedBox(
            height: 20,
          ),
          //construire un tableau si sinotes n'est pas null

          const SizedBox(
            height: 20,
          ),
          const Text("Informatique",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),

          ElevatedButton(
            onPressed: () async {
              // ignore: deprecated_member_use
              await launch(infoLink);
            },
            child: const Text('Ouvrir'),
          ),
        ];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // //vérification droit de stockage
      // var status = await Permission.storage.status;
      // if (!status.isGranted) {
      //   status = await Permission.storage.request();
      //   if (!status.isGranted) {
      //     return;
      //   }
      // }

      // //vérification droit d'écrire dans le dossier de l'application
      // var status2 = await Permission.manageExternalStorage.status;
      // if (!status2.isGranted) {
      //   status2 = await Permission.manageExternalStorage.request();
      //   if (!status2.isGranted) {
      //     return;
      //   }
      // }

      //récupérer le nom et le prénom
      List<Map<String, dynamic>> nomPrenom =
          await PTSIDatabase.instance.getValue(1);
      if (nomPrenom.isNotEmpty) {
        nameController.text = nomPrenom[0]['value'];
      } else {
        nameController.text = "Eleve";
        await PTSIDatabase.instance.insert(1, nameController.text);
      }

      //réupérer le lien dropbox
      List<Map<String, dynamic>> dropbox =
          await PTSIDatabase.instance.getValue(3);

      if (dropbox.isNotEmpty) {
        dropboxLink = dropbox[0]['value'];
        dropboxController.text = dropbox[0]['value'];
      } else {
        dropboxLink = "";
        dropboxController.text = "";
        await PTSIDatabase.instance.insert(3, dropboxLink);
      }

      //récupérer le lien si
      List<Map<String, dynamic>> si = await PTSIDatabase.instance.getValue(4);
      if (dropbox.isNotEmpty) {
        siLink = si[0]['value'];
        siController.text = si[0]['value'];
      } else {
        siLink = "";
        siController.text = "";
        await PTSIDatabase.instance.insert(4, siLink);
      }

      //récupérer le lien info
      List<Map<String, dynamic>> info = await PTSIDatabase.instance.getValue(5);
      if (dropbox.isNotEmpty) {
        infoLink = info[0]['value'];
        infoController.text = info[0]['value'];
      } else {
        infoLink = "";
        infoController.text = "";
        await PTSIDatabase.instance.insert(5, infoLink);
      }

      //réupérer G
      List<Map<String, dynamic>> groupeG =
          await PTSIDatabase.instance.getValue(6);
      if (groupeG.isNotEmpty) {
        groupe_G = groupeG[0]['value'];
        groupeGController.text = groupeG[0]['value'];
      } else {
        groupeGController.text = "G2";
        await PTSIDatabase.instance.insert(6, groupeGController.text);
      }

      //réupérer TP
      List<Map<String, dynamic>> groupeTP =
          await PTSIDatabase.instance.getValue(7);
      if (groupeTP.isNotEmpty) {
        groupe_TP = groupeTP[0]['value'];
        groupeTPController.text = groupeTP[0]['value'];
      } else {
        groupeTPController.text = "TP3b";
        await PTSIDatabase.instance.insert(7, groupeTPController.text);
      }

      //récupérer la couleur
      List<Map<String, dynamic>> color =
          await PTSIDatabase.instance.getValue(2);
      if (color.isNotEmpty) {
        mainTheme = Color(int.parse(color[0]['value']));
      } else {
        mainTheme = const Color.fromRGBO(255, 143, 0, 1);
        await PTSIDatabase.instance.insert(2, mainTheme.value.toString());
      }
      widget.changeColor(mainTheme);

      //ignore: avoid_print
      print(await PTSIDatabase.instance.read());
      //ignore: avoid_print
      print("init ok");
    });
  }

  Future<File> getDropBoxPdf(String url, String filename) async {
    if (url == "") {
      return File("");
    }
    try {
      var response = await http.get(Uri.parse(url));
      var dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      return File("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextButton(
            onPressed: () {
              //affiche une image de shrek lorsque l'on appuie sur le titre
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("A la vie, à la mort, à la PTSI !"),
                    //message et image de shrek réduite
                    content: ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight:
                                300), // Remplacez 300 par la hauteur minimale souhaitée
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/shrek.jpeg',
                              width: 200, // Set the desired width
                              height: 200, // Set the desired height
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                                "Shrek te surveille, il sait tout de toi, il sait que tu as oublié d'aller dans les paramètres"),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                                "Made with ❤️ by Asticotboy (Cédric Ludwigs)")
                          ],
                        )),

                    //bouton pour fermer la boite de dialogue
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Fermer'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'PTSI',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 5.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset("assets/images/logo_settings.png", width: 32),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                ).then((value) async => {
                      await PTSIDatabase.instance
                          .update(nameController.text, 1),
                      widget.changeColor(mainTheme),
                      await PTSIDatabase.instance
                          .update(mainTheme.value.toString(), 2),
                      await PTSIDatabase.instance.update(dropboxLink, 3),
                      await PTSIDatabase.instance.update(siLink, 4),
                      await PTSIDatabase.instance.update(infoLink, 5),
                      await PTSIDatabase.instance.update(groupe_G, 6),
                      await PTSIDatabase.instance.update(groupe_TP, 7),
                    });

                setState(() {});
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: constraints,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: onglet()),
            );
          }),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            //logo de home depuis assets/images/logo_home2.png
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/logo_home.png', width: 34),
              label: 'Accueil',
            ),

            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/logo_calendrier.png",
                width: 34,
              ),
              label: 'Emploi du temps',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/logo_notes.png', width: 32),
              label: 'Notes',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: mainTheme,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SendMail()),
            );
          },
          tooltip: 'Envoyer un mail',
          child: Image.asset(
            "assets/images/logo_mail.png",
            width: 38,
          ),
        ));
  }

  Future<Widget> listviewNewEmploiDuTemps() async {
    var groupeInfo =
        await Rotation.getGroupe(DateTime(2024, EDT.nbMonth, EDT.nbJour));

    //récupérer les matières du jour
    Future<Map<String, List>> edt = EDT.getNewEDT();

    Future<List> ajrd = edt.then((value) => value[EDT.jour[EDT.jourActuel]]!);

    return FutureBuilder<List>(
      future: ajrd, // la Future que vous voulez attendre
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          List<Matieres> matieresDuJour = [];

          if (snapshot.data!.length >= 3) {
            var colonne1 = snapshot.data![1] ?? [];
            var colonne2 = snapshot.data![2] ?? [];

            var colonne3 = snapshot.data![0] ?? [];
            print(colonne3);
            //pour chaque cours de la colonne
            for (var i = 0; i < colonne1.length; i++) {
              var m;

              var cours1 = colonne1[i];
              var cours2 = colonne2[i];
              var cours3 = colonne3[i];
              var cours;
              //determinations duquel des 3 cours est le bon en fonction des groupes
              if (cours1[4] != null && cours1[4] != "null") {
                //si il s'agit d'un groupe de TP
                if (cours1[4].toString().contains("TP")) {
                  if (cours1[4]
                      .toString()
                      .contains(groupe_TP.substring(0, groupe_TP.length - 1))) {
                    cours = cours1;
                  } else if (cours2[4]
                      .toString()
                      .contains(groupe_TP.substring(0, groupe_TP.length - 1))) {
                    cours = cours2;
                  } else if (cours3[4]
                      .toString()
                      .contains(groupe_TP.substring(0, groupe_TP.length - 1))) {
                    cours = cours3;
                  }
                }

                //si il s'agit d'un chiffre
                else if (int.tryParse(cours1[4]) != null ||
                    int.tryParse(cours2[4]) != null) {
                  //traiter le cas égal 5
                  if (int.parse(cours1[4]) == 5) {
                    print("skibidi");

                    if (groupeInfo[0][int.tryParse(cours1[4])][groupeInfo[1]]
                        .toString()
                        .contains(
                            groupe_TP.substring(0, groupe_TP.length - 1))) {
                      print("dob dob");
                      cours = cours1;

                      print(cours);
                    } else {
                      cours = cours2;
                      print("yes yes");
                      print(cours2[0] +
                          " " +
                          cours2[1] +
                          " " +
                          cours2[2] +
                          " " +
                          cours2[3] +
                          " " +
                          cours2[4]);
                    }
                  } else {
                    var groupeCours1 = groupeInfo[0][int.tryParse(cours1[4])]
                            [groupeInfo[1]]
                        .toString()
                        .split("+");

                    var groupeCours2 = groupeInfo[0][int.tryParse(cours2[4])]
                            [groupeInfo[1]]
                        .toString()
                        .split("+");

                    var groupeInverse = groupe_TP.contains("a")
                        ? groupe_TP.replaceFirst("a", "b")
                        : groupe_TP.replaceFirst("b", "a");

                    for (var groupe in groupeCours1) {
                      if (groupe.contains(groupe_TP)) {
                        cours = cours1;
                        continue;
                      }
                    }

                    for (var groupe in groupeCours2) {
                      if (groupe.contains(groupe_TP)) {
                        cours = cours2;
                        continue;
                      }
                    }

                    for (var groupe in groupeCours1) {
                      if (groupe.contains(
                              groupe_TP.substring(0, groupe_TP.length - 1)) &&
                          !groupe.contains(groupeInverse)) {
                        cours = cours1;
                        continue;
                      }
                    }

                    for (var groupe in groupeCours2) {
                      if (groupe.contains(
                              groupe_TP.substring(0, groupe_TP.length - 1)) &&
                          !groupe.contains(groupeInverse)) {
                        cours = cours2;
                        continue;
                      }
                    }
                  }
                }

                //si il s'agit d'un groupe de G
                else if (cours1[4].toString().contains("G")) {
                  if (cours1[4].toString().contains(groupe_G)) {
                    cours = cours1;
                  } else if (cours2[4].toString().contains(groupe_G)) {
                    cours = cours2;
                  } else if (cours3[4].toString().contains(groupe_G)) {
                    cours = cours3;
                  }
                }
              } else {
                cours = cours1;
              }

              if (cours != null) {
                for (var k = 0; k < matieresStyle.length; k++) {
                  if (cours[0].toString().contains(matieresStyle[k].edtname)) {
                    var m = Matieres(
                        name: matieresStyle[k].name,
                        color: matieresStyle[k].color,
                        logo: matieresStyle[k].logo,
                        edtname: matieresStyle[k].edtname);

                    m.setTime(double.parse(cours[3]));

                    m.setSubtitle(cours[1] + " " + cours[2]);

                    if (m.name.contains("Repas")) {
                      m.setSubtitle("");
                    }
                    matieresDuJour.add(m);
                    continue;
                    // if(cours.toString().contains(matieresStyle[k].edtname)){

                    //   }
                  }
                }
              }
            }
          } else {
            print(snapshot.data!.toString());
            return const Text("Pas de cours aujourd'hui");
          }
          if (semaine == 2) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 3.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      "Vacances !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }

          // m = matieresStyle[k];
          //       }
          //     }
          //     m.time = cours[3];
          //     m.setSubtitle(cours[2]);
          //     matieresDuJour.add(m);

          return ListView.builder(
            shrinkWrap: true,
            itemCount: matieresDuJour.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  height: 80.0,

                  // Utiliser 'time' pour définir la hauteur
                  child: Card(
                      //générer une couleur aléatoire avec des chiffres entre 0 et 255 avec random
                      color: matieresDuJour[index].color,
                      elevation: 3.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: ListTile(
                          title: Text(matieresDuJour[index].name),
                          subtitle: Text(matieresDuJour[index].subtitle),
                          leading: Image.asset(matieresDuJour[index].logo),
                          trailing: Text("${matieresDuJour[index].time}h"),
                        ),
                      )));
            },
          );
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator(); // Afficher un spinner de chargement pendant l'attente
        }
      },
    );
  }

  Future<Widget> listviewEmploiDuTemps() async {
    //récupérer les matières du jour
    Future<Map<String, List>> edt = EDT.getEDT();

    //récupérer uniquement les cours du lundi depuis edt
    Future<List> lundi = edt.then((value) => value[EDT.jour[EDT.jourActuel]]!);

    return FutureBuilder<List>(
      future: lundi, // la Future que vous voulez attendre
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          List<Matieres> matieresDuJour = [];

          var m;

          for (var i = 0; i < snapshot.data!.length; i++) {
            var length = snapshot.data![i].length;
            var nullCount = 0;

            for (var j = 0; j < snapshot.data![i].length; j++) {
              if (snapshot.data![i][j] != null) {
                for (var k = 0; k < matieresStyle.length; k++) {
                  if (snapshot.data![i][j]
                      .toString()
                      .contains(matieresStyle[k].edtname)) {
                    if (m == matieresStyle[k]) {
                      if (m.name == matieresStyle[k].name) {
                        m.time = m.time + 0.5;
                      }
                    } else {
                      m = matieresStyle[k];
                      m.time = 0.5;
                      var lastLine =
                          snapshot.data![i][j].toString().split("\n").last;
                      m.setSubtitle(lastLine);
                      matieresDuJour.add(m);
                    }
                  }
                }
              } else {
                nullCount++;
              }
            }

            //une ligne null correspnd à 30min de cours + 30min piur le cours
            if (nullCount == length) {
              if (m != null) {
                m.time = m.time + 0.5;
              } else {}
            }
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: matieresDuJour.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  height: 80.0,

                  // Utiliser 'time' pour définir la hauteur
                  child: Card(
                      //générer une couleur aléatoire avec des chiffres entre 0 et 255 avec random
                      color: matieresDuJour[index].color,
                      elevation: 3.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: ListTile(
                          title: Text(matieresDuJour[index].name),
                          subtitle: Text(matieresDuJour[index].subtitle),
                          leading: Image.asset(matieresDuJour[index].logo),
                          trailing: Text("${matieresDuJour[index].time}h"),
                        ),
                      )));
            },
          );
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator(); // Afficher un spinner de chargement pendant l'attente
        }
      },
    );
  }
}
