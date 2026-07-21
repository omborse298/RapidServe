import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_request_model.dart';

final serviceRequestsProvider =
AsyncNotifierProvider<ServiceRequestsNotifier,
    List<ServiceRequest>>(
  ServiceRequestsNotifier.new,
);

class ServiceRequestsNotifier
    extends AsyncNotifier<List<ServiceRequest>> {
  @override
  Future<List<ServiceRequest>> build() async {
    return _getDemoRequests();
  }

  List<ServiceRequest> _getDemoRequests() {
    return [
      ServiceRequest(
        id: 'request_001',
        serviceType: 'Plumbing',
        customerName: 'Rahul Sharma',
        customerAddress: 'Mumbai, Maharashtra',
        serviceLocation: 'Kitchen pipe repair',
        status: 'requested',
        distance: 2.5,
        estimatedDuration: 30,
        customerRating: 4.7,
        customerReviews: 35,
        serviceFee: 850.0,
        requestedAt: DateTime.now(),
        description:
        'Water leakage under the kitchen sink.',
        customerLatitude: 19.0760,
        customerLongitude: 72.8777,
        customerProfileImage:
        'https://via.placeholder.com/150',
      ),
      ServiceRequest(
        id: 'request_002',
        serviceType: 'Electrical',
        customerName: 'Ayesha Khan',
        customerAddress: 'Andheri, Mumbai',
        serviceLocation: 'Living room electrical repair',
        status: 'requested',
        distance: 4.2,
        estimatedDuration: 45,
        customerRating: 4.8,
        customerReviews: 22,
        serviceFee: 1200.0,
        requestedAt:
        DateTime.now().subtract(const Duration(minutes: 10)),
        description:
        'Power socket is not working.',
        customerLatitude: 19.1197,
        customerLongitude: 72.8468,
        customerProfileImage:
        'https://via.placeholder.com/150',
      ),
    ];
  }

  Future<void> refreshRequests() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () async => _getDemoRequests(),
    );
  }
}

final serviceRequestProvider = AsyncNotifierProvider.family<
    ServiceRequestNotifier,
    ServiceRequest?,
    String>(
  ServiceRequestNotifier.new,
);

class ServiceRequestNotifier
    extends FamilyAsyncNotifier<ServiceRequest?, String> {
  late String requestId;

  @override
  Future<ServiceRequest?> build(String arg) async {
    requestId = arg;

    final requests =
    await ref.watch(serviceRequestsProvider.future);

    try {
      return requests.firstWhere(
            (request) => request.id == arg,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> acceptJob(String id) async {
    final current = state.value;

    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        status: 'accepted',
      ),
    );
  }

  Future<void> declineJob(String id) async {
    final current = state.value;

    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        status: 'declined',
      ),
    );
  }

  Future<void> updateJobStatus(
      String id,
      String status,
      ) async {
    final current = state.value;

    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        status: status,
      ),
    );
  }
}

final acceptedJobProvider =
FutureProvider.family<ServiceRequest?, String>(
      (ref, jobId) async {
    final requests =
    await ref.watch(serviceRequestsProvider.future);

    try {
      return requests.firstWhere(
            (request) => request.id == jobId,
      );
    } catch (_) {
      return null;
    }
  },
);