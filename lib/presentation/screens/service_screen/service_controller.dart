import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

export 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

/// Maps grid title → category ID
const Map<String, String> kCategoryIds = {
  'PC': '6ab2c087371b87cdfa867bb3',
  'Printer': '6ab2c094371b87cdfa867bbb',
  'Home Appliances': '6ab2c0a4371b87cdfa867bc3',
  'Networking': '6ab2c0b7371b87cdfa867bcb',
};

/// Maps category title → SVG asset pair
final Map<String, List<String>> kCategoryIcons = {
  'PC': [
    AppAssets.computerDeviceOutlineImage,
    AppAssets.computerDeviceFilledImage,
  ],
  'Printer': [AppAssets.tvOutlineImage, AppAssets.tvFilledImage],
  'Home Appliances': [
    AppAssets.smartHomeOutlineImage,
    AppAssets.smartHomeFilledImage,
  ],
  'Networking': [AppAssets.wifiOutlineImage, AppAssets.wifiFilledImage],
};

class ServiceController extends GetxController {
  static const int pageSize = 10;

  ServiceController({this.initialTitle, this.initialCategoryId});
  final String? initialTitle;
  final String? initialCategoryId;

  final selectedIndex = 0.obs;
  final isLoadingSubcategories = true.obs;
  final isLoadingMoreSubcategories = false.obs;
  final hasMoreSubcategories = true.obs;
  final isLoadingServices = false.obs;
  final isLoadingMoreServices = false.obs;
  final hasMoreServices = true.obs;

  final rightScrollController = ScrollController();
  final leftScrollController = ScrollController();

  int _categoryVersion = 0;
  int _servicesVersion = 0;
  int _subcategoryPage = 1;
  int _servicePage = 1;
  String? _activeSubcategoryId;

  final RxList<SubcategoryItem> subcategories = <SubcategoryItem>[].obs;
  final RxList<ServiceItem> services = <ServiceItem>[].obs;

  String categoryId = kCategoryIds['PC']!;
  String categoryTitle = 'PC';

  @override
  void onInit() {
    super.onInit();
    leftScrollController.addListener(_onSubcategoryScroll);
    rightScrollController.addListener(_onServiceScroll);
    final rawArgs = Get.arguments;
    final args = rawArgs is Map<String, dynamic>
        ? rawArgs
        : <String, dynamic>{};
    categoryTitle = initialTitle ?? args['title'] as String? ?? 'PC';
    categoryId =
        initialCategoryId ??
        args['categoryId'] as String? ??
        kCategoryIds['PC']!;
    _fetchSubcategories();
  }

  void _onSubcategoryScroll() {
    if (!leftScrollController.hasClients ||
        leftScrollController.position.extentAfter > 200) {
      return;
    }
    loadMoreSubcategories();
  }

  void _onServiceScroll() {
    if (!rightScrollController.hasClients ||
        rightScrollController.position.extentAfter > 300) {
      return;
    }
    final id = _activeSubcategoryId;
    if (id != null) loadMoreServices(id);
  }

  void setCategory({required String title, required String categoryId}) {
    if (this.categoryId == categoryId &&
        (isLoadingSubcategories.value || subcategories.isNotEmpty))
      return;
    categoryTitle = title;
    this.categoryId = categoryId;
    _fetchSubcategories();
  }

  Future<void> refreshData() async {
    selectedIndex.value = 0;
    await _fetchSubcategories();
  }

  Future<void> _fetchSubcategories() async {
    final version = ++_categoryVersion;
    _servicesVersion++;
    _subcategoryPage = 1;
    hasMoreSubcategories.value = true;
    isLoadingMoreSubcategories.value = false;
    _servicePage = 1;
    hasMoreServices.value = true;
    isLoadingMoreServices.value = false;
    _activeSubcategoryId = null;
    selectedIndex.value = 0;
    services.clear();
    isLoadingServices.value = false;
    isLoadingSubcategories.value = true;
    try {
      final res = await Get.find<ApiRepo>().getSubcategories(
        categoryId,
        page: 1,
        limit: pageSize,
      );
      if (isClosed || version != _categoryVersion) return;
      subcategories.assignAll(res.subcategories);
      hasMoreSubcategories.value = res.hasMore && res.subcategories.isNotEmpty;
      _subcategoryPage = 1;
      if (subcategories.isNotEmpty) {
        await _fetchServices(subcategories[0].id);
      }
    } catch (e) {
      if (!isClosed && version == _categoryVersion)
        AppSnackbar.show('Error', 'Failed to load subcategories.');
    } finally {
      if (!isClosed && version == _categoryVersion)
        isLoadingSubcategories.value = false;
    }
  }

