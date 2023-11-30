import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/firebase_options.dart';
import 'package:login_app/page_pricipal.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class Authenticator {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> verificarInicioSesion(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print("Ocurrio un error");
    }
    return null;
  }
}
 
class MyApp extends StatelessWidget {
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>(); // Mueve la declaración aquí
  final Authenticator authenticator = Authenticator();

   MyApp({Key? key}) : super(key: key);

  TextEditingController _contrasenaController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/page_principal': (context) => PaginaPrincipal(),
      },
      home: Scaffold(
        body: cuerpo(context),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget cuerpo(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://acumbamail.com/blog/wp-content/uploads/2022/09/encuestas.svg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Form(
              key: keyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  titulo(),
                  SizedBox(height: 25.0,),
                  campoUsuario(),
                  SizedBox(height: 15.0,),
                  campoContrasena(),
                  SizedBox(height: 25.0,),
                  botonEntrar(context: context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget titulo() {
    return Text("Sign in",
        style: TextStyle(color: Colors.white, fontSize: 25.0));
      }

  Widget campoUsuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: TextFormField(
        controller: _correoController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa tu usuario';
          }
          return null;
        },
          decoration: InputDecoration(
            hintText: 'User', 
            fillColor: Colors.white, 
            filled: true
          ),
      ),
    );
  }

  Widget campoContrasena() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 50.0),
    child: TextFormField(
      controller: _contrasenaController, // Asocia el controlador aquí
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu contraseña';
        }
        return null;
      },
        decoration: InputDecoration(
          hintText: 'Password',
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }


    Widget botonEntrar({BuildContext? context}) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        ),
        onPressed: () async {
          if (context != null && keyForm.currentState!.validate()) {
            final String usuario = _correoController.text;
            final String contrasena = _contrasenaController.text;

            // Llamada a verificarInicioSesion
            final User? usuarioAutenticado = await authenticator.verificarInicioSesion(usuario, contrasena);

            if (usuarioAutenticado != null) {
              // Iniciar sesión exitosa
              keyForm.currentState!.reset();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaginaPrincipal()),
              );
            } else {
              // Manejar errores de autenticación
              mostrarSnackBar(context, "Inicio de sesión fallido");
            }
          }
        },
        child: Text(
          "Ingresar",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
    );
  }
}

void mostrarSnackBar(BuildContext context, String mensaje) {
  final snackBar = SnackBar(
    content: Text(mensaje),
    duration: Duration(seconds: 3), // Ajusta la duración del mensaje
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
