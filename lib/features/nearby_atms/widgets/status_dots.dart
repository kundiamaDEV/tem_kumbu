import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/models/atm_status_model.dart';

class StatusDots extends StatelessWidget {
  final AtmStatusModel status;

  const StatusDots({
    super.key,
    required this.status,
  });

  Color _moneyColor() {
    if (!status.emServico) return AppColors.redStatus;
    return status.temDinheiro
        ? AppColors.greenStatus
        : AppColors.yellowStatus;
  }

  Color _paperColor() {
    if (!status.emServico) return AppColors.redStatus;
    return status.temPapel
        ? AppColors.greenStatus
        : AppColors.yellowStatus;
  }

  Color _serviceColor() {
    return status.emServico
        ? AppColors.greenStatus
        : AppColors.redStatus;
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      _moneyColor(),
      _paperColor(),
      _serviceColor(),
    ];

    return Row(
      children: colors
          .map(
            (color) => Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}