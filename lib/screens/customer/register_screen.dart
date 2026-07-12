// name=lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:rapidserve/services/auth_service.dart';
import 'package:rapidserve/utils/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  final AuthService _authService = AuthService();

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
    // 1. Enforce Terms & Conditions selection
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Conditions')),
      );
      return;
    }

    // 2. Validate all Form text fields
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 3. Send all captured data parameters to the backend Firestore/Auth service
    String? result = await _authService.registerUser(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      password: _pass.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // 4. Handle registration backend response
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Take the user out of registration and back to the login screen flow
      Navigator.pop(context);
    } else {
      // Print the custom error message received from Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer',
                          style: TextStyle(
                            fontSize: 28, // Scaled up slightly for a bolder appearance
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'Registration',
                          style: TextStyle(
                            fontSize: 28, // Scaled up slightly for a bolder appearance
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1967F2),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Create your account to book trusted services.',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 40,
                      color: Color(0xFF1967F2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18), // Reduced from 30/24 to make the vertical flow tighter and cleaner
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Personal Information Heading ---
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'Personal Information',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _InputCard(
                      child: TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Full Name',
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          prefixIcon: Icon(Icons.person, color: Color(0xFF1967F2), size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InputCard(
                      child: TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter phone' : null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          prefixIcon: Icon(Icons.phone, color: Color(0xFF1967F2), size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InputCard(
                      child: TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Please enter email';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email Address',
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                          prefixIcon: Icon(Icons.email, color: Color(0xFF1967F2), size: 22),
                        ),
                      ),
                    ),

                    // --- Security Heading ---
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 20, bottom: 8),
                      child: Text(
                        'Security',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    _InputCard(
                      child: TextFormField(
                        controller: _pass,
                        obscureText: _obscurePass,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.length < 6) ? 'Password must be 6+ chars' : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF1967F2), size: 22),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, size: 20),
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
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _createAccount(),
                        validator: (v) => (v != _pass.text) ? 'Passwords do not match' : null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF1967F2), size: 22),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, size: 20),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _agree,
                          activeColor: const Color(0xFF1967F2),
                          onChanged: (v) => setState(() => _agree = v ?? false),
                        ),
                        const Expanded(
                          child: Text(
                            'I agree to the Terms & Conditions and Privacy Policy',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1967F2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Create Account', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Login', style: TextStyle(color: Color(0xFF1967F2), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final Widget child;
  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}