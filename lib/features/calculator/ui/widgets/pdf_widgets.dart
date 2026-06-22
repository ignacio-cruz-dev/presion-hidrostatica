import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/constants/unit_systems.dart';
import '../../../../core/enums/unit_system.dart';

//header
pw.Widget buildPdfHeader(pw.MemoryImage image) {
  return pw.Container(
    width: double.infinity,

    padding: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 28),


    decoration: const pw.BoxDecoration(
      color: PdfColor.fromInt(0xFF001B70),
    ),

    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,

      children: [
        /// LOGO
        pw.Container(
          width: 120,
          height: 120,

          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(12),
          ),

          child: pw.Image(image),
        ),

        pw.SizedBox(width: 26),

        /// TEXTOS
        /// TEXTOS
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            mainAxisSize: pw.MainAxisSize.min,

            children: [
              pw.Text(
                'Reporte HydroPressure Lab',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 6),

              pw.Text(
                'Calculadora de Presión Hidrostática · BHP',
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 13),
              ),

              pw.SizedBox(height: 10),

              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(20),
                ),

                child: pw.Text(
                  'Grupo TANIS · www.ttanis.com · tanis.dvc@ttanis.com',

                  style: pw.TextStyle(
                    fontSize: 9,
                    color: PdfColor.fromInt(0xFF001B70),
                    fontWeight: pw.FontWeight.bold,
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

// result card
pw.Widget buildMainResultCard({
  required double result,
  required UnitSystem unit,
}) {
  return pw.Container(
    width: 240,

    padding: const pw.EdgeInsets.all(24),

    decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF001B70)),

    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,

      children: [
        pw.Text(
          'RESULTADO BHP',
          style: pw.TextStyle(color: PdfColors.white, fontSize: 13),
        ),

        pw.SizedBox(height: 14),

        pw.Text(
          '${result.toStringAsFixed(2)} ${UnitConstants.pressure(unit)}',

          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 26,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

//tabla tecnica
pw.Widget buildTechnicalTable({
  required double rho,
  required double h,
  required double result,
  required UnitSystem unit,
}) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.6),

    children: [
      /// HEADER
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF001B70)),

        children: [_tableHeader("Campo"), _tableHeader("Valor")],
      ),

      _tableRow('Densidad', '$rho ${UnitConstants.density(unit)}'),

      _tableRow('TVD', '$h ${UnitConstants.depth(unit)}'),

      _tableRow(
        'Resultado',
        '${result.toStringAsFixed(2)} ${UnitConstants.pressure(unit)}',
      ),

      _tableRow('Sistema', unit.name.toUpperCase()),
    ],
  );
}

pw.Widget _tableHeader(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(10),

    child: pw.Text(
      text,

      style: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
      ),
    ),
  );
}

pw.TableRow _tableRow(String label, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(10),

        child: pw.Text(
          label,

          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
      ),

      pw.Padding(
        padding: const pw.EdgeInsets.all(10),

        child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
      ),
    ],
  );
}

//row helper
pw.TableRow pdfRow(String label, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(10),

        child: pw.Text(
          label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),

      pw.Padding(padding: const pw.EdgeInsets.all(10), child: pw.Text(value)),
    ],
  );
}

// ================= HISTORIAL PDF =================
pw.Widget buildHistorySection(List calculations) {
  /// LISTA SEGURA
  final safeCalculations = calculations.where((item) {
    return item != null &&
        item is Map &&
        item['rho'] != null &&
        item['h'] != null &&
        item['result'] != null;
  }).toList();

  /// SIN DATOS
  if (safeCalculations.isEmpty) {
    return pw.Text(
      'No hay historial disponible.',
      style: const pw.TextStyle(fontSize: 11),
    );
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,

    children: [
      /// TITULO
      pw.Text(
        'Historial reciente',

        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),

      pw.SizedBox(height: 16),

      /// ITEMS
      ...safeCalculations.take(3).map((item) {
        /// UNIT SAFE
        final unitName = item['unit']?.toString() ?? 'si';

        UnitSystem unit = UnitSystem.si;

        try {
          unit = UnitSystem.values.firstWhere((e) => e.name == unitName);
        } catch (_) {
          unit = UnitSystem.si;
        }

        /// UNIDADES
        final densityUnit = UnitConstants.density(unit);

        final depthUnit = UnitConstants.depth(unit);

        final pressureUnit = UnitConstants.pressure(unit);

        /// VALORES
        final rho = (item['rho'] as num).toDouble();

        final h = (item['h'] as num).toDouble();

        final result = (item['result'] as num).toDouble();

        return pw.Container(
          width: double.infinity,

          margin: const pw.EdgeInsets.only(bottom: 8),

          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),

          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,

            borderRadius: pw.BorderRadius.circular(6),

            border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
          ),

          child: pw.Wrap(
            spacing: 20,
            runSpacing: 5,
            alignment: pw.WrapAlignment.spaceBetween,

            children: [
              pw.Text(
                'Densidad: ${rho.toStringAsFixed(2)} $densityUnit',

                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.Text(
                'Profundidad: ${h.toStringAsFixed(2)} $depthUnit',

                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.Text(
                'Presión: ${result.toStringAsFixed(2)} $pressureUnit',

                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF001B70),
                ),
              ),
            ],
          ),
        );
      }),
    ],
  );
}

//footer
pw.Widget buildPdfFooter() {
  return pw.Column(
    children: [
      /// LINEA
      pw.Container(height: 1, color: PdfColors.grey300),

      pw.SizedBox(height: 24),

      /// CARD FOOTER
      pw.Container(
        width: double.infinity,

        padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 18),

        decoration: pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFF5F7FA),

          borderRadius: pw.BorderRadius.circular(12),

          border: pw.Border.all(color: PdfColors.grey300, width: 0.6),
        ),

        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,

          children: [
            /// EMPRESA
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                pw.Text(
                  'Grupo TANIS',

                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                    color: PdfColor.fromInt(0xFF001B70),
                  ),
                ),

                pw.SizedBox(height: 6),

                pw.Text(
                  'Altas Soluciones para la Industria',

                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),

            /// CONTACTO
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                pw.Text(
                  'Contacto',

                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),

                pw.SizedBox(height: 6),

                pw.Text(
                  'Correo: tanis.dvc@ttanis.com',

                  style: const pw.TextStyle(fontSize: 9),
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  'Web: www.ttanis.com',

                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ),

            /// APP
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                pw.Text(
                  'Redes Sociales',

                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),

                pw.SizedBox(height: 6),

                pw.Text(
                  'www.facebook.com/grupottanis',

                  style: const pw.TextStyle(fontSize: 9),
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  'www.linkedin.com/company/grupo-ttanis',

                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),

      pw.SizedBox(height: 24),

      /// TEXTO FINAL
      pw.Center(
        child: pw.Text(
          'Documento generado automáticamente por HydroPressure Lab by Grupo TANIS',

          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
      ),
    ],
  );
}
