import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pessoa.dart';

class StorageService {
  static const String chavePessoas = 'pessoas';

  Future<List<Pessoa>> buscarPessoas() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getStringList(chavePessoas) ?? [];

    return dados.map((item) {
      return Pessoa.fromMap(jsonDecode(item));
    }).toList();
  }

  Future<void> salvarPessoa(Pessoa pessoa) async {
    final prefs = await SharedPreferences.getInstance();

    final pessoas = await buscarPessoas();

    pessoas.add(pessoa);

    final dados = pessoas.map((pessoa) {
      return jsonEncode(pessoa.toMap());
    }).toList();

    await prefs.setStringList(chavePessoas, dados);
  }

  Future<void> excluirPessoa(int indice) async {
    final prefs = await SharedPreferences.getInstance();

    final pessoas = await buscarPessoas();

    if (indice >= 0 && indice < pessoas.length) {
      pessoas.removeAt(indice);
    }

    final dados = pessoas.map((pessoa) {
      return jsonEncode(pessoa.toMap());
    }).toList();

    await prefs.setStringList(chavePessoas, dados);
  }
}