import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';

class DownloadPdfWebScreen extends StatefulWidget {
  const DownloadPdfWebScreen({super.key});

  @override
  State<DownloadPdfWebScreen> createState() => _DownloadPdfWebScreenState();
}

class _DownloadPdfWebScreenState extends State<DownloadPdfWebScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _downloading = false;
  String? _message;

  Future<void> _download() async {
    setState(() {
      _downloading = true;
      _message = null;
    });
    try {
      final url = _urlController.text.trim();
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final name = url.split('/').last;
      await FileSaver.instance.saveFile(
        name: name,
        bytes: Uint8List.fromList(response.data!),
        ext: "pdf",
        mimeType: MimeType.pdf,
      );
      setState(() {
        _message = 'Download started! Check your Downloads folder.';
      });
    } catch (e) {
      setState(() {
        _message = 'Download failed: $e';
      });
    } finally {
      setState(() {
        _downloading = false;
      });
    }
  }

  Future<void> _openInNewTab() async {
    final url = _urlController.text.trim();
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      setState(() {
        _message = 'Could not open URL';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download PDF (Web)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'PDF URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _downloading ? null : _download,
                  child: _downloading
                      ? const CircularProgressIndicator()
                      : const Text('Download'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _openInNewTab,
                  child: const Text('Open in New Tab'),
                ),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(_message!),
            ],
          ],
        ),
      ),
    );
  }
}