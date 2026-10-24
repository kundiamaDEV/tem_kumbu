import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/atm_status_utils.dart';
import '../../../data/models/atm_model.dart';

class AtmListItem extends StatelessWidget {
  final AtmModel atm;
  final VoidCallback onTap;

  const AtmListItem({
    super.key,
    required this.atm,
    required this.onTap,
  });

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

  String _buildTitle() {
    final local = atm.localCompleto.trim();

    if (local.isNotEmpty) {
      return 'ATM do ${atm.bancoSigla} - $local';
    }

    return 'ATM do ${atm.bancoSigla}';
  }

  String _buildSubtitle() {
    if (atm.distanceKm != null) {
      return '${atm.distanceKm!.toStringAsFixed(2)} km • ${atm.endereco}';
    }

    return atm.endereco;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = AtmStatusUtils.getColor(atm);
    final statusLabel = AtmStatusUtils.getLabel(atm);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _logoBackground(atm.bancoSigla),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    atm.bancoSigla,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _buildTitle(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      atm.bancoNome,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _buildSubtitle(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withAlpha(90),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    statusLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}