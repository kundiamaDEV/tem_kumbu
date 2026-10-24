import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/services/external_map_service.dart';
import '../../data/models/atm_model.dart';
import '../../data/repositories/atm_repository.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final ExternalMapService _externalMapService = ExternalMapService();

  AtmModel? _atm;
  double? _userLatitude;
  double? _userLongitude;
  bool _initialized = false;
  bool _isOpeningMap = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final atmId = args?['atmId'] as String?;
    _userLatitude = args?['userLatitude'] as double?;
    _userLongitude = args?['userLongitude'] as double?;

    final repository = AtmRepository();

    if (atmId != null && _userLatitude != null && _userLongitude != null) {
      _atm = repository.getAtmByIdWithDistance(
        id: atmId,
        userLatitude: _userLatitude!,
        userLongitude: _userLongitude!,
      );
    } else if (atmId != null) {
      _atm = repository.getAtmById(atmId);
    }
  }

  Future<void> _openExternalDirections() async {
    if (_atm == null) return;

    try {
      setState(() {
        _isOpeningMap = true;
      });

      await _externalMapService.openDirections(
        destinationLatitude: _atm!.latitude,
        destinationLongitude: _atm!.longitude,
        destinationTitle: _atm!.titulo,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningMap = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_atm == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Trajecto'),
        ),
        body: const Center(
          child: Text(
            'Trajecto indisponível.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trajecto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.alt_route_rounded,
                  size: 42,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  _atm!.titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _atm!.endereco,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Latitude do ATM: ${_atm!.latitude.toStringAsFixed(5)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Longitude do ATM: ${_atm!.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _atm!.distanceKm == null
                      ? 'Distância estimada indisponível'
                      : 'Distância estimada: ${_atm!.distanceKm!.toStringAsFixed(2)} km',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isOpeningMap ? null : _openExternalDirections,
                  icon: _isOpeningMap
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.map_outlined),
                  label: Text(
                    _isOpeningMap ? 'ABRINDO MAPA...' : 'ABRIR TRAJECTO NO MAPA',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}