import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'local.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';


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

var categorias =[];

List categories(){
  return categorias;
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
    for (var local in locales) {
      if(!categorias.contains(local.category)){
        categorias.add(local.category);
      }
    }
    return locales;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

/*List<String>  getCategorias(){
  var url = "http://www.cactusdigital.com/locales/blog/public/categories";
  http.get(url, headers: {'Api-Token': '8e84eb8b-e715-496c-9cf7-7fc81105d9b5'});

}*/


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostelería Pontevedra',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'HOSTELERÍA PONTEVEDRA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //final List<Local> entries = <Local>[new Local('TABERNA CENTOLA'), new Local('TABERNA CENTOLA'),new Local('TABERNA CENTOLA')];

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
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
      key: ValueKey('scaffoldmyapp'),
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
                      child:
                          _WidgetTexto(negrita: 'Nombre', valor: todo.name))))
        ]),
        Expanded(
            flex: 1,
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _WidgetTexto(negrita: "Dirección", valor: todo.address),
                      _WidgetTexto(
                          negrita: "Horario", valor: todo.opening_hours),
                      _WidgetTexto(negrita: "Para llevar", valor: para_llevar),
                      _WidgetTexto(
                          negrita: 'Entrega a domicilio', valor: entregas),
                      Row(children: [_WidgetEmail(email: todo.email),
                      _WidgetWeb(web: todo.web)]),
                      Row(children: [_WidgetPhone(phone: todo.phones[0]),
                      _WidgetPhone(phone: todo.phones[1])]),
                    ])))
      ]),
    );
  }
}

class _WidgetEmail extends StatelessWidget{
  String email;

  _WidgetEmail({Key key, @required this.email}) : super(key: key);

  Widget build(BuildContext context) {
    if (this.email != null && this.email != "") {
      return FlatButton.icon(
          onPressed: () => {launch("mailto:" + this.email)},
          icon: Icon(Icons.email),
          label: Text("EMAIL"));
    } else {
      return new Container(width: 0, height: 0);
    }
  }
}

class _WidgetWeb extends StatelessWidget{
  String web;

  _WidgetWeb({Key key, @required this.web}) : super(key: key);

  Widget build(BuildContext context) {
    if (this.web != null && this.web != "") {
      return FlatButton.icon(
          onPressed: () => {launch(this.web)},
          icon: Icon(Icons.web),
          label: Text("WEB"));
    } else {
      return new Container(width: 0, height: 0);
    }
  }
}

class _WidgetTexto extends StatelessWidget {
  String negrita;
  String valor;

  _WidgetTexto({Key key, @required this.negrita, @required this.valor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(children: [
        Text(
          this.negrita + ":     ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Flexible(child: Text(this.valor, style: TextStyle(fontSize: 18)))
      ]),
    );
  }
}

class _WidgetPhone extends StatelessWidget{
  
  String phone;

  _WidgetPhone({Key key, @required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.phone != null && this.phone != "") {
      return FlatButton.icon(
          onPressed: () => {launch('tel:/'+this.phone)},
          icon: Icon(Icons.phone),
          label: Text(this.phone));
    } else {
      return new Container(width: 0, height: 0);
    }
  }
}



class _MyHomePageState extends State<MyHomePage> {

  List<Widget> _createChildren(categorias,context){
  return new List<Widget>.generate(categorias.length, (index) {
    return new SimpleDialogOption(
               child: Text(categorias[index]),
               onPressed: () {
               filterByCategory(categorias[index]);
               Navigator.pop(context, categorias[index]);
               },
             );
  });
}



  void _mostrarDialogo(BuildContext context,categories) {
    showDialog(
        context: context,
        child: SimpleDialog(
          title: const Text("Seleccione categoria"),
          children:_createChildren(categories,context),
          // [ 
          //   SimpleDialogOption(
          //   child: Text('Restaurante'),
          //    onPressed: () {
          //    filterByCategory("restaurante");
          //    Navigator.pop(context, Category.restaurante);
          //     },
          //   ),
          //  SimpleDialogOption(
          //     child: Text('Bar'),
          //     onPressed: () {
          //       filterByCategory("bar");
            //     Navigator.pop(context, Category.bar);
            //   },
            // ),
            // SimpleDialogOption(
            //     child: Text('Hotel'),
            //     onPressed: () {
            //       filterByCategory("hotel");
            //       Navigator.pop(context, Category.hotel);
            //     }),
            // SimpleDialogOption(
            //   child: Text('Asador'),
            //   onPressed: () {
            //     filterByCategory("asador");
            //     Navigator.pop(context, Category.hotel);
            //   },
            // ),
            // SimpleDialogOption(
            //     child: Text('Todos'),
            //     onPressed: () {
            //       filterByCategory(null);
            //       Navigator.pop(context, "todos");
            //     })
          //]
          
        ));
  }

