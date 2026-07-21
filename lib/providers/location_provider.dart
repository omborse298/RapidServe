import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationProvider = FutureProvider<Position>((ref) async {
  final serviceEnabled =
  await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission =
  await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission =
    await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception('Location permission denied.');
  }

  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );
});