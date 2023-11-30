import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/Encuestas/encuesta_pizzeria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InicioPagePizzeria extends StatefulWidget {
  @override
  _InicioPagePizzeriaState createState() => _InicioPagePizzeriaState();
}

class _InicioPagePizzeriaState extends State<InicioPagePizzeria> {
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
                // Validar que ambos campos estén llenos
                if (_nombreController.text.isNotEmpty && _numeroCuentaController.text.isNotEmpty) {
                  // Obtener referencia al documento 'Registro Pizzería'
                  DocumentReference registroPizzeriaDoc = _registroCollection.doc('Registro de Pizzeria');

                  // Actualizar datos en el documento sin borrar los existentes
                  await registroPizzeriaDoc.update({
                    'nombre': FieldValue.arrayUnion([_nombreController.text]),
                    'numeroCuenta': FieldValue.arrayUnion([_numeroCuentaController.text]),
                  });

                  // Navegar a la página de preguntas (PizzeriaPage)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PizzeriaPage(
                        nombre: _nombreController.text,
                        numeroCuenta: _numeroCuentaController.text,
                      ),
                    ),
                  );
                } else {
                  // Mostrar un mensaje si algún campo está vacío
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
