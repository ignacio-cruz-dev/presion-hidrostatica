import '../enums/unit_system.dart';

class UnitConstants {
  /// 🔹 UNIDADES
  static String density(UnitSystem unit) {
    switch (unit) {
      case UnitSystem.api:
        return "ppg"; // pounds per gallon
      case UnitSystem.mixto:
        return "g/cm³";
      case UnitSystem.si:
        return "kg/m³";
    }
  }

  static String depth(UnitSystem unit) {
    switch (unit) {
      case UnitSystem.api:
        return "ft";
      case UnitSystem.mixto:
      case UnitSystem.si:
        return "m";
    }
  }

  static String pressure(UnitSystem unit) {
    switch (unit) {
      case UnitSystem.api:
      case UnitSystem.mixto:
        return "psi";
      case UnitSystem.si:
        return "Pa";
    }
  }

  /// 🔹 FÓRMULAS
  static double calculatePressure({
    required UnitSystem unit,
    required double rho,
    required double h,
  }) {
    switch (unit) {
      case UnitSystem.api:
        return 0.052 * rho * h;
      case UnitSystem.mixto:
        return rho * h * 0.1;
      case UnitSystem.si:
        return rho * 9.81 * h;
    }
  }

  /// 🔹 ECUACIÓN TEXTO
  static String equation(UnitSystem unit) {
    switch (unit) {
      case UnitSystem.api:
        return "P = 0.052 × ρ(ppg) × h(ft)";
      case UnitSystem.mixto:
        return "P = ρ(g/cm³) × h(m) × 0.1";
      case UnitSystem.si:
        /* return "P = ρ × 9.81 × h";
      default: */
        return "P = ρ × g × h";
    }
  }
}
