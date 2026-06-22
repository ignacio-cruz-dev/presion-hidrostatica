class CalculationService {
  static double calculatePressure(double rho, double h) {
    const g = 9.81;
    return rho * g * h;
  }
}