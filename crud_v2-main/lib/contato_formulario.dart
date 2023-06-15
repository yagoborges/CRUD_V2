import 'package:crud_v2/contato.dart';
import 'package:crud_v2/contato_formulario_back.dart';
import 'package:crud_v2/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:crud_v2/contato_formulario.dart';
import 'package:crud_v2/contato_lista.dart';
import 'package:crud_v2/contato_lista_back.dart';

class ContatoFormulario extends StatelessWidget {
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  late String nome, email, idade;
  final dbHelper = DatabaseHelper.instance;
  Contato? contato;

  @override
  Widget build(BuildContext context) {
    var _back = ContatoFormularioBack(context);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Formulário com Validação'),
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

  Widget _formUI(BuildContext context, ContatoFormularioBack _back) {
    var _controller = TextEditingController();
    var _controller2 = TextEditingController();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      contato = ModalRoute.of(context)!.settings.arguments as Contato;
    }

    if (contato == null) {
      print('contato nulo');
    } else {
      _controller.text = _back.contato.nome!;
      _controller2.text = _back.contato.idade!.toString();
    }

    return Column(
      children: <Widget>[
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Nome Completo'),
          maxLength: 100,
          validator: _validarNome,
          onSaved: (String? val) {
            nome = val!;
            (newValue) => _back.contato.nome = newValue;
          },
        ),
        TextFormField(
            controller: _controller2,
            decoration: InputDecoration(hintText: 'Idade'),
            keyboardType: TextInputType.number,
            maxLength: 3,
            validator: _validarIdade,
            onSaved: (String? val) {
              idade = val!;
              (newValue) => _back.contato.nome = newValue;
            }),
        SizedBox(height: 15.0),
        ElevatedButton(onPressed: _sendForm, child: Text('Enviar')),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyContatoList()));
          },
          child: Text('Listar'),
        ),
        ElevatedButton(
            onPressed: () {
              _controller.clear();
              _controller2.clear();
            },
            child: Text('Limpar'))
      ],
    );
  }

  String? _validarNome(String? value) {
    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String? _validarIdade(String? value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);

    if (value!.isEmpty) {
      return "Informe a idade";
    } else if (value.length != 2) {
      return "A idade deve ter até 2 digitos";
    } else if (!regExp.hasMatch(value)) {
      return "A idade só deve conter números";
    }
    return null;
  }

  void _consultar() async {
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
  }

  _sendForm() async {
    if (_key.currentState!.validate()) {
      // sem erros na validação
      _key.currentState!.save();
      print("Nome $nome");
      print("Idade $idade");

      Map<String, dynamic> row = {
        DatabaseHelper.columNome: nome,
        DatabaseHelper.columIdade: idade,
      };
      if (contato == null) {
        final id = await dbHelper.insert(row);
        print('linha inserida id: $id');
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columNome: nome,
          DatabaseHelper.columIdade: idade,
          DatabaseHelper.columId: contato?.id,
        };
        final id2 = await dbHelper.update(row);
        print('linha alterada id: $id2');
      }
    } else {
      print('erro de validação');
    }
  }
}
