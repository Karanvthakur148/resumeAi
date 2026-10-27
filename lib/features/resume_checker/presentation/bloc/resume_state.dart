import 'package:equatable/equatable.dart';
import '../../domain/entities/resume_analysis.dart';

enum ResumeStatus { initial, extracting, ready, analyzing, success, failure }

class ResumeState extends Equatable {
  final ResumeStatus status;
  final String? fileName;
  final String? resumeText;
  final ResumeAnalysis? analysis;
  final String? errorMessage;

  const ResumeState({
    this.status = ResumeStatus.initial,
    this.fileName,
    this.resumeText,
    this.analysis,
    this.errorMessage,
  });

  bool get canAnalyze =>
      resumeText != null &&
      status != ResumeStatus.analyzing &&
      status != ResumeStatus.extracting;

  /// errorMessage carry nahi hota (har emit pe reset), baaki fields carry hote hain.
  ResumeState copyWith({
    ResumeStatus? status,
    String? fileName,
    String? resumeText,
    ResumeAnalysis? analysis,
    String? errorMessage,
  }) {
    return ResumeState(
      status: status ?? this.status,
      fileName: fileName ?? this.fileName,
      resumeText: resumeText ?? this.resumeText,
      analysis: analysis ?? this.analysis,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, fileName, resumeText, analysis, errorMessage];
}
