import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/presentation/screens/map_picker_screen/map_picker_controller.dart';

class MapPickerScreen extends StatelessWidget {
  const MapPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapPickerController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _MapView(controller: controller),
                  const _CenterPin(),
                  _CurrentLocationFab(controller: controller),
                  _MapZoomControls(controller: controller),
                  _TopBar(controller: controller),
                  Obx(
                    () => controller.showDropdown.value
                        ? _AutocompleteDropdown(controller: controller)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              _BottomCard(controller: controller),
          ],
        ),
      ),
    );
  }
}

// ─── 1. Map view ──────────────────────────────────────────────────────────────

class _MapView extends StatelessWidget {
  final MapPickerController controller;
  const _MapView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
        onMapCreated: controller.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: controller.initialCameraTarget,
          zoom: controller.initialCameraZoom,
        ),
        onCameraMove: controller.onCameraMove,
        onCameraIdle: controller.onCameraIdle,
        padding: const EdgeInsets.only(bottom: 8),
        minMaxZoomPreference: const MinMaxZoomPreference(3, 21),
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        // No markers — the fixed pin widget plays that role.
        markers: const {},
        myLocationEnabled: controller.locationPermissionGranted.value,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}

// ─── 2. Fixed center pin ──────────────────────────────────────────────────────

/// A pure widget pinned to the screen center via [Align].
/// It does NOT move with the map — the map moves under it, which is exactly
/// what gives the "draggable pin" illusion.
class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -24),
        child: CustomPaint(size: const Size(36, 48), painter: _PinPainter()),
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(18, 48)
      ..cubicTo(13, 37, 0, 28, 0, 18)
      ..arcToPoint(const Offset(36, 18), radius: const Radius.circular(18))
      ..cubicTo(36, 28, 23, 37, 18, 48)
      ..close();
    canvas.drawShadow(path, Colors.black38, 3, true);
    canvas.drawPath(path, Paint()..color = const Color(0xFFFF5C19));
    canvas.drawCircle(const Offset(18, 18), 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _PinPainter oldDelegate) => false;
}

