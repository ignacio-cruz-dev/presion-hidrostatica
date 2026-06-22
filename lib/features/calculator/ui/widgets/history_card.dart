import 'package:flutter/material.dart';
import '../../../../core/enums/unit_system.dart';
import '../../../../core/constants/unit_systems.dart';

class HistoryCard extends StatelessWidget {
  final Map item;
  final VoidCallback onDelete;
  final int index;
  final bool isLatest;

  const HistoryCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.index,
    required this.isLatest,
  });

  @override
  Widget build(BuildContext context) {
    final unit = UnitSystem.values.firstWhere((e) => e.name == item['unit']);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),

        border: isLatest ? Border.all(color: Colors.amber, width: 1.5) : null,
      ),
      child: Column(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// IZQUIERDA
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Cálculo #$index",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        if (isLatest) ...[
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: const Text(
                              "NUEVO",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 2),

                    Text(
                      item['date'] ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                /// DELETE
                Row(
                  children: [
                    /// RESULTADO
                    Text(
                      "${item['result'].toStringAsFixed(2)} "
                      "${UnitConstants.pressure(unit)}",

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// DELETE
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// BODY
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                /// RHO + H
                Text(
                  "ρ: ${item['rho']} ${UnitConstants.density(unit)}"
                  "   •   "
                  "h: ${item['h']} ${UnitConstants.depth(unit)}",

                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 2),

                /// ECUACIÓN DINÁMICA
                Center(
                  child: Text(
                    UnitConstants.equation(unit)
                        .replaceAll("ρ", item['rho'].toString())
                        .replaceAll("h", item['h'].toString()),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
