import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final double result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Resultado"),
            SizedBox(height: 10),
            Text(
              result.toStringAsFixed(2),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text("Pa"),
          ],
        ),
      ),
    );
  }
}