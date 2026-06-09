import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';

/// Model for a service category tile
class ServiceCategory {
  final String icon;
  final String label;
  final bool isSvg;

  const ServiceCategory({
    required this.icon,
    required this.label,
    this.isSvg = false,
  });
}

/// Model for a special offer / banner card
class OfferBanner {
  final String tag;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final Color bgColor;

  const OfferBanner({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.bgColor,
  });
}

/// Model for a popular service card
class PopularService {
  final String imagePath;
  final String title;
  final String buttonLabel;

  const PopularService({
    required this.imagePath,
    required this.title,
    required this.buttonLabel,
  });
}

/// Model for a user story card
class UserStory {
  final String imagePath;
  final String title;

  const UserStory({required this.imagePath, required this.title});
}

class HomeController extends GetxController {
  // ── State ────────────────────────────────────────────────────────────────────

  final String userName = 'Jagritii';
  final String address = 'CDS Stores, Greenfall Road...';
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  /// Index of the currently visible special offer banner
  final RxInt offerBannerIndex = 0.obs;

  // ── Data ─────────────────────────────────────────────────────────────────────

  final List<ServiceCategory> serviceCategories = const [
    ServiceCategory(
      icon: 'assets/images/smart.png',
      label: 'Smart Home Installations',
    ),
    ServiceCategory(
      icon: 'assets/images/tv_mountain.png',
      label: 'TV\nMounting',
    ),
    ServiceCategory(
      icon: 'assets/images/wifi_icon.png',
      label: 'WiFi &\nNetworking',
    ),
    ServiceCategory(
      icon: 'assets/images/computer_device_support.png',
      label: 'Computer & Device Support',
    ),
    ServiceCategory(
      icon: 'assets/images/security.png',
      label: 'Security & Surveillance',
    ),
    ServiceCategory(
      icon: 'assets/images/video.png',
      label: 'Audio & Video\nDevice Setup',
    ),
  ];

  final List<OfferBanner> specialOffers = const [
    OfferBanner(
      tag: 'EXCLUSIVE DEAL',
      title: 'Summer Offer\n20% Off AC\nServices',
      subtitle: '',
      buttonLabel: 'Book Now',
      bgColor: Color(0xFFFFBB5E),
    ),
    OfferBanner(
      tag: 'LIMITED TIME',
      title: 'Winter Offer\n15% Off\nHeating Setup',
      subtitle: '',
      buttonLabel: 'Book Now',
      bgColor: Color(0xFFADD8E6),
    ),
  ];

  final List<PopularService> popularServices =  [
    PopularService(
      imagePath: AppAssets.serviceImage,
      title: 'TV Mount AC',
      buttonLabel: 'Book a Service',
    ),
    PopularService(
      imagePath: AppAssets.serviceImage,
      title: 'TV Mount AC',
      buttonLabel: 'Book a Service',
    ),
    PopularService(
      imagePath: AppAssets.serviceImage,
      title: 'TV Mount AC',
      buttonLabel: 'Book a Service',
    ),
  ];

  final List<UserStory> userStories = const [
    UserStory(
      imagePath: 'assets/images/onboarding_image_2.png',
      title: 'Got cleaned water\nheater fixed',
    ),
    UserStory(
      imagePath: 'assets/images/onboarding_image_1.png',
      title: 'Got their home\nRepairs &...',
    ),
  ];

  // ── Helpers ──────────────────────────────────────────────────────────────────

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onOfferPageChanged(int index) {
    offerBannerIndex.value = index;
  }

  void onViewAllServicesTapped() {
    // TODO: navigate to services list
  }

  void onViewAllOffersTapped() {
    // TODO: navigate to offers list
  }

  void onViewAllPopularTapped() {
    // TODO: navigate to popular services list
  }

  void onViewAllStoriesTapped() {
    // TODO: navigate to stories list
  }

  void onServiceCategoryTapped(ServiceCategory category) {
    // TODO: navigate to service category detail
  }

  void onSpecialOfferBookNow(OfferBanner offer) {
    // TODO: navigate to booking
  }

  void onPopularServiceBook(PopularService service) {
    // TODO: navigate to booking
  }

  void onNeedHelpSosTapped() {
    // TODO: trigger SOS / help flow
  }

  void onSquadCarePlusTapped() {
    // TODO: navigate to Squad Care+ detail
  }

  void onSummerHeatBannerTapped() {
    // TODO: navigate to summer deal
  }

  void onNotificationsTapped() {
    // TODO: navigate to notifications
  }

  void onProfileTapped() {
    // TODO: navigate to profile
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
