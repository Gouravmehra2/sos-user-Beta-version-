import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

class CategoryItem {
  final String label;
  final IconData icon;
  const CategoryItem({required this.label, required this.icon});
}

class HeroBanner {
  final String title;
  final String titleHighlight;
  final String subtitle;
  final String imagePath;
  const HeroBanner({
    required this.title,
    this.titleHighlight = '',
    required this.subtitle,
    required this.imagePath,
  });
}

class HomeServicesController extends GetxController {
  final selectedTabIndex = 0.obs;
  final showAllCategories = false.obs;

  final tabs = ['All', 'Home Services', 'Business Services'];

  final heroBanners = [
    HeroBanner(
      title: "Professional\nCleaning for a\nHealthier Home".tr,
      titleHighlight: 'Cleaning',
      subtitle: "Book trusted experts\nat your doorstep.".tr,
      imagePath: AppAssets.onboardingImage1,
    ),
    HeroBanner(
      title: "Home Services".tr,
      subtitle:
          "Trusted professionals for all your home maintenance and repair needs."
              .tr,
      imagePath: AppAssets.onboardingImage2,
    ),
    HeroBanner(
      title: "Business Services".tr,
      subtitle: "Professional solutions for your business needs.".tr,
      imagePath: AppAssets.onboardingImage1,
    ),
  ];

  final allServiceCategories = [
    CategoryItem(
      label: "Home\nServices".tr,
      icon: Icons.home_repair_service_outlined,
    ),
    CategoryItem(
      label: "Business\nServices".tr,
      icon: Icons.business_center_outlined,
    ),
    CategoryItem(label: "IT &\nTechnology".tr, icon: Icons.computer_outlined),
    CategoryItem(
      label: "Marketing &\nBranding".tr,
      icon: Icons.campaign_outlined,
    ),
    CategoryItem(
      label: "Professional\nServices".tr,
      icon: Icons.build_outlined,
    ),
    CategoryItem(label: "Health &\nWellness".tr, icon: Icons.favorite_border),
    CategoryItem(
      label: "Beauty &\nPersonal Care".tr,
      icon: Icons.content_cut_outlined,
    ),
    CategoryItem(
      label: "Transportation\nServices".tr,
      icon: Icons.directions_car_outlined,
    ),
  ];

  final homeServiceCategories = [
    CategoryItem(label: "AC & Appliance".tr, icon: Icons.ac_unit_outlined),
    CategoryItem(label: "Carpentry".tr, icon: Icons.carpenter),
    CategoryItem(label: "Cleaning".tr, icon: Icons.cleaning_services_outlined),
    CategoryItem(label: "Diagnostic".tr, icon: Icons.home_outlined),
    CategoryItem(label: "Electrical".tr, icon: Icons.lightbulb_outline),
    CategoryItem(label: "Gardening".tr, icon: Icons.yard_outlined),
    CategoryItem(label: "Handyman".tr, icon: Icons.handyman_outlined),
    CategoryItem(label: "Home Theater".tr, icon: Icons.tv_outlined),
    CategoryItem(label: "Painting".tr, icon: Icons.format_paint_outlined),
    CategoryItem(label: "Pest Control".tr, icon: Icons.pest_control_outlined),
    CategoryItem(label: "Plumbing".tr, icon: Icons.plumbing_outlined),
    CategoryItem(label: "Smart Home".tr, icon: Icons.home_outlined),
    CategoryItem(label: "TV Mounting".tr, icon: Icons.tv_outlined),
  ];

  final popularServices = [
    ServiceItem(
      id: '1',
      name: 'Smart Lock - Video Doorbell Setup',
      actualPrice: 10,
      offerPrice: 10,
      ratingsAverage: 4.3,
      ratingsQuantity: 124,
      featuredImage: '',
      shortDescription: '',
      longDescription: '',
      serviceDuration: 0,
      addons: [],
      includedItems: [],
      excludedItems: [],
      faqs: [],
      gallery: [],
    ),
    ServiceItem(
      id: '2',
      name: 'Thermostats Installation',
      actualPrice: 10,
      offerPrice: 10,
      ratingsAverage: 4.3,
      ratingsQuantity: 124,
      featuredImage: '',
      shortDescription: '',
      longDescription: '',
      serviceDuration: 0,
      addons: [],
      includedItems: [],
      excludedItems: [],
      faqs: [],
      gallery: [],
    ),
    ServiceItem(
      id: '3',
      name: 'TV Mounting',
      actualPrice: 10,
      offerPrice: 10,
      ratingsAverage: 4.3,
      ratingsQuantity: 124,
      featuredImage: '',
      shortDescription: '',
      longDescription: '',
      serviceDuration: 0,
      addons: [],
      includedItems: [],
      excludedItems: [],
      faqs: [],
      gallery: [],
    ),
  ];

  List<CategoryItem> get baseCategories => selectedTabIndex.value == 1
      ? homeServiceCategories
      : allServiceCategories;

  List<CategoryItem> get visibleCategories {
    final cats = baseCategories;
    if (selectedTabIndex.value == 1) {
      if (showAllCategories.value) {
        return cats;
      }
      return cats.take(7).toList();
    }
    return cats;
  }

  bool get canToggle => selectedTabIndex.value == 1;

  HeroBanner get currentBanner => heroBanners[selectedTabIndex.value];

  String get appBarTitle {
    if (selectedTabIndex.value == 1) return 'Home Services';
    if (selectedTabIndex.value == 2) return 'Business Services';
    return 'All Services';
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
    showAllCategories.value = false;
  }

  void toggleCategories() => showAllCategories.value = !showAllCategories.value;
}
