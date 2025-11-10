import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

import '../../../base/amikom_color.dart';

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

      if (mounted) {
        setState(() {
          _pageImage = img;
          _loading = false;
        });
      }
    } catch (e) {
      print("Gagal render thumbnail PDF: $e");
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _loading
          ? ClipRRect(
              key: const ValueKey('loading'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 100,
                width: double.infinity,
                color: magnoliaWhiteNewAmikom,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/pdf.svg",
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            )
          : _pageImage != null
          ? ClipRRect(
              key: const ValueKey('preview'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Image.memory(
                  _pageImage!.bytes,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : ClipRRect(
              key: const ValueKey('fallback'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/pdf.svg",
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
    );
  }
}
