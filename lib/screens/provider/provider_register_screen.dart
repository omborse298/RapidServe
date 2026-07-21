import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() =>
      _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _obscurePassword = true;

  File? _aadhaarFile;
  File? _panFile;

  String? _aadhaarFileName;
  String? _panFileName;

  static const Color primaryBlue = Color(0xFF286BE6);
  static const Color fieldColor = Color(0xFFF7F7F7);
  static const Color successGreen = Color(0xFF4CAF62);

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _experienceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // =========================
  // PICK AADHAAR
  // =========================

  Future<void> _pickAadhaar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
      ],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _aadhaarFile = File(result.files.single.path!);
        _aadhaarFileName = result.files.single.name;
      });
    }
  }

  // =========================
  // PICK PAN
  // =========================

  Future<void> _pickPan() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
      ],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _panFile = File(result.files.single.path!);
        _panFileName = result.files.single.name;
      });
    }
  }

  // =========================
  // REGISTER PROVIDER
  // =========================

  void _registerProvider() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_aadhaarFile == null || _panFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please upload both Aadhaar Card and PAN Card',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF9F4FC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            16,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: successGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Registration Successful',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF20202A),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),



              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              40,
              20,
              40,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // BACK BUTTON
                // =========================

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 45),

                // =========================
                // HEADING
                // =========================

                const Text(
                  'Provider',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Registration',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 40),

                // =========================
                // FULL NAME
                // =========================

                _buildTextField(
                  controller: _nameController,
                  icon: Icons.person_outline,
                  hintText: 'Full Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =========================
                // AGE
                // =========================

                _buildTextField(
                  controller: _ageController,
                  icon: Icons.cake_outlined,
                  hintText: 'Age',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your age';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =========================
                // CONTACT NUMBER
                // =========================

                _buildTextField(
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  hintText: 'Contact Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your contact number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =========================
                // BUSINESS EMAIL
                // =========================

                _buildTextField(
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  hintText: 'Business Email ID',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your business email';
                    }

                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =========================
                // PASSWORD
                // =========================

                _buildTextField(
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: primaryBlue,
                      size: 24,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must contain at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =========================
                // EXPERIENCE
                // =========================

                _buildTextField(
                  controller: _experienceController,
                  icon: Icons.work_outline,
                  hintText: 'Experience in Years',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your experience';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // =========================
                // DOCUMENT TITLE
                // =========================

                const Text(
                  'Upload Documents',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // =========================
                // AADHAAR CARD
                // =========================

                _buildDocumentCard(
                  title: 'Aadhaar Card',
                  fileName: _aadhaarFileName,
                  onTap: _pickAadhaar,
                ),

                const SizedBox(height: 16),

                // =========================
                // PAN CARD
                // =========================

                _buildDocumentCard(
                  title: 'PAN Card',
                  fileName: _panFileName,
                  onTap: _pickPan,
                ),

                const SizedBox(height: 20),

                // =========================
                // BUSINESS ADDRESS
                // =========================

                _buildTextField(
                  controller: _addressController,
                  icon: Icons.location_on_outlined,
                  hintText: 'Business Address',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your business address';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // =========================
                // REGISTER BUTTON
                // =========================

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _registerProvider,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Register as Provider',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Your information will be securely verified.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // TEXT FIELD
  // =========================

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator,

      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: fieldColor,

        hintText: hintText,

        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF303030),
        ),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 14,
          ),
          child: Icon(
            icon,
            color: primaryBlue,
            size: 27,
          ),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 58,
        ),

        suffixIcon: suffixIcon,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primaryBlue,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // =========================
  // DOCUMENT CARD
  // =========================

  Widget _buildDocumentCard({
    required String title,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    final bool uploaded = fileName != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: uploaded ? successGreen : primaryBlue,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                uploaded
                    ? Icons.check_circle_outline
                    : Icons.upload_file_outlined,
                color: uploaded ? successGreen : primaryBlue,
                size: 32,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    uploaded
                        ? fileName!
                        : 'Tap to upload JPG, PNG or PDF',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: uploaded
                          ? successGreen
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              uploaded
                  ? Icons.check_circle
                  : Icons.upload,
              color: uploaded
                  ? successGreen
                  : primaryBlue,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}