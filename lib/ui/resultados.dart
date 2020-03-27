import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'formulario.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'temperatura.dart';

class ResultadosPage extends StatelessWidget {
  final List<int> data;

  ResultadosPage({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => MyApp(),
        '/formulario': (BuildContext context) => FormularioPage(),
      },
      home: MyResultadosPage(respuestas: data),
    );
  }
}

class MyResultadosPage extends StatefulWidget {
  final List<int> respuestas;
  MyResultadosPage({Key key, this.respuestas}) : super(key: key);

  @override
  _MyResultadosPageState createState() => _MyResultadosPageState();
}

class Post {
  int dni;
  int riesgo;

  Post({
    @required this.dni,
    @required this.riesgo,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      dni: json["dni"],
      riesgo: json["riesgo"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"dni": dni, "riesgo": riesgo};
  }
}

class _MyResultadosPageState extends State<MyResultadosPage> {
  static const API = 'http://coe.jujuy.gob.ar/covid19/registro';
  //static const API = 'https://prueba-3ac16.firebaseio.com/personas.json';

  static const headers = {
    'apiKey': '12039i10238129038',
    'Content-Type': 'application/json'
  };

  Future<bool> enviarResultados(Post item) {
    return http.post(API, body: json.encode(item.toJson())).then((data) {
      print('STATUS ' + data.statusCode.toString());
      if (data.statusCode == 200) {
        setState(() {
          _menuHabilitado = true;
        });
        return true;
      }
      return false;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _riesgo = 0;
  bool _menuHabilitado = false;
  bool _savedDni = false;
  int _dni = 0;

  Future<void> _getDniFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final startupDniNumber = prefs.getInt('savedDniNumber');
    if (startupDniNumber == null) {
      setState(() {
        _dni = 0;
      });
    } else {
      setState(() {
        _dni = startupDniNumber;
      });
      _enviarResultadosHandler();
    }
  }

  Future<bool> _getSavedDniFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int dni = await prefs.getInt('savedDniNumber');
    if (dni == null || dni == 0) {
      return false;
    }
    return true;
  }

  Future<void> _savedDniQuery() async {
    await _getSavedDniFromSharedPref().then(_updateSavedDni);
  }

  void _updateSavedDni(bool value) {
    setState(() {
      _savedDni = value;
    });
  }

  void _calcularRiesgo() {
    (widget.respuestas[0] == 1 || widget.respuestas[1] == 1) &&
            (widget.respuestas[2] == 1 ||
                widget.respuestas[3] == 1 ||
                widget.respuestas[4] == 1)
        ? setState(() {
            _riesgo = 1;
          })
        : (widget.respuestas[0] == 1 || widget.respuestas[1] == 1) &&
                (widget.respuestas[2] == 0 ||
                    widget.respuestas[3] == 0 ||
                    widget.respuestas[4] == 0)
            ? setState(() {
                _riesgo = 2;
              })
            : (widget.respuestas[0] == 0 || widget.respuestas[1] == 0) &&
                    (widget.respuestas[2] == 1 ||
                        widget.respuestas[3] == 1 ||
                        widget.respuestas[4] == 1)
                ? setState(() {
                    _riesgo = 3;
                  })
                : setState(() {
                    _riesgo = 3;
                  });
  }

  void _enviarResultadosHandler() async {
    final form = Post(
      dni: _dni,
      riesgo: _riesgo,
    );
    var connectivityResult =
    await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      final result = await enviarResultados(form);
      setState(() {
        _menuHabilitado = true;
      });
    } else if (connectivityResult ==
        ConnectivityResult.wifi) {
      final result = await enviarResultados(form);
      setState(() {
        _menuHabilitado = true;
      });
    } else {
      setState(() {
        _menuHabilitado = true;
      });
    }
  }

  @override
  void initState() {
    _getDniFromSharedPref();
    _calcularRiesgo();
    //_savedDniQuery();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Resultado',
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
                Center(
                  child: Text(
                    'del test',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Image.asset(
                    (_riesgo == 1)
                        ? 'assets/graphics/covid-shield.png'
                        : (_riesgo == 2)
                            ? 'assets/graphics/covid-simple.png'
                            : (_riesgo == 3)
                                ? 'assets/graphics/covid-tachado.png'
                                : 'assets/graphics/covid-tachado.png',
                    color: (_riesgo == 1)
                        ? Colors.deepOrangeAccent
                        : (_riesgo == 2)
                            ? Colors.yellowAccent
                            : (_riesgo == 3)
                                ? Colors.lightGreenAccent
                                : Colors.lightGreenAccent,
                    width: 150,
                  ),
                ),
                Center(
                  child: Text(
                    "${(widget.respuestas[0] == 1 || widget.respuestas[1] == 1) && (widget.respuestas[2] == 1 || widget.respuestas[3] == 1 || widget.respuestas[4] == 1) ? 'Usted presenta una situación de riesgo con respecto a la pandemia Covid19' : (widget.respuestas[0] == 1 || widget.respuestas[1] == 1) && (widget.respuestas[2] == 0 || widget.respuestas[3] == 0 || widget.respuestas[4] == 0) ? 'Usted presenta una situación de riesgo medio con respecto a la pandemia Covid19' : (widget.respuestas[0] == 0 || widget.respuestas[1] == 0) && (widget.respuestas[2] == 1 || widget.respuestas[3] == 1 || widget.respuestas[4] == 1) ? 'Usted presenta una situación de bajo riesgo con respecto a la pandemia Covid19' : 'Usted presenta una situación de bajo riesgo con respecto a la pandemia Covid19'}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: Text(
                    'El gobierno de Jujuy brindara ayuda, consejos e información sobre su estado y también sobre el operativo provincial con respecto al Covid19. '
                    'Manténgase informado de las recomendaciones en la página oficial del COE.'
                    ' El resultado de este cuestionario es meramente orientativo, '
                    'y se enmarca en la confidencialidad de los datos correspondientes a una relación médico-paciente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                Center(
                  child: Text(
                    (_riesgo == 1)
                        ? 'Contáctese por favor al 0800 888 4767'
                        : (_riesgo == 2)
                            ? 'Te recomendamos el auto aislamiento recomendado en paginas oficiales'
                            : (_riesgo == 3) ? '' : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
                SizedBox(height: 40.0),
                Visibility(
                  visible: _menuHabilitado,
                  child: Center(
                    child: RaisedButton(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 90.0, right: 90.0),
                      color: Colors.deepOrangeAccent,
                      splashColor: Colors.blueAccent,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/main');
                      },
                      child: Text(
                        'Menu principal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
              ],
            ),
          )),
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
