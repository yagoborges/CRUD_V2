import 'package:crud_v2/database_helper_rest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:crud_v2/database_helper.dart';
import 'package:crud_v2/my_app.dart';
import 'package:crud_v2/contato_formulario.dart';
import 'package:crud_v2/contato_lista.dart';
import 'package:crud_v2/contato.dart';
import 'package:crud_v2/contato_lista_back.dart';

class ContatoList extends StatelessWidget {
  final dbHelper = DatabaseHelperRest.instance;
  

  final _back = ContatoListBack();
  var listaContato;

  Future<List<Contato>> _buscar() async {




    
    final todasLinhas = await dbHelper.buscar();
    print('Consulta todas as linhas _buscar');
    todasLinhas.forEach((row) => print(row));

/*
    List<Contato> lista = List.generate(todasLinhas.length, (i) {
      var linha = todasLinhas[i];
      return Contato(
        id: linha['_id'],
        nome: linha['nome'],
        idade: linha['idade'],
      );
    });
    listaContato = lista;
     return lista;
    */
    return todasLinhas;
  }

  Widget iconEditButton(Function onPressed) {
    return IconButton(
        icon: Icon(Icons.edit), color: Colors.orange, onPressed: onPressed());
  }

  Widget iconRemoveButton(BuildContext context, Function remove) {
    return IconButton(
        icon: Icon(Icons.delete),
        color: Colors.red,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Excluir'),
                    content: Text('Confirmar a Exclusão?'),
                    actions: [
                      ElevatedButton(
                        child: Text('Não'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Sim'),
                        onPressed: remove(),
                      ),
                    ],
                  ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _back.goToForm(context);
              })
        ],
      ),
      body: Observer(builder: (context) {
        return FutureBuilder(
            future: _buscar(),
            builder: (context, futuro) {
              print(futuro.hasData);
              print(futuro.hasError);
              print(futuro.error);
              print(futuro.hashCode);
              if (!futuro.hasData) {
                return CircularProgressIndicator();
              } else {
                List<Contato>? listaContato = futuro.data;
                return ListView.builder(
                    itemCount: listaContato?.length,
                    itemBuilder: (context, i) {
                      var Contato = listaContato![i];
                      return ListTile(
                        title: Text(Contato.nome!),
                        onTap: () {
                          _back.goToDetails(context, Contato);
                        },
                        subtitle: Text(Contato.idade.toString()),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.orange,
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _back.goToForm(context, Contato);
                                    });
                                  }),
                              iconRemoveButton(context, () {
                                _back.remove(Contato.id);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.of(context).setState(() {
                                    _buscar();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamed(MyApp.CONTATO_LIST);
                                  });
                                });
                              }),
                            ],
                          ),
                        ),
                      );
                    });
              }
            });
      }),
    );
  }
}

class MyContatoList extends StatefulWidget {
  @override
  State<MyContatoList> createState() => _MyContatoListState();
}

class _MyContatoListState extends State<MyContatoList> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ContatoList();
        break;
      case 1:
        page = ContatoFormulario();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.format_list_bulleted),
                    label: Text('Lista'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.contact_page_outlined),
                    label: Text('Cadastro de contato'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
