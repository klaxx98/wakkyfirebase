import 'package:flutter/material.dart';

/*
* PANTALLA DE HISTORIAL DE CONTRATACIONES
*/

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> historyList = [
    {
      'professional': 'Pro1',
      'date': '2025-01-10',
      'serviceType': 'Computación',
      'price': '\$50'
    },
    {
      'professional': 'Pro2',
      'date': '2025-01-15',
      'serviceType': 'Smartphone',
      'price': '\$30'
    },
    {
      'professional': 'Pro3',
      'date': '2025-01-20',
      'serviceType': 'Computación',
      'price': '\$70'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Contrataciones'),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList[index];
          return ListTile(
            title: Text(item['professional'] ?? ''),
            subtitle: Text(item['date'] ?? ''),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(item['professional'] ?? ''),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipo de servicio: ${item['serviceType']}'),
                        Text('Fecha: ${item['date']}'),
                        Text('Valor pagado: ${item['price']}'),
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
      ),
    );
  }
}
