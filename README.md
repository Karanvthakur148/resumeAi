# 📄 AI Resume Checker

An AI-powered Flutter app that analyzes your resume in seconds. Upload a PDF, optionally paste a job description, and get an instant score, ATS compatibility check, and actionable suggestions to improve it.

Built with **BLoC** and **Clean Architecture**, powered by **Google Gemini** (via Google AI Studio).

---

## ✨ Features

- 📤 Upload your resume as a PDF
- 🎯 Optional job description input for role-specific analysis
- 📊 Overall resume score (0–100)
- 🤖 ATS (Applicant Tracking System) compatibility score
- 💪 Key strengths and ⚠️ weaknesses
- 🔑 Missing keywords for the target role
- 💡 Specific, actionable improvement suggestions
- 🎬 Animated splash screen (scanning-resume effect)
- 🧱 Clean, testable, easily extensible architecture

---

## 📸 Screenshots

| Splash | Upload | Result |
|:---:|:---:|:---:|
| ![Splash](screenshots/splash.png) | ![Upload](screenshots/upload.png) | ![Result](screenshots/result.png) |

> Add your screenshots to a `screenshots/` folder and update the file names above.

---

## 🏗 Architecture

The project follows **Clean Architecture** with three layers per feature. Dependencies only point inward: `presentation → domain ← data`.

```
lib/
├── core/
│   ├── constants/        # App-wide constants (API config)
│   ├── error/            # Failures & exceptions
│   └── usecases/         # Base UseCase contract
│
├── features/
│   ├── splash/
│   │   └── presentation/pages/       # Animated splash screen
│   │
│   └── resume_checker/
│       ├── data/
│       │   ├── datasources/          # PDF text extraction + AI API call
│       │   ├── models/               # JSON parsing (extends entities)
│       │   └── repositories/         # Repository implementation
│       ├── domain/
│       │   ├── entities/             # Pure business objects
│       │   ├── repositories/         # Repository contracts
│       │   └── usecases/             # ExtractResumeText, AnalyzeResume
│       └── presentation/
│           ├── bloc/                 # Events, states, BLoC
│           ├── pages/                # Resume checker screen
│           └── widgets/              # Score circle, bullet sections
│
├── injection_container.dart          # Dependency injection (get_it)
└── main.dart
```

**Why this structure?**
The AI provider lives entirely in the data layer. Switching from one provider to another (this project moved to Gemini for its free tier) only required changing the remote data source. The UI, BLoC, and business logic stayed untouched.

### App flow

```
User picks PDF
   → ResumeFileSelected event
   → ExtractResumeText use case → text extracted on-device
   → User taps "Check Resume"
   → AnalyzeRequested event
   → AnalyzeResume use case → Gemini API
   → ResumeState.success → results UI
```

---

## 🧰 Tech Stack

| Purpose | Package |
|---|---|
| State management | `flutter_bloc`, `equatable` |
| Dependency injection | `get_it` |
| Functional error handling | `dartz` (`Either<Failure, T>`) |
| HTTP | `http` |
| PDF text extraction | `syncfusion_flutter_pdf` |
| File picking | `file_picker` |
| AI | Google Gemini API (Google AI Studio) |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- A free Gemini API key from [Google AI Studio](https://aistudio.google.com/app/apikey)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/<your-repo>.git
   cd <your-repo>
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your API key**

   Open `lib/core/constants/app_constants.dart` and set your key, or pass it at run time (recommended):
   ```bash
   flutter run --dart-define=API_KEY=your_api_key_here
   ```

4. **Android only:** make sure the internet permission exists in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

5. **Run**
   ```bash
   flutter run
   ```

---

## 🔐 API Key Safety

- **Never commit your API key** to a public repository.
- Prefer `--dart-define` over hardcoding the key.
- If a key is ever pushed by accident, delete it in Google AI Studio and create a new one.
- For production apps, call the AI API through your own backend so the key never ships inside the app.

---

## ⚠️ Known Limitations

- Scanned or image-based PDFs have no extractable text, so OCR support is needed.
- Flutter Web is not supported for direct API calls because of CORS. Use Android, iOS, or desktop.
- AI scores are guidance, not a guarantee of ATS results.

---

## 🗺 Roadmap

- [ ] Save analysis history (Hive / Isar)
- [ ] DOCX resume support
- [ ] OCR for scanned PDFs
- [ ] Compare multiple resume versions
- [ ] Export the report as PDF
- [ ] Unit tests for use cases and BLoC

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome. Feel free to open an issue or submit a pull request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m "Add amazing feature"`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 👤 Author

**Karan Thakur**
⭐ If you found this project useful, consider giving it a star!