// ─── 3. Top bar ───────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final MapPickerController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPadding + 8,
      left: 12,
      right: 12,
      child: Row(
        children: [
          // Back button
          _CircleButton(icon: Icons.arrow_back_ios_rounded, onTap: Get.back),
          const SizedBox(width: 10),
          // Search field
          Expanded(child: _SearchField(controller: controller)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final MapPickerController controller;
  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Obx(
        () => TextField(
          controller: controller.searchController,
          onChanged: controller.onSearchChanged,
          textAlignVertical: TextAlignVertical.center,
          style: AppTextStyle.bodyMediumRegular.copyWith(
            color: AppColor.blackShade1,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search address on map…',
            hintStyle: AppTextStyle.bodyMediumRegular.copyWith(
              color: AppColor.coolGrayText,
            ),
            prefixIcon: controller.isSearching.value
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.blackColor,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.search_rounded,
                    color: AppColor.blackColor,
                    size: 22,
                  ),
            suffixIcon: controller.searchText.value.isNotEmpty
                ? GestureDetector(
                    onTap: controller.clearSearch,
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColor.coolGrayText,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}

// ─── 4. Autocomplete dropdown ─────────────────────────────────────────────────

class _AutocompleteDropdown extends StatelessWidget {
  final MapPickerController controller;
  const _AutocompleteDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 68,
      bottom: 8,
      left: 12,
      right: 12,
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: controller.predictions.isEmpty
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.isSearching.value)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                Text(
                                  controller.searchMessage.value,
                                  style: AppTextStyle.bodySmallRegular.copyWith(
                                    color: AppColor.coolGrayText,
                                  ),
                                ),
                                if (controller.searchError.value)
                                  TextButton(
                                    onPressed: controller.retrySearch,
                                    child: const Text('Retry'),
                                  ),
                                TextButton(
                                  onPressed: controller.enterAddressManually,
                                  child: const Text('Enter address manually'),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: controller.predictions.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) {
                              final prediction = controller.predictions[i];
                              return ListTile(
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(
                                  prediction.mainText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: prediction.secondaryText.isEmpty
                                    ? null
                                    : Text(
                                        prediction.secondaryText,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                onTap: controller.isSearching.value
                                    ? null
                                    : () => controller.onPredictionSelected(
                                        prediction,
                                      ),
                              );
                            },
                          ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
                    child: Text(
                      'Google Maps',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 5. Current-location FAB ──────────────────────────────────────────────────

class _CurrentLocationFab extends StatelessWidget {
  final MapPickerController controller;
  const _CurrentLocationFab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      // Float above the bottom card (card is ~240 dp tall)
      bottom: 16,
      child: Obx(
        () => FloatingActionButton.extended(
          heroTag: 'map-current-location',
          label: const Text('Use current location'),
          icon: controller.isLocating.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location_rounded),
          onPressed: controller.isLocating.value
              ? null
              : controller.onUseCurrentLocation,
          backgroundColor: Colors.white,
          foregroundColor: AppColor.blackColor,
          elevation: 6,
        ),
      ),
    );
  }
}

class _MapZoomControls extends StatelessWidget {
  final MapPickerController controller;
  const _MapZoomControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 82,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Zoom in',
              onPressed: controller.zoomIn,
              icon: const Icon(Icons.add_rounded),
            ),
            const Divider(height: 1),
            IconButton(
              tooltip: 'Zoom out',
              onPressed: controller.zoomOut,
              icon: const Icon(Icons.remove_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 7. Bottom confirm card ───────────────────────────────────────────────────

class _BottomCard extends StatelessWidget {
  final MapPickerController controller;
  const _BottomCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColor.lightGreyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Address preview ────────────────────────────────────────────
          Obx(() {
            final geocoding = controller.isGeocoding.value;
            final result = controller.geocodeResult.value;

            if (geocoding) return const _AddressShimmer();

            if (result.display.isEmpty) {
              return Text(
                controller.geocodeError.value.isEmpty
                    ? 'Zoom in and move the map so the pin marks your exact entrance.'
                    : controller.geocodeError.value,
                style: AppTextStyle.bodyMediumRegular.copyWith(
                  color: AppColor.coolGrayText,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: AppColor.blackColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Selected Location',
                      style: AppTextStyle.labelMediumSemiBold.copyWith(
                        color: AppColor.coolGrayText,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  result.display,
                  style: AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (result.city.isNotEmpty || result.zipcode.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    [
                      result.city,
                      result.state,
                      result.zipcode,
                    ].where((s) => s.isNotEmpty).join(', '),
                    style: AppTextStyle.bodySmallRegular.copyWith(
                      color: AppColor.coolGrayText,
                    ),
                  ),
                ],
              ],
            );
          }),

          Obx(
            () => controller.geocodeError.value.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Text(
                        controller.geocodeError.value,
                        style: AppTextStyle.bodySmallRegular.copyWith(
                          color: Colors.red,
                        ),
                      ),
                      Wrap(
                        children: [
                          TextButton(
                            onPressed: controller.retryGeocode,
                            child: const Text('Retry'),
                          ),
                          if (controller.geocodeResult.value.display.isNotEmpty)
                            TextButton(
                              onPressed: controller.restorePreviousLocation,
                              child: const Text('Use previous location'),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),
          TextButton(
            onPressed: controller.enterAddressManually,
            child: const Text('Enter address manually'),
          ),
          const SizedBox(height: 8),

          // ── Confirm button ─────────────────────────────────────────────
          Obx(
            () => CommonButton(
              label: 'Confirm Location',
              onTap: controller.canConfirm
                  ? controller.onConfirmLocation
                  : null,
              enabled: controller.canConfirm,
              backgroundColor: controller.canConfirm
                  ? AppColor.blackColor
                  : AppColor.lightGreyColor,
              foregroundColor: controller.canConfirm
                  ? Colors.white
                  : AppColor.coolGrayText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Address shimmer ──────────────────────────────────────────────────────────

class _AddressShimmer extends StatefulWidget {
  const _AddressShimmer();

  @override
  State<_AddressShimmer> createState() => _AddressShimmerState();
}

class _AddressShimmerState extends State<_AddressShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.25,
      end: 0.65,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box(double width, double height) => AnimatedBuilder(
    animation: _anim,
    builder: (_, _) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.lightGreyColor.withValues(alpha: _anim.value),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(100, 10),
        const SizedBox(height: 8),
        _box(double.infinity, 14),
        const SizedBox(height: 6),
        _box(200, 10),
      ],
    );
  }
}

// ─── Reusable circle button ───────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: const CircleBorder(),
    elevation: 4,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(icon, size: 20, color: AppColor.blackShade1),
      ),
    ),
  );
}
