import 'package:geolocator/geolocator.dart';

import '../../data/models/user_location_model.dart';

class LocationService {
  Future<UserLocationModel> getCurrentUserLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'A localização do dispositivo está desligada. Active o GPS para continuar.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'Permissão de localização negada pelo utilizador.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização negada permanentemente. Active nas definições do telefone.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return UserLocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}