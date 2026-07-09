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
          Positioned.fill(
            top: 0,
            child: SizedBox(
              height: 260,
              child: CustomPaint(
                painter: _TopWavePainter(),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                bottom: MediaQuery.of(context).viewInsets.bottom, // ✅ FIX ADDED HERE
              ),
              child: Column(
                children: [
                  const SizedBox(height: 28),

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

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Welcome Back',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade900)),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Login to continue',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 15)),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border:
                      Border.all(color: Colors.blue.shade50, width: 1.8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => isUserSelected = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              decoration: BoxDecoration(
                                color: isUserSelected
                                    ? const Color(0xFF0B63E6)
                                    : Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person,
                                      color: isUserSelected
                                          ? Colors.white
                                          : const Color(0xFF0B63E6)),
                                  const SizedBox(width: 10),
                                  Text('User',
                                      style: TextStyle(
                                          color: isUserSelected
                                              ? Colors.white
                                              : const Color(0xFF0B63E6),
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => isUserSelected = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              decoration: BoxDecoration(
                                color: isUserSelected
                                    ? Colors.white
                                    : const Color(0xFF0B63E6),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.handyman,
                                      color: isUserSelected
                                          ? const Color(0xFF0B63E6)
                                          : Colors.white),
                                  const SizedBox(width: 10),
                                  Text('Service Provider',
                                      style: TextStyle(
                                          color: isUserSelected
                                              ? const Color(0xFF0B63E6)
                                              : Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  _buildInputField(
                    prefix:
                    const Icon(Icons.phone, color: Color(0xFF0B63E6)),
                    hint: 'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  _buildInputField(
                    prefix: const Icon(Icons.lock, color: Color(0xFF0B63E6)),
                    hint: 'Password',
                    obscure: _obscure,
                    suffix: GestureDetector(
                      onTap: () =>
                          setState(() => _obscure = !_obscure),
                      child: Icon(
                          _obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade500),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap),
                      child: const Text('Forgot Password?'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B63E6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 160,
              child: CustomPaint(
                painter: _BottomWavesPainter(),
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
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// painters unchanged
class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}