  Future<void> loadMoreSubcategories() async {
    if (isLoadingSubcategories.value ||
        isLoadingMoreSubcategories.value ||
        !hasMoreSubcategories.value) {
      return;
    }
    final version = _categoryVersion;
    isLoadingMoreSubcategories.value = true;
    try {
      final page = _subcategoryPage + 1;
      final res = await Get.find<ApiRepo>().getSubcategories(
        categoryId,
        page: page,
        limit: pageSize,
      );
      if (isClosed || version != _categoryVersion) return;
      final existingIds = subcategories.map((item) => item.id).toSet();
      final newItems = res.subcategories
          .where((item) => item.id.isEmpty || !existingIds.contains(item.id))
          .toList();
      subcategories.addAll(newItems);
      _subcategoryPage = page;
      hasMoreSubcategories.value = res.hasMore && newItems.isNotEmpty;
    } catch (e) {
      if (!isClosed && version == _categoryVersion) {
        AppSnackbar.show('Error', 'Failed to load more subcategories.');
      }
    } finally {
      if (!isClosed && version == _categoryVersion) {
        isLoadingMoreSubcategories.value = false;
      }
    }
  }

  Future<void> _fetchServices(String subcategoryId) async {
    final version = ++_servicesVersion;
    _activeSubcategoryId = subcategoryId;
    _servicePage = 1;
    hasMoreServices.value = true;
    isLoadingMoreServices.value = false;
    isLoadingServices.value = true;
    try {
      final res = await Get.find<ApiRepo>().getServicesBySubcategory(
        subcategoryId,
        page: 1,
        limit: pageSize,
      );
      if (isClosed || version != _servicesVersion) return;
      services.assignAll(res.services);
      hasMoreServices.value = res.hasMore && res.services.isNotEmpty;
      _servicePage = 1;
    } catch (e) {
      if (!isClosed && version == _servicesVersion) {
        AppSnackbar.show('Error', 'Failed to load services.');
      }
    } finally {
      if (!isClosed && version == _servicesVersion) {
        isLoadingServices.value = false;
      }
    }
  }

  Future<void> loadMoreServices(String subcategoryId) async {
    if (isLoadingServices.value ||
        isLoadingMoreServices.value ||
        !hasMoreServices.value ||
        subcategoryId != _activeSubcategoryId) {
      return;
    }
    final version = _servicesVersion;
    isLoadingMoreServices.value = true;
    try {
      final page = _servicePage + 1;
      final res = await Get.find<ApiRepo>().getServicesBySubcategory(
        subcategoryId,
        page: page,
        limit: pageSize,
      );
      if (isClosed || version != _servicesVersion) return;
      final existingIds = services.map((item) => item.id).toSet();
      final newItems = res.services
          .where((item) => item.id.isEmpty || !existingIds.contains(item.id))
          .toList();
      services.addAll(newItems);
      _servicePage = page;
      hasMoreServices.value = res.hasMore && newItems.isNotEmpty;
    } catch (_) {
      if (!isClosed && version == _servicesVersion) {
        AppSnackbar.show('Error', 'Failed to load more services.');
      }
    } finally {
      if (!isClosed && version == _servicesVersion) {
        isLoadingMoreServices.value = false;
      }
    }
  }

  void onCategoryTap(int index) {
    if (index < 0 || index >= subcategories.length) return;
    if (selectedIndex.value == index &&
        (isLoadingServices.value || services.isNotEmpty))
      return;
    selectedIndex.value = index;
    _fetchServices(subcategories[index].id);
    _scrollLeftIfNeeded(index);
  }

  void _scrollLeftIfNeeded(int index) {
    if (!leftScrollController.hasClients) return;
    const itemHeight = 80.0;
    final itemTop = index * itemHeight;
    final itemBottom = itemTop + itemHeight;
    final offset = leftScrollController.offset;
    final viewportHeight = leftScrollController.position.viewportDimension;
    if (itemTop < offset || itemBottom > offset + viewportHeight) {
      leftScrollController.animateTo(
        itemTop,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String iconFor(String title, {bool selected = false}) {
    final icons = kCategoryIcons[title] ?? kCategoryIcons['PC']!;
    return selected ? icons[1] : icons[0];
  }

  @override
  void onClose() {
    rightScrollController.dispose();
    leftScrollController.dispose();
    super.onClose();
  }
}
