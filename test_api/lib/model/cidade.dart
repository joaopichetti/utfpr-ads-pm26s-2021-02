class Cidade {
  static const campoCodigo = 'codigo';
  static const campoNome = 'nome';
  static const campoUf = 'uf';

  int? codigo;
  String nome;
  String uf;

  Cidade({this.codigo, required this.nome, required this.uf});

  factory Cidade.fromJson(Map<String, dynamic> json) => Cidade(
    codigo: int.tryParse(json[campoCodigo]?.toString() ?? ''),
    nome: json[campoNome]?.toString() ?? '',
    uf: json[campoUf]?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    campoCodigo: codigo,
    campoNome: nome,
    campoUf: uf,
  };
}