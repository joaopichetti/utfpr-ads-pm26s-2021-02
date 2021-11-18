class Contato {
  static const nomeTabela = 'contato';
  static const campoId = '_id';
  static const campoNome = 'nome';
  static const campoTelefone = 'telefone';
  static const campoEmail = 'email';
  static const campoTipoImagem = 'tipo_imagem';
  static const campoCaminhoImagem = 'caminho_imagem';
  static const campoCaminhoVideo = 'caminho_video';
  static const tipoImagemNetwork = 'network';
  static const tipoImagemAssets = 'assets';
  static const tipoImagemFile = 'file';
  static const tiposPermitidos = [
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
  String? caminhoVideo;

  Contato({
    this.id,
    required this.nome,
    this.telefone,
    this.email,
    String? tipoImagem,
    this.caminhoImagem,
    this.caminhoVideo,
  }) : _tipoImagem = tipoImagem;

  String get tipoImagem => _tipoImagem ?? tipoImagemAssets;

  set tipoImagem(String tipoImagem) => _tipoImagem =
      (tiposPermitidos.contains(tipoImagem) ? tipoImagem : tipoImagemAssets);

  Map<String, dynamic> toMap() => {
        campoId: id,
        campoNome: nome,
        campoTelefone: telefone,
        campoEmail: email,
        campoTipoImagem: tipoImagem,
        campoCaminhoImagem: caminhoImagem,
        campoCaminhoVideo: caminhoVideo,
      };

  factory Contato.fromMap(Map<String, dynamic> map) => Contato(
        id: map[campoId] is int ? map[campoId] : null,
        nome: map[campoNome] is String ? map[campoNome] : '',
        telefone: map[campoTelefone] is String ? map[campoTelefone] : null,
        email: map[campoEmail] is String ? map[campoEmail] : null,
        tipoImagem: map[campoTipoImagem] is String ? map[campoTipoImagem] : '',
        caminhoImagem:
            map[campoCaminhoImagem] is String ? map[campoCaminhoImagem] : null,
        caminhoVideo:
            map[campoCaminhoVideo] is String ? map[campoCaminhoVideo] : null,
      );

  static String getTipoImagemLabel(String tipoImagem) {
    switch (tipoImagem) {
      case tipoImagemNetwork:
        return 'Da internet';
      case tipoImagemAssets:
        return 'Arquivo interno';
      case tipoImagemFile:
        return 'Arquivo externo';
      default:
        return 'Desconhecido';
    }
  }
}
