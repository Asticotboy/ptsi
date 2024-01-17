import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ptsi/global.dart';

class SendMail extends StatefulWidget {
  const SendMail({super.key});

  @override
  State<SendMail> createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  Map<String, String> contactsInfo = {
    'Plateau Repas': 'internat@loritz.fr',
    'Renaud Pfeiffer': 'renaud.pfeiffer@ac-nancy-metz.fr',
    'Axel Rogue': 'axelrogue@aol.com',
    'Alexis Ramus' :"Alexis.Ramus@ac-nancy-metz.fr", 
    'Jean-Louis Ciman': 'i.ciman@free.fr',
    'Phillipe Gaillard': 'prmgaillard@gmail.com',
    'Florent Gillet': 'florent.gillet@yahoo.fr', 
    'Alexandra Hermann': 'alexandra.herman@univ-lorraine.fr',
    'Emanuel Prémilat': 'annemanu.premilat@free.fr',
  };

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
        //original shape never seen
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        actions: const <Widget>[],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: contactsInfo.entries.map((entry) {
          return Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(entry.key),
                      subtitle: Text(entry.value),
                      trailing: const Icon(Icons.send),
                      onTap: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: entry.value,
                          queryParameters: <String, String>{
                            'subject': entry.key == 'Plateau Repas'
                                ? 'Plateau Repas'
                                : '',
                            'body': entry.key == 'Plateau Repas'
                                ? "Bonjour,\n\nJ'aimerai réserver un plateau repas pour ce soir.\n\nBonne journée\n\n${nameController.text}"
                                : ''
                          },
                        );
                        // ignore: deprecated_member_use
                        await launch(emailLaunchUri.toString());
                      },
                    ),
                  )));
        }).toList(),
      ),
    );
  }
}
