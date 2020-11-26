import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'local.dart';
import 'package:url_launcher/url_launcher.dart';

//void main() => runApp(MyApp());

void main() {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();
  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

Future<List<Local>> fetchListaLocales() async {
  List<Local> locales = [];
  var url = "http://www.cactusdigital.com/locales/blog/public/index.php";
  final response = await http
      .get(url, headers: {'Api-Token': '8e84eb8b-e715-496c-9cf7-7fc81105d9b5'});
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    stderr.writeln("Respuesta correcta");
    final json = jsonDecode(response.body);
    if (json != null) {
      json.forEach((element) {
        locales.add(Local.fromJson(element));
      });
    }
    return locales;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MyApp extends StatefulWidget {
  //final List<Local> entries = <Local>[new Local('TABERNA CENTOLA'), new Local('TABERNA CENTOLA'),new Local('TABERNA CENTOLA')];

  @override
  _MyAppState createState() => _MyAppState();
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Local todo;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    var para_llevar = todo.take_away == 1 ? "Disponible" : "No";
    var entregas = todo.deliverys == 1 ? "Disponible" : "No";
    return Scaffold(
      /*appBar: AppBar(
        title: Text(todo.name),
      ),*/
      body: Column(children: [
        Stack(children: [
          Image.network(
            "https://" + todo.url_foto,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 160,
              child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25),
                          topRight: const Radius.circular(25))),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      child: _WidgetTexto(negrita:'Nombre' ,valor: todo.name))))
        ]),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _WidgetTexto(negrita: "Dirección", valor: todo.address),
                _WidgetTexto(negrita: "Horario", valor: todo.opening_hours),
                _WidgetTexto(negrita: "Para llevar", valor: para_llevar),
                _WidgetTexto(negrita:'Entrega a domicilio',valor: entregas),
          TextButton(
              onPressed: () => launch("mailto:" + todo.email),
              child: Text('Email: ' + todo.email)),
          TextButton(
              onPressed: () => launch(todo.web),
              child: Text('Web: ' + todo.web)),
          TextButton(
              onPressed: () => launch("tel:" + todo.phones[0]),
              child: Text('Teléfono 1: ' + todo.phones[0])),
          TextButton(
              onPressed: () => launch("tel:" + todo.phones[1]),
              child: Text('Teléfono 2: ' + todo.phones[1]))
        ]))
      ]),
    );
  }
}

class _WidgetTexto extends StatelessWidget{
  String negrita;
  String valor;

    _WidgetTexto({Key key, @required this.negrita, @required this.valor}) : super(key: key);

    @override
    Widget build(BuildContext context){
      return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        child: Row(
          children:[Text(this.negrita+":     ",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    Text(this.valor,style: TextStyle(fontSize: 18))
          ]),
      );
    }
}

class _MyAppState extends State<MyApp> {
  Future<List<Local>> locales;
  List<Local> unfilteredLocales;
  List<Local> listaAplicacion;

  Future loadJson() async{
    List<Local> data = await fetchListaLocales();
    setState(() {
      this.unfilteredLocales=data;
      this.listaAplicacion=data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

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
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                onChanged: (value) {
                  //filterSearchResults(value);
                },
              //  controller: editingController,
                decoration: InputDecoration(
                    labelText: "Buscar",
                    hintText: "Buscar",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
        Container(
            height: 250,
            child: FutureBuilder<List<Local>>(
                future: locales,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                            todo: snapshot.data[index])));
                              },
                              title: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    color: Color(0xFFb79f6c),
                                  ),
                                  child: Row(children: [
                                    Container(
                                        margin: const EdgeInsets.all(9),
                                        child: ClipRRect(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(15)),
                                            child: Image.network(
                                              "https://" +
                                                  snapshot.data[index].url_foto,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ))),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(1),
                                            child: Text(
                                                snapshot.data[index].name
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontFamily: 'Din',
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF6e090b))),
                                          ),
                                          Container(
                                              padding: const EdgeInsets.all(1),
                                              child: Text(
                                                  snapshot.data[index].address,
                                                  style: TextStyle(
                                                      fontFamily: 'Din',
                                                      fontSize: 14,
                                                      color:
                                                          Color(0xFF6e090b))))
                                        ])
                                  ])));
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                })),
      ]
      ))
      ),
    );
  }


   void filterSearchResults(String query) {
    List<Local> dummySearchList = List<Local>();
    List<Local> lista;
    this.locales.then((value) =>lista=value);
    dummySearchList.addAll(lista);
    if(query.isNotEmpty) {
      List<Local> dummyListData = List<Local>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
       /* items.clear();
        items.addAll(dummyListData);*/
      });
      return;
    } else {
      setState(() {
        /*items.clear();
        items.addAll(duplicateItems);
        */
      });
    }

  }
}
