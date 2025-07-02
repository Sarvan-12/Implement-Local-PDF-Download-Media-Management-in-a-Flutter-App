import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../models/download_manager.dart';
import '../models/pdf_file_model.dart';

class DownloadedReportsScreen extends StatefulWidget {
  const DownloadedReportsScreen({super.key});

  @override
  State<DownloadedReportsScreen> createState() => _DownloadedReportsScreenState();
}

class _DownloadedReportsScreenState extends State<DownloadedReportsScreen> {
  List<PdfFileModel> get pdfFiles => List<PdfFileModel>.from(DownloadManager.downloadedPdfs);
  List<PdfFileModel> selectedFiles = [];

  Future<void> _openAssetPdf(PdfFileModel pdf) async {
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

  void _onLongPress(PdfFileModel pdf) {
    setState(() {
      if (selectedFiles.contains(pdf)) {
        selectedFiles.remove(pdf);
      } else {
        selectedFiles.add(pdf);
      }
    });
  }

  void _onDeleteSelected() {
    setState(() {
      DownloadManager.downloadedPdfs.removeWhere((pdf) => selectedFiles.contains(pdf));
      selectedFiles.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected files deleted!')),
    );
  }

  bool isSelected(PdfFileModel pdf) => selectedFiles.contains(pdf);

  @override
  Widget build(BuildContext context) {
    final files = pdfFiles;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloaded PDFs"),
        actions: selectedFiles.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _onDeleteSelected,
                  tooltip: 'Delete selected',
                )
              ]
            : [],
      ),
      body: files.isEmpty
          ? const Center(
              child: Text(
                'No downloaded PDFs',
                style: TextStyle(fontSize: 18, color: Colors.amber),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (_, index) {
                final pdf = files[index];
                final selected = isSelected(pdf);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.amber.withOpacity(0.08) : Colors.white10,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected ? Colors.amber : Colors.amber.withOpacity(0.4),
                      width: selected ? 3 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.picture_as_pdf, color: Colors.amber.shade400, size: 36),
                    title: Text(
                      pdf.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selected ? Colors.amber : Colors.amber.shade200,
                      ),
                    ),
                    selected: selected,
                    onTap: () {
                      if (selectedFiles.isNotEmpty) {
                        _onLongPress(pdf);
                      } else {
                        _openAssetPdf(pdf);
                      }
                    },
                    onLongPress: () => _onLongPress(pdf),
                    trailing: selected
                        ? const Icon(Icons.check_circle, color: Colors.amber, size: 28)
                        : IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                DownloadManager.downloadedPdfs.remove(pdf);
                              });
                            },
                            tooltip: 'Delete',
                          ),
                  ),
                );
              },
            ),
    );
  }
}