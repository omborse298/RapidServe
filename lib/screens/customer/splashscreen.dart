// name=lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const RapidServeApp());
}

/// Local routes used by this example. If your project already has a utils/app_routes.dart,
/// remove or rename that other AppRoutes or import with a prefix to avoid collisions.
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
}

class RapidServeApp extends StatelessWidget {
  const RapidServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapid Serve Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
      },
    );
  }
}

/// Splash screen — has a const constructor so it can be used in routes as `const SplashScreen()`.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0B63E6);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: blue.withValues(), blurRadius: 14, offset: const Offset(0, 8))],
                    ),
                    child: Center(child: Text('R', style: TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: blue))),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            const Text('RAPID SERVE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF0B63E6))),
            const SizedBox(height: 8),
            const Text('We Serve. You Relax.', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 18),
            const SizedBox(
              width: 60,
              height: 6,
              child: LinearProgressIndicator(minHeight: 6, valueColor: AlwaysStoppedAnimation(Color(0xFF0B63E6))),
            ),
          ],
        ),
      ),
    );
  }
}

/// Onboarding screen (three visual sections)
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const blue1 = Color(0xFF0B63E6);
    const blue2 = Color(0xFF083E9A);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF6FBFF),
            Color(0xFFEFF6FF),
          ]),
        ),
        child: Stack(
          children: [
            // faint city background image (low opacity)
            Positioned(
              top: size.height * 0.62,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/images/city.png',
                  height: size.height * 0.32,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, st) => const SizedBox.shrink(),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const LogoBlock(),
                    const SizedBox(height: 26),

                    // Title
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(text: 'RAPID ', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: blue1, letterSpacing: 1.2)),
                          TextSpan(text: 'SERVE', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600, color: Color(0xFF0A3D9C))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tagline + dividers
                    Column(
                      children: [
                        Container(margin: const EdgeInsets.symmetric(horizontal: 50), child: Row(children: [Expanded(child: Divider(color: Colors.blue.shade100, thickness: 2))])),
                        const SizedBox(height: 8),
                        Text('We Serve. You Relax.', style: GoogleFonts.poppins(fontSize: 16, color: Colors.blueGrey.shade700, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Container(margin: const EdgeInsets.symmetric(horizontal: 50), child: Row(children: [Expanded(child: Divider(color: Colors.blue.shade100, thickness: 2))])),
                      ],
                    ),

                    const SizedBox(height: 26),

                    // Stopwatch callout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: [BoxShadow(color: blue1.withValues(), blurRadius: 10, offset: const Offset(0, 6))]),
                          child: const Icon(Icons.timer, color: blue1, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('AT YOUR DOORSTEP IN', style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                          Text('30-40 MIN', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: blue1)),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Icons row with dotted curve
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: Stack(children: [
                        Positioned.fill(child: CustomPaint(painter: DottedCurvePainter())),
                        Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(child: Align(alignment: Alignment.center, child: FeatureIcon(icon: Icons.ac_unit, label: 'AC\nREPAIR'))),
                              Expanded(child: Align(alignment: Alignment.center, child: FeatureIcon(icon: Icons.cleaning_services, label: 'HOUSEHOLD\nCLEANING'))),
                              Expanded(child: Align(alignment: Alignment.center, child: FeatureIcon(icon: Icons.wifi, label: 'WIFI\nTECHNICIAN'))),
                              Expanded(child: Align(alignment: Alignment.center, child: FeatureIcon(icon: Icons.build, label: '& MORE\nSERVICES'))),
                              Expanded(child: Align(alignment: Alignment.center, child: FeatureIcon(icon: Icons.warning_amber_rounded, label: 'EMERGENCY\nSERVICES'))),
                            ],
                          ),
                        ),
                      ]),
                    ),

                    const SizedBox(height: 30),

                    // Runner + blue wave + footer text
                    SizedBox(
                      height: size.height * 0.38,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            bottom: 0,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: size.height * 0.28,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [blue1, blue2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: size.height * 0.06,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              SizedBox(
                                height: size.height * 0.22,
                                child: Image.asset('assets/images/runner.png', fit: BoxFit.contain, errorBuilder: (c, e, st) => const Icon(Icons.directions_run, size: 90, color: Colors.white70)),
                              ),
                            ]),
                          ),

                          Positioned(
                            left: 18,
                            right: 18,
                            bottom: 16,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Icon(Icons.shield, color: Colors.white70),
                              const SizedBox(width: 10),
                              Expanded(child: Text('Trusted Professionals. Fast Response. Quality Service. Every Time.', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600))),
                            ]),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Logo block (fallback if asset missing)
class LogoBlock extends StatelessWidget {
  const LogoBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final blue = const Color(0xFF0B63E6);

    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: blue.withValues(), // ⚠️ FIXED HERE
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'R',
                    style: GoogleFonts.poppins(
                      fontSize: 86,
                      fontWeight: FontWeight.w800,
                      color: blue,
                      shadows: [
                        Shadow(
                          color: blue.withValues(), // ⚠️ FIXED HERE
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade50,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

/// FeatureIcon widget
class FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureIcon({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}

/// Dotted curve painter used behind the icons row
class DottedCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF9EC7FF)..style = PaintingStyle.stroke..strokeWidth = 2.2..strokeCap = StrokeCap.round;

    final path = Path();
    final left = Offset(40, size.height * 0.45);
    final right = Offset(size.width - 40, size.height * 0.45);
    final cp1 = Offset(size.width * 0.25, -size.height * 0.2);
    final cp2 = Offset(size.width * 0.75, size.height * 1.2);

    path.moveTo(left.dx, left.dy);
    path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, right.dx, right.dy);

    const dashWidth = 8.0;
    const dashSpace = 8.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final extract = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extract, paint);
        distance += dashWidth + dashSpace;
      }
    }

    final dotPaint = Paint()..color = const Color(0xFF0B63E6);
    canvas.drawCircle(left.translate(-12, 0), 4, dotPaint);
    canvas.drawCircle(right.translate(12, 0), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}