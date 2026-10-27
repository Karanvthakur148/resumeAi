import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/resume_analysis.dart';
import '../repositories/resume_repository.dart';

class AnalyzeResume extends UseCase<ResumeAnalysis, AnalyzeParams> {
  final ResumeRepository repository;
  AnalyzeResume(this.repository);

  @override
  Future<Either<Failure, ResumeAnalysis>> call(AnalyzeParams params) =>
      repository.analyze(
        resumeText: params.resumeText,
        jobDescription: params.jobDescription,
      );
}

class AnalyzeParams extends Equatable {
  final String resumeText;
  final String? jobDescription;
  const AnalyzeParams({required this.resumeText, this.jobDescription});

  @override
  List<Object?> get props => [resumeText, jobDescription];
}
