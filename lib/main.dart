import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/resume_checker/presentation/bloc/resume_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider MaterialApp ke upar hai taaki splash ke baad bhi bloc mile
    return BlocProvider(
      create: (_) => di.sl<ResumeBloc>(),
      child: MaterialApp(
        title: 'ResumeAI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
        ),
        home: const SplashPage(),
      ),
    );
  }
}