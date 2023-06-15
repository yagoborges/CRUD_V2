import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:crud_v2/database_helper.dart';
import 'package:crud_v2/my_app.dart';
import 'package:crud_v2/contato.dart';

part 'contato_lista_back.g.dart';

class ContatoListBack = _ContatoListBack with _$ContatoListBack;

abstract class _ContatoListBack with Store {
  final dbHelper = DatabaseHelper.instance;

  //lista de contatos
  @observable
  Future<List<Contato>>? list;

  //metodo para atualizar a lista de contatos
  @action
  refreshList([dynamic value]) async {
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta Todas as linhas _refreshList():');
    todasLinhas.forEach((row) => print(row));

    List<Contato> list = List.generate(todasLinhas.length, (i) {
      var linha = todasLinhas[i];
      print(i);
      return Contato(
          id: linha['_id'], nome: linha['nome'], idade: linha['idade']);
    });
  }

  _ContatoListBack() {
    print('Passou no construtor e chamou o refresh');
    refreshList();
  }

  //metodo para chamar o form salvar/alterar
  goToForm(BuildContext context, [Contato? contato]) {
    print('passou no goToForm');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .pushNamed(MyApp.CONTATO_FORM, arguments: contato)
          .then(refreshList);
    });
  }

  goToDetails(BuildContext context, Contato contato) {
    //desativado
  }

  //excluir
  remove(dynamic id) {
    dbHelper.delete(id);
    refreshList();
  }
}
