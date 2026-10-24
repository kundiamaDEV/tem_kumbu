import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/theme/app_colors.dart';
import '../../data/models/atm_model.dart';

class AtmStatusUtils {
  static Color getColor(AtmModel atm) {
    final status = atm.status;

    if (!status.emServico) {
      return AppColors.redStatus;
    }

    if (status.temDinheiro && status.temPapel) {
      return AppColors.greenStatus;
    }

    return AppColors.yellowStatus;
  }

  static String getLabel(AtmModel atm) {
    final status = atm.status;

    if (!status.emServico) {
      return 'Fora de serviço';
    }

    if (status.temDinheiro && status.temPapel) {
      return 'Activo';
    }

    return 'Activo parcial';
  }

  static double getMarkerHue(AtmModel atm) {
    final status = atm.status;

    if (!status.emServico) {
      return BitmapDescriptor.hueRed;
    }

    if (status.temDinheiro && status.temPapel) {
      return BitmapDescriptor.hueGreen;
    }

    return BitmapDescriptor.hueYellow;
  }
}