import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'features/resume_checker/data/datasources/resume_local_data_source.dart';
import 'features/resume_checker/data/datasources/resume_remote_data_source.dart';
import 'features/resume_checker/data/repositories/resume_repository_impl.dart';
import 'features/resume_checker/domain/repositories/resume_repository.dart';
import 'features/resume_checker/domain/usecases/analyze_resume.dart';
import 'features/resume_checker/domain/usecases/extract_resume_text.dart';
import 'features/resume_checker/presentation/bloc/resume_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => ResumeBloc(
        extractResumeText: sl(),
        analyzeResume: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => ExtractResumeText(sl()));
  sl.registerLazySingleton(() => AnalyzeResume(sl()));

  // Repository
  sl.registerLazySingleton<ResumeRepository>(
      () => ResumeRepositoryImpl(local: sl(), remote: sl()));

  // Data sources
  sl.registerLazySingleton<ResumeLocalDataSource>(
      () => ResumeLocalDataSourceImpl());
  sl.registerLazySingleton<ResumeRemoteDataSource>(
      () => ResumeRemoteDataSourceImpl(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
