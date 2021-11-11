class Contato {
  static const nomeTabela = 'contato';
  static const campoId = '_id';
  static const campoNome = 'nome';
  static const campoTelefone = 'telefone';
  static const campoEmail = 'email';
  static const campoTipoImagem = 'tipo_imagem';
  static const campoCaminhoImagem = 'caminho_imagem';
  static const tipoImagemNetwork = 'network';
  static const tipoImagemAssets = 'assets';
  static const tipoImagemFile = 'file';
  static const _tiposPermitidos = [
    tipoImagemNetwork,
    tipoImagemAssets,
    tipoImagemFile,
  ];

  int? id;
  String nome;
  String? telefone;
  String? email;
  String? _tipoImagem;
  String? caminhoImagem;

  Contato({
    this.id,
    required this.nome,
    this.telefone,
    this.email,
    String? tipoImagem,
    this.caminhoImagem,
  }) : _tipoImagem = tipoImagem;

  String get tipoImagem => _tipoImagem ?? tipoImagemAssets;

  set tipoImagem(String tipoImagem) => _tipoImagem =
      (_tiposPermitidos.contains(tipoImagem) ? tipoImagem : tipoImagemAssets);

  Map<String, dynamic> toMap() => {
        campoId: id,
        campoNome: nome,
        campoTelefone: telefone,
        campoEmail: email,
        campoTipoImagem: tipoImagem,
        campoCaminhoImagem: caminhoImagem,
      };

  factory Contato.fromMap(Map<String, dynamic> map) => Contato(
        id: map[campoId] is int ? map[campoId] : null,
        nome: map[campoNome] is String ? map[campoNome] : '',
        telefone: map[campoTelefone] is String ? map[campoTelefone] : null,
        email: map[campoEmail] is String ? map[campoEmail] : null,
        tipoImagem: map[campoTipoImagem] is String ? map[campoTipoImagem] : '',
        caminhoImagem:
            map[campoCaminhoImagem] is String ? map[campoCaminhoImagem] : null,
      );
}
