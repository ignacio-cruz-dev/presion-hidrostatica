import 'package:flutter/material.dart';
import '../../../../core/enums/unit_system.dart';
import '../../../../core/constants/unit_systems.dart';

class HistoryCard extends StatelessWidget {
  final Map item;
  final VoidCallback onDelete;

  const HistoryCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final unit = UnitSystem.values.firstWhere((e) => e.name == item['unit']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Cálculo", style: TextStyle(color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),

          /// BODY
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                /// RHO + H
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ρ: ${item['rho']} ${UnitConstants.density(unit)}"),
                    Text("h: ${item['h']} ${UnitConstants.depth(unit)}"),
                  ],
                ),

                const SizedBox(height: 6),

                /// RESULTADO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Resultado"),
                    Text(
                      "${item['result'].toStringAsFixed(2)} ${UnitConstants.pressure(unit)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// ECUACIÓN DINÁMICA
                Text(
                  UnitConstants.equation(unit)
                      .replaceAll("ρ", item['rho'].toString())
                      .replaceAll("h", item['h'].toString()),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
