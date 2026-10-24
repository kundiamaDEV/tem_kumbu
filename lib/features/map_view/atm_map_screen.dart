import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/atm_status_utils.dart';
import '../../data/models/atm_model.dart';
import '../../data/repositories/atm_repository.dart';

class AtmMapScreen extends StatefulWidget {
  const AtmMapScreen({super.key});

  @override
  State<AtmMapScreen> createState() => _AtmMapScreenState();
}

class _AtmMapScreenState extends State<AtmMapScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  final AtmRepository _repository = AtmRepository();

  AtmModel? _selectedAtm;
  List<AtmModel> _atms = [];

  String _query = '';
  String? _atmId;
  double? _userLatitude;
  double? _userLongitude;
  bool _openedWithoutLocation = false;
  bool _initialized = false;

  static const CameraPosition _fallbackCamera = CameraPosition(
    target: LatLng(-8.8383, 13.2344),
    zoom: 11,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _query = (args?['query'] as String?) ?? '';
    _atmId = args?['atmId'] as String?;
    _userLatitude = args?['userLatitude'] as double?;
    _userLongitude = args?['userLongitude'] as double?;
    _openedWithoutLocation =
        (args?['openedWithoutLocation'] as bool?) ?? false;

    _loadData();
  }

  void _loadData() {
    if (_atmId != null && _atmId!.isNotEmpty) {
      if (_userLatitude != null && _userLongitude != null) {
        _selectedAtm = _repository.getAtmByIdWithDistance(
          id: _atmId!,
          userLatitude: _userLatitude!,
          userLongitude: _userLongitude!,
        );
      } else {
        _selectedAtm = _repository.getAtmById(_atmId!);
      }

      if (_selectedAtm != null) {
        _atms = [_selectedAtm!];
        return;
      }
    }

    if (_userLatitude != null && _userLongitude != null) {
      _atms = _repository.getAllAtmsSortedByDistance(
        userLatitude: _userLatitude!,
        userLongitude: _userLongitude!,
        query: _query,
      );
    } else {
      _atms = _repository.searchAtms(_query);
    }

    if (_atms.isNotEmpty) {
      _selectedAtm = _atms.first;
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    for (final atm in _atms) {
      markers.add(
        Marker(
          markerId: MarkerId('atm_${atm.id}'),
          position: LatLng(atm.latitude, atm.longitude),
          infoWindow: InfoWindow(
            title: atm.bancoNome,
            snippet: atm.endereco,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.atmDetails,
                arguments: {
                  'atmId': atm.id,
                  'userLatitude': _userLatitude,
                  'userLongitude': _userLongitude,
                },
              );
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            AtmStatusUtils.getMarkerHue(atm),
          ),
          onTap: () {
            setState(() {
              _selectedAtm = atm;
            });
          },
        ),
      );
    }

    if (_userLatitude != null && _userLongitude != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_marker'),
          position: LatLng(_userLatitude!, _userLongitude!),
          infoWindow: const InfoWindow(
            title: 'Sua localização',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    return markers;
  }

  Future<void> _focusOnSelectedAtm() async {
    if (_selectedAtm == null) return;
    if (!_mapController.isCompleted) return;

    final controller = await _mapController.future;

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(_selectedAtm!.latitude, _selectedAtm!.longitude),
        16,
      ),
    );
  }

  Future<void> _fitBoundsIfPossible() async {
    if (!_mapController.isCompleted) return;
    if (_atms.isEmpty) return;

    final controller = await _mapController.future;

    if (_atms.length == 1 && (_userLatitude == null || _userLongitude == null)) {
      await _focusOnSelectedAtm();
      return;
    }

    double minLat = _atms.first.latitude;
    double maxLat = _atms.first.latitude;
    double minLng = _atms.first.longitude;
    double maxLng = _atms.first.longitude;

    for (final atm in _atms) {
      if (atm.latitude < minLat) minLat = atm.latitude;
      if (atm.latitude > maxLat) maxLat = atm.latitude;
      if (atm.longitude < minLng) minLng = atm.longitude;
      if (atm.longitude > maxLng) maxLng = atm.longitude;
    }

    if (_userLatitude != null && _userLongitude != null) {
      if (_userLatitude! < minLat) minLat = _userLatitude!;
      if (_userLatitude! > maxLat) maxLat = _userLatitude!;
      if (_userLongitude! < minLng) minLng = _userLongitude!;
      if (_userLongitude! > maxLng) maxLng = _userLongitude!;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
    } catch (_) {
      if (_selectedAtm != null) {
        await _focusOnSelectedAtm();
      } else {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(_fallbackCamera),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedAtm == null && _atms.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ATM no mapa'),
        ),
        body: const Center(
          child: Text(
            'ATM não encontrado no mapa.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final AtmModel atmForCamera = _selectedAtm ?? _atms.first;

    final initialCamera = CameraPosition(
      target: LatLng(atmForCamera.latitude, atmForCamera.longitude),
      zoom: 15,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATM no mapa'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCamera,
              myLocationEnabled:
                  _userLatitude != null && _userLongitude != null,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: true,
              markers: _buildMarkers(),
              onMapCreated: (controller) async {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
                await Future.delayed(const Duration(milliseconds: 300));
                await _fitBoundsIfPossible();
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  atmForCamera.bancoNome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  atmForCamera.endereco,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AtmStatusUtils.getColor(atmForCamera),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AtmStatusUtils.getLabel(atmForCamera),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AtmStatusUtils.getColor(atmForCamera),
                      ),
                    ),
                  ],
                ),
                if (_query.isNotEmpty && _atmId == null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Pesquisa: $_query',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (_openedWithoutLocation) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Mapa aberto sem localização do utilizador.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  atmForCamera.distanceKm == null
                      ? 'Distância indisponível'
                      : 'Distância estimada: ${atmForCamera.distanceKm!.toStringAsFixed(2)} km',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.routeView,
                        arguments: {
                          'atmId': atmForCamera.id,
                          'userLatitude': _userLatitude,
                          'userLongitude': _userLongitude,
                        },
                      );
                    },
                    child: const Text('VER TRAJECTO'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}