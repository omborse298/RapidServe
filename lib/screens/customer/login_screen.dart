// name=lib/screens/customer/login_screen.dart
import 'package:flutter/material.dart';
import 'package:rapidserve/services/auth_service.dart';
import 'package:rapidserve/utils/app_routes.dart';
import 'package:rapidserve/screens/customer/register_screen.dart'; // <-- MAKE SURE IT SAYS AUTH HERE

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isUserSelected = true;
  bool _obscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    String? result = await _authService.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );

      // Route dynamically using your AppRoutes naming convention
      if (isUserSelected) {
        // Navigator.pushReplacementNamed(context, AppRoutes.customerHome);
      } else {
        // Navigator.pushReplacementNamed(context, AppRoutes.providerHome);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// TOP WAVE
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 260,
              child: CustomPaint(
                painter: _TopWavePainter(),
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  /// HERO IMAGE
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/logo2.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// USER / PROVIDER TOGGLE
                  Container(
                    height: 59,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30), // Fully rounded outer capsule
                      border: Border.all(color: Colors.blue.shade50, width: 1.8),
                    ),
                    padding: const EdgeInsets.all(4), // Creates the necessary space around the independent pill fields
                    child: Row(
                      children: [
                        // --- USER TAB ---
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isUserSelected = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              decoration: BoxDecoration(
                                // Fully rounds ALL 4 corners for the complete capsule look you drew
                                color: isUserSelected ? const Color(0xFF0B63E6) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: isUserSelected ? Colors.white : const Color(0xFF0B63E6),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'User',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isUserSelected ? Colors.white : const Color(0xFF0B63E6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // --- PROVIDER TAB ---
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isUserSelected = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              decoration: BoxDecoration(
                                // Fully rounds ALL 4 corners for the complete capsule look you drew
                                color: !isUserSelected ? const Color(0xFF0B63E6) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.handyman,
                                    color: !isUserSelected ? Colors.white : const Color(0xFF0B63E6),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Provider',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: !isUserSelected ? Colors.white : const Color(0xFF0B63E6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// EMAIL FIELD
                  _buildInputField(
                    controller: emailController,
                    prefix: const Icon(Icons.email, color: Color(0xFF0B63E6)),
                    hint: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  /// PASSWORD FIELD
                  _buildInputField(
                    controller: passwordController,
                    prefix: const Icon(Icons.lock, color: Color(0xFF0B63E6)),
                    hint: 'Password',
                    obscure: _obscure,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0B63E6),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('or', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B63E6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// SIGN UP NAVIGATION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to Rapid Serve?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF0B63E6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF3F8FF);
    final path = Path();

    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5,
        size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9,
        size.width, size.height * 0.7);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}