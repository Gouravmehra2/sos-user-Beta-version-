import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

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

/// Model for a summer-heat banner slide
class SummerBanner {
  final String imagePath;
  final VoidCallback? onTap;

  const SummerBanner({required this.imagePath, this.onTap});
}

/// Model for a user story card – supports both image and video assets.
class UserStory {
  final String mediaPath;
  final String title;

  /// When [isVideo] is true, [mediaPath] points to an asset video file.
  /// Otherwise it is treated as an image asset.
  final bool isVideo;

  const UserStory({
    required this.mediaPath,
    required this.title,
    this.isVideo = false,
  });
}

class HomeController extends GetxController {
  String userName = 'User';
  String address = 'Your location';
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString selectedDateFilter = 'Today'.obs;
  final List<String> serviceSuggestions = [
    'AC Repair',
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Appliance Repair',
    'Painting',
    'Pest Control',
  ];
  final RxBool isProfileLoading = false.obs;
  HomeProfileUser? profile;
  final RxInt offerBannerIndex = 0.obs;

  // Search
  final RxList<ServiceItem> searchResults = <ServiceItem>[].obs;
  final RxBool isLoadingSearch = false.obs;
  final RxBool isLoadingMoreSearch = false.obs;
  final RxBool hasMoreSearch = false.obs;
  final RxBool isSearchMode = false.obs;
  final RxBool showSearchSuggestions = false.obs;
  Worker? _debounceWorker;
  final _searchQuery = ''.obs;
  int _searchVersion = 0;
  int _searchPage = 1;
  static const int _pageSize = 10;

  // Featured services
  final RxList<FeaturedServiceItem> featuredServices =
      <FeaturedServiceItem>[].obs;
  final RxBool isLoadingFeatured = false.obs;
  final RxBool isLoadingMoreFeatured = false.obs;
  final RxBool hasMoreFeatured = false.obs;
  int _featuredPage = 1;

  @override
  void onInit() {
    super.onInit();
    final initialProfile = Get.arguments;
    if (initialProfile is HomeProfileUser) {
      profile = initialProfile;
      userName = initialProfile.name.isNotEmpty ? initialProfile.name : 'User';
      address =
          initialProfile.defaultAddress?.displayAddress ?? 'Your location';
    } else {
      fetchUserProfile();
    }
    fetchFeaturedServices();
    _debounceWorker = debounce(
      _searchQuery,
      (String q) => _runSearch(q),
      time: const Duration(milliseconds: 300),
    );
  }

  void onSearchChanged(String value) {
    _searchVersion++;
    isLoadingMoreSearch.value = false;
    _searchQuery.value = value;
    searchQuery.value = value;
    if (value.trim().isEmpty) {
      isLoadingSearch.value = false;
      isSearchMode.value = false;
      showSearchSuggestions.value = false;
      searchResults.clear();
      hasMoreSearch.value = false;
    } else {
      isSearchMode.value = true;
      showSearchSuggestions.value = true;
    }
  }

  void showSearchSuggestionsAgain() {
    if (isSearchMode.value) showSearchSuggestions.value = true;
  }

  void hideSearchSuggestions() {
    showSearchSuggestions.value = false;
  }

  void clearSearch() {
    _searchVersion++;
    isLoadingMoreSearch.value = false;
    isLoadingSearch.value = false;
    searchController.clear();
    _searchQuery.value = '';
    searchQuery.value = '';
    isSearchMode.value = false;
    showSearchSuggestions.value = false;
    searchResults.clear();
    hasMoreSearch.value = false;
  }

  Future<void> _runSearch(String query) async {
    if (query.trim().isEmpty) return;
    final version = _searchVersion;
    _searchPage = 1;
    hasMoreSearch.value = false;
    isLoadingSearch.value = true;
    try {
      final results = await Get.find<ApiRepo>().searchServices(
        query.trim(),
        page: 1,
        limit: _pageSize,
      );
      if (!isClosed && version == _searchVersion) {
        searchResults.assignAll(results.items);
        hasMoreSearch.value = results.hasMore && results.items.isNotEmpty;
      }
    } catch (_) {
      if (!isClosed && version == _searchVersion) searchResults.clear();
    } finally {
      if (!isClosed && version == _searchVersion) isLoadingSearch.value = false;
    }
  }

  Future<void> loadMoreSearchResults() async {
    final query = _searchQuery.value.trim();
    if (query.isEmpty ||
        !hasMoreSearch.value ||
        isLoadingSearch.value ||
        isLoadingMoreSearch.value) {
      return;
    }
    final version = _searchVersion;
    isLoadingMoreSearch.value = true;
    try {
      final nextPage = _searchPage + 1;
      final result = await Get.find<ApiRepo>().searchServices(
        query,
        page: nextPage,
        limit: _pageSize,
      );
      if (isClosed || version != _searchVersion) return;
      final knownIds = searchResults.map((item) => item.id).toSet();
      final newItems = result.items
          .where((item) => item.id.isEmpty || knownIds.add(item.id))
          .toList();
      searchResults.addAll(newItems);
      _searchPage = nextPage;
      hasMoreSearch.value = result.hasMore && newItems.isNotEmpty;
    } catch (_) {
      // Keep already loaded results available if a later page fails.
    } finally {
      if (!isClosed && version == _searchVersion) {
        isLoadingMoreSearch.value = false;
      }
    }
  }

  Future<void> refreshData() async {
    await Future.wait([fetchUserProfile(), fetchFeaturedServices()]);
  }

