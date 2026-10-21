import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/privacy_policy_screen/privacy_policy_controller.dart';

class PrivacyPolicyScreen extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => PolicyDocumentView(
    controller: controller,
    title: 'Privacy Policy',
    icon: Icons.privacy_tip_outlined,
  );
}

/// Shared reading layout for the app's legal documents.
class PolicyDocumentView extends StatelessWidget {
  const PolicyDocumentView({
    super.key,
    required this.controller,
    required this.title,
    required this.icon,
  });
  final PrivacyPolicyController controller;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      useSafeArea: true,
      safeAreaTop: false,
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(semanticsLabel: 'Loading $title'),
          );
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.description_outlined, size: 40),
                  const SizedBox(height: 16),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyMediumRegular,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: controller.loadPolicy,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        return SelectionArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView.builder(
                key: PageStorageKey(controller.documentAsset),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                itemCount: controller.sections.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(icon, size: 32),
                            const SizedBox(height: 16),
                            Semantics(
                              header: true,
                              child: Text(
                                controller.pageTitle.value,
                                style: AppTextStyle.headlineLargeBold.copyWith(
                                  color: AppColor.blackShade1,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            if (controller.subtitle.value.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                controller.subtitle.value,
                                style: AppTextStyle.titleSmallSemiBold.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            for (final block in controller.headerBlocks)
                              _PolicyBlockView(block: block),
                          ],
                        ),
                      ),
                    );
                  }
                  final section = controller.sections[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExcludeSemantics(
                                  child: Icon(
                                    section.icon,
                                    size: 24,
                                    color: AppColor.blackColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    section.title,
                                    style: AppTextStyle.titleLargeBold.copyWith(
                                      color: AppColor.blackShade1,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          for (final block in section.blocks)
                            _PolicyBlockView(block: block),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: child,
    );
  }
}

// ── Block quote ───────────────────────────────────────────────────────────────

class _PolicyBlockView extends StatelessWidget {
  final PrivacyPolicyBlock block;

  const _PolicyBlockView({required this.block});

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case PrivacyPolicyBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            block.text,
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: AppColor.blackColor,
              fontSize: 14,
            ),
          ),
        );
      case PrivacyPolicyBlockType.paragraph:
        final text = Text(
          block.text,
          textAlign: block.centered ? TextAlign.center : TextAlign.start,
          style: AppTextStyle.bodyMediumRegular.copyWith(
            color: const Color(0xff454B54),
            height: 1.6,
          ),
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: block.contact
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.neutral1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: text,
                )
              : text,
        );
      case PrivacyPolicyBlockType.list:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < block.items.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:
                            24 *
                            MediaQuery.textScalerOf(context).scale(14) /
                            14,
                        child: Text(
                          block.ordered ? '${index + 1}.' : '\u2022',
                          style: AppTextStyle.bodyMediumMedium.copyWith(
                            color: AppColor.blackColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          block.items[index],
                          style: AppTextStyle.bodyMediumRegular.copyWith(
                            color: const Color(0xff454B54),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
    }
  }
}
