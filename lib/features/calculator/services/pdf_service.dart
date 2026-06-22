import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generatePdf(List calculations) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// TITLE
              pw.Text(
                "Reporte de Presión Hidrostática",
                style: pw.TextStyle(fontSize: 20),
              ),

              pw.Text("Fecha: ${DateTime.now()}"),

              pw.SizedBox(height: 20),

              /// HISTORIAL
              ...calculations.map(
                (item) => pw.Container(
                  margin: pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("ρ: ${item['rho']} kg/m³"),
                      pw.Text("h: ${item['h']} m"),
                      pw.Text(
                        "Resultado: ${item['result'].toStringAsFixed(2)} Pa",
                      ),
                      pw.Text("P = ${item['rho']} × 9.81 × ${item['h']}"),
                      pw.Divider(),
                    ],
                  ),
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
