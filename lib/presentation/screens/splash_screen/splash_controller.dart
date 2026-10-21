import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';

class SplashController extends GetxController {
  final error = ''.obs;
  bool _checking = false;

  @override
  void onReady() {
    super.onReady();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    if (_checking || isClosed) return;
    _checking = true;
    error.value = '';
    final session = Get.find<AuthSession>();
    try {
      await session.restoreFromStorage();
      if (isClosed) return;
      if (!session.hasToken) {
        Get.offAllNamed(AppRoutes.onboardingScreen);
        return;
      }
      final response = await Get.find<ApiRepo>().meProfile();
      if (isClosed) return;
      Get.offAllNamed(
        response.data.user.addresses.isEmpty
            ? AppRoutes.locationPermissionScreen
            : AppRoutes.dashboardScreen,
        arguments: response.data.user,
      );
    } catch (exception) {
      if (isClosed) return;
      if (exception is ApiException && exception.statusCode == 401) {
        await session.clearSession();
        Get.offAllNamed(AppRoutes.onboardingScreen);
      } else {
        error.value =
            'Unable to connect. Please check your connection and retry.';
      }
    } finally {
      _checking = false;
    }
  }
}
