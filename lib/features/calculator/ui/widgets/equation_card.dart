import 'package:flutter/material.dart';

class EquationCard extends StatelessWidget {
  final String equation;

  const EquationCard({super.key, required this.equation});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          equation,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}