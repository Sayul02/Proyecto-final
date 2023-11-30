import 'package:flutter/material.dart';

class RedesSocialesPage extends StatefulWidget {
  final String nombre;
  final String numeroCuenta;

  RedesSocialesPage ({required this.nombre, required this.numeroCuenta, Key? key}) : super(key: key);

  @override
  _RedesSocialesPage createState() => _RedesSocialesPage();
}

class _RedesSocialesPage extends State<RedesSocialesPage > {
  final List<Pregunta> _preguntas = [
    Pregunta(
        enunciado: "¿Cual es tu red social favorita?",
        opciones: ['Facebook', 'Instagram', 'X', "Snapchat", "Otra"],
        tipoRespuesta: TipoRespuesta.Radio),
    Pregunta(
        enunciado: "¿Que aplicaciones utilizas mas?",
        opciones: ['Facebook', 'Instagram', 'X', "Snapchat", "Pinteres", "Tiktok", "Otra"],
        tipoRespuesta: TipoRespuesta.Checkbox),
    Pregunta(
        enunciado: "¿Que aplicacion que no se tan conocida recomendarias para estudiar?",
        opciones: [],
        tipoRespuesta: TipoRespuesta.Texto),
    Pregunta(
        enunciado: "¿De cual aplicacion te gusta mas la interfaz con el usuario?",
        opciones: ['Facebook', 'Instagram', 'X', "Snapchat", "Pinteres", "Tiktok", "Otra"],
        tipoRespuesta: TipoRespuesta.Radio),
    Pregunta(
        enunciado: "¿Si pudieras hacer una aplicacion de que y para que la harias?",
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
        title: Text('Redes sociales'),
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
                child: Guardar(context: context),
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

Widget Guardar({BuildContext? context}) {
  return Container(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(150, 50),
        primary: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      ),
      onPressed: () {
        // Lógica para guardar o enviar
        mostrarMensaje(context);
      },
      child: Text(
        "Enviar",
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    ),
  );
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
