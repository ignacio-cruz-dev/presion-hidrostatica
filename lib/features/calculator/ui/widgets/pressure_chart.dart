import 'package:flutter/material.dart';
import 'package:hydro_app/core/enums/unit_system.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/unit_systems.dart';

class PressureChart extends StatelessWidget {
  final double rho;
  final double h;
  final UnitSystem unit;

  const PressureChart({
    super.key,
    required this.rho,
    required this.h,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {

    final formatter = NumberFormat.compact();

    /// Datos
    final data = List.generate(10, (i) {
      final depth = (h / 10) * i;

      final pressure = UnitConstants.calculatePressure(
        unit: unit,
        rho: rho,
        h: depth,
      );

      return ChartData(pressure, depth);
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
          /// TÍTULO
          const Text(
            "Perfil de presión vs TVD",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 16),

          /// GRÁFICA
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),

              primaryXAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Presión (${UnitConstants.pressure(unit)})',
                ),
                numberFormat: formatter,

                majorGridLines: const MajorGridLines(
                  width: 1,
                  dashArray: [5, 5],
                ),
              ),

              /// 🔥 EJE INVERTIDO REAL
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Profundidad (${UnitConstants.depth(unit)})',
                ),
                isInversed: true,
                minimum: 0,
                maximum: h,
                interval: h / 5,

                majorGridLines: const MajorGridLines(
                  width: 1,
                  dashArray: [5, 5],
                ),
              ),

              series: <CartesianSeries>[
                LineSeries<ChartData, double>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.pressure,
                  yValueMapper: (ChartData data, _) => data.depth,

                  width: 3,
                  color: Colors.blueAccent,

                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// DESCRIPCIÓN
          const Text(
            "La presión aumenta con la profundidad",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// MODELO DE DATOS
class ChartData {
  final double pressure;
  final double depth;

  ChartData(this.pressure, this.depth);
}
