import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/resume_analysis.dart';

abstract class ResumeRepository {
  Future<Either<Failure, String>> extractText(String filePath);

  Future<Either<Failure, ResumeAnalysis>> analyze({
    required String resumeText,
    String? jobDescription,
  });
}
