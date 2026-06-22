import 'package:flutter/material.dart';

import '../../../../core/constants/unit_systems.dart';
import '../../../../core/enums/unit_system.dart';
import '../../models/fluid_option.dart';
import '../../services/calculation_service.dart';

class FluidSection extends StatelessWidget {
  final bool isMobile;
  final UnitSystem selectedUnit;
  final double? selectedFluid;
  final TextEditingController rhoController;
  final VoidCallback clearCalculatedResult;
  final Function(double densitySI) onFluidSelected;

  const FluidSection({
    super.key,
    required this.isMobile,
    required this.selectedUnit,
    required this.selectedFluid,
    required this.rhoController,
    required this.clearCalculatedResult,
    required this.onFluidSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),

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
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 16 : 20),

          /// GRID
          GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            shrinkWrap: true,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: isMobile ? 4.6 : 7.2,
            physics: const NeverScrollableScrollPhysics(),

            children: FluidOption.all
                .map((fluid) => _fluidItem(context, fluid))
                .toList(),
          ),

          const SizedBox(height: 15),

          /// INPUT PERSONALIZADO
          const Text(
            "DENSIDAD PERSONALIZADA",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),

          const SizedBox(height: 6),

          TextField(
            controller: rhoController,

            onChanged: (_) {
              clearCalculatedResult();
            },

            decoration: InputDecoration(
              hintText: "Ingresa densidad",

              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),

              suffixIcon: Container(
                alignment: Alignment.center,
                width: 85,

                child: Text(
                  UnitConstants.density(selectedUnit),

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

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),

                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),

                borderSide: const BorderSide(color: Colors.amber, width: 1.5),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),

            style: const TextStyle(
              color: Color(0xFFF7F8FC),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            cursorColor: Colors.amber,

            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }

  Widget _fluidItem(BuildContext context, FluidOption fluid) {
    final isSelected = selectedFluid == fluid.densitySI;

    Color fluidColor;

    if (fluid.name.contains("Agua")) {
      fluidColor = Colors.blue;
    } else if (fluid.name.contains("Lodo")) {
      fluidColor = Colors.green;
    } else if (fluid.name.contains("Aceite")) {
      fluidColor = Colors.brown;
    } else if (fluid.name.contains("Cemento")) {
      fluidColor = Colors.grey;
    } else {
      fluidColor = Colors.blueGrey;
    }

    final convertedDensity = CalculationService.densityFromSI(
      value: fluid.densitySI,
      unit: selectedUnit,
    );

    String densityText;

    switch (selectedUnit) {
      case UnitSystem.si:
        densityText = "${convertedDensity.toStringAsFixed(0)} kg/m³";
        break;

      case UnitSystem.mixto:
        densityText = "${convertedDensity.toStringAsFixed(2)} g/cm³";
        break;

      case UnitSystem.api:
        densityText = "${convertedDensity.toStringAsFixed(2)} ppg";
        break;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        onTap: () {
          onFluidSelected(fluid.densitySI);
        },

        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 14,
            vertical: isMobile ? 6 : 10,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withValues(alpha: 0.10)
                : const Color(0xFFF5F6FA),

            borderRadius: BorderRadius.circular(10),

            border: Border(left: BorderSide(color: fluidColor, width: 4)),
          ),

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      fluid.name,

                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 14 : 15,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 1),

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
}
