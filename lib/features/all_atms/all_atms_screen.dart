import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/atm_model.dart';
import '../../data/repositories/atm_repository.dart';
import '../nearby_atms/widgets/atm_list_item.dart';

class AllAtmsScreen extends StatelessWidget {
  const AllAtmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final query = (args?['query'] as String?) ?? '';
    final userLatitude = args?['userLatitude'] as double?;
    final userLongitude = args?['userLongitude'] as double?;
    final openedWithoutLocation =
        (args?['openedWithoutLocation'] as bool?) ?? false;

    final repository = AtmRepository();

    final List<AtmModel> atms =
        (userLatitude != null && userLongitude != null)
            ? repository.getAllAtmsSortedByDistance(
                userLatitude: userLatitude,
                userLongitude: userLongitude,
                query: query,
              )
            : repository.searchAtms(query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os ATM\'s'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (query.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  openedWithoutLocation
                      ? 'Resultado para: $query (sem localização)'
                      : 'Resultado para: $query',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            if (atms.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.atmMap,
                        arguments: {
                          'query': query,
                          'userLatitude': userLatitude,
                          'userLongitude': userLongitude,
                          'openedWithoutLocation': openedWithoutLocation,
                        },
                      );
                    },
                    icon: const Icon(Icons.map_outlined),
                    label: const Text(
                      'VER NO MAPA',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: atms.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum ATM encontrado.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: atms.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final atm = atms[index];

                        return AtmListItem(
                          atm: atm,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.atmDetails,
                              arguments: {
                                'atmId': atm.id,
                                'userLatitude': userLatitude,
                                'userLongitude': userLongitude,
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}