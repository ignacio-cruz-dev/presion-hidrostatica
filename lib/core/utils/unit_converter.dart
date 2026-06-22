class UnitConverter {
  /// DENSIDAD → SI (kg/m³)
  static double densityToSI(double value, String unit) {
    switch (unit) {
      case 'kg/m³':
        return value;
      case 'lb/ft³':
        return value * 16.0185;
      case 'g/cc':
        return value * 1000;
      default:
        return value;
    }
  }

  /// PROFUNDIDAD → SI (m)
  static double depthToSI(double value, String unit) {
    switch (unit) {
      case 'm':
        return value;
      case 'ft':
        return value * 0.3048;
      default:
        return value;
    }
  }

  /// PRESIÓN desde SI
  static double pressureFromSI(double value, String unit) {
    switch (unit) {
      case 'Pa':
        return value;
      case 'psi':
        return value * 0.000145038;
      default:
        return value;
    }
  }
}
