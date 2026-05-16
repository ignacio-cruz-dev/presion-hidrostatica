import 'package:flutter/material.dart';
import '../../services/calculation_service.dart';
import '../../services/storage_service.dart';
import '../widgets/input_field.dart';
import '../widgets/equation_card.dart';
import '../widgets/history_card.dart';
import '../../services/pdf_service.dart';
import '../widgets/pressure_chart.dart';

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
  String selectedUnit = "SI";

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

    final res = CalculationService.calculatePressure(rho, h);

    StorageService.saveCalculation(rho: rho, h: h, result: res);

    setState(() {
      result = res;
      loadHistory();
    });
  }

  void clearInputs() {
    rhoController.clear();
    hController.clear();

    setState(() {
      result = null;
    });
  }

  // 4️⃣ HELPERS UI

  Widget _unitButton(String label) {
    final isSelected = selectedUnit == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnit = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[800] : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.amber : Colors.white30),
          borderRadius: BorderRadius.circular(12),
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
                /// HEADER
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.water_drop,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "HydroPressure Lab",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Calculadora de Presión Hidrostática · BHP",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// BOTONES SISTEMAS DE UNIDADES
                Row(
                  children: [
                    Expanded(child: _unitButton("SI")),
                    const SizedBox(width: 10),
                    Expanded(child: _unitButton("Campo")),
                    const SizedBox(width: 10),
                    Expanded(child: _unitButton("Mixto")),
                  ],
                ),

                const SizedBox(height: 20),

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
                          unit: "kg/m³",
                          controller: rhoController,
                        ),
                        const SizedBox(width: 10),
                        InputField(
                          label: "Profundidad",
                          unit: "m",
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
                  EquationCard(
                    equation:
                        "P = ρ × g × h = ${rhoController.text} × 9.81 × ${hController.text}",
                  ),

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
                        const Text("Pa"),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                /// GRAFICA
                if (result != null)
                  PressureChart(
                    rho: double.parse(rhoController.text),
                    h: double.parse(hController.text),
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
                            final item = calculations[index];

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
