import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../../core/error/exceptions.dart';

abstract class ResumeLocalDataSource {
  Future<String> extractTextFromPdf(String path);
}

class ResumeLocalDataSourceImpl implements ResumeLocalDataSource {
  @override
  Future<String> extractTextFromPdf(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final text = PdfTextExtractor(document).extractText();
      document.dispose();

      if (text.trim().isEmpty) {
        throw const FileException(
            'No text found in the PDF. It may be a scanned or image-based PDF.');
      }
      return text;
    } on FileException {
      rethrow;
    } catch (_) {
      throw const FileException('Unable to read the PDF file. Please try another file.');
    }
  }
}
