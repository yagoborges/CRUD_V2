// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contato_lista_back.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContatoListBack on _ContatoListBack, Store {
  late final _$listAtom = Atom(name: '_ContatoListBack.list', context: context);

  @override
  Future<List<Contato>>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(Future<List<Contato>>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$refreshListAsyncAction =
      AsyncAction('_ContatoListBack.refreshList', context: context);

  @override
  Future refreshList([dynamic value]) {
    return _$refreshListAsyncAction.run(() => super.refreshList(value));
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
