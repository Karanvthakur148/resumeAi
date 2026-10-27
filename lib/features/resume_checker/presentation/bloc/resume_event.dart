import 'package:equatable/equatable.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();
  @override
  List<Object?> get props => [];
}

class ResumeFileSelected extends ResumeEvent {
  final String path;
  final String fileName;
  const ResumeFileSelected({required this.path, required this.fileName});

  @override
  List<Object?> get props => [path, fileName];
}

class AnalyzeRequested extends ResumeEvent {
  final String? jobDescription;
  const AnalyzeRequested({this.jobDescription});

  @override
  List<Object?> get props => [jobDescription];
}

class ResumeReset extends ResumeEvent {
  const ResumeReset();
}
