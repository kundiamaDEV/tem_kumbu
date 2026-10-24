import 'package:map_launcher/map_launcher.dart';

class ExternalMapService {
  Future<void> openDirections({
    required double destinationLatitude,
    required double destinationLongitude,
    required String destinationTitle,
  }) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isEmpty) {
      throw Exception('Nenhum aplicativo de mapas encontrado no dispositivo.');
    }

    await availableMaps.first.showDirections(
      destination: Coords(destinationLatitude, destinationLongitude),
      destinationTitle: destinationTitle,
    );
  }

  Future<void> openMarker({
    required double latitude,
    required double longitude,
    required String title,
  }) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isEmpty) {
      throw Exception('Nenhum aplicativo de mapas encontrado no dispositivo.');
    }

    await availableMaps.first.showMarker(
      coords: Coords(latitude, longitude),
      title: title,
    );
  }
}