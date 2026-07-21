import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/service_request_model.dart';
import '../../providers/service_request_provider.dart';
import '../../providers/location_provider.dart';

class ServiceRequestsScreen extends ConsumerStatefulWidget {
  const ServiceRequestsScreen({super.key});

  @override
  ConsumerState<ServiceRequestsScreen> createState() =>
      _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState
    extends ConsumerState<ServiceRequestsScreen> {
  GoogleMapController? _mapController;

  bool _showMap = false;
  String? _acceptedJobId;

  static const Color primaryBlue = Color(0xFF286BE6);
  static const Color lightGrey = Color(0xFFF7F7F7);
  static const Color darkText = Color(0xFF20202A);

  @override
  void initState() {
    super.initState();
    _initializeLocationTracking();
  }

  Future<void> _initializeLocationTracking() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceRequests = ref.watch(serviceRequestsProvider);
    final currentLocation = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Service Requests',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: primaryBlue,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _showMap && _acceptedJobId != null
          ? _buildLiveTrackingView(currentLocation)
          : _buildServiceRequestsList(serviceRequests),
    );
  }

  // ============================================================
  // SERVICE REQUESTS LIST
  // ============================================================

  Widget _buildServiceRequestsList(
      AsyncValue<List<ServiceRequest>> serviceRequests) {
    return serviceRequests.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: primaryBlue,
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.refresh(serviceRequestsProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No Service Requests',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'New requests will appear here',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: primaryBlue,
          onRefresh: () => ref.refresh(serviceRequestsProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];

              return _buildServiceRequestCard(request);
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // SERVICE REQUEST CARD
  // ============================================================

  Widget _buildServiceRequestCard(ServiceRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getServiceIcon(request.serviceType),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.serviceType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By: ${request.customerName}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                _buildStatusChip(request.status),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 12),

            // WORK LOCATION
            _buildLocationRow(
              request.serviceLocation,
              'Work Location',
            ),

            const SizedBox(height: 12),

            // CUSTOMER LOCATION
            _buildLocationRow(
              request.customerAddress,
              'Customer Location',
            ),

            const SizedBox(height: 16),

            // PROBLEM MENTIONED
            if (request.description != null &&
                request.description!.trim().isNotEmpty)
              _buildProblemBox(request.description!),

            const SizedBox(height: 16),

            // CUSTOMER PROBLEM IMAGE
            _buildCustomerProblemImage(
              request.problemImageUrl,
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 12),

            // INFORMATION ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  'Distance',
                  '${request.distance} km',
                ),
                _buildInfoColumn(
                  'Duration',
                  '${request.estimatedDuration} min',
                ),
                _buildRatingColumn(
                  request.customerRating,
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 12),

            // SERVICE FEE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Fee',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${request.serviceFee.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Requested at',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a').format(request.requestedAt),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _declineRequest(request.id);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _acceptRequest(request);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Accept Job',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROBLEM BOX
  // ============================================================

  Widget _buildProblemBox(String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primaryBlue,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.report_problem,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'PROBLEM MENTIONED',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.45,
                color: darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CUSTOMER PROBLEM IMAGE
  // ============================================================

  Widget _buildCustomerProblemImage(String? imageUrl) {
    final hasImage =
        imageUrl != null && imageUrl.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.image_outlined,
                color: primaryBlue,
                size: 26,
              ),

              SizedBox(width: 10),

              Text(
                'Problem Image',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: hasImage
                ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return _buildNoImageView();
                },
              ),
            )
                : _buildNoImageView(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoImageView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 52,
            color: Colors.grey,
          ),

          SizedBox(height: 12),

          Text(
            'No problem image uploaded',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RATING
  // ============================================================

  Widget _buildRatingColumn(double rating) {
    return Column(
      children: [
        Text(
          'Rating',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),

        const SizedBox(height: 4),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(width: 4),

            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 19,
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // LIVE TRACKING VIEW
  // ============================================================

  Widget _buildLiveTrackingView(
      AsyncValue<Position> currentLocation) {
    final acceptedJob =
    ref.watch(acceptedJobProvider(_acceptedJobId!));

    return acceptedJob.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: primaryBlue,
        ),
      ),
      error: (error, stackTrace) {
        return _buildErrorView(error);
      },
      data: (job) {
        if (job == null) {
          return _buildErrorView(
            'Accepted job not found',
          );
        }

        return Stack(
          children: [
            _buildMapView(
              job,
              currentLocation,
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTrackingTopBar(job),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildTrackingBottomSheet(job),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MAP
  // ============================================================

  Widget _buildMapView(
      ServiceRequest job,
      AsyncValue<Position> currentLocation) {
    return currentLocation.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: primaryBlue,
        ),
      ),
      error: (error, stackTrace) {
        return _buildErrorView(error);
      },
      data: (position) {
        return GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              job.customerLatitude,
              job.customerLongitude,
            ),
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('provider'),
              position: LatLng(
                position.latitude,
                position.longitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
              infoWindow: const InfoWindow(
                title: 'Your Location',
              ),
            ),

            Marker(
              markerId: const MarkerId('customer'),
              position: LatLng(
                job.customerLatitude,
                job.customerLongitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: InfoWindow(
                title: job.customerName,
                snippet: job.customerAddress,
              ),
            ),
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              points: [
                LatLng(
                  position.latitude,
                  position.longitude,
                ),
                LatLng(
                  job.customerLatitude,
                  job.customerLongitude,
                ),
              ],
              color: primaryBlue,
              width: 4,
              geodesic: true,
            ),
          },
        );
      },
    );
  }

  // ============================================================
  // TRACKING TOP BAR
  // ============================================================

  Widget _buildTrackingTopBar(ServiceRequest job) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ETA: ${_calculateETA(job.estimatedDuration)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                '${job.distance} km away',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.phone,
                  color: primaryBlue,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calling customer...'),
                    ),
                  );
                },
              ),

              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _showMap = false;
                    _acceptedJobId = null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRACKING BOTTOM SHEET
  // ============================================================

  Widget _buildTrackingBottomSheet(ServiceRequest job) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.65,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      job.customerProfileImage,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              '${job.customerRating} '
                                  '(${job.customerReviews} reviews)',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(),

              const SizedBox(height: 16),

              _buildStatusTimeline(job),

              const SizedBox(height: 16),

              _buildLocationSection(job),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(
                          serviceRequestProvider(job.id)
                              .notifier,
                        )
                            .updateJobStatus(
                          job.id,
                          'arrived',
                        );
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Mark Arrived'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(
                          serviceRequestProvider(job.id)
                              .notifier,
                        )
                            .updateJobStatus(
                          job.id,
                          'in_progress',
                        );
                      },
                      icon: const Icon(Icons.play_circle),
                      label: const Text('Start Service'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(
                      serviceRequestProvider(job.id)
                          .notifier,
                    )
                        .updateJobStatus(
                      job.id,
                      'completed',
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Complete Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // STATUS TIMELINE
  // ============================================================

  Widget _buildStatusTimeline(ServiceRequest job) {
    final statuses = [
      'requested',
      'accepted',
      'arrived',
      'in_progress',
      'completed',
    ];

    final currentIndex = statuses.indexOf(job.status);

    return Column(
      children: [
        Text(
          'Job Status',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        Row(
          children: List.generate(
            statuses.length,
                (index) {
              final isDone = index <= currentIndex;

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone
                            ? primaryBlue
                            : Colors.grey[300],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isDone
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    if (index < statuses.length - 1)
                      Container(
                        height: 2,
                        color: index < currentIndex
                            ? primaryBlue
                            : Colors.grey[300],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOCATION SECTION
  // ============================================================

  Widget _buildLocationSection(ServiceRequest job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location Details',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        _buildLocationRow(
          job.serviceLocation,
          'Work Location',
        ),

        const SizedBox(height: 12),

        _buildLocationRow(
          job.customerAddress,
          'Customer Location',
        ),
      ],
    );
  }

  // ============================================================
  // LOCATION ROW
  // ============================================================

  Widget _buildLocationRow(
      String location,
      String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.location_on_outlined,
          color: primaryBlue,
          size: 21,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 3),

              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO COLUMN
  // ============================================================

  Widget _buildInfoColumn(
      String label,
      String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS CHIP
  // ============================================================

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  // ============================================================
  // SERVICE ICON
  // ============================================================

  Icon _getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'plumbing':
        return const Icon(
          Icons.plumbing,
          color: primaryBlue,
          size: 28,
        );

      case 'electrical':
        return const Icon(
          Icons.electrical_services,
          color: primaryBlue,
          size: 28,
        );

      case 'cleaning':
        return const Icon(
          Icons.cleaning_services,
          color: primaryBlue,
          size: 28,
        );

      case 'delivery':
        return const Icon(
          Icons.local_shipping,
          color: primaryBlue,
          size: 28,
        );

      default:
        return const Icon(
          Icons.build,
          color: primaryBlue,
          size: 28,
        );
    }
  }

  // ============================================================
  // ERROR VIEW
  // ============================================================

  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),

          const SizedBox(height: 16),

          Text(
            'Error: $error',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              setState(() {
                _showMap = false;
                _acceptedJobId = null;
              });
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACCEPT REQUEST
  // ============================================================

  Future<void> _acceptRequest(
      ServiceRequest request) async {
    try {
      await ref
          .read(
        serviceRequestProvider(request.id)
            .notifier,
      )
          .acceptJob(request.id);

      setState(() {
        _showMap = true;
        _acceptedJobId = request.id;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Job accepted! Starting live tracking...',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to accept job: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // DECLINE REQUEST
  // ============================================================

  Future<void> _declineRequest(
      String requestId) async {
    try {
      await ref
          .read(
        serviceRequestProvider(requestId)
            .notifier,
      )
          .declineJob(requestId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job declined'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to decline job: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // ETA
  // ============================================================

  String _calculateETA(int durationMinutes) {
    final now = DateTime.now();

    final eta = now.add(
      Duration(
        minutes: durationMinutes,
      ),
    );

    return DateFormat(
      'hh:mm a',
    ).format(eta);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}