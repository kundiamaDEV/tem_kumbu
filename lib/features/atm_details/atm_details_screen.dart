import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/atm_status_utils.dart';
import '../../data/models/atm_model.dart';
import '../../data/repositories/atm_repository.dart';

class AtmDetailsScreen extends StatelessWidget {
  const AtmDetailsScreen({super.key});

  Widget _buildOption({
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.radio_button_checked, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(AtmModel atm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption(
          text: atm.status.emServico ? 'Em serviço' : 'Fora de serviço',
          color: atm.status.emServico
              ? AppColors.greenStatus
              : AppColors.redStatus,
        ),
        _buildOption(
          text: atm.status.temDinheiro ? 'Dinheiro disponível' : 'Sem dinheiro',
          color: atm.status.temDinheiro
              ? AppColors.greenStatus
              : AppColors.yellowStatus,
        ),
        _buildOption(
          text: atm.status.temPapel ? 'Papel disponível' : 'Sem papel',
          color: atm.status.temPapel
              ? AppColors.greenStatus
              : AppColors.yellowStatus,
        ),
      ],
    );
  }

  Color _logoBackground(String sigla) {
    switch (sigla.toUpperCase()) {
      case 'BFA':
        return const Color(0xFFFF6B00);
      case 'BIC':
        return const Color(0xFFE53935);
      case 'BAI':
        return const Color(0xFF2946A3);
      case 'ATL':
        return const Color(0xFF6C63FF);
      case 'SOL':
        return const Color(0xFFFFB300);
      case 'KEVE':
        return const Color(0xFF00897B);
      case 'BE':
        return const Color(0xFF546E7A);
      case 'YETU':
        return const Color(0xFF8E24AA);
      case 'BNI':
        return const Color(0xFF1565C0);
      default:
        return const Color(0xFFE0E0E0);
    }
  }

  Future<void> _abrirTrajectoDirecto({
    required BuildContext context,
    required AtmModel atm,
    double? userLatitude,
    double? userLongitude,
  }) async {
    final destinoLat = atm.latitude;
    final destinoLng = atm.longitude;

    String url;

    if (userLatitude != null && userLongitude != null) {
      url =
          'https://www.google.com/maps/dir/?api=1'
          '&origin=$userLatitude,$userLongitude'
          '&destination=$destinoLat,$destinoLng'
          '&travelmode=driving';
    } else {
      url =
          'https://www.google.com/maps/dir/?api=1'
          '&destination=$destinoLat,$destinoLng'
          '&travelmode=driving';
    }

    final uri = Uri.parse(url);

    final opened = await launchUrl(uri, mode: LaunchMode.platformDefault);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o trajecto no mapa.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final atmId = args?['atmId'] as String?;
    final userLatitude = args?['userLatitude'] as double?;
    final userLongitude = args?['userLongitude'] as double?;

    final repository = AtmRepository();

    final AtmModel? atm =
        (atmId != null && userLatitude != null && userLongitude != null)
            ? repository.getAtmByIdWithDistance(
                id: atmId,
                userLatitude: userLatitude,
                userLongitude: userLongitude,
              )
            : (atmId == null ? null : repository.getAtmById(atmId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do ATM'),
      ),
      body: atm == null
          ? const Center(
              child: Text(
                'ATM não encontrado.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9CCC65),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Container(
                            width: 92,
                            height: 92,
                            decoration: BoxDecoration(
                              color: _logoBackground(atm.bancoSigla),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                atm.bancoSigla,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        atm.bancoNome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        atm.localCompleto,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        atm.endereco,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        atm.distanceKm == null
                            ? 'Distância estimada indisponível'
                            : 'Distância estimada: ${atm.distanceKm!.toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AtmStatusUtils.getColor(atm).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AtmStatusUtils.getColor(atm),
                            width: 1.1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AtmStatusUtils.getColor(atm),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Estado atual: ${AtmStatusUtils.getLabel(atm)}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AtmStatusUtils.getColor(atm),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Estado do ATM',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusSection(atm),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.atmMap,
                                  arguments: {
                                    'atmId': atm.id,
                                    'query': atm.localCompleto,
                                    'userLatitude': userLatitude,
                                    'userLongitude': userLongitude,
                                    'openedWithoutLocation':
                                        userLatitude == null ||
                                            userLongitude == null,
                                  },
                                );
                              },
                              icon: const Icon(Icons.map_outlined, size: 18),
                              label: const Text(
                                'MAPA',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await _abrirTrajectoDirecto(
                                  context: context,
                                  atm: atm,
                                  userLatitude: userLatitude,
                                  userLongitude: userLongitude,
                                );
                              },
                              icon: const Icon(Icons.directions, size: 18),
                              label: const Text(
                                'TRAJECTO',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}