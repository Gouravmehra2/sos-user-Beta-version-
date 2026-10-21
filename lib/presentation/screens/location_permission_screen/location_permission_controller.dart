import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/core/helpers/location_permission_helper.dart';

class LocationPermissionController extends GetxController {
  final RxString address = ''.obs;
  final RxBool isFetching = false.obs;

  Future<LatLng?> requestLocationAndFetch() async {
    if (isFetching.value) return null;
    isFetching.value = true;
    try {
      final permission = await LocationPermissionHelper.request();
      if (permission != LocationPermissionResult.granted) return null;
      final position = await LocationPermissionHelper.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      AppSnackbar.show(
        'Location unavailable',
        'Please try again or enter your address manually.',
      );
      return null;
    } finally {
      isFetching.value = false;
    }
  }
}
