import 'package:flutter/material.dart';
import '../models/pdf_file_model.dart';

class PdfListItem extends StatelessWidget {
  final PdfFileModel pdf;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PdfListItem({
    super.key,
    required this.pdf,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.picture_as_pdf, color: Colors.red),
      title: Text(pdf.name),
      tileColor: selected ? Colors.grey[300] : null,
      onTap: onTap,
      onLongPress: onLongPress,
      trailing: selected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
    );
  }
}