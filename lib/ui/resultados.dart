import 'package:flutter/material.dart';
import 'formulario.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _MyResultadosPageState extends State<MyResultadosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _savedDni = false;

  Future<bool> _getSavedDniFromSharedPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int dni = await prefs.getInt('savedDniNumber');
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
  Widget build(BuildContext context){
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
                      (widget.respuestas[0] == 1 ||
                              widget.respuestas[1] == 1) &&
                          (widget.respuestas[2] == 1 ||
                              widget.respuestas[3] == 1 ||
                              widget.respuestas[4] == 1)
                      ? 'assets/graphics/covid-shield.png'
                      : (widget.respuestas[0] == 1 ||
                                  widget.respuestas[1] == 1) &&
                              (widget.respuestas[2] == 0 ||
                                  widget.respuestas[3] == 0 ||
                                  widget.respuestas[4] == 0)
                          ? 'assets/graphics/covid-simple.png'
                          : (widget.respuestas[0] == 0 ||
                                      widget.respuestas[1] == 0) &&
                                  (widget.respuestas[2] == 1 ||
                                      widget.respuestas[3] == 1 ||
                                      widget.respuestas[4] == 1)
                              ? 'assets/graphics/covid-tachado.png':
                                'assets/graphics/covid-tachado.png',
                    color: (widget.respuestas[0] == 1 ||
                        widget.respuestas[1] == 1) &&
                        (widget.respuestas[2] == 1 ||
                            widget.respuestas[3] == 1 ||
                            widget.respuestas[4] == 1)
                        ? Colors.deepOrangeAccent
                        : (widget.respuestas[0] == 1 ||
                        widget.respuestas[1] == 1) &&
                        (widget.respuestas[2] == 0 ||
                            widget.respuestas[3] == 0 ||
                            widget.respuestas[4] == 0)
                        ? Colors.yellowAccent
                        : (widget.respuestas[0] == 0 ||
                        widget.respuestas[1] == 0) &&
                        (widget.respuestas[2] == 1 ||
                            widget.respuestas[3] == 1 ||
                            widget.respuestas[4] == 1)
                        ? Colors.lightGreenAccent
                        : Colors.lightGreenAccent,
                    width: 150,
                  ),
                ),
                Center(
                  child: Text(
                    "${(widget.respuestas[0] == 1 || widget.respuestas[1] == 1) && (widget.respuestas[2] == 1 || widget.respuestas[3] == 1 || widget.respuestas[4] == 1) ?
                        'Usted tiene un ALTO RIESGO de tener coronavirus' :
                    (widget.respuestas[0] == 1 || widget.respuestas[1] == 1) && (widget.respuestas[2] == 0 || widget.respuestas[3] == 0 || widget.respuestas[4] == 0) ?
                            'Usted tiene RIESGO MEDIO y tendrá seguimiento' :
                    (widget.respuestas[0] == 0 || widget.respuestas[1] == 0) && (widget.respuestas[2] == 1 || widget.respuestas[3] == 1 || widget.respuestas[4] == 1) ?
                                'Usted tiene RIESGO BAJO de tener COVID-19 pero TENGA EXTREMO CUIDADO' : 'Usted tiene RIESGO BAJO de tener COVID-19 pero TENGA EXTREMO CUIDADO'}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                      (widget.respuestas[0] == 1 ||
                          widget.respuestas[1] == 1) &&
                          (widget.respuestas[2] == 1 ||
                              widget.respuestas[3] == 1 ||
                              widget.respuestas[4] == 1)
                          ? (_savedDni ? 'ENVÍE SUS RESULTADOS' : 'SIGA LAS INSTRUCCIONES')
                          : (widget.respuestas[0] == 1 ||
                          widget.respuestas[1] == 1) &&
                          (widget.respuestas[2] == 0 ||
                              widget.respuestas[3] == 0 ||
                              widget.respuestas[4] == 0)
                          ? (_savedDni ? 'ENVÍE SUS RESULTADOS' : 'SIGA LAS INSTRUCCIONES')
                          : (widget.respuestas[0] == 0 ||
                          widget.respuestas[1] == 0) &&
                          (widget.respuestas[2] == 1 ||
                              widget.respuestas[3] == 1 ||
                              widget.respuestas[4] == 1)
                          ? '':'',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: Text(
                      'El gobierno de Jujuy le brindará ayuda, consejos e información'
                          ' sobre su estado y el estado en el que se encuentra la provincia, respecto al coronavirus,'
                          ' para acceder a esta información siga las instrucciones y luego vea las recomendaciones en la página oficial del COE.'
                          ' El resultado de este cuestionario es meramente orientador, '
                          'para datos certeros sobre su salud consulte a su médico de cabecera',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 40.0),
                Center(
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
                      (widget.respuestas[0] == 1 ||
                          widget.respuestas[1] == 1) &&
                          (widget.respuestas[2] == 1 ||
                              widget.respuestas[3] == 1 ||
                              widget.respuestas[4] == 1)
                          ? (_savedDni ?
                          // ENVIAR LOS RESULTADOS CON EL DNI POR AQUI
                      Navigator.of(context).pushNamed('/main') :
                      Navigator.of(context).pushNamed('/formulario') )
                          : (widget.respuestas[0] == 1 ||
                          widget.respuestas[1] == 1) &&
                          (widget.respuestas[2] == 0 ||
                              widget.respuestas[3] == 0 ||
                              widget.respuestas[4] == 0)
                          ? (_savedDni ?
                      // ENVIAR LOS RESULTADOS CON EL DNI POR AQUI
                      Navigator.of(context).pushNamed('/main') :
                      Navigator.of(context).pushNamed('/formulario') )
                          : (widget.respuestas[0] == 0 ||
                          widget.respuestas[1] == 0) &&
                          (widget.respuestas[2] == 1 ||
                              widget.respuestas[3] == 1 ||
                              widget.respuestas[4] == 1)
                          ? Navigator.of(context).pushNamed('/main'):Navigator.of(context).pushNamed('/main');
                    },
                    child: Text(
                        (widget.respuestas[0] == 1 ||
                            widget.respuestas[1] == 1) &&
                            (widget.respuestas[2] == 1 ||
                                widget.respuestas[3] == 1 ||
                                widget.respuestas[4] == 1)
                            ? (_savedDni ? 'Enviar resultados' : 'Instrucciones')
                            : (widget.respuestas[0] == 1 ||
                            widget.respuestas[1] == 1) &&
                            (widget.respuestas[2] == 0 ||
                                widget.respuestas[3] == 0 ||
                                widget.respuestas[4] == 0)
                            ? (_savedDni ? 'Enviar resultados' : 'Instrucciones')
                            : (widget.respuestas[0] == 0 ||
                            widget.respuestas[1] == 0) &&
                            (widget.respuestas[2] == 1 ||
                                widget.respuestas[3] == 1 ||
                                widget.respuestas[4] == 1)
                            ? 'Menu principal':'Menu principal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
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
