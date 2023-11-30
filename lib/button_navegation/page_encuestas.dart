import 'package:flutter/material.dart';
import 'package:login_app/Encuestas/Inicio_COVID.dart';
import 'package:login_app/Encuestas/Inicio_electorales.dart';
import 'package:login_app/Encuestas/Inicio_materias.dart';
import 'package:login_app/Encuestas/Inicio_pizzeria.dart';
import 'package:login_app/Encuestas/Inicio_redes.dart';

class PageEncuestas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            COVID(context: context),
            SizedBox(height: 5.0, width: 5.0,),
            Materia(context: context),
            SizedBox(height: 5.0, width: 5.0,),
            RedesSociales(context: context),
            SizedBox(height: 5.0, width: 5.0,),
            Electorales(context: context),
            SizedBox(height: 5.0, width: 5.0,),
            Pizzeria(context: context),
            SizedBox(height: 5.0, width: 5.0,),
          ],
        ),
      ),
    );
  }
}

Widget COVID({BuildContext? context}){
  return Container(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(700, 75),
        primary: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 3.0),
      ),
      onPressed: (){
        if(context != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InicioPageCOVID())
          );
        }
      },
      child: Text(
      "Encuesta del COVID-19",
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ),
  );
}

Widget Materia({BuildContext? context}){
  return Container(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(700, 75),
        primary: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 3.0)
      ),
      onPressed: (){
        if(context != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InicioPageMaterias())
          );
        }
      },
      child: Text(
      "Encuesta de materias",
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ),
  );
}

Widget RedesSociales({BuildContext? context}){
  return Container(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(700, 75),
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 3.0),
        primary: Colors.blue
      ),
      onPressed: (){
        if(context != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InicioPageRedes())
          );
        }
      },
      child: Text(
      "Encuesta de las redes sociales",
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ),
  );
}

Widget Electorales({BuildContext? context}){
  return Container(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(700, 75),
        primary: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 3.0)
      ),
      onPressed: (){
        if(context != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InicioPageElectorales())
          );
        }
      },
      child: Text(
      "Encuesta electorales",
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ),
  );
}

Widget Pizzeria({BuildContext? context}){
  return Container(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(700, 75),
        primary: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 3.0)
      ),
      onPressed: (){
        if(context != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InicioPagePizzeria())
          );
        }
      },
      child: Text(
      "Encuesta de pizzeria",
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ),
  );
}