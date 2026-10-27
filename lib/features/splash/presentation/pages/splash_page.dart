import 'package:flutter/material.dart';
import '../../../resume_checker/presentation/pages/resume_checker_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _main;
  late final AnimationController _ripple;

  late final Animation<double> _logoScale;
  late final Animation<double> _scan;
  late final Animation<double> _check;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _main = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _ripple = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _logoScale = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.0, 0.30, curve: Curves.elasticOut),
    );
    _scan = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.25, 0.65, curve: Curves.easeInOut),
    );
    _check = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.65, 0.85, curve: Curves.elasticOut),
    );
    final titleCurve = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.60, 0.85, curve: Curves.easeOutCubic),
    );
    _titleFade = titleCurve;
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(titleCurve);
    _taglineFade = CurvedAnimation(
      parent: _main,
      curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
    );

    _main.forward().whenComplete(_goNext);
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondary) =>
            const ResumeCheckerPage(),
        transitionsBuilder: (context, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _main.dispose();
    _ripple.dispose();
    super.dispose();
  }

  Widget _bar(double widthFactor, Color color) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 8,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildRipples() {
    return AnimatedBuilder(
      animation: _ripple,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (i) {
            final phase = (_ripple.value + i / 3) % 1.0;
            final size = 120 + phase * 120;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromRGBO(255, 255, 255, (1 - phase) * 0.35),
                  width: 2,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildResumeCard() {
    return AnimatedBuilder(
      animation: _main,
      builder: (context, _) {
        // 0 -> 1 -> 0 (neeche jaakar wapas upar)
        final t = _scan.value;
        final tri = t < 0.5 ? t * 2 : (1 - t) * 2;

        return Transform.scale(
          scale: _logoScale.value,
          child: SizedBox(
            width: 110,
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Resume card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color(0xFF5E35B1),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _bar(1, const Color(0xFF5E35B1)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _bar(1.0, Colors.grey.shade300),
                              _bar(0.85, Colors.grey.shade300),
                              _bar(0.95, Colors.grey.shade300),
                              _bar(0.6, Colors.grey.shade300),
                              _bar(0.8, Colors.grey.shade300),
                            ],
                          ),
                        ),
                        // Scanning line
                        Positioned(
                          left: 0,
                          right: 0,
                          top: tri * 134,
                          child: Opacity(
                            opacity: (t > 0 && t < 1) ? 1 : 0,
                            child: Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.cyanAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent,
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Check badge
                Positioned(
                  right: -16,
                  bottom: -16,
                  child: Transform.scale(
                    scale: _check.value,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF1B5E20),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF5E35B1)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildRipples(),
                  _buildResumeCard(),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleFade,
                child: const Text(
                  'ResumeAI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _taglineFade,
              child: const Text(
                'Make your resume perfect with AI.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
