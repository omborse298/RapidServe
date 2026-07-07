import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isUserSelected = true;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Top subtle wave (light)
          Positioned.fill(
            top: 0,
            child: SizedBox(
              height: 260,
              child: CustomPaint(
                painter: _TopWavePainter(),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // Logo (use asset if present)
                  SizedBox(
                    height: 195,
                    child: Center(
                      child: Image.asset(
                        'assets/images/login_logo.png',
                        width: 175,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Welcome texts
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Welcome Back',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.blue.shade900)),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Login to continue', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                  ),

                  const SizedBox(height: 20),

                  // Segmented control (User / Service Provider)
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue.shade50, width: 1.8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isUserSelected = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              decoration: BoxDecoration(
                                color: isUserSelected ? const Color(0xFF0B63E6) : Colors.white,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, color: isUserSelected ? Colors.white : const Color(0xFF0B63E6)),
                                  const SizedBox(width: 10),
                                  Text('User', style: TextStyle(color: isUserSelected ? Colors.white : const Color(0xFF0B63E6), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isUserSelected = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              decoration: BoxDecoration(
                                color: isUserSelected ? Colors.white : const Color(0xFF0B63E6),
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.handyman, color: isUserSelected ? const Color(0xFF0B63E6) : Colors.white),
                                  const SizedBox(width: 10),
                                  Text('Service Provider', style: TextStyle(color: isUserSelected ? const Color(0xFF0B63E6) : Colors.white, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Phone field
                  _buildInputField(
                    prefix: const Icon(Icons.phone, color: Color(0xFF0B63E6)),
                    hint: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  _buildInputField(
                    prefix: const Icon(Icons.lock, color: Color(0xFF0B63E6)),
                    hint: 'Password',
                    obscure: _obscure,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade500),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Forgot password aligned right
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text('Forgot Password?', style: TextStyle(color: const Color(0xFF0B63E6))),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Login button (blue rounded)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B63E6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                        shadowColor: const Color(0xFF0B63E6).withOpacity(0.3),
                      ),
                      child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // OR divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('or', style: TextStyle(color: Colors.grey.shade500)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Login with OTP
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone_android, color: Color(0xFF0B63E6)),
                      label: Text('Login with OTP', style: TextStyle(color: const Color(0xFF0B63E6), fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF0B63E6), width: 1.6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Sign up row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New to Rapid Serve?', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Sign Up', style: TextStyle(color: Color(0xFF0B63E6), fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Bottom blue waves
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 160,
              child: CustomPaint(
                painter: _BottomWavesPainter(),
                child: Container(), // required child to set size
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required Widget prefix,
    Widget? suffix,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.4),
        boxShadow: [BoxShadow(color: Colors.blue.shade50.withOpacity(0.8), blurRadius: 8, offset: const Offset(0, 6))],
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Padding(padding: const EdgeInsets.only(left: 14, right: 6), child: prefix),
          prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 44),
          suffixIcon: suffix == null ? null : Padding(padding: const EdgeInsets.only(right: 14), child: suffix),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

/// Light top wave painter (very subtle)
class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF3F8FF);
    final path = Path();
    final h = size.height;
    final w = size.width;
    path.moveTo(0, h * 0.7);
    path.quadraticBezierTo(w * 0.25, h * 0.55, w * 0.5, h * 0.7);
    path.quadraticBezierTo(w * 0.75, h * 0.85, w, h * 0.7);
    path.lineTo(w, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bottom layered blue waves painter
class _BottomWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // back wave (light)
    final paint1 = Paint()..color = const Color(0xFF0B63E6).withOpacity(0.12);
    final p1 = Path();
    p1.moveTo(0, h * 0.6);
    p1.quadraticBezierTo(w * 0.25, h * 0.8, w * 0.5, h * 0.6);
    p1.quadraticBezierTo(w * 0.75, h * 0.4, w, h * 0.6);
    p1.lineTo(w, h);
    p1.lineTo(0, h);
    p1.close();
    canvas.drawPath(p1, paint1);

    // front wave gradient
    final rect = Rect.fromLTWH(0, 0, w, h);
    final grad = LinearGradient(colors: [const Color(0xFF0B63E6), const Color(0xFF083E9A)]);
    final paint2 = Paint()..shader = grad.createShader(rect);
    final p2 = Path();
    p2.moveTo(0, h * 0.45);
    p2.quadraticBezierTo(w * 0.2, h * 0.2, w * 0.5, h * 0.45);
    p2.quadraticBezierTo(w * 0.8, h * 0.7, w, h * 0.5);
    p2.lineTo(w, h);
    p2.lineTo(0, h);
    p2.close();
    canvas.drawPath(p2, paint2);

    // small decorative houses silhouette (optional - very subtle)
    final housePaint = Paint()..color = Colors.white.withOpacity(0.06);
    final houseWidth = w / 18;
    double x = houseWidth * 0.5;
    while (x < w - houseWidth) {
      final house = Path();
      house.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, h - houseWidth * 0.9, houseWidth * 0.8, houseWidth * 0.6), const Radius.circular(4)));
      canvas.drawPath(house, housePaint);
      x += houseWidth + 6;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}