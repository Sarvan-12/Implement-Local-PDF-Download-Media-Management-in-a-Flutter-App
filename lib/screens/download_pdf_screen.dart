import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../models/pdf_file_model.dart';
import '../models/download_manager.dart';
import 'downloaded_reports_screen.dart';

class DownloadPdfScreen extends StatefulWidget {
  const DownloadPdfScreen({super.key});

  @override
  State<DownloadPdfScreen> createState() => _DownloadPdfScreenState();
}

class _DownloadPdfScreenState extends State<DownloadPdfScreen> {
  final List<PdfFileModel> allPdfs = [
    PdfFileModel(assetPath: 'assets/pdfs/Module_1.pdf', name: 'Module_1.pdf'),
    PdfFileModel(assetPath: 'assets/pdfs/Module_2.pdf', name: 'Module_2.pdf'),
    PdfFileModel(assetPath: 'assets/pdfs/Module_3.pdf', name: 'Module_3.pdf'),
    PdfFileModel(assetPath: 'assets/pdfs/Module_4.pdf', name: 'Module_4.pdf'),
    PdfFileModel(assetPath: 'assets/pdfs/Module_5.pdf', name: 'Module_5.pdf'),
  ];

  Future<void> _viewPdf(PdfFileModel pdf) async {
    try {
      final byteData = await rootBundle.load(pdf.assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${pdf.name}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open PDF: $e')),
      );
    }
  }

  void _downloadPdf(PdfFileModel pdf) {
    if (!DownloadManager.downloadedPdfs.any((d) => d.name == pdf.name)) {
      DownloadManager.downloadedPdfs.add(pdf);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text('${pdf.name} successfully downloaded!'),
            ],
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.orange),
              const SizedBox(width: 8),
              Text('${pdf.name} already downloaded!'),
            ],
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder, color: Colors.amber),
            tooltip: 'View Downloaded PDFs',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DownloadedReportsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.folder),
              label: const Text('View Downloaded PDFs'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DownloadedReportsScreen()),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: allPdfs.length,
              itemBuilder: (_, index) {
                final pdf = allPdfs[index];
                final isDownloaded = DownloadManager.downloadedPdfs.any((d) => d.name == pdf.name);
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.picture_as_pdf, color: Colors.red.shade400, size: 32),
                    title: Text(
                      pdf.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () => _viewPdf(pdf),
                    trailing: isDownloaded
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () => _downloadPdf(pdf),
                            tooltip: 'Download',
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}