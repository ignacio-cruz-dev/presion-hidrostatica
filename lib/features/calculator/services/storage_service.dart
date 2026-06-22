import 'package:hive/hive.dart';
import '../../../core/enums/unit_system.dart';
import 'package:intl/intl.dart';

class StorageService {
  static final box = Hive.box('calculations');

  static void saveCalculation({
    required double rho,
    required double h,
    required double result,
    required UnitSystem unit,
  }) {
    box.add({
      'rho': rho,
      'h': h,
      'result': result,
      'unit': unit.name,
      'date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
    });
  }

  static List<Map> getCalculations() {
    return box.keys
        .map((key) {
          final item = Map<String, dynamic>.from(box.get(key));
          item['key'] = key;
          return item;
        })
        .toList()
        .reversed
        .toList();
  }

  static void delete(dynamic key) {
    box.delete(key);
  }

  static void clear() {
    box.clear();
  }
}
