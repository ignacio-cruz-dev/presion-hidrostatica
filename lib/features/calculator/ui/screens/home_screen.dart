import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../widgets/input_field.dart';
import '../widgets/equation_card.dart';
import '../widgets/history_card.dart';
import '../../services/pdf_service.dart';
import '../widgets/pressure_chart.dart';
import '../../../../core/enums/unit_system.dart';
import '../../../../core/constants/unit_systems.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1️⃣ VARIABLES
  final rhoController = TextEditingController();
  final hController = TextEditingController();

  double? result;
  List calculations = [];
  UnitSystem selectedUnit = UnitSystem.si;
  double? selectedFluid;

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
    super.dispose();
  }

  // 3️⃣ MÉTODOS (lógica)

  void loadHistory() {
    setState(() {
      calculations = StorageService.getCalculations();
    });
  }

  void calculate() {
    final rho = double.tryParse(rhoController.text);
    final h = double.tryParse(hController.text);

    if (rho == null || h == null) return;

    final finalResult = UnitConstants.calculatePressure(
      unit: selectedUnit,
      rho: rho,
      h: h,
    );

    setState(() {
      result = finalResult;
      loadHistory();
    });

    StorageService.saveCalculation(
      rho: rho,
      h: h,
      result: finalResult,
      unit: selectedUnit,
    );
  }

  void clearInputs() {
    rhoController.clear();
    hController.clear();

    setState(() {
      result = null;
    });
  }

  // 4️⃣ HELPERS UI

  Widget _unitButton(UnitSystem unit, String label) {
    final isSelected = selectedUnit == unit;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnit = unit;
        });
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.amber : Colors.white30),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _fluidItem(String title, String densityText, double value) {
    final isSelected = selectedFluid == value;

    /// 🎨 COLOR POR TIPO DE FLUIDO
    Color fluidColor;

    if (title.contains("Agua")) {
      fluidColor = Colors.blue;
    } else if (title.contains("Lodo")) {
      fluidColor = Colors.green;
    } else if (title.contains("Aceite")) {
      fluidColor = Colors.brown;
    } else if (title.contains("Cemento")) {
      fluidColor = Colors.grey;
    } else {
      fluidColor = Colors.blueGrey;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFluid = value;
            rhoController.text = value.toString();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.10)
                : const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(10),

            /// 🔥 BORDE IZQUIERDO TIPO INDUSTRIA
            border: Border(left: BorderSide(color: fluidColor, width: 4)),
          ),
          child: Row(
            children: [
              /// 🔥 CONTENIDO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      densityText,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5️⃣ BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// ================= HEADER =================
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// LOGO
                        Container(
                          width: 55,
                          height: 55,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// TITULO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "HydroPressure Lab",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Calculadora de Presión Hidrostática · BHP",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// BADGE GRUPO TANIS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "• by Grupo Tanis · Ingeniería y Consultoría",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// FORMULAS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                            "P = ρ × g × h",
                            style: TextStyle(color: Colors.white70),
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

                    const SizedBox(height: 20),
                  ],
                ),

                const SizedBox(height: 20),

                /// ================= UNIDADES =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _unitButton(UnitSystem.si, "SI"),
                    const SizedBox(width: 12),
                    _unitButton(UnitSystem.api, "API"),
                    const SizedBox(width: 12),
                    _unitButton(UnitSystem.mixto, "Mixto"),
                  ],
                ),

                const SizedBox(height: 20),

                /// BOTONES SISTEMAS DE UNIDADES
                /* Row(
                  children: [
                    Expanded(child: _unitButton("SI")),
                    const SizedBox(width: 10),
                    Expanded(child: _unitButton("Campo")),
                    const SizedBox(width: 10),
                    Expanded(child: _unitButton("Mixto")),
                  ],
                ),

                const SizedBox(height: 20), */

                /// INPUT CARD
                Card(
                  color: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        InputField(
                          label: "Densidad",
                          unit: UnitConstants.density(selectedUnit),
                          controller: rhoController,
                        ),
                        const SizedBox(width: 10),
                        InputField(
                          label: "Profundidad",
                          unit: UnitConstants.depth(selectedUnit),
                          controller: hController,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// BOTONES
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: calculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Calcular Presión",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: clearInputs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Limpiar"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ECUACIÓN
                if (result != null)
                  EquationCard(equation: UnitConstants.equation(selectedUnit)),

                const SizedBox(height: 20),

                /// RESULTADO
                if (result != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text("Resultado"),
                        const SizedBox(height: 10),
                        Text(
                          result!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(UnitConstants.pressure(selectedUnit)),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                /// ================= FLUIDOS =================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITULO
                      Row(
                        children: const [
                          Icon(Icons.circle, size: 8, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            "TIPO DE FLUIDO",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// GRID
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _fluidItem("Agua dulce", "1 g/cm³", 1000),
                          _fluidItem("Agua salada", "1.07 g/cm³", 1070),
                          _fluidItem("Lodo ligero", "1.2 g/cm³", 1200),
                          _fluidItem("Lodo pesado", "1.8 g/cm³", 1800),
                          _fluidItem("Aceite", "0.85 g/cm³", 850),
                          _fluidItem("Cemento", "1.9 g/cm³", 1900),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// INPUT PERSONALIZADO
                      const Text(
                        "DENSIDAD PERSONALIZADA",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: rhoController,
                        onChanged: (_) {
                          setState(() {
                            selectedFluid = null;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(
                            0xFF2A2A2A,
                          ), // 🔥 mejor que negro puro
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),

                          /// 🔥 AQUÍ EL CAMBIO IMPORTANTE
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              UnitConstants.density(selectedUnit),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// GRAFICA
                if (result != null)
                  PressureChart(
                    rho: double.parse(rhoController.text),
                    h: double.parse(hController.text),
                    unit: selectedUnit,
                  ),

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Historial de Cálculos",
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    PdfService.generatePdf(calculations);
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
                                      loadHistory();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text("Limpiar"),
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
                          itemCount: calculations.length,
                          itemBuilder: (context, index) {
                            final rawItem = calculations[index];

                            final unit = UnitSystem.values.firstWhere(
                              (e) => e.name == rawItem['unit'],
                            );

                            final item = {...rawItem, 'unitParsed': unit};

                            return HistoryCard(
                              item: item,
                              onDelete: () {
                                StorageService.delete(index);
                                setState(() {
                                  loadHistory();
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
