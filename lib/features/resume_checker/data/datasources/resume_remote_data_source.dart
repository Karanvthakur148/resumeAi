
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/resume_analysis_model.dart';

abstract class ResumeRemoteDataSource {
  Future<ResumeAnalysisModel> analyze({
    required String resumeText,
    String? jobDescription,
  });
}

class ResumeRemoteDataSourceImpl implements ResumeRemoteDataSource {
  final http.Client client;

  ResumeRemoteDataSourceImpl(this.client);

  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent';

  static const String _system = '''
You are an expert resume reviewer and ATS specialist.

Analyze the resume and return ONLY a valid JSON object
with exactly this structure:

{
  "overall_score": 0,
  "ats_score": 0,
  "summary": "2-3 sentence overall assessment",
  "strengths": ["..."],
  "weaknesses": ["..."],
  "missing_keywords": ["..."],
  "suggestions": ["specific, actionable improvements"]
}

Rules:
- overall_score and ats_score must be integers from 0 to 100.
- strengths, weaknesses, missing_keywords and suggestions must be arrays of strings.
- If a job description is provided, evaluate the resume against it.
- Base missing_keywords on the job description when available.
- Be honest, specific and concise.
- Do not invent qualifications or experience.
- Return JSON only, without Markdown fences.
''';

  @override
  Future<ResumeAnalysisModel> analyze({
    required String resumeText,
    String? jobDescription,
  }) async {
    final apiKey = AppConstants.apiKey.trim();

    if (apiKey.isEmpty) {
      throw const ServerException(
        'Gemini API key is not configured. Please configure GEMINI_API_KEY.',
      );
    }

    final resume = resumeText.length > AppConstants.maxResumeChars
        ? resumeText.substring(0, AppConstants.maxResumeChars)
        : resumeText;

    final hasJd = jobDescription != null &&
        jobDescription.trim().isNotEmpty;

    final userPrompt = StringBuffer()
      ..writeln('RESUME:')
      ..writeln(resume);

    if (hasJd) {
      userPrompt
        ..writeln()
        ..writeln('JOB DESCRIPTION:')
        ..writeln(jobDescription.trim());
    }

    late http.Response response;

    try {
      response = await client
          .post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode({
          'systemInstruction': {
            'parts': [
              {'text': _system}
            ]
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': userPrompt.toString()}
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'temperature': 0.2,
            'maxOutputTokens': 2000,
          },
        }),
      )
          .timeout(const Duration(seconds: 90));
    } catch (_) {
      throw const ServerException(
        'Unable to connect to the Gemini API. Please check your internet connection and try again.',
      );
    }

    if (response.statusCode == 400) {
      throw const ServerException(
        'Invalid request. Please check the resume text and API request, then try again.',
      );
    }

    if (response.statusCode == 401 ||
        response.statusCode == 403) {
      throw const ServerException(
        'The API key is invalid, or API access is unavailable.',
      );
    }

    if (response.statusCode == 429) {
      throw const ServerException(
        'The API usage limit has been reached. Please try again later.',
      );
    }

    if (response.statusCode != 200) {
      throw ServerException(
        'Gemini server error (${response.statusCode}). Please try again later.',
      );
    }

    try {
      final body = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      final candidates = body['candidates'] as List?;

      if (candidates == null || candidates.isEmpty) {
        throw const FormatException('No candidates returned');
      }

      final candidate = candidates.first as Map<String, dynamic>;
      final content = candidate['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;

      if (parts == null || parts.isEmpty) {
        throw const FormatException('No text returned');
      }

      final text = parts
          .whereType<Map<String, dynamic>>()
          .map((part) => part['text'])
          .whereType<String>()
          .join()
          .trim();

      if (text.isEmpty) {
        throw const FormatException('Empty response');
      }

      final cleaned = text
          .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
          .replaceFirst(RegExp(r'\s*```$'), '')
          .trim();

      final analysisJson =
      jsonDecode(cleaned) as Map<String, dynamic>;

      return ResumeAnalysisModel.fromJson(analysisJson);
    } catch (_) {
      throw const ServerException(
        'Unable to process the AI response. Please try again.',
      );
    }
  }
}
