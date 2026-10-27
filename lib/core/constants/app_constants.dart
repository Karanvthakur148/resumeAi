// class AppConstants {
//   static const apiUrl = 'https://api.anthropic.com/v1/messages';
//   static const apiVersion = '2023-06-01';
//   static const model = 'claude-sonnet-5-5';
//   // Yahan apni key paste karo (sirf testing ke liye). Ya --dart-define=ANTHROPIC_API_KEY=... use karo.
//   static const apiKey = String.fromEnvironment(
//     'ANTHROPIC_API_KEY',
//     defaultValue: '--dart-define=ANTHROPIC_API_KEY=...',
//   );
//   static const maxResumeChars = 15000;
// }


class AppConstants {
  static const String apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
  );

  static const int maxResumeChars = 15000;
}

