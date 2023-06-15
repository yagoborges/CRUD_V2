import 'package:crud_v2/contato.dart';
import 'package:flutter/cupertino.dart';

class ContatoFormularioBack {
  late Contato contato;

  ContatoFormularioBack(BuildContext context) {
    var parameter = ModalRoute.of(context)?.settings.arguments;
    if ((parameter == null)) {
      contato = Contato();
    } else {
      contato = parameter as Contato;
    }
  }
}
