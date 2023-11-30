import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class COVIDPage extends StatefulWidget {
  final String nombre;
  final String numeroCuenta;

  COVIDPage({required this.nombre, required this.numeroCuenta, Key? key}) : super(key: key);

  @override
  _COVIDPageState createState() => _COVIDPageState();
}

class _COVIDPageState extends State<COVIDPage> {
  final List<Pregunta> _preguntas = [
    Pregunta(
        enunciado: "¿Alguna vez te dio COVID-19?",
        opciones: ['Si', 'No', 'Ni me enteré'],
        tipoRespuesta: TipoRespuesta.Radio),
    Pregunta(
        enunciado: "¿Qué síntomas presentaste?",
        opciones: ["Dificultad para respirar", "Cansancio", "Dolor de huesos", "Perdida del gusto"],
        tipoRespuesta: TipoRespuesta.Checkbox),
    Pregunta(
        enunciado: "¿Quiénes de tu familia se enfermaron de COVID?",
        opciones: ["Papá", "Mamá", "Hermano", "Hermana", "Tios"],
        tipoRespuesta: TipoRespuesta.Checkbox),
    Pregunta(
        enunciado: "Cuando se crearon las vacunas ¿Te vacunaste contra el COVID?",
        opciones: ["Si", "No", "Nada mas la primera dosis"],
        tipoRespuesta: TipoRespuesta.Radio),
    Pregunta(
        enunciado: "Describe las acciones que tomaste cuando te dio COVID",
        opciones: [],
        tipoRespuesta: TipoRespuesta.Texto),
  ];

  void _opcionSeleccionada(int indexPreguntas, int indexOpciones) {
    final Pregunta pregunta = _preguntas[indexPreguntas];
    final String opcion = pregunta.opciones[indexOpciones];

    if (pregunta.tipoRespuesta == TipoRespuesta.Radio) {
      _preguntas[indexPreguntas] = pregunta.actualizarPregunta([opcion]);
    } else if (pregunta.tipoRespuesta == TipoRespuesta.Checkbox) {
      final List<String> respuestas = List.from(pregunta.respuestas);
      if (respuestas.contains(opcion)) {
        respuestas.remove(opcion);
      } else {
        respuestas.add(opcion);
      }
      _preguntas[indexPreguntas] = pregunta.actualizarPregunta(respuestas);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_preguntas.length, (indexPreguntas) {
                    final pregunta = _preguntas[indexPreguntas];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pregunta.enunciado),
                        Wrap(
                          children: List.generate(pregunta.opciones.length, (indexOpciones) {
                            final opcion = pregunta.opciones[indexOpciones];
                            return Row(
                              children: [
                                if (pregunta.tipoRespuesta == TipoRespuesta.Radio)
                                  Radio(
                                    value: opcion,
                                    groupValue: pregunta.respuestas.isNotEmpty ? pregunta.respuestas[0] : null,
                                    onChanged: (value) {
                                      _opcionSeleccionada(indexPreguntas, indexOpciones);
                                    },
                                  )
                                else if (pregunta.tipoRespuesta == TipoRespuesta.Checkbox)
                                  Checkbox(
                                    value: pregunta.respuestas.contains(opcion),
                                    onChanged: (value) {
                                      _opcionSeleccionada(indexPreguntas, indexOpciones);
                                    },
                                  ),
                                Text(
                                  pregunta.opciones[indexOpciones],
                                ),
                              ],
                            );
                          }),
                        ),
                        if (pregunta.tipoRespuesta == TipoRespuesta.Texto)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              onChanged: (value) {
                                _opcionSeleccionada(indexPreguntas, 0); // Usamos 0 como índice para el campo de texto
                              },
                              decoration: InputDecoration(
                                hintText: "Escribe tu respuesta aquí...",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Guardar(
                  context: context,
                  nombre: widget.nombre,
                  numeroCuenta: widget.numeroCuenta,
                  preguntas: _preguntas,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum TipoRespuesta {
  Radio,
  Checkbox,
  Texto,
}

class Pregunta {
  final String enunciado;
  final List<String> opciones;
  final TipoRespuesta tipoRespuesta;
  List<String> respuestas;

  Pregunta({
    required this.enunciado,
    required this.opciones,
    required this.tipoRespuesta,
    this.respuestas = const [],
  });

  Pregunta actualizarPregunta(List<String> respuestas) {
    return Pregunta(enunciado: enunciado, opciones: opciones, tipoRespuesta: tipoRespuesta, respuestas: respuestas);
  }
}

Widget Guardar({BuildContext? context, required String nombre, required String numeroCuenta, required List<Pregunta> preguntas}) {
  return Container(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(150, 50),
        primary: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      ),
      onPressed: () async {
        // Lógica para guardar o enviar
        await guardarRespuestasFirestore(nombre, numeroCuenta, preguntas);
        mostrarMensaje(context);
      },
      child: Text(
        "Enviar",
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    ),
  );
}

Future<void> guardarRespuestasFirestore(String nombre, String numeroCuenta, List<Pregunta> preguntas) async {
  try {
    // Referencia a la colección 'Encuestas' y el documento 'COVID'
    CollectionReference encuestasCollection = FirebaseFirestore.instance.collection('Encuestas');
    DocumentReference covidDocument = encuestasCollection.doc('COVID');

    // Crear un mapa de respuestas
    Map<String, dynamic> respuestasMap = {
      'nombre': nombre,
      'numeroCuenta': numeroCuenta,
    };

    for (int i = 0; i < preguntas.length; i++) {
      respuestasMap['pregunta${i + 1}'] = preguntas[i].respuestas;
    }

    // Guardar las respuestas en Firestore
    await covidDocument.update(respuestasMap);
  } catch (e) {
    print('Error al guardar en Firestore: $e');
  }
}

void mostrarMensaje(BuildContext? context) {
  showDialog(
    context: context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Encuesta Registrada'),
        content: Text('¡Gracias por completar la encuesta!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/page_principal');
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
