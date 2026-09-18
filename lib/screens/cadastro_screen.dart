import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/pessoa.dart';
import '../services/storage_service.dart';
import '../services/viacep_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();

  final ViaCepService _viaCepService = ViaCepService();
  final StorageService _storageService = StorageService();

  bool buscandoCep = false;

  @override
  void dispose() {
    nomeController.dispose();
    cepController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    numeroController.dispose();
    complementoController.dispose();

    super.dispose();
  }

  Future<void> buscarCep() async {
    final cep = cepController.text;

    if (cep.replaceAll(RegExp(r'[^0-9]'), '').length != 8) {
      return;
    }

    setState(() {
      buscandoCep = true;
    });

    final dados = await _viaCepService.buscarCep(cep);

    if (!mounted) return;

    setState(() {
      buscandoCep = false;
    });

    if (dados == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'CEP não encontrado. Verifique o número informado.',
          ),
        ),
      );
      return;
    }

    ruaController.text = dados['logradouro'] ?? '';
    bairroController.text = dados['bairro'] ?? '';
    cidadeController.text = dados['localidade'] ?? '';
    estadoController.text = dados['uf'] ?? '';
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final pessoa = Pessoa(
      nome: nomeController.text.trim(),
      cep: cepController.text.trim(),
      rua: ruaController.text.trim(),
      bairro: bairroController.text.trim(),
      cidade: cidadeController.text.trim(),
      estado: estadoController.text.trim(),
      numero: numeroController.text.trim(),
      complemento: complementoController.text.trim(),
    );

    await _storageService.salvarPessoa(pessoa);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pessoa cadastrada com sucesso!',
        ),
      ),
    );

    Navigator.pop(context);
  }

  InputDecoration campoDecoration(
    String label,
    IconData icone,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo cadastro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Dados pessoais',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: campoDecoration(
                'Nome',
                Icons.person_outline,
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Digite o nome';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            const Text(
              'Endereço',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: campoDecoration(
                'CEP',
                Icons.location_on_outlined,
              ).copyWith(
                suffixIcon: buscandoCep
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        onPressed: buscarCep,
                        icon: const Icon(Icons.search),
                        tooltip: 'Buscar CEP',
                      ),
              ),
              onChanged: (valor) {
                if (valor.length == 8) {
                  buscarCep();
                }
              },
              validator: (valor) {
                if (valor == null || valor.length != 8) {
                  return 'Digite um CEP válido';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: ruaController,
              readOnly: true,
              decoration: campoDecoration(
                'Rua',
                Icons.signpost_outlined,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: bairroController,
              readOnly: true,
              decoration: campoDecoration(
                'Bairro',
                Icons.home_work_outlined,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: cidadeController,
                    readOnly: true,
                    decoration: campoDecoration(
                      'Cidade',
                      Icons.location_city_outlined,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextFormField(
                    controller: estadoController,
                    readOnly: true,
                    decoration: campoDecoration(
                      'Estado',
                      Icons.map_outlined,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    decoration: campoDecoration(
                      'Número',
                      Icons.numbers,
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Digite o número';
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: complementoController,
                    decoration: campoDecoration(
                      'Complemento',
                      Icons.add_home,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: salvar,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Salvar cadastro',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}