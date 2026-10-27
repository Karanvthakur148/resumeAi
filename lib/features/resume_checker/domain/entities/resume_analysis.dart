import 'package:equatable/equatable.dart';

class ResumeAnalysis extends Equatable {
  final int overallScore;
  final int atsScore;
  final String summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> missingKeywords;
  final List<String> suggestions;

  const ResumeAnalysis({
    required this.overallScore,
    required this.atsScore,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.missingKeywords,
    required this.suggestions,
  });

  @override
  List<Object?> get props => [
        overallScore,
        atsScore,
        summary,
        strengths,
        weaknesses,
        missingKeywords,
        suggestions,
      ];
}
