import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/resume_repository.dart';

class ExtractResumeText extends UseCase<String, String> {
  final ResumeRepository repository;
  ExtractResumeText(this.repository);

  @override
  Future<Either<Failure, String>> call(String filePath) =>
      repository.extractText(filePath);
}
