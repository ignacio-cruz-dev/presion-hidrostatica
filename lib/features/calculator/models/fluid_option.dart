class FluidOption {
  final String name;

  /// SIEMPRE GUARDAR EN SI
  /// kg/m³
  final double densitySI;

  const FluidOption({required this.name, required this.densitySI});

  /// ================= FLUIDOS =================

  static const waterFresh = FluidOption(name: 'Agua dulce', densitySI: 1000);

  static const waterSalt = FluidOption(name: 'Agua salada', densitySI: 1070);

  static const lightMud = FluidOption(name: 'Lodo ligero', densitySI: 1200);

  static const heavyMud = FluidOption(name: 'Lodo pesado', densitySI: 1800);

  static const oil = FluidOption(name: 'Aceite', densitySI: 850);

  static const cement = FluidOption(name: 'Cemento', densitySI: 1900);

  /// ================= LISTA =================

  static const all = [waterFresh, waterSalt, lightMud, heavyMud, oil, cement];
}
