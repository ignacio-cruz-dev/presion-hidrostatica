import 'package:hive/hive.dart';

class StorageService {
  static final box = Hive.box('calculations');

  static void saveCalculation({
    required double rho,
    required double h,
    required double result,
  }) {
    box.add({
      'rho': rho,
      'h': h,
      'result': result,
      'date': DateTime.now().toString(),
    });
  }

  static List getCalculations() {
    return box.values.toList().reversed.toList();
  }

  static void delete(int index) {
    box.deleteAt(index);
  }

  static void clear() {
    box.clear();
  }
}
