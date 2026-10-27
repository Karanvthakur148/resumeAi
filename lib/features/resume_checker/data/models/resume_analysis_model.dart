import '../../domain/entities/resume_analysis.dart';

class ResumeAnalysisModel extends ResumeAnalysis {
  const ResumeAnalysisModel({
    required super.overallScore,
    required super.atsScore,
    required super.summary,
    required super.strengths,
    required super.weaknesses,
    required super.missingKeywords,
    required super.suggestions,
  });

  factory ResumeAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ResumeAnalysisModel(
      overallScore: _score(json['overall_score']),
      atsScore: _score(json['ats_score']),
      summary: (json['summary'] ?? '').toString(),
      strengths: _list(json['strengths']),
      weaknesses: _list(json['weaknesses']),
      missingKeywords: _list(json['missing_keywords']),
      suggestions: _list(json['suggestions']),
    );
  }

  static int _score(dynamic v) =>
      ((v as num?)?.round() ?? 0).clamp(0, 100).toInt();

  static List<String> _list(dynamic v) =>
      ((v as List?) ?? const []).map((e) => e.toString()).toList();
}
