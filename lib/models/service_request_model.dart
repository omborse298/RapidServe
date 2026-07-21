class ServiceRequest {
  final String id;
  final String serviceType;
  final String customerName;
  final String customerAddress;
  final String serviceLocation;
  final String status;
  final double distance;
  final int estimatedDuration;
  final double customerRating;
  final int customerReviews;
  final double serviceFee;
  final DateTime requestedAt;
  final String? description;
  final double customerLatitude;
  final double customerLongitude;
  final String customerProfileImage;
  final String? problemImageUrl;

  const ServiceRequest({
    required this.id,
    required this.serviceType,
    required this.customerName,
    required this.customerAddress,
    required this.serviceLocation,
    required this.status,
    required this.distance,
    required this.estimatedDuration,
    required this.customerRating,
    required this.customerReviews,
    required this.serviceFee,
    required this.requestedAt,
    this.description,
    required this.customerLatitude,
    required this.customerLongitude,
    required this.customerProfileImage,
    this.problemImageUrl,
  });

  ServiceRequest copyWith({
    String? id,
    String? serviceType,
    String? customerName,
    String? customerAddress,
    String? serviceLocation,
    String? status,
    double? distance,
    int? estimatedDuration,
    double? customerRating,
    int? customerReviews,
    double? serviceFee,
    DateTime? requestedAt,
    String? description,
    double? customerLatitude,
    double? customerLongitude,
    String? customerProfileImage,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      serviceLocation: serviceLocation ?? this.serviceLocation,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      estimatedDuration:
      estimatedDuration ?? this.estimatedDuration,
      customerRating:
      customerRating ?? this.customerRating,
      customerReviews:
      customerReviews ?? this.customerReviews,
      serviceFee: serviceFee ?? this.serviceFee,
      requestedAt: requestedAt ?? this.requestedAt,
      description: description ?? this.description,
      customerLatitude:
      customerLatitude ?? this.customerLatitude,
      customerLongitude:
      customerLongitude ?? this.customerLongitude,
      customerProfileImage:
      customerProfileImage ?? this.customerProfileImage,
    );
  }

  factory ServiceRequest.fromMap(
      Map<String, dynamic> map,
      ) {
    return ServiceRequest(
      id: map['id']?.toString() ?? '',
      serviceType:
      map['serviceType']?.toString() ?? 'General Service',
      customerName:
      map['customerName']?.toString() ?? 'Customer',
      customerAddress:
      map['customerAddress']?.toString() ?? '',
      serviceLocation:
      map['serviceLocation']?.toString() ?? '',
      status:
      map['status']?.toString() ?? 'requested',
      distance:
      (map['distance'] as num?)?.toDouble() ?? 0.0,
      estimatedDuration:
      (map['estimatedDuration'] as num?)?.toInt() ?? 0,
      customerRating:
      (map['customerRating'] as num?)?.toDouble() ?? 0.0,
      customerReviews:
      (map['customerReviews'] as num?)?.toInt() ?? 0,
      serviceFee:
      (map['serviceFee'] as num?)?.toDouble() ?? 0.0,
      requestedAt:
      DateTime.tryParse(
        map['requestedAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
      description:
      map['description']?.toString(),
      customerLatitude:
      (map['customerLatitude'] as num?)?.toDouble() ?? 0.0,
      customerLongitude:
      (map['customerLongitude'] as num?)?.toDouble() ?? 0.0,
      customerProfileImage:
      map['customerProfileImage']?.toString() ??
          'https://via.placeholder.com/150',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceType': serviceType,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'serviceLocation': serviceLocation,
      'status': status,
      'distance': distance,
      'estimatedDuration': estimatedDuration,
      'customerRating': customerRating,
      'customerReviews': customerReviews,
      'serviceFee': serviceFee,
      'requestedAt': requestedAt.toIso8601String(),
      'description': description,
      'customerLatitude': customerLatitude,
      'customerLongitude': customerLongitude,
      'customerProfileImage': customerProfileImage,
    };
  }
}