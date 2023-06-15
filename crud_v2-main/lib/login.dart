import 'package:flutter/material.dart';
import 'package:crud_v2/database_helper_rest_usuario.dart';
import 'package:crud_v2/usuario.dart';
import 'package:crud_v2/contato_lista.dart';
import 'package:crud_v2/login_back.dart';

class Login extends StatelessWidget {
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  late String email, senha;
  final dbHelper = DatabaseHelperRestUsuario.instance;
  Usuario? usuario;

  @override
  Widget build(BuildContext context) {
    var _back = LoginBack(context);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Form(
              key: _key,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: _formUI(context, _back),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formUI(BuildContext context, LoginBack _back) {
    var _loginController = TextEditingController();
    var _loginController2 = TextEditingController();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
    }

    if (usuario == null) {
      print('usuario nulo');
    } else {
      _loginController.text = _back.usuario.email!;
      _loginController2.text = _back.usuario.password!;
    }

    return Column(
      children: <Widget>[
        TextFormField(
          controller: _loginController,
          decoration: InputDecoration(hintText: 'Usuário'),
          maxLength: 100,
          validator: _validarEmail,
          onSaved: (String? val) {
            email = val!;
            //(newValue) => _back.contato.nome = newValue;
          },
        ),
        TextFormField(
            controller: _loginController2,
            decoration: InputDecoration(hintText: 'Senha'),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            maxLength: 8,
            validator: _validarSenha,
            onSaved: (String? val) {
              senha = val!;
              //(newValue) => _back.contato.idade = newValue;
            }),
        SizedBox(height: 15.0),
        ElevatedButton(
          onPressed: () async {
            var teste = await _sendForm();
            if (teste == true){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyContatoList()));
            }
          },
          child: Text('Entrar'),
        ),
        ElevatedButton(
            onPressed: () {
              _loginController.clear();
              _loginController2.clear();
            },
            child: Text('Limpar'))
      ],
    );
  }

  String? _validarEmail(String? value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return "Informe o usuário";
    } else if (!regExp.hasMatch(value)) {
      return "O usuário deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String? _validarSenha(String? value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return "Informe a senha";
    } else if (value.length != 8) {
      return "A senha deve ter até 8 dígitos";
    } else if (!regExp.hasMatch(value)) {
      return "A senha só deve conter números";
    }
    return null;
  }

//TO DO: login enviar para o back
//conferir como usar o jwt
  //_sendForm(BuildContext context) async{
  Future<bool> _sendForm() async {
    if (_key.currentState!.validate()) {
      // Sem erros na validação
      _key.currentState!.save();

/*
      var usuarioBd = Usuario(
        idUsuario: usuario?.idUsuario,
        email: email,
        password: senha
      );
      */

      //var response = await dbHelper.login(email, senha);
      var response = await dbHelper.loginJwt(email, senha);
      return true;
    } else {
      //  _validate = true;
      print('erro de validação');
      return false;
    }

    //redirecionar para página de lista de acordo com a permissão
    //gravar token localmente para reenviar (ou armazenar na sessão)
    //passar o token no header como authorization + expressão bearer

/*
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyContatoList()),
            );
 
  */
  }
}
