class ProviderProfile {
  final String name;
  final String bio;
  final String phone;
  final String email;
  final String address;
  final String profileImage;

  final double rating;
  final int reviews;
  final int totalJobs;
  final int completedJobs;
  final double totalEarnings;

  final bool isOnline;

  final List<String> services;
  final List<String> certifications;

  const ProviderProfile({
    required this.name,
    required this.bio,
    required this.phone,
    required this.email,
    required this.address,
    required this.profileImage,
    required this.rating,
    required this.reviews,
    required this.totalJobs,
    required this.completedJobs,
    required this.totalEarnings,
    required this.isOnline,
    required this.services,
    required this.certifications,
  });

  ProviderProfile copyWith({
    String? name,
    String? bio,
    String? phone,
    String? email,
    String? address,
    String? profileImage,
    double? rating,
    int? reviews,
    int? totalJobs,
    int? completedJobs,
    double? totalEarnings,
    bool? isOnline,
    List<String>? services,
    List<String>? certifications,
  }) {
    return ProviderProfile(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      totalJobs: totalJobs ?? this.totalJobs,
      completedJobs: completedJobs ?? this.completedJobs,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      isOnline: isOnline ?? this.isOnline,
      services: services ?? this.services,
      certifications: certifications ?? this.certifications,
    );
  }
}