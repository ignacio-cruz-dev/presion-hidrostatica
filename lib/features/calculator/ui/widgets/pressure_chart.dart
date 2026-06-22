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
    final isMobile = MediaQuery.of(context).size.width < 600;

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
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TÍTULO
          Text(
            "Perfil de presión vs TVD",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 16 : 18,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          /// GRÁFICA
          SizedBox(
            height: isMobile ? 240 : 300,
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

                  animationDuration: 800,
                  width: 3,
                  color: const Color(0xFF3B82F6),

                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 5,
                    width: 5,
                    borderWidth: 2,
                    borderColor: Colors.blue,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// DESCRIPCIÓN
          const Text(
            "El perfil muestra el incremento de presión con respecto a la profundidad.",
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
