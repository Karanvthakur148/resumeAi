import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/analyze_resume.dart';
import '../../domain/usecases/extract_resume_text.dart';
import 'resume_event.dart';
import 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final ExtractResumeText extractResumeText;
  final AnalyzeResume analyzeResume;

  ResumeBloc({
    required this.extractResumeText,
    required this.analyzeResume,
  }) : super(const ResumeState()) {
    on<ResumeFileSelected>(_onFileSelected);
    on<AnalyzeRequested>(_onAnalyze);
    on<ResumeReset>((_, emit) => emit(const ResumeState()));
  }

  Future<void> _onFileSelected(
      ResumeFileSelected event, Emitter<ResumeState> emit) async {
    // naya file -> purana result clear
    emit(ResumeState(status: ResumeStatus.extracting, fileName: event.fileName));

    final result = await extractResumeText(event.path);
    result.fold(
      (failure) => emit(ResumeState(
        status: ResumeStatus.failure,
        fileName: event.fileName,
        errorMessage: failure.message,
      )),
      (text) => emit(ResumeState(
        status: ResumeStatus.ready,
        fileName: event.fileName,
        resumeText: text,
      )),
    );
  }

  Future<void> _onAnalyze(
      AnalyzeRequested event, Emitter<ResumeState> emit) async {
    final text = state.resumeText;
    if (text == null) return;

    emit(state.copyWith(status: ResumeStatus.analyzing));

    final result = await analyzeResume(
      AnalyzeParams(resumeText: text, jobDescription: event.jobDescription),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ResumeStatus.failure,
        errorMessage: failure.message,
      )),
      (analysis) =>
          emit(state.copyWith(status: ResumeStatus.success, analysis: analysis)),
    );
  }
}
