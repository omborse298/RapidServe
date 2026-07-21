import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/service_request_model.dart';
import '../../providers/service_request_provider.dart';

class ActiveJobsScreen extends ConsumerWidget {
  const ActiveJobsScreen({super.key});

  static const Color primaryBlue = Color(0xFF286BE6);
  static const Color darkText = Color(0xFF20202A);
  static const Color lightGrey = Color(0xFFF7F7F7);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceRequests = ref.watch(serviceRequestsProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Active Jobs',
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
            onPressed: () {
              ref.refresh(serviceRequestsProvider);
            },
            icon: const Icon(
              Icons.refresh,
              color: primaryBlue,
            ),
          ),
        ],
      ),

      body: serviceRequests.when(
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
                size: 50,
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
          final activeJobs = requests.where((request) {
            return request.status == 'accepted' ||
                request.status == 'arrived' ||
                request.status == 'in_progress';
          }).toList();

          if (activeJobs.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            color: primaryBlue,

            onRefresh: () {
              return ref.refresh(
                serviceRequestsProvider.future,
              );
            },

            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeJobs.length,

              itemBuilder: (context, index) {
                return _buildActiveJobCard(
                  context,
                  ref,
                  activeJobs[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 70,
            color: Colors.grey[300],
          ),

          const SizedBox(height: 18),

          const Text(
            'No Active Jobs',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Your accepted jobs will appear here',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVE JOB CARD
  // ============================================================

  Widget _buildActiveJobCard(
      BuildContext context,
      WidgetRef ref,
      ServiceRequest job,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),

      elevation: 2,

      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ====================================================
            // HEADER
            // ====================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _getServiceIcon(job.serviceType),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        job.serviceType,

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Customer: ${job.customerName}',

                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                _buildStatusChip(job.status),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 14),

            // ====================================================
            // PROBLEM
            // ====================================================

            if (job.description != null &&
                job.description!.trim().isNotEmpty)
              _buildProblemBox(job.description!),

            if (job.description != null &&
                job.description!.trim().isNotEmpty)
              const SizedBox(height: 16),

            // ====================================================
            // CUSTOMER LOCATION
            // ====================================================

            _buildLocationRow(
              Icons.location_on_outlined,
              'Customer Location',
              job.customerAddress,
            ),

            const SizedBox(height: 14),

            _buildLocationRow(
              Icons.build_outlined,
              'Work Location',
              job.serviceLocation,
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 14),

            // ====================================================
            // JOB INFORMATION
            // ====================================================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                _buildInfoColumn(
                  'Distance',
                  '${job.distance} km',
                ),

                _buildInfoColumn(
                  'Duration',
                  '${job.estimatedDuration} min',
                ),

                _buildInfoColumn(
                  'Fee',
                  '₹${job.serviceFee.toStringAsFixed(2)}',
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 14),

            // ====================================================
            // REQUESTED TIME
            // ====================================================

            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: primaryBlue,
                ),

                const SizedBox(width: 8),

                Text(
                  'Requested at: ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),

                Text(
                  DateFormat(
                    'hh:mm a',
                  ).format(job.requestedAt),

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ====================================================
            // ACTION BUTTONS
            // ====================================================

            _buildActionButtons(
              context,
              ref,
              job,
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

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: primaryBlue,
          width: 1.5,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
              Icon(
                Icons.report_problem_outlined,
                color: primaryBlue,
                size: 21,
              ),

              SizedBox(width: 8),

              Text(
                'Problem Mentioned',

                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            description,

            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.4,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _buildActionButtons(
      BuildContext context,
      WidgetRef ref,
      ServiceRequest job,
      ) {
    if (job.status == 'accepted') {
      return SizedBox(
        width: double.infinity,

        child: ElevatedButton.icon(
          onPressed: () {
            _updateStatus(
              context,
              ref,
              job,
              'arrived',
            );
          },

          icon: const Icon(
            Icons.location_on,
          ),

          label: const Text(
            'Mark Arrived',
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,

            padding: const EdgeInsets.symmetric(
              vertical: 14,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    if (job.status == 'arrived') {
      return SizedBox(
        width: double.infinity,

        child: ElevatedButton.icon(
          onPressed: () {
            _updateStatus(
              context,
              ref,
              job,
              'in_progress',
            );
          },

          icon: const Icon(
            Icons.play_circle_outline,
          ),

          label: const Text(
            'Start Service',
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,

            padding: const EdgeInsets.symmetric(
              vertical: 14,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    if (job.status == 'in_progress') {
      return SizedBox(
        width: double.infinity,

        child: ElevatedButton.icon(
          onPressed: () {
            _updateStatus(
              context,
              ref,
              job,
              'completed',
            );
          },

          icon: const Icon(
            Icons.check_circle_outline,
          ),

          label: const Text(
            'Complete Service',
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,

            padding: const EdgeInsets.symmetric(
              vertical: 14,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  // ============================================================
  // UPDATE STATUS
  // ============================================================

  Future<void> _updateStatus(
      BuildContext context,
      WidgetRef ref,
      ServiceRequest job,
      String status,
      ) async {
    try {
      await ref
          .read(
        serviceRequestProvider(
          job.id,
        ).notifier,
      )
          .updateJobStatus(
        job.id,
        status,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Job status updated to $status',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update job: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // LOCATION ROW
  // ============================================================

  Widget _buildLocationRow(
      IconData icon,
      String label,
      String location,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          color: primaryBlue,
          size: 22,
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

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
                location,

                maxLines: 2,

                overflow:
                TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFORMATION COLUMN
  // ============================================================

  Widget _buildInfoColumn(
      String label,
      String value,
      ) {
    return Column(
      children: [
        Text(
          label,

          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,

          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS CHIP
  // ============================================================

  Widget _buildStatusChip(String status) {
    String statusText = status;

    switch (status) {
      case 'accepted':
        statusText = 'Accepted';
        break;

      case 'arrived':
        statusText = 'Arrived';
        break;

      case 'in_progress':
        statusText = 'In Progress';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Text(
        statusText,

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

  Icon _getServiceIcon(
      String serviceType,
      ) {
    switch (
    serviceType.toLowerCase()) {
      case 'plumbing':
        return const Icon(
          Icons.plumbing,
          color: primaryBlue,
          size: 30,
        );

      case 'electrical':
        return const Icon(
          Icons.electrical_services,
          color: primaryBlue,
          size: 30,
        );

      case 'cleaning':
        return const Icon(
          Icons.cleaning_services,
          color: primaryBlue,
          size: 30,
        );

      case 'delivery':
        return const Icon(
          Icons.local_shipping,
          color: primaryBlue,
          size: 30,
        );

      case 'ac repair':
        return const Icon(
          Icons.ac_unit,
          color: primaryBlue,
          size: 30,
        );

      default:
        return const Icon(
          Icons.build,
          color: primaryBlue,
          size: 30,
        );
    }
  }
}