import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
* PANTALLA DE HISTORIAL DE CONTRATACIONES
*/

class HistoryScreen extends StatelessWidget {
  Future<String> _fetchProName(String proEmail) async {
    try {
      var proDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('mail', isEqualTo: proEmail)
          .limit(1)
          .get();

      if (proDoc.docs.isNotEmpty) {
        return proDoc.docs.first['name'] ?? 'Profesional';
      }
    } catch (e) {
      print("Error al obtener el nombre del profesional: $e");
    }
    return 'Profesional';
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Historial de Contrataciones')),
        body: Center(child: Text('No has iniciado sesión.')),
      );
    }

    String userEmail = user.email!.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Contrataciones'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('usermail', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tienes contrataciones previas.'));
          }

          var historyList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              var item = historyList[index].data() as Map<String, dynamic>;
              String proEmail = item['promail'] ?? 'Correo desconocido';

              return FutureBuilder<String>(
                future: _fetchProName(proEmail),
                builder: (context, proSnapshot) {
                  String proName = proSnapshot.data ?? 'Cargando...';

                  return ListTile(
                    title: Text(proName),
                    subtitle: Text(
                      item['timestamp'] != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                                  (item['timestamp'] as Timestamp)
                                      .millisecondsSinceEpoch)
                              .toString()
                          : 'Fecha desconocida',
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(proName),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tipo de servicio: ${item['problem'] ?? 'No especificado'}'),
                                Text(
                                    'Fecha: ${item['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch((item['timestamp'] as Timestamp).millisecondsSinceEpoch).toString() : 'Fecha desconocida'}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cerrar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
