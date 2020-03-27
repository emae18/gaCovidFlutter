import 'dart:convert';

import 'package:covidjujuy_app/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class TemperaturaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/main': (BuildContext context) => MyApp(),
      },
      home: MyTemperaturaPage(),
    );
  }
}

class MyTemperaturaPage extends StatefulWidget {
  MyTemperaturaPage({Key key}) : super(key: key);
  @override
  _MyTemperaturaPage createState() => _MyTemperaturaPage();
}

class Post {
  int dni;
  int temperatura;

  Post({
        @required this.dni,
        @required this.temperatura,
      });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      dni: json['json_dni'],
      temperatura: json['json_temperatura'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "dni": dni,
      "temperatura": temperatura,
    };
  }
}

class _MyTemperaturaPage extends State<MyTemperaturaPage> {
  static const API = 'https://prueba-3ac16.firebaseio.com/personas.json';
  static const headers = {
    'apiKey' : '12039i10238129038',
    'Content-Type': 'application/json'
  };

  Future<bool> enviarFormulario(Post item) {
    return http.post(API, body: jsonEncode(item.toJson())).then((data) {
      if (data.statusCode == 200) {
        return true;
      }
      return false;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formEnviado = true;
  var _temperaturaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _savedDni = false;
  int _dni = 0;

  Future<bool> _getSavedDniFromSharedPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int dni = await prefs.getInt('savedDniNumber');
    setState(() {
      _dni = dni;
    });
    if(dni == null || dni == 0)
    {
      return false;
    }
    return true;
  }

  Future<void> _savedDniQuery() async{
    await _getSavedDniFromSharedPref().then(_updateSavedDni);
  }
  void _updateSavedDni(bool value) {
    setState(() {
      _savedDni = value;
    });
  }

  @override
  void initState() {
    _savedDniQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.blue[900], Colors.lightBlue],
              )),
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Temperatura',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.4),
                            offset: Offset(0.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Por favor, teniendo todos los cuidados, tomese la temperatura axilar, con un termómetro digital o de vidrio.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.4),
                            offset: Offset(0.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Ingrese la temperatura',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.4),
                            offset: Offset(0.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20.0,right: 20.0),
                          child: TextFormField(
                            controller: _temperaturaController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                            decoration: const InputDecoration(
                                errorStyle: TextStyle(color: Colors.white,),
                                hintText: 'Ingrese su temperatura',
                                labelText: 'Temperatura',
                                labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white))),
                            validator: (String value) {
                              return value.isEmpty
                                  ? 'El campo es obligatorio'
                                  : null;
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 100.0),
                  Visibility(
                    visible: _formEnviado,
                    child: RaisedButton(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 100.0,
                          right: 100.0),
                      color: Colors.deepOrangeAccent,
                      splashColor: Colors.blueAccent,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: (){
                            Navigator.of(context).pushNamed('/main');
                            showInSnackBar('Temperatura enviada exitosamente');
                      },
                      child: Text(
                        'Enviar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Visibility(
                    visible: _formEnviado,
                    child: RaisedButton(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          left: 100.0,
                          right: 100.0),
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
                        //Navigator.of(context).pushNamed('/home');
                        _temperaturaController.text='';
                        _scaffoldKey.currentState.removeCurrentSnackBar();
                        showInSnackBar('¡Por favor envíe la temperatura!');
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/main');
                        },
                        child: Text(
                          'Volver al menu principal',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
                        )),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void showInSnackBar(String value) {
    SnackBar mySnackBar = SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    backgroundColor: Colors.pink,
    );
    _scaffoldKey.currentState.showSnackBar(mySnackBar);
  }
}
