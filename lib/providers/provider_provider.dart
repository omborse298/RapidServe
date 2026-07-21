import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/provider_model.dart';

class ProviderProfileNotifier
    extends AsyncNotifier<ProviderProfile> {
  @override
  Future<ProviderProfile> build() async {
    // Temporary data for testing.
    // Later this can be replaced with Firebase/Firestore data.

    return const ProviderProfile(
      name: 'Provider Name',
      bio: 'Professional service provider',
      phone: '9876543210',
      email: 'provider@gmail.com',
      address: 'Mumbai, India',
      profileImage: '',
      rating: 4.8,
      reviews: 25,
      totalJobs: 100,
      completedJobs: 95,
      totalEarnings: 50000,
      isOnline: true,
      services: [
        'Electrical Repair',
        'AC Repair',
      ],
      certifications: [
        'Certified Technician',
      ],
    );
  }

  Future<void> updateProfile({
    required String name,
    required String bio,
    required String phone,
    required String address,
  }) async {
    final currentProfile = state.value;

    if (currentProfile == null) {
      return;
    }

    state = AsyncData(
      currentProfile.copyWith(
        name: name,
        bio: bio,
        phone: phone,
        address: address,
      ),
    );
  }

  Future<void> updateProfileImage(
      String imageUrl,
      ) async {
    final currentProfile = state.value;

    if (currentProfile == null) {
      return;
    }

    state = AsyncData(
      currentProfile.copyWith(
        profileImage: imageUrl,
      ),
    );
  }

  Future<void> toggleOnlineStatus() async {
    final currentProfile = state.value;

    if (currentProfile == null) {
      return;
    }

    state = AsyncData(
      currentProfile.copyWith(
        isOnline: !currentProfile.isOnline,
      ),
    );
  }
}

final providerProfileProvider =
AsyncNotifierProvider<
    ProviderProfileNotifier,
    ProviderProfile
>(
  ProviderProfileNotifier.new,
);


class ProviderAuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  Future<void> logout() async {
    // Later connect FirebaseAuth.signOut() here.
    state = false;
  }
}

final providerAuthProvider =
NotifierProvider<
    ProviderAuthNotifier,
    bool
>(
  ProviderAuthNotifier.new,
);