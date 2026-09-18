import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../services/storage_service.dart';
import '../widgets/app_drawer.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();

  List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    carregarPessoas();
  }

  Future<void> carregarPessoas() async {
    final lista = await _storageService.buscarPessoas();

    if (!mounted) return;

    setState(() {
      pessoas = lista;
    });
  }

  Future<void> adicionarPessoa() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroScreen(),
      ),
    );

    carregarPessoas();
  }

  Future<void> excluirPessoa(int indice) async {
    await _storageService.excluirPessoa(indice);

    carregarPessoas();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pessoa excluída com sucesso!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text(
          'Pessoas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: pessoas.isEmpty
          ? _telaVazia()
          : RefreshIndicator(
              onRefresh: carregarPessoas,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pessoas.length,
                itemBuilder: (context, index) {
                  final pessoa = pessoas[index];

                  return _cardPessoa(
                    pessoa,
                    index,
                  );
                },
              ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: adicionarPessoa,
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _telaVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Nenhuma pessoa cadastrada',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Clique no botão + para adicionar uma pessoa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardPessoa(
    Pessoa pessoa,
    int indice,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFD9B382),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.person,
                size: 32,
                color: Color(0xFF4A2F21),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pessoa.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${pessoa.rua}, ${pessoa.numero}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  Text(
                    '${pessoa.cidade} - ${pessoa.estado}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                excluirPessoa(indice);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}