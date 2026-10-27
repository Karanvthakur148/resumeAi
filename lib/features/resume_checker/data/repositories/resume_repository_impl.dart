import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/resume_analysis.dart';
import '../../domain/repositories/resume_repository.dart';
import '../datasources/resume_local_data_source.dart';
import '../datasources/resume_remote_data_source.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeLocalDataSource local;
  final ResumeRemoteDataSource remote;

  ResumeRepositoryImpl({
    required this.local,
    required this.remote,
  });

  @override
  Future<Either<Failure, String>> extractText(String filePath) async {
    try {
      return Right(await local.extractTextFromPdf(filePath));
    } on FileException catch (e) {
      return Left(FileFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ResumeAnalysis>> analyze({
    required String resumeText,
    String? jobDescription,
  }) async {
    try {
      final result = await remote.analyze(
        resumeText: resumeText,
        jobDescription: jobDescription,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        NetworkFailure(
          'Unable to connect to the internet. Please check your connection and try again.',
        ),
      );
    } on TimeoutException {
      return const Left(
        NetworkFailure(
          'The request timed out. Please try again.',
        ),
      );
    }
  }

}