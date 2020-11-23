import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final List<String> entries = <String>['TABERNA CENTOLA', 'TABERNA CENTOLA', 'TABERNA CENTOLA'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostelería Pontevedra',
      home: Scaffold(
          body: Center(
              child: Column(children: [
        Stack(children: [
          Image.asset('assets/images/hosteleria.jpg',
              width: double.infinity, height: 250, fit: BoxFit.cover),
          Positioned(
              top: 150,
              left: 20,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'HOSTELERÍA \nPONTEVEDRA',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      fontFamily: 'Impact'),
                ),
              ))
        ]),
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(12),
            child: Text(
              'ELIJE TU RESTAURANTE FAVORITO:',
              style: TextStyle(
                  color: Color(0xFF6e090b),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'Din'),
            )),
        Container(
            height: 350,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title:Container(
                  padding: const EdgeInsets.all(8),
                  decoration: new BoxDecoration(borderRadius:
                    BorderRadius.all(Radius.circular(25)),
                    color: Color(0xFFb79f6c), ),
                  child: Row(
                  children: [
                  Image.asset('assets/images/silverware.png', width: 50,height: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(entries[index],
                      style: TextStyle(fontFamily: 'Din', fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6e090b))),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('Comida típica galega',
                      style: TextStyle(fontFamily: 'Din',
                                      fontSize: 14,
                                      color: Color(0xFF6e090b)))
                    )
                  ])
                ])))
              ;
              },
            ),
            ),
      ]))),
    );
  }
}

class Local {
  final String nombre;
  /*final String phone1;
  final String phone2;
  final String web;
  final String email;
  final String whatapp;
*/
  //Local(this.nombre,this.phone1,this.phone2,this.web,this.email,this.whatapp);
  Local(this.nombre);
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Local todo;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.nombre),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Text('Nombre: ' + todo.nombre),
            /*          Text('Telefono 1: '+todo.phone1),
              Text('Telefono 2: '+todo.phone2),
              Text('WhatsApp: '+todo.whatapp),
              Text('Email: '+todo.email),
              Text('Web: '+todo.web)*/
          ])),
    );
  }
}
