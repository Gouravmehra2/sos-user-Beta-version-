import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';

class LocationPermissionController extends GetxController {
  final RxString address = ''.obs;
  final RxBool isFetching = false.obs;

  Future<void> requestLocationAndFetch() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) return;

    isFetching.value = true;

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final p = placemarks.first;
      address.value = [
        p.name,
        p.subLocality,
        p.locality,
        p.administrativeArea,
      ].where((s) => s != null && s.isNotEmpty).join(', ');

      await Future.delayed(const Duration(seconds: 2));
    } finally {
      isFetching.value = false;
    }

    Get.offNamed(AppRoutes.locationDetailScreen);
  }
}
