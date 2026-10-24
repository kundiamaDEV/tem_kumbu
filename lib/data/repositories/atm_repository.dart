import '../../core/utils/geo_utils.dart';
import '../models/atm_model.dart';
import '../sources/atm_local_data.dart';

class AtmRepository {
  List<AtmModel> getAllAtms() {
    return List<AtmModel>.from(AtmLocalData.atms);
  }

  List<AtmModel> searchAtms(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return getAllAtms();
    }

    return AtmLocalData.atms.where((atm) {
      return atm.titulo.toLowerCase().contains(normalizedQuery) ||
          atm.bancoNome.toLowerCase().contains(normalizedQuery) ||
          atm.bancoSigla.toLowerCase().contains(normalizedQuery) ||
          atm.endereco.toLowerCase().contains(normalizedQuery) ||
          atm.provincia.toLowerCase().contains(normalizedQuery) ||
          atm.municipio.toLowerCase().contains(normalizedQuery) ||
          atm.bairro.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  List<AtmModel> getNearestAtms({
    required double userLatitude,
    required double userLongitude,
    String query = '',
    int limit = 5,
  }) {
    final filtered = searchAtms(query);

    final withDistance = filtered.map((atm) {
      final distance = GeoUtils.distanceInKm(
        startLatitude: userLatitude,
        startLongitude: userLongitude,
        endLatitude: atm.latitude,
        endLongitude: atm.longitude,
      );

      return atm.copyWith(distanceKm: distance);
    }).toList();

    withDistance.sort((a, b) {
      final aDistance = a.distanceKm ?? double.infinity;
      final bDistance = b.distanceKm ?? double.infinity;
      return aDistance.compareTo(bDistance);
    });

    return withDistance.take(limit).toList();
  }

  List<AtmModel> getAllAtmsSortedByDistance({
    required double userLatitude,
    required double userLongitude,
    String query = '',
  }) {
    final filtered = searchAtms(query);

    final withDistance = filtered.map((atm) {
      final distance = GeoUtils.distanceInKm(
        startLatitude: userLatitude,
        startLongitude: userLongitude,
        endLatitude: atm.latitude,
        endLongitude: atm.longitude,
      );

      return atm.copyWith(distanceKm: distance);
    }).toList();

    withDistance.sort((a, b) {
      final aDistance = a.distanceKm ?? double.infinity;
      final bDistance = b.distanceKm ?? double.infinity;
      return aDistance.compareTo(bDistance);
    });

    return withDistance;
  }

  AtmModel? getAtmById(String id) {
    try {
      return AtmLocalData.atms.firstWhere((atm) => atm.id == id);
    } catch (_) {
      return null;
    }
  }

  AtmModel? getAtmByIdWithDistance({
    required String id,
    required double userLatitude,
    required double userLongitude,
  }) {
    final atm = getAtmById(id);
    if (atm == null) return null;

    final distance = GeoUtils.distanceInKm(
      startLatitude: userLatitude,
      startLongitude: userLongitude,
      endLatitude: atm.latitude,
      endLongitude: atm.longitude,
    );

    return atm.copyWith(distanceKm: distance);
  }
}