  Future<List<Local>> locales;
  List<Local> unfilteredLocales;
  List<Local> listaAplicacion;
  static bool inicial = true;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    this.locales = fetchListaLocales();
    this.unfilteredLocales = new List<Local>();
    this.listaAplicacion = new List<Local>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostelería Pontevedra',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(children: [
          Stack(children: [
            Image.asset('assets/images/hosteleria.jpg',
                width: double.infinity, height: 250, fit: BoxFit.cover),
            Positioned(
                top: 60,
                left: 20,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'HOSTELERÍA \nPONTEVEDRA',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
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
                filterSearchResults(value);
              },
              //controller: editingController,
              decoration: InputDecoration(
                  labelText: "Buscar",
                  hintText: "Buscar",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                  height: 250,
                  child: FutureBuilder<List<Local>>(
                      future: locales,
                      builder: (context, snapshot) {
                        if (_MyHomePageState.inicial && snapshot.hasData) {
                          listaAplicacion.addAll(snapshot.data);
                          if (this.unfilteredLocales.isEmpty) {
                            this.unfilteredLocales.addAll(snapshot.data);
                          }
                          _MyHomePageState.inicial = false;
                        }
                        if (listaAplicacion != null &&
                            listaAplicacion.isNotEmpty) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: listaAplicacion.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(
                                                      todo: listaAplicacion[
                                                          index])));
                                    },
                                    title: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          color: Color(0xFFb79f6c),
                                        ),
                                        child: Row(children: [
                                          Container(
                                              decoration: new BoxDecoration(
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.white,
                                                      spreadRadius: 1)
                                                ],
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              margin: const EdgeInsets.all(4),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: Image.network(
                                                    "https://" +
                                                        listaAplicacion[index]
                                                            .url_foto,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ))),
                                          Container(
                                              margin: EdgeInsets.all(8),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      child: Flexible(
                                                        child: Text(
                                                          listaAplicacion[index]
                                                              .name
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontFamily: 'Din',
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color: Color(
                                                                  0xFF6e090b))),
                                                    )),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        child: Text(
                                                            listaAplicacion[
                                                                    index]
                                                                .address,
                                                            textAlign: TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Din',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xFF6e090b))))
                                                  ]))
                                        ])));
                              });
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return Center(child: CircularProgressIndicator());
                      }))),
        ])),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            var categories=[];
            for (var local in this.unfilteredLocales) {
              if(!categories.contains(local.category)){
                categories.add(local.category);
              }  
            }
            _mostrarDialogo(this.context,categories);
          },
          label: Text('Categoria'),
          icon: Icon(Icons.arrow_drop_down_circle_sharp),
          backgroundColor: Color(0xFF6e090b),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    if (this.unfilteredLocales != null) {
      List<Local> dummySearchList = List<Local>();
      dummySearchList.addAll(this.unfilteredLocales);
      if (query.isNotEmpty) {
        List<Local> dummyListData = List<Local>();
        dummySearchList.forEach((item) {
          if (item.contains(query)) {
            dummyListData.add(item);
          }
        });
        setState(() {
          this.listaAplicacion.clear();
          this.listaAplicacion.addAll(dummyListData);
        });
        return;
      } else {
        setState(() {
          this.listaAplicacion.clear();
          this.listaAplicacion.addAll(this.unfilteredLocales);
        });
      }
    }
  }

  void filterByCategory(String query) {
    if (this.unfilteredLocales != null) {
      List<Local> dummySearchList = List<Local>();
      dummySearchList.addAll(this.unfilteredLocales);
      log("Filtrado por categoria: ");
      debugPrint("Filtrado por categoria");
      if (query != null) {
        List<Local> dummyListData = List<Local>();
        dummySearchList.forEach((item) {
          debugPrint("Item.category:" + item.category);
          debugPrint("Query: " + query);
          if (item.category == query) {
            debugPrint("Entra en el if");
            dummyListData.add(item);
          }
        });
        setState(() {
          this.listaAplicacion.clear();
          this.listaAplicacion.addAll(dummyListData);
        });
        return;
      } else {
        setState(() {
          this.listaAplicacion.clear();
          this.listaAplicacion.addAll(this.unfilteredLocales);
        });
      }
    }
  }
}
