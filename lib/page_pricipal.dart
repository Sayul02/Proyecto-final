import 'package:flutter/material.dart';
import 'package:login_app/button_navegation/page_encuestas.dart';
import 'package:login_app/button_navegation/page_estadisticas.dart';

class PaginaPrincipal extends StatefulWidget {
  PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => _MyAppState();
}

class _MyAppState extends State<PaginaPrincipal> {
  int _paginaActual = 0;

  List<Widget> _paginas = [PageEncuestas(), EstadisticasPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App de encuestas'),
        ),
        body: _paginas[_paginaActual],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _paginaActual = index;
            });
          },
          currentIndex: _paginaActual,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              label: "Encuestas",
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: "Estadisticas",
              backgroundColor: Colors.orange,
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.blueAccent, // Color de fondo del Drawer
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueAccent),
                  child: Image.asset('images/logo2.png'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 1, // Puedes ajustar este número según la cantidad de elementos que tengas antes del botón "Sign out"
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Center(
                          child: Text(
                            "Opciones",
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  onTap: () {
                    // Navegar a la página de Sign out (asegúrate de que la ruta sea correcta)
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  title: Text("Sign out",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
