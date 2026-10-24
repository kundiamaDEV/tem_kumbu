import 'atm_status_model.dart';

class AtmModel {
  final String id;
  final String bancoNome;
  final String bancoSigla;
  final String titulo;
  final String endereco;
  final String provincia;
  final String municipio;
  final String bairro;
  final double latitude;
  final double longitude;
  final double? distanceKm;
  final AtmStatusModel status;

  const AtmModel({
    required this.id,
    required this.bancoNome,
    required this.bancoSigla,
    required this.titulo,
    required this.endereco,
    required this.provincia,
    required this.municipio,
    required this.bairro,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.distanceKm,
  });

  AtmModel copyWith({
    String? id,
    String? bancoNome,
    String? bancoSigla,
    String? titulo,
    String? endereco,
    String? provincia,
    String? municipio,
    String? bairro,
    double? latitude,
    double? longitude,
    double? distanceKm,
    AtmStatusModel? status,
  }) {
    return AtmModel(
      id: id ?? this.id,
      bancoNome: bancoNome ?? this.bancoNome,
      bancoSigla: bancoSigla ?? this.bancoSigla,
      titulo: titulo ?? this.titulo,
      endereco: endereco ?? this.endereco,
      provincia: provincia ?? this.provincia,
      municipio: municipio ?? this.municipio,
      bairro: bairro ?? this.bairro,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceKm: distanceKm ?? this.distanceKm,
      status: status ?? this.status,
    );
  }

  String get localResumo => '$bairro, $municipio';

  String get localCompleto => '$provincia, $municipio';

  String get statusResumo {
    if (status.foraDeSistema) return 'Fora de sistema';
    if (status.ativoComDinheiroEPapel) return 'Activo com dinheiro e papel';
    if (status.apenasDinheiro) return 'Activo apenas com dinheiro';
    if (status.apenasPapel) return 'Activo apenas com papel';
    return 'Estado indefinido';
  }
}