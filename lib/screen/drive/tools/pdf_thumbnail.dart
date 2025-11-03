import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

class PdfThumbnail extends StatefulWidget {
  final String url;
  const PdfThumbnail({super.key, required this.url});

  @override
  State<PdfThumbnail> createState() => _PdfThumbnailState();
}

class _PdfThumbnailState extends State<PdfThumbnail> {
  PdfPageImage? _pageImage;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode != 200) return;

      final document = await PdfDocument.openData(response.bodyBytes);
      final page = await document.getPage(1);
      final img = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      await page.close();
      await document.close();

      if (mounted) setState(() {
        _pageImage = img;
        _loading = false;
      });
    } catch (e) {
      print("Gagal render thumbnail PDF: $e");
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (_pageImage != null) {
      return AspectRatio(
        aspectRatio: _pageImage!.width! / _pageImage!.height!,
        child: Image.memory(
          _pageImage!.bytes,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    return const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red);
  }
}
