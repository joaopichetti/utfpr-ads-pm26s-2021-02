class PontoTuristico {
  static const nomeTabela = 'ponto_turistico';
  static const campoId = '_id';
  static const campoNome = 'nome';
  static const campoDescricao = 'descricao';
  static const campoFavorito = 'favorito';
  static const campoLatitude = 'latitude';
  static const campoLongitude = 'longitude';

  int? id;
  String nome;
  String? descricao;
  bool favorito;
  double? latitude;
  double? longitude;

  PontoTuristico({
    this.id,
    required this.nome,
    this.descricao,
    this.favorito = false,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() => {
        campoId: id,
        campoNome: nome,
        campoDescricao: descricao,
        campoFavorito: favorito ? 1 : 0,
        campoLatitude: latitude,
        campoLongitude: longitude,
      };

  factory PontoTuristico.fromMap(Map<String, dynamic> map) => PontoTuristico(
        id: map[campoId] is int ? map[campoId] : null,
        nome: map[campoNome] is String ? map[campoNome] : '',
        descricao: map[campoDescricao] is String ? map[campoDescricao] : null,
        favorito: map[campoFavorito] is int && map[campoFavorito] == 1,
        latitude: map[campoLatitude] is double ? map[campoLatitude] : null,
        longitude: map[campoLongitude] is double ? map[campoLongitude] : null,
      );
}
