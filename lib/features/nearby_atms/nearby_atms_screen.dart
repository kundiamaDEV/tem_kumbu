import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/location_service.dart';
import '../../data/models/atm_model.dart';
import '../../data/models/user_location_model.dart';
import '../../data/repositories/atm_repository.dart';
import 'widgets/atm_list_item.dart';

class NearbyAtmsScreen extends StatefulWidget {
  const NearbyAtmsScreen({super.key});

  @override
  State<NearbyAtmsScreen> createState() => _NearbyAtmsScreenState();
}

class _NearbyAtmsScreenState extends State<NearbyAtmsScreen> {
  final AtmRepository _repository = AtmRepository();
  final LocationService _locationService = LocationService();

  bool _isLoading = true;
  bool _initialized = false;
  String? _errorMessage;
  String _query = '';
  UserLocationModel? _userLocation;
  List<AtmModel> _nearbyAtms = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    _query = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
    _loadNearbyAtms();
  }

  bool _isLocationDeniedMessage(String message) {
    final text = message.toLowerCase();

    return text.contains('permissão de localização negada') ||
        text.contains('permissão de localização negada permanentemente') ||
        text.contains('active nas definições do telefone') ||
        text.contains('ative nas definições do telefone') ||
        text.contains('localização do dispositivo está desligada') ||
        text.contains('active o gps') ||
        text.contains('ative o gps');
  }

  void _openAllAtmsWithoutLocation() {
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.allAtms,
      arguments: {
        'query': _query,
        'userLatitude': null,
        'userLongitude': null,
        'openedWithoutLocation': true,
      },
    );
  }

  void _openNearbyAtmsOnMap() {
    if (!mounted || _nearbyAtms.isEmpty) return;

    Navigator.pushNamed(
      context,
      AppRoutes.atmMap,
      arguments: {
        'query': _query,
        'userLatitude': _userLocation?.latitude,
        'userLongitude': _userLocation?.longitude,
        'atms': _nearbyAtms,
      },
    );
  }

  Future<void> _loadNearbyAtms() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final userLocation = await _locationService.getCurrentUserLocation();

      final nearbyAtms = _repository.getNearestAtms(
        userLatitude: userLocation.latitude,
        userLongitude: userLocation.longitude,
        query: _query,
        limit: 5,
      );

      if (!mounted) return;

      setState(() {
        _userLocation = userLocation;
        _nearbyAtms = nearbyAtms;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().replaceFirst('Exception: ', '');

      if (_isLocationDeniedMessage(message)) {
        _openAllAtmsWithoutLocation();
        return;
      }

      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canOpenActions = _nearbyAtms.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATM\'s próximos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _query.isEmpty ? 'Todos os ATM\'s próximos' : _query,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('ALTERAR'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_userLocation != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Sua posição: ${_userLocation!.latitude.toStringAsFixed(5)}, '
                  '${_userLocation!.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadNearbyAtms,
                                  child: const Text('TENTAR NOVAMENTE'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _nearbyAtms.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum ATM encontrado para esta pesquisa.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.separated(
                              itemCount: _nearbyAtms.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final atm = _nearbyAtms[index];

                                return AtmListItem(
                                  atm: atm,
                                  onTap: () {
                                    if (_userLocation == null) return;

                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.atmDetails,
                                      arguments: {
                                        'atmId': atm.id,
                                        'userLatitude': _userLocation!.latitude,
                                        'userLongitude':
                                            _userLocation!.longitude,
                                      },
                                    );
                                  },
                                );
                              },
                            ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: !canOpenActions
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.allAtms,
                              arguments: {
                                'query': _query,
                                'userLatitude': _userLocation?.latitude,
                                'userLongitude': _userLocation?.longitude,
                              },
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      disabledForegroundColor: Colors.grey,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'LISTAR TODOS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: !canOpenActions ? null : _openNearbyAtmsOnMap,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text(
                      'VER NO MAPA',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}