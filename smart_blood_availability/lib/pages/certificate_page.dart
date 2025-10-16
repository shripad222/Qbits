import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';

class CertificatePage extends StatefulWidget {
  final String donorName;
  const CertificatePage({super.key, required this.donorName});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  final pdf = pw.Document();

  Future<Uint8List> _generateCertificatePdf() async {
    final pdf = pw.Document(); // create a new document each time
    final logo = (await rootBundle.load('assets/logo.png')).buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.red, width: 3),
            ),
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(pw.MemoryImage(logo), width: 80),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Certificate of Appreciation",
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red900,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "This certificate is proudly presented to",
                  style: const pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  widget.donorName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "for their invaluable contribution and life-saving blood donations.",
                  style: const pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 40),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(width: 100, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 4),
                        pw.Text("Authorized Signature",
                            style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                    pw.Text(
                      "Date: ${DateTime.now().toString().split(" ").first}",
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
  Future<void> _saveToDownloads() async {
    try {
      // 1️⃣ Request storage permission (Android 11+)
      if (Platform.isAndroid) {
        final status = await Permission.manageExternalStorage.request();
        print("Storage permission status: $status"); // 🔹 Debug
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
          return;
        }
      }

      // 2️⃣ Generate PDF
      final bytes = await _generateCertificatePdf();
      print("PDF generated, size: ${bytes.length} bytes"); // 🔹 Debug

      // 3️⃣ Target Downloads folder
      final directory = Directory('/storage/emulated/0/Download'); // Global Downloads
      print("Downloads directory: ${directory.path}"); // 🔹 Debug

      if (!await directory.exists()) {
        await directory.create(recursive: true);
        print("Created Downloads folder"); // 🔹 Debug
      }

      // 4️⃣ Save PDF file
      final file = File("${directory.path}/certificate_${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(bytes);
      print("PDF saved at: ${file.path}"); // 🔹 Debug

      // 5️⃣ Notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to Downloads: ${file.path}')),
      );
    } catch (e, stacktrace) {
      print("Error saving PDF: $e");
      print("Stacktrace: $stacktrace"); // 🔹 Debug full stack
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Certificate"),
        backgroundColor: Colors.red.shade400,
      ),
      body: FutureBuilder<Uint8List>(
        future: _generateCertificatePdf(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: PdfPreview(
                  build: (format) async => snapshot.data!,
                  allowPrinting: false,
                  allowSharing: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _saveToDownloads,
                  icon: const Icon(Icons.download),
                  label: const Text("Download Certificate"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
