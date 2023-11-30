import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Encuestas/encuesta_redes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InicioPageRedes extends StatefulWidget {
  @override
  _InicioPageRedesState createState() => _InicioPageRedesState();
}

class _InicioPageRedesState extends State<InicioPageRedes> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _numeroCuentaController = TextEditingController();
  final CollectionReference _registroCollection = FirebaseFirestore.instance.collection('Registros');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre completo'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              ],
            ),
            TextField(
              controller: _numeroCuentaController,
              decoration: InputDecoration(labelText: 'Número de Cuenta'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nombreController.text.isNotEmpty && _numeroCuentaController.text.isNotEmpty) {
                  // Obtener referencia al documento 'Registro de COVID'
                  DocumentReference registroCOVIDDoc = _registroCollection.doc('Registro de RedesSociales');

                  // Actualizar datos en el documento sin borrar los existentes
                  await registroCOVIDDoc.update({
                    'nombre': FieldValue.arrayUnion([_nombreController.text]),
                    'numeroCuenta': FieldValue.arrayUnion([_numeroCuentaController.text]),
                  });

                  // Navegar a la página de preguntas (COVIDPage)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RedesSocialesPage(
                        nombre: _nombreController.text,
                        numeroCuenta: _numeroCuentaController.text,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, completa todos los campos.'),
                    ),
                  );
                }
              },
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
