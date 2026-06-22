import '../../../../core/enums/unit_system.dart';

class CalculationService {
  static const double g = 9.81;

  /// =====================================================
  /// CALCULAR PRESIÓN
  /// =====================================================

  static double calculatePressure({
    required double rhoSI,
    required double hSI,
  }) {
    return rhoSI * g * hSI;
  }

  /// =====================================================
  /// DENSIDAD
  /// =====================================================

  /// UI -> SI
  static double densityToSI({required double value, required UnitSystem unit}) {
    switch (unit) {
      /// kg/m³
      case UnitSystem.si:
        return value;

      /// g/cm³ -> kg/m³
      case UnitSystem.mixto:
        return value * 1000;

      /// ppg -> kg/m³
      case UnitSystem.api:
        return value / 0.008345404;
    }
  }

  /// SI -> UI
  static double densityFromSI({
    required double value,
    required UnitSystem unit,
  }) {
    switch (unit) {
      /// kg/m³
      case UnitSystem.si:
        return value;

      /// kg/m³ -> g/cm³
      case UnitSystem.mixto:
        return value / 1000;

      /// kg/m³ -> ppg
      case UnitSystem.api:
        return value * 0.008345404;
    }
  }

  /// =====================================================
  /// PROFUNDIDAD
  /// =====================================================

  static double depthToSI({required double value, required UnitSystem unit}) {
    switch (unit) {
      case UnitSystem.si:
      case UnitSystem.mixto:
        return value;

      /// ft -> m
      case UnitSystem.api:
        return value / 3.28084;
    }
  }

  static double depthFromSI({required double value, required UnitSystem unit}) {
    switch (unit) {
      case UnitSystem.si:
      case UnitSystem.mixto:
        return value;

      /// m -> ft
      case UnitSystem.api:
        return value * 3.28084;
    }
  }

  /// =====================================================
  /// PRESIÓN
  /// =====================================================

  static double pressureFromSI({
    required double value,
    required UnitSystem unit,
  }) {
    switch (unit) {
      /// Pa
      case UnitSystem.si:
        return value;

      /// PSI
      case UnitSystem.api:
      case UnitSystem.mixto:
        return value * 0.000145038;
    }
  }
}
