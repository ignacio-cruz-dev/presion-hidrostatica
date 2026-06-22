import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PressureChart extends StatelessWidget {
  final double rho;
  final double h;

  const PressureChart({super.key, required this.rho, required this.h});

  @override
  Widget build(BuildContext context) {
    const g = 9.81;

    /// 🔥 puntos reales (sin invertir)
    final spots = List.generate(10, (i) {
      final depth = (h / 10) * i;
      final pressure = rho * g * depth;

      return FlSpot(pressure, depth);
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gráfica: Presión vs Profundidad",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: rho * g * h,

                minY: 0,
                maxY: h,

                gridData: FlGridData(show: true),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text("Presión (Pa)"),
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text("Profundidad (m)"),
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),

                borderData: FlBorderData(show: true),

                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    dotData: FlDotData(show: true),
                    color: Colors.blue,
                    barWidth: 3,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Relación lineal entre presión y profundidad",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
