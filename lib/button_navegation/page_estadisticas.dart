import 'package:flutter/material.dart';

class EstadisticasPage extends StatelessWidget {
  const EstadisticasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/estadistica1.png', width: 200, height: 200),
            SizedBox(height: 20),
            Image.asset('assets/estadistica2.png', width: 200, height: 200),
            // Agrega más imágenes según sea necesario
          ],
        ),
      ),
    );
  }
}
