import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/provider_model.dart';
import '../../providers/provider_provider.dart';

class ProviderProfileScreen
    extends ConsumerStatefulWidget {
  const ProviderProfileScreen({
    super.key,
  });

  @override
  ConsumerState<ProviderProfileScreen> createState() =>
      _ProviderProfileScreenState();
}


class _ProviderProfileScreenState
    extends ConsumerState<ProviderProfileScreen> {

  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    final profileAsync =
    ref.watch(providerProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },

            child: Text(
              _isEditing ? 'Cancel' : 'Edit',

              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: profileAsync.when(

        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Text(
                'Unable to load profile\n\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },

        data: (profile) {
          _setControllers(profile);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,

              children: [

                _buildProfileImage(profile),

                const SizedBox(height: 16),

                if (_isEditing)
                  _buildEditFields()
                else
                  _buildProfileHeader(profile),

                const SizedBox(height: 24),

                if (!_isEditing)
                  _buildStatistics(profile),

                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 20),

                _buildAboutSection(profile),

                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 20),

                _buildContactSection(profile),

                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 20),

                _buildServicesSection(profile),

                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 20),

                _buildCertificationSection(profile),

                const SizedBox(height: 24),

                if (_isEditing)
                  _buildSaveButton(),

                const SizedBox(height: 12),

                _buildLogoutButton(),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }


  void _setControllers(
      ProviderProfile profile,
      ) {
    if (!_isEditing &&
        _nameController.text.isEmpty) {

      _nameController.text = profile.name;
      _bioController.text = profile.bio;
      _phoneController.text = profile.phone;
      _addressController.text = profile.address;
    }
  }


  Widget _buildProfileImage(
      ProviderProfile profile,
      ) {
    return CircleAvatar(
      radius: 60,

      backgroundColor: Colors.blue.shade100,

      backgroundImage:
      profile.profileImage.isNotEmpty
          ? NetworkImage(
        profile.profileImage,
      )
          : null,

      child: profile.profileImage.isEmpty
          ? const Icon(
        Icons.person,
        size: 60,
        color: Colors.blue,
      )
          : null,
    );
  }


  Widget _buildProfileHeader(
      ProviderProfile profile,
      ) {
    return Column(
      children: [

        Text(
          profile.name,

          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),

            const SizedBox(width: 5),

            Text(
              '${profile.rating} '
                  '(${profile.reviews} reviews)',

              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),

          decoration: BoxDecoration(
            color: profile.isOnline
                ? Colors.green
                : Colors.grey,

            borderRadius:
            BorderRadius.circular(20),
          ),

          child: Text(
            profile.isOnline
                ? 'Online'
                : 'Offline',

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildStatistics(
      ProviderProfile profile,
      ) {
    return Row(
      children: [

        Expanded(
          child: _buildStatCard(
            'Total Jobs',
            profile.totalJobs.toString(),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildStatCard(
            'Completed',
            profile.completedJobs.toString(),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildStatCard(
            'Earnings',
            '₹${profile.totalEarnings}',
          ),
        ),
      ],
    );
  }


  Widget _buildStatCard(
      String title,
      String value,
      ) {
    return Card(
      elevation: 1,

      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 5,
        ),

        child: Column(
          children: [

            Text(
              title,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              value,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAboutSection(
      ProviderProfile profile,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _buildSectionTitle(
          'About Me',
        ),

        const SizedBox(height: 12),

        Text(
          profile.bio.isEmpty
              ? 'No bio added'
              : profile.bio,

          style: TextStyle(
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }


  Widget _buildContactSection(
      ProviderProfile profile,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _buildSectionTitle(
          'Contact Information',
        ),

        const SizedBox(height: 12),

        _buildContactRow(
          Icons.phone,
          profile.phone,
        ),

        const SizedBox(height: 12),

        _buildContactRow(
          Icons.email,
          profile.email,
        ),

        const SizedBox(height: 12),

        _buildContactRow(
          Icons.location_on,
          profile.address,
        ),
      ],
    );
  }


  Widget _buildContactRow(
      IconData icon,
      String value,
      ) {
    return Row(
      children: [

        Icon(
          icon,
          color: Colors.blue,
          size: 20,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            value,
          ),
        ),
      ],
    );
  }


  Widget _buildServicesSection(
      ProviderProfile profile,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _buildSectionTitle(
          'Services Offered',
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,

          children: profile.services
              .map(
                (service) => Chip(
              label: Text(service),

              backgroundColor:
              Colors.blue.shade100,
            ),
          )
              .toList(),
        ),
      ],
    );
  }


  Widget _buildCertificationSection(
      ProviderProfile profile,
      ) {
    if (profile.certifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        _buildSectionTitle(
          'Certifications & Qualifications',
        ),

        const SizedBox(height: 12),

        ...profile.certifications.map(
              (certification) {
            return ListTile(
              contentPadding:
              EdgeInsets.zero,

              leading: const Icon(
                Icons.verified,
                color: Colors.green,
              ),

              title: Text(
                certification,
              ),
            );
          },
        ),
      ],
    );
  }


  Widget _buildEditFields() {
    return Column(
      children: [

        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
        ),

        const SizedBox(height: 12),

        _buildTextField(
          controller: _bioController,
          label: 'Bio',
          maxLines: 3,
        ),

        const SizedBox(height: 12),

        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          keyboardType:
          TextInputType.phone,
        ),

        const SizedBox(height: 12),

        _buildTextField(
          controller: _addressController,
          label: 'Address',
          maxLines: 2,
        ),
      ],
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,

      maxLines: maxLines,

      keyboardType: keyboardType,

      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(
      String title,
      ) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }


  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        onPressed: _saveProfile,

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,

          padding:
          const EdgeInsets.symmetric(
            vertical: 15,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),

        child: const Text(
          'Save Changes',
        ),
      ),
    );
  }


  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton(
        onPressed: _logout,

        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,

          padding:
          const EdgeInsets.symmetric(
            vertical: 15,
          ),

          side: const BorderSide(
            color: Colors.red,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(8),
          ),
        ),

        child: const Text(
          'Logout',
        ),
      ),
    );
  }


  Future<void> _saveProfile() async {
    await ref
        .read(
      providerProfileProvider
          .notifier,
    )
        .updateProfile(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Profile updated successfully',
        ),
      ),
    );
  }


  Future<void> _logout() async {
    await ref
        .read(
      providerAuthProvider
          .notifier,
    )
        .logout();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    super.dispose();
  }
}