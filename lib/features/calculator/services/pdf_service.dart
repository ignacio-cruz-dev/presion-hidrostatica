import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/enums/unit_system.dart';
import '../ui/widgets/pdf_widgets.dart';

class PdfService {
  static Future<void> generatePdf(List calculations) async {
    final regularFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"),
    );

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );

    /// LOGO
    final logo = await rootBundle.load('assets/grupo-tanis-logo-pdf.png');

    final image = pw.MemoryImage(logo.buffer.asUint8List());

    /// ÚLTIMO CÁLCULOq
    if (calculations.isEmpty) {
      return;
    }
    final latest = calculations.first;

    final unit = UnitSystem.values.firstWhere((e) => e.name == latest['unit']);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,

        margin: const pw.EdgeInsets.all(0),

        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              buildPdfHeader(image),

              pw.Padding(
                padding: const pw.EdgeInsets.all(32),

                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,

                  children: [
                    buildMainResultCard(result: latest['result'], unit: unit),

                    pw.SizedBox(height: 18),

                    buildTechnicalTable(
                      rho: latest['rho'],
                      h: latest['h'],
                      result: latest['result'],
                      unit: unit,
                    ),

                    pw.SizedBox(height: 22),

                    buildHistorySection(calculations),

                    pw.SizedBox(height: 26),

                    buildPdfFooter(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
