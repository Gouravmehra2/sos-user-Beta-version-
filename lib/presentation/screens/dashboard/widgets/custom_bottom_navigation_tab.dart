import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';

class BottomNavItemModel {
  final String label;
  final String filledIcon;
  final String outlineIcon;
  final IconData? icon;
  final bool pulseWhenInactive;

  const BottomNavItemModel({
    required this.label,
    this.filledIcon = '',
    this.outlineIcon = '',
    this.icon,
    this.pulseWhenInactive = false,
  });
}

class AnimatedBottomNavItem extends StatefulWidget {
  final bool isSelected;
  final BottomNavItemModel item;
  final VoidCallback onTap;

  const AnimatedBottomNavItem({
    super.key,
    required this.isSelected,
    required this.item,
    required this.onTap,
  });

  @override
  State<AnimatedBottomNavItem> createState() => _AnimatedBottomNavItemState();
}

class _AnimatedBottomNavItemState extends State<AnimatedBottomNavItem>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _pulse;
  bool _resumed = true;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _resumed = state == AppLifecycleState.resumed;
    _syncPulse();
  }

  void _syncPulse() {
    final animate =
        widget.item.pulseWhenInactive &&
        !widget.isSelected &&
        _resumed &&
        TickerMode.valuesOf(context).enabled &&
        !MediaQuery.disableAnimationsOf(context);
    if (animate) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: widget.isSelected,
    label: widget.item.label,
    child: Tooltip(
      message: widget.item.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) => DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: Curves.easeInOut.transform(_pulse.value) * 0.28,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: child,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isSelected ? 10 : 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: widget.item.icon != null
                        ? Icon(
                            widget.item.icon,
                            key: ValueKey(widget.isSelected),
                            size: 24,
                            color: widget.isSelected
                                ? Colors.black
                                : Colors.white,
                          )
                        : SvgPicture.asset(
                            widget.isSelected
                                ? widget.item.filledIcon
                                : widget.item.outlineIcon,
                            key: ValueKey(widget.isSelected),
                            colorFilter: ColorFilter.mode(
                              widget.isSelected ? Colors.black : Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 24,
                          ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: widget.isSelected
                        ? Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                (widget.item.label).tr,
                                style: AppTextStyle.buttonMedium.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
