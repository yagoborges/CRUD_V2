import 'package:crud_v2/contato.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelperRest {
  var uriREST = Uri.parse('http://localhost:8080/contato');

  DatabaseHelperRest._privateConstructor();
  static final DatabaseHelperRest instance =
      DatabaseHelperRest._privateConstructor();

  Future<List<Contato>> buscar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var uriREST2 = Uri.parse('http://10.2.67.15:8080/contato');
    var header = {'Content-Type':'application/json',
                  'Authorization':'Bearer $token'};

    var response = await http.get(uriREST2, headers: header);
    //var response = await http.get(uriREST);

    if (response.statusCode != 200) throw Exception('Erro de REST API.');

    Iterable listDart = jsonDecode(response.body);
    var listaContato = <Contato>[];

    for (Map<String, dynamic> item in listDart) {
      //pegar o item, converte para contato

      var contato =
          Contato(id: item['id'], nome: item['nome'], idade: item['idade']);

      listaContato.add(contato);
    }
    for (var c in listaContato) {
      print(c.nome);
    }
    return listaContato;
  }

  salvar(Contato contato) async {
    var headers = {'Content-Type': 'application/json'};

    var statusCode = 0;
    var resposta;
    if (contato.id == null) {
      var contatoJson =
          jsonEncode({'nome': contato.nome, 'idade': contato.idade});
      resposta = await http.post(uriREST, headers: headers, body: contatoJson);
    } else {
      var contatoJson = jsonEncode(
          {'id': contato.id, 'nome': contato.nome, 'idade': contato.idade});
      resposta = await http.put(uriREST, headers: headers, body: contatoJson);
    }
    statusCode = resposta.statusCode;
    if (statusCode != 200) throw Exception('Erro de REST API.');
  }

  excluir(int id) async {
    var uri = Uri.parse('http://ipAqui:8080/contato/$id');
    var resposta = await http.delete(uri);
    var statusCode = resposta.statusCode;
    if (statusCode != 200) throw Exception('Erro de REST API.');
  }
}
