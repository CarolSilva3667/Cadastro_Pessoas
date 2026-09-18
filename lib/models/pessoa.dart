class Pessoa {
  String nome;
  String cep;
  String rua;
  String bairro;
  String cidade;
  String estado;
  String numero;
  String complemento;

  Pessoa({
    required this.nome,
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.numero,
    required this.complemento,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cep': cep,
      'rua': rua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'numero': numero,
      'complemento': complemento,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      nome: map['nome'] ?? '',
      cep: map['cep'] ?? '',
      rua: map['rua'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      numero: map['numero'] ?? '',
      complemento: map['complemento'] ?? '',
    );
  }
}