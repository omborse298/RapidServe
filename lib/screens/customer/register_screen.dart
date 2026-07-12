// name=lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidserve/screens/customer/login_screen.dart';

void main() => runApp(const RegisterScreen());

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF7F9FF),
      ),
      home: const CustomerRegisterScreen(),
    );
  }
}

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agree = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _createAccount() async {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept Terms & Conditions')));
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created (demo)')));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final bool wide = w > 420;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // NOTE: top decorative circle removed per request (was Positioned with _LargeCircle)

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                children: [
                  // Back arrow
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  // Title + illustration
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: title block
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: 'Customer\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87)),
                                  TextSpan(text: 'Registration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF1967F2))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Create your account to book trusted services in your area.', style: TextStyle(color: Colors.grey.shade700)),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Right: illustration (use asset if you have it)
                      SizedBox(
                        width: wide ? 400 : 200,
                        height: wide ? 400 : 200,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/registration_logo.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) {
                                        // fallback drawing if no asset
                                        return const Icon(Icons.person_rounded, size: 72, color: Color(0xFF1967F2));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Section label
                        Text('Personal Information', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                        const SizedBox(height: 10),

                        _InputCard(
                          child: TextFormField(
                            controller: _name,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Full Name',
                              prefixIcon: Icon(Icons.person, color: Color(0xFF1967F2)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _InputCard(
                          child: TextFormField(
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter phone' : null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone, color: Color(0xFF1967F2)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _InputCard(
                          child: TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Please enter email';
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email Address',
                              prefixIcon: Icon(Icons.email, color: Color(0xFF1967F2)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),
                        Text('Security', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                        const SizedBox(height: 10),

                        _InputCard(
                          child: TextFormField(
                            controller: _pass,
                            obscureText: _obscurePass,
                            validator: (v) => (v == null || v.length < 6) ? 'Password must be 6+ chars' : null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF1967F2)),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePass = !_obscurePass),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _InputCard(
                          child: TextFormField(
                            controller: _confirm,
                            obscureText: _obscureConfirm,
                            validator: (v) => (v != _pass.text) ? 'Passwords do not match' : null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock, color: Color(0xFF1967F2)),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Info box
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: const Color(0xFF1967F2), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.verified_user, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your data is safe with us. We never share your information with anyone.',
                                  style: TextStyle(color: Colors.blue.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Terms checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(value: _agree, onChanged: (v) => setState(() => _agree = v ?? false)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(color: Colors.grey.shade700),
                                  children: [
                                    TextSpan(text: 'Terms & Conditions', style: const TextStyle(color: Color(0xFF1967F2))),
                                    const TextSpan(text: ' and '),
                                    TextSpan(text: 'Privacy Policy', style: const TextStyle(color: Color(0xFF1967F2))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Create Account button (gradient) with white text
                        SizedBox(
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF1967F2), Color(0xFF0B48B8)]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.blue.shade200.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 6))],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _createAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // OR divider
                        Row(children: [
                          const Expanded(child: Divider()),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('OR', style: TextStyle(color: Colors.grey.shade600))),
                          const Expanded(child: Divider()),
                        ]),

                        const SizedBox(height: 14),

                        // Social / Google button (simple)
                        SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: SizedBox(width: 28, child: Image.asset('assets/google_logo.png', height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, color: Colors.red))),
                            label: const Text('Continue with Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Login row (now navigates to LoginScreen)
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('Already have an account? ', style: TextStyle(color: Colors.grey.shade700)),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the login page
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                            },
                            child: const Text('Login', style: TextStyle(color: Color(0xFF1967F2), fontWeight: FontWeight.w700)),
                          ),
                        ]),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // bottom wave removed
          ],
        ),
      ),
    );
  }
}

/// Simple white rounded input card used for each field
class _InputCard extends StatelessWidget {
  final Widget child;
  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))
      ]),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: child,
    );
  }
}