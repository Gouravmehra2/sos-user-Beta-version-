import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/support_screen/email_support_controller.dart';

class EmailSupportScreen extends GetView<EmailSupportController> {
  const EmailSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Email Support".tr,
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          children: [
            // Hero
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                color: AppColor.blackColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "How can we help?".tr,
              style: AppTextStyle.headlineLargeBold.copyWith(
                color: AppColor.blackShade1,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Our dedicated support team typically responds within 24 hours to ensure your SOS experience is seamless."
                  .tr,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMediumRegular.copyWith(
                color: AppColor.coolGrayText,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Form card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.lightGreyColor),
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Subject'),
                    const SizedBox(height: 6),
                    CommonTextFormField(
                      controller: controller.subjectController,
                      hintText: "e.g. Booking inquiry or Technical issue".tr,
                      borderRadius: 10,
                      borderColor: AppColor.blackColor.withValues(alpha: 0.4),
                      focusedBorderColor: AppColor.blackColor,
                      backgroundColor: const Color(0xFFFAF7F4),
                      validator: CommonValidators.required(
                        message: "Subject is required".tr,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Order ID'),
                    const SizedBox(height: 6),
                    CommonTextFormField(
                      controller: controller.orderIdController,
                      hintText: "e.g. #ORD-77291".tr,
                      borderRadius: 10,
                      borderColor: AppColor.blackColor.withValues(alpha: 0.4),
                      focusedBorderColor: AppColor.blackColor,
                      backgroundColor: const Color(0xFFFAF7F4),
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Describe your issue'),
                    const SizedBox(height: 6),
                    CommonTextFormField(
                      controller: controller.descriptionController,
                      hintText:
                          "Please provide as much detail as possible so our experts can assist you effectively..."
                              .tr,
                      maxLines: 5,
                      minLines: 5,
                      borderRadius: 10,
                      borderColor: AppColor.blackColor.withValues(alpha: 0.4),
                      focusedBorderColor: AppColor.blackColor,
                      backgroundColor: const Color(0xFFFAF7F4),
                      validator: CommonValidators.required(
                        message: "Description is required".tr,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Attach file
                    GestureDetector(
                      onTap: controller.onAttachFile,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF7F4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColor.blackColor.withValues(alpha: 0.4),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.attach_file_rounded,
                              color: AppColor.coolGrayText,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Attach screenshots or relevant files".tr,
                              style: AppTextStyle.bodySmallMedium.copyWith(
                                color: AppColor.coolGrayText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    CommonButton(
                      label: "Send Message".tr,
                      onTap: controller.onSendMessage,
                      backgroundColor: AppColor.blackColor,
                      foregroundColor: Colors.white,
                      trailingIcon: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bottom options
            _BottomOptionTile(
              icon: Icons.menu_book_outlined,
              title: "Knowledge Base".tr,
              subtitle: "Browse our FAQ and guides for instant answers.".tr,
              onTap: controller.onKnowledgeBase,
            ),
            const SizedBox(height: 12),
            _BottomOptionTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: "Live Chat".tr,
              subtitle: "Available Mon-Fri from 9am to 6pm PST.".tr,
              onTap: controller.onLiveChat,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      (label).tr,
      style: AppTextStyle.bodyMediumMedium.copyWith(
        color: AppColor.blackColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BottomOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BottomOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.lightGreyColor),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColor.blackColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (title).tr,
                    style: AppTextStyle.titleSmallSemiBold.copyWith(
                      color: AppColor.blackShade1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (subtitle).tr,
                    style: AppTextStyle.bodySmallRegular.copyWith(
                      color: AppColor.coolGrayText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
