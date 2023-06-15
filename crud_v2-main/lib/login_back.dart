import 'package:flutter/material.dart';
import 'package:crud_v2/usuario.dart';

class LoginBack {
  late Usuario usuario;

  LoginBack(BuildContext context) {
    var parameter = ModalRoute.of(context)?.settings.arguments;
    if ((parameter == null)) {
      usuario = Usuario();
    } else {
      usuario = parameter as Usuario;
    }
  }
}
