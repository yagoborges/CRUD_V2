import 'package:flutter/material.dart';
import 'package:crud_v2/contato_formulario.dart';
import 'package:crud_v2/contato_lista.dart';
import 'package:crud_v2/login.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const HOME = '/';
  static const CONTATO_FORM = 'contato-form';
  static const CONTATO_LIST = 'contato-list';
  static const LOGIN = 'login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contato ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: {
        //HOME: (context) => MyContatoList(),
        HOME: (context) => Login(),
        CONTATO_FORM: (context) => ContatoFormulario(),
        CONTATO_LIST: (context) => MyContatoList(),
        LOGIN: (context) => Login(),
      },
    );
  }
}
