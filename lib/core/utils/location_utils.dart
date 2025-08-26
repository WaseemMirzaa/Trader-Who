import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utility class for converting coordinates to readable addresses
///
/// Usage examples:
/// ```dart
/// // Convert lat/lng to address
/// String address = await LocationUtils.getAddressFromCoordinates(37.7749, -122.4194);
///
/// // Convert LatLng object to address
/// LatLng location = LatLng(37.7749, -122.4194);
/// String address = await LocationUtils.getAddressFromLatLng(location);
///
/// // Get short address (city, state)
/// String shortAddress = await LocationUtils.getShortAddressFromCoordinates(37.7749, -122.4194);
///
/// // Get only city name
/// String city = await LocationUtils.getCityFromCoordinates(37.7749, -122.4194);
///
/// // Validate coordinates
/// bool isValid = LocationUtils.areCoordinatesValid(37.7749, -122.4194);
/// ```
class LocationUtils {
  /// Convert latitude and longitude to a readable address
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // Check if coordinates are valid
      if (latitude == 0.0 && longitude == 0.0) {
        return 'Location not specified';
      }

      // Perform reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Build address string from placemark components
        List<String> addressParts = [];

        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }

        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }

        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }

        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }

        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          addressParts.add(place.postalCode!);
        }

        // Return formatted address or fallback
        if (addressParts.isNotEmpty) {
          return addressParts
              .take(3)
              .join(', '); // Limit to first 3 components to keep it concise
        }
      }

      // Fallback to coordinates if reverse geocoding fails
      return 'Lat: ${latitude.toStringAsFixed(4)}, Lon: ${longitude.toStringAsFixed(4)}';
    } catch (e) {
      print('❌ Error getting address from coordinates: $e');
      // Return coordinates as fallback
      return 'Lat: ${latitude.toStringAsFixed(4)}, Lon: ${longitude.toStringAsFixed(4)}';
    }
  }

  /// Convert LatLng object to a readable address
  static Future<String> getAddressFromLatLng(LatLng latLng) async {
    return await getAddressFromCoordinates(latLng.latitude, latLng.longitude);
  }

  /// Get a short address (city, state) from coordinates
  static Future<String> getShortAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      if (latitude == 0.0 && longitude == 0.0) {
        return 'Location not specified';
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        List<String> addressParts = [];

        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }

        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }

        if (addressParts.isNotEmpty) {
          return addressParts.join(', ');
        }
      }

      return 'Unknown Location';
    } catch (e) {
      print('❌ Error getting short address: $e');
      return 'Unknown Location';
    }
  }

  /// Get city name from coordinates
  static Future<String> getCityFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      if (latitude == 0.0 && longitude == 0.0) {
        return 'Unknown City';
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
      }

      return 'Unknown City';
    } catch (e) {
      print('❌ Error getting city from coordinates: $e');
      return 'Unknown City';
    }
  }

  /// Check if coordinates are valid (not zero and within reasonable bounds)
  static bool areCoordinatesValid(double latitude, double longitude) {
    return latitude != 0.0 &&
        longitude != 0.0 &&
        latitude >= -90.0 &&
        latitude <= 90.0 &&
        longitude >= -180.0 &&
        longitude <= 180.0;
  }
}
