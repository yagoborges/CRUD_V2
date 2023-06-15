import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crud_v2/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelperRestUsuario {
  var uriREST = Uri.parse('http://10.2.67.15:8080/usuario');

  DatabaseHelperRestUsuario._privateConstructor();
  static final DatabaseHelperRestUsuario instance =
      DatabaseHelperRestUsuario._privateConstructor();

  Future<List<Usuario>> buscar() async {
    var testeToken = getToken();

    var uriREST2 = Uri.parse('http://10.2.67.15:8080/api/test/user');
    var header = {'Content-Type':'application/json',
                  'Authorization':'Bearer $testeToken'};

    var response = await http.get(uriREST2, headers: header);
    //'Accept': 'application/json',
    print('Token : ${testeToken}');
    print(response);

    if (response.statusCode < 200 || response.statusCode > 300)
        throw Exception('Erro de REST API.');

    Iterable listDart = json.decode(response.body);
    var listaUsuario = <Usuario>[];

    for (Map<String, dynamic> item in listDart) {
      //pegar o item, converte para usuario
      var contato = Usuario(
          idUsuario: item['id'],
          email: item['email'],
          password: item['password']);
      //adicionar no listaContato
      listaUsuario.add(contato);
    }
    for (var c in listaUsuario) {
      print(c.email);
    }
    return listaUsuario;
  }

  salvar(Usuario usuario) async {
    var headers = {'Content-Type': 'application/json'};

    var statusCode = 0;
    var resposta;
    if (usuario.idUsuario == null) {
      var contatoJson =
          jsonEncode({'email': usuario.email, 'password': usuario.password});
      resposta = await http.post(uriREST, headers: headers, body: contatoJson);
    } else {
      var contatoJson = jsonEncode({
        'idUsuario': usuario.idUsuario,
        'email': usuario.email,
        'password': usuario.password
      });
      resposta = await http.put(uriREST, headers: headers, body: contatoJson);
    }
    statusCode = resposta.statusCode;
    if (statusCode != 200) throw Exception('Erro de REST API.');
  }

  excluir(int id) async {
    var uri = Uri.parse('http://10.2.67.15:8080/usuario/$id');
    var resposta = await http.delete(uri);
    var statusCode = resposta.statusCode;
    if (statusCode != 200) throw Exception('Erro de REST API.');
  }

  Future<bool> login(String email, String password) async {
    //var url = "/login";
    var uriREST2 = Uri.parse('http://10.2.67.15:8080/usuario/login');
    var header = {'Content-Type': 'application/json'};

    Map params = {"password": password, "email": email};

    var _body = json.encode(params);
    print("json enviado: $_body");

    var response = await http.post(uriREST2, headers: header, body: _body);
    print('Response status ${response.statusCode}');
    print('Responde body: ${response.body}');

    Map mapResponse = json.decode(response.body);

    var mensagem = mapResponse["message"];
    var token = mapResponse["token"];

    //print("message $mensagem");
    //print("token $token");

    return true;
  }

  Future<bool> loginJwt(String email, String password) async {
    var uriREST2 = Uri.parse('http://10.2.67.15:8080/api/auth/signin');
    var header = {'Content-Type': 'application/json'};

    Map params = {"username": email, "password": password};

    var _body = json.encode(params);
    print("json enviado: $_body");

    var response = await http.post(uriREST2, headers: header, body: _body);
    print('Response status ${response.statusCode}');
    print('Responde body: ${response.body}');

    Map mapResponse = json.decode(response.body);

    var mensagem = mapResponse["roles"];
    var token = mapResponse["accessToken"];

    print("Roles $mensagem");
    print("token $token");

    setToken(token);

    return true;
  }

  //usar o sharedpreferences para salvar o token no dispositivo
  Future<bool> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  //despois recupera
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

}