  /// Featured cards are summaries; resolve the full record before opening
  /// details or booking so variants and add-ons are available in both flows.
  Future<ServiceItem> loadFeaturedService(FeaturedServiceItem featured) async {
    if (featured.id.isEmpty) {
      throw StateError("Service ID is missing.".tr);
    }
    final services = await Get.find<ApiRepo>().searchServices(
      featured.name,
      page: 1,
      limit: _pageSize,
    );
    for (final service in services.items) {
      if (service.id == featured.id) return service;
    }
    throw StateError("This service is currently unavailable.".tr);
  }

  Future<void> fetchFeaturedServices() => _fetchFeaturedServices(reset: true);

  Future<void> _fetchFeaturedServices({required bool reset}) async {
    if (isLoadingFeatured.value || isLoadingMoreFeatured.value) return;
    if (reset) {
      _featuredPage = 1;
      hasMoreFeatured.value = false;
      isLoadingFeatured.value = true;
    } else {
      if (!hasMoreFeatured.value) return;
      isLoadingMoreFeatured.value = true;
    }
    try {
      final page = reset ? 1 : _featuredPage + 1;
      final results = await Get.find<ApiRepo>().getFeaturedServices(
        page: page,
        limit: _pageSize,
      );
      if (reset) {
        featuredServices.assignAll(results.items);
        hasMoreFeatured.value = results.hasMore && results.items.isNotEmpty;
      } else {
        final knownIds = featuredServices.map((item) => item.id).toSet();
        final newItems = results.items
            .where((item) => item.id.isEmpty || knownIds.add(item.id))
            .toList();
        featuredServices.addAll(newItems);
        hasMoreFeatured.value = results.hasMore && newItems.isNotEmpty;
      }
      _featuredPage = page;
    } catch (_) {
      // silently fail — carousel stays empty
    } finally {
      isLoadingFeatured.value = false;
      isLoadingMoreFeatured.value = false;
    }
  }

  Future<void> loadMoreFeaturedServices() =>
      _fetchFeaturedServices(reset: false);

  Future<void> fetchUserProfile() async {
    if (isProfileLoading.value) return;

    isProfileLoading.value = true;
    try {
      final response = await Get.find<ApiRepo>().meProfile();
      final user = response.data.user;
      profile = user;
      userName = user.name.isNotEmpty ? user.name : 'User';
      address = user.defaultAddress?.displayAddress ?? 'Your location';
      update();
    } catch (error) {
      AppSnackbar.show("nav_profile".tr, "Unable to load profile details.".tr);
    } finally {
      isProfileLoading.value = false;
    }
  }

  // ── Data ─────────────────────────────────────────────────────────────────────

  List<ServiceCategory> get serviceCategories => [
    ServiceCategory(
      icon: 'assets/images/smart.png',
      label: 'home_cat_smart_home'.tr,
    ),
    ServiceCategory(
      icon: 'assets/images/tv_mountain.png',
      label: 'home_cat_tv_mount'.tr,
    ),
    ServiceCategory(
      icon: 'assets/images/wifi_icon.png',
      label: 'home_cat_wifi'.tr,
    ),
    ServiceCategory(
      icon: 'assets/images/computer_device_support.png',
      label: 'home_cat_computer'.tr,
    ),
    ServiceCategory(
      icon: 'assets/images/security.png',
      label: 'home_cat_security'.tr,
    ),
    ServiceCategory(
      icon: 'assets/images/video.png',
      label: 'home_cat_audio_video'.tr,
    ),
  ];

  List<OfferBanner> get specialOffers => [
    OfferBanner(
      tag: 'home_offer_tag_exclusive'.tr,
      title: 'home_offer1_title'.tr,
      subtitle: '',
      buttonLabel: 'home_offer_book_now'.tr,
      bgColor: const Color(0xFFFFBB5E),
    ),
    OfferBanner(
      tag: 'home_offer_tag_limited'.tr,
      title: 'home_offer2_title'.tr,
      subtitle: '',
      buttonLabel: 'home_offer_book_now'.tr,
      bgColor: const Color(0xFFADD8E6),
    ),
  ];

  List<PopularService> get popularServices => [
    PopularService(
      imagePath: AppAssets.serviceImage,
      title: "TV Mount AC".tr,
      buttonLabel: 'home_popular_book_service'.tr,
    ),
    PopularService(
      imagePath: AppAssets.serviceImage,
      title: "TV Mount AC".tr,
      buttonLabel: 'home_popular_book_service'.tr,
    ),
    PopularService(
      imagePath: AppAssets.serviceImage,
      title: "TV Mount AC".tr,
      buttonLabel: 'home_popular_book_service'.tr,
    ),
  ];

  final List<SummerBanner> summerBanners = [
    SummerBanner(imagePath: AppAssets.bannerImage1),
    SummerBanner(imagePath: AppAssets.bannerImage2),
    SummerBanner(imagePath: AppAssets.bannerImage3),
  ];

  List<UserStory> get userStories => [
    UserStory(
      mediaPath: 'assets/images/service_video.mp4',
      title: 'home_story1_title'.tr,
      isVideo: true,
    ),
    UserStory(
      mediaPath: 'assets/images/onboarding_image_2.png',
      title: 'home_story2_title'.tr,
    ),
    UserStory(
      mediaPath: 'assets/images/onboarding_image_1.png',
      title: 'home_story3_title'.tr,
    ),
  ];

  // ── Helpers ──────────────────────────────────────────────────────────────────

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'home_greeting_morning'.tr;
    if (hour < 17) return 'home_greeting_afternoon'.tr;
    return 'home_greeting_evening'.tr;
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
    Get.toNamed(AppRoutes.notificationScreen);
  }

  void onProfileTapped() {
    // TODO: navigate to profile
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounceWorker?.dispose();
    super.onClose();
  }
}
