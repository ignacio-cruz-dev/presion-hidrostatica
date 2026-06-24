import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../widgets/history_card.dart';
import '../../services/pdf_service.dart';
import '../widgets/pressure_chart.dart';
import '../../../../core/enums/unit_system.dart';
import '../../../../core/constants/unit_systems.dart';
import '../widgets/app_footer.dart';
import '../../services/calculation_service.dart';
import '../widgets/fluid_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1️⃣ VARIABLES
  final rhoController = TextEditingController();
  final hController = TextEditingController();
  final pressureController = TextEditingController();

  double? result;
  List calculations = [];
  UnitSystem selectedUnit = UnitSystem.si;
  double? selectedFluid;
  bool showAllHistory = false;

  // 2️⃣ LIFECYCLE (SIEMPRE ARRIBA)
  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  @override
  void dispose() {
    rhoController.dispose();
    hController.dispose();
    pressureController.dispose();
    super.dispose();
  }

  // 3️⃣ MÉTODOS (lógica)

  void loadHistory() {
    calculations = StorageService.getCalculations();
  }

  void calculate() {
    final rho = double.tryParse(rhoController.text);
    final h = double.tryParse(hController.text);

    if (rho == null || h == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa densidad y profundidad válidas")),
      );
      return;
    }

    /// Convertir a SI
    final rhoSI = CalculationService.densityToSI(
      value: rho,
      unit: selectedUnit,
    );

    final hSI = CalculationService.depthToSI(value: h, unit: selectedUnit);

    /// Calcular en SI
    final pressureSI = CalculationService.calculatePressure(
      rhoSI: rhoSI,
      hSI: hSI,
    );

    /// Convertir para UI
    final finalResult = CalculationService.pressureFromSI(
      value: pressureSI,
      unit: selectedUnit,
    );

    pressureController.text = finalResult.toStringAsFixed(2);

    StorageService.saveCalculation(
      rho: rho,
      h: h,
      result: finalResult,
      unit: selectedUnit,
    );

    setState(() {
      result = finalResult;
      loadHistory();
    });
  }

  void clearInputs() {
    rhoController.clear();
    hController.clear();
    pressureController.clear();

    setState(() {
      selectedFluid = null;
      result = null;
    });
  }

  void clearCalculatedResult() {
    pressureController.clear();

    setState(() {
      result = null;
    });
  }

  void changeUnit(UnitSystem newUnit) {
    /// DENSIDAD
    final currentDensity = double.tryParse(rhoController.text);

    if (currentDensity != null) {
      /// UI actual -> SI
      final densitySI = CalculationService.densityToSI(
        value: currentDensity,
        unit: selectedUnit,
      );

      /// SI -> nueva UI
      final convertedDensity = CalculationService.densityFromSI(
        value: densitySI,
        unit: newUnit,
      );

      rhoController.text = convertedDensity.toStringAsFixed(
        newUnit == UnitSystem.si ? 0 : 2,
      );
    }

    /// PROFUNDIDAD
    final currentDepth = double.tryParse(hController.text);

    if (currentDepth != null) {
      final depthSI = CalculationService.depthToSI(
        value: currentDepth,
        unit: selectedUnit,
      );

      final convertedDepth = CalculationService.depthFromSI(
        value: depthSI,
        unit: newUnit,
      );

      hController.text = convertedDepth.toStringAsFixed(0);
    }

    /// LIMPIAR RESULTADO
    pressureController.clear();

    setState(() {
      selectedUnit = newUnit;
      result = null;
    });
  }

  // 4️⃣ HELPERS UI

  InputDecoration _inputDecoration({
    required String hint,
    required String unit,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(
        color: Colors.white54,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),

      suffixIcon: Container(
        alignment: Alignment.center,
        width: 85,

        child: Text(
          unit,

          style: const TextStyle(
            color: Color(0xFFFFC400),
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      ),

      filled: true,
      fillColor: const Color(0xFF1F1F1F),
      isDense: true,

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),

        borderSide: const BorderSide(color: Colors.amber, width: 1.5),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  double get sliderMaxDepth {
    switch (selectedUnit) {
      case UnitSystem.si:
        return 2000;

      case UnitSystem.mixto:
        return 2000;

      case UnitSystem.api:
        return 6500;
    }
  }

  // 5️⃣ BUILD
  @override
  Widget build(BuildContext context) {
    final depthInput = double.tryParse(hController.text) ?? 0;

    final depthValue = CalculationService.depthToSI(
      value: depthInput,
      unit: selectedUnit,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF001B70),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1050),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 24,
                  vertical: isMobile ? 18 : 28,
                ),
                child: Column(
                  children: [
                    /// ================= HEADER =================
                    Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 10,

                          children: [
                            /// LOGO
                            Container(
                              width: isMobile ? 52 : 120,
                              height: isMobile ? 52 : 120,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                image: DecorationImage(
                                  image: AssetImage('assets/tanis-logo.jpg'),
                                  fit: BoxFit.cover,
                                  opacity: 0.95,
                                ),
                              ),
                            ),

                            SizedBox(width: isMobile ? 10 : 18),

                            /// TITULO
                            Column(
                              crossAxisAlignment: isMobile
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "HydroPressure Lab V2",
                                  style: TextStyle(
                                    fontSize: isMobile ? 18 : 44,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Calculadora de Presión Hidrostática · BHP",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isMobile ? 10 : 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: isMobile ? 6 : 18),

                        /// BADGE GRUPO TANIS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "• by Grupo Tanis · Altas Soluciones para la Industria",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isMobile ? 10 : 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// FORMULAS
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 12 : 16,
                                vertical: isMobile ? 6 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "P = ρ × g × h",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "BHP",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),

                        //const SizedBox(height: 20),
                      ],
                    ),

                    SizedBox(height: isMobile ? 10 : 16),

                    /// ================= SISTEMAS DE UNIDADES =================
                    Container(
                      height: isMobile ? 46 : 64,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),

                      child: Row(
                        children: [
                          _buildUnitTab(
                            label: "SI · Métrico",
                            unit: UnitSystem.si,
                          ),

                          _buildUnitTab(
                            label: "Campo\n(ppg/ft)",
                            unit: UnitSystem.api,
                          ),

                          _buildUnitTab(label: "Mixto", unit: UnitSystem.mixto),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ================= FLUIDOS =================
                    FluidSection(
                      isMobile: isMobile,
                      selectedUnit: selectedUnit,
                      selectedFluid: selectedFluid,
                      rhoController: rhoController,

                      clearCalculatedResult: clearCalculatedResult,

                      onFluidSelected: (densitySI) {
                        clearCalculatedResult();

                        final convertedDensity =
                            CalculationService.densityFromSI(
                              value: densitySI,
                              unit: selectedUnit,
                            );

                        setState(() {
                          selectedFluid = densitySI;

                          rhoController.text = convertedDensity.toStringAsFixed(
                            selectedUnit == UnitSystem.si ? 0 : 2,
                          );
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    /// ================= TVD =================
                    Container(
                      padding: EdgeInsets.all(isMobile ? 16 : 20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// TITULO
                          Text(
                            "PROFUNDIDAD VERTICAL VERDADERA (TVD)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              fontSize: isMobile ? 16 : 18,
                            ),
                          ),

                          SizedBox(height: isMobile ? 14 : 16),

                          /// ================= INPUTS =================
                          isMobile
                              ? Column(
                                  children: [
                                    /// TVD
                                    TextField(
                                      controller: hController,

                                      decoration: _inputDecoration(
                                        hint: "Ingresa TVD",
                                        unit: UnitConstants.depth(selectedUnit),
                                      ),

                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      cursorColor: Colors.amber,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),

                                      onChanged: (_) {
                                        clearCalculatedResult();

                                        setState(() {});
                                      },
                                    ),

                                    const SizedBox(height: 12),

                                    /// RESULTADO
                                    TextField(
                                      controller: pressureController,
                                      readOnly: true,

                                      decoration: _inputDecoration(
                                        hint: "Presión",
                                        unit: UnitConstants.pressure(
                                          selectedUnit,
                                        ),
                                      ),

                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      cursorColor: Colors.amber,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: hController,

                                        decoration: _inputDecoration(
                                          hint: "Ingresa TVD",
                                          unit: UnitConstants.depth(
                                            selectedUnit,
                                          ),
                                        ),

                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: Colors.amber,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),

                                        onChanged: (_) {
                                          clearCalculatedResult();

                                          setState(() {});
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: TextField(
                                        controller: pressureController,
                                        readOnly: true,

                                        decoration: _inputDecoration(
                                          hint: "Presión",
                                          unit: UnitConstants.pressure(
                                            selectedUnit,
                                          ),
                                        ),

                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        cursorColor: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),

                          SizedBox(height: isMobile ? 12 : 16),

                          /// SLIDER
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,

                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),

                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 18,
                              ),
                            ),

                            child: Slider(
                              value: depthValue.clamp(0, 2000),

                              min: 0,
                              max: sliderMaxDepth,
                              divisions: 20,

                              activeColor: Colors.amber,
                              inactiveColor: Colors.grey[300],

                              onChanged: (value) {
                                clearCalculatedResult();

                                setState(() {
                                  final convertedDepth =
                                      CalculationService.depthFromSI(
                                        value: value,
                                        unit: selectedUnit,
                                      );

                                  hController.text = convertedDepth
                                      .toStringAsFixed(0);
                                });
                              },
                            ),
                          ),

                          SizedBox(height: isMobile ? 12 : 16),

                          /// ================= BOTONES =================
                          isMobile
                              ? Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,

                                      child: ElevatedButton(
                                        onPressed:
                                            rhoController.text.isEmpty ||
                                                hController.text.isEmpty ||
                                                result != null
                                            ? null
                                            : () {
                                                calculate();
                                              },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,

                                          minimumSize: const Size(
                                            double.infinity,
                                            50,
                                          ),

                                          disabledBackgroundColor: Colors.amber
                                              .withValues(alpha: 0.4),

                                          disabledForegroundColor:
                                              Colors.black54,
                                        ),

                                        child: const Text(
                                          "Calcular BHP",

                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    SizedBox(
                                      width: double.infinity,

                                      child: ElevatedButton(
                                        onPressed: clearInputs,

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,

                                          minimumSize: const Size(
                                            double.infinity,
                                            50,
                                          ),
                                        ),

                                        child: const Text(
                                          "Limpiar",

                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            rhoController.text.isEmpty ||
                                                hController.text.isEmpty ||
                                                result != null
                                            ? null
                                            : () {
                                                calculate();
                                              },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,

                                          minimumSize: const Size(
                                            double.infinity,
                                            50,
                                          ),

                                          disabledBackgroundColor: Colors.amber
                                              .withValues(alpha: 0.4),

                                          disabledForegroundColor:
                                              Colors.black54,
                                        ),

                                        child: const Text(
                                          "Calcular BHP",

                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    ElevatedButton(
                                      onPressed: clearInputs,

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,

                                        minimumSize: const Size(120, 50),
                                      ),

                                      child: const Text(
                                        "Limpiar",

                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// GRAFICA
                    if (result != null)
                      PressureChart(
                        rho: double.tryParse(rhoController.text) ?? 0,
                        h: double.tryParse(hController.text) ?? 0,
                        unit: selectedUnit,
                      ),

                    const SizedBox(height: 15),

                    /// HISTORIAL
                    if (calculations.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            /// HEADER HISTORIAL
                            isMobile
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Historial de Cálculos",
                                        style: TextStyle(color: Colors.white),
                                      ),

                                      const SizedBox(height: 12),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: calculations.isEmpty
                                                  ? null
                                                  : () async {
                                                      await PdfService.generatePdf(
                                                        calculations,
                                                      );
                                                    },

                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.amber,
                                              ),

                                              child: const Text("PDF"),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                StorageService.clear();

                                                setState(() {
                                                  calculations = [];
                                                });
                                              },

                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),

                                              child: const Text(
                                                "Limpiar",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Historial de Cálculos",
                                        style: TextStyle(color: Colors.white),
                                      ),

                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: calculations.isEmpty
                                                ? null
                                                : () async {
                                                    await PdfService.generatePdf(
                                                      calculations,
                                                    );
                                                  },

                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                            ),

                                            child: const Text("PDF"),
                                          ),

                                          const SizedBox(width: 8),

                                          ElevatedButton(
                                            onPressed: () {
                                              StorageService.clear();

                                              setState(() {
                                                calculations = [];
                                              });
                                            },

                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),

                                            child: const Text(
                                              "Limpiar",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                            const SizedBox(height: 10),

                            /// LISTA
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: showAllHistory
                                  ? calculations.length
                                  : calculations.take(4).length,
                              itemBuilder: (context, index) {
                                final visibleCalculations = showAllHistory
                                    ? calculations
                                    : calculations.take(4).toList();

                                final rawItem = visibleCalculations[index];

                                final originalIndex = calculations.indexOf(
                                  rawItem,
                                );

                                final unit = UnitSystem.values.firstWhere(
                                  (e) => e.name == rawItem['unit'],
                                );

                                final item = {...rawItem, 'unitParsed': unit};

                                return HistoryCard(
                                  item: item,
                                  onDelete: () {
                                    StorageService.delete(item['key']);

                                    setState(() {
                                      calculations =
                                          StorageService.getCalculations();
                                    });
                                  },
                                  index: calculations.length - originalIndex,
                                  isLatest: index == 0,
                                );
                              },
                            ),

                            // VER MAS
                            if (calculations.length > 4) ...[
                              const SizedBox(height: 10),

                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showAllHistory = !showAllHistory;
                                  });
                                },

                                child: Text(
                                  showAllHistory ? "Ver menos" : "Ver más",

                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),
                    const AppFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitTab({required String label, required UnitSystem unit}) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final isSelected = selectedUnit == unit;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          changeUnit(unit);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          margin: const EdgeInsets.symmetric(horizontal: 2),

          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFC400) : Colors.transparent,

            borderRadius: BorderRadius.circular(10),

            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFC400)
                  : Colors.white.withValues(alpha: 0.15),
            ),

            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),

          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,

              style: TextStyle(
                color: isSelected
                    ? Colors.black87
                    : Colors.amber.withValues(alpha: 0.85),

                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 13 : 17,
                height: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
