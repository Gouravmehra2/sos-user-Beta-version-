import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/auth/login_screen/login_controller.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/common_auth_header.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_country_code_picker.dart';
import 'package:squadonsite/constant/common_widgets/common_text_form_field.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/common_widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: MyScaffold(
            useSafeArea: true,
            backgroundColor: AppColor.blackShade2,
            body: AuthLayout(
              imagePath: AppAssets.personImage,
              body: loginPanel(controller),
            ),
          ),
        );
      },
    );
  }
}

Widget loginPanel(LoginController controller) {
  return Container(
    height: Get.height * 0.648,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              /// Title
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blackShade1,
                ),
              ),
              const SizedBox(height: 6),

              /// Subtitle
              const Text(
                'Enter your details to continue\nwith Squad On Site',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.coolGrayText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              /// Phone Number Row — rebuilds when country or live error changes
              Obx(() {
                // Registering observables as Obx dependencies
                controller.selectedCountry.value;
                final phoneErr = controller.phoneError.value;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Country code picker
                    CommonCountryCodePicker(
                      onChanged: controller.onCountryChanged,
                      initialSelection:
                          controller.selectedCountry.value.code ?? 'IN',
                      backgroundColor: Colors.white,
                      borderColor: AppColor.lightGreyColor,
                    ),
                    const SizedBox(width: 10),

                    /// Phone number field — formatters + validator re-created
                    /// on every country change; errorText shows live feedback.
                    Expanded(
                      child: CommonTextFormField(
                        controller: controller.phoneController,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: controller.phoneFormatters,
                        validator: controller.validatePhone,
                        onChanged: controller.onPhoneChanged,
                        errorText: phoneErr.isEmpty ? null : phoneErr,
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 14),

              /// Password field
              Obx(
                () => CommonTextFormField.password(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: !controller.isPasswordVisible.value,
                  onToggleObscure: controller.togglePasswordVisibility,
                  validator: CommonValidators.compose([
                    CommonValidators.required(
                        message: 'Password is required'),
                    CommonValidators.strongPassword(),
                  ]),
                  textInputAction: TextInputAction.done,
                ),
              ),

              /// Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.navigateToForgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColor.brownAccentPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              /// Sign In Button
              CommonButton(
                label: 'Sign In',
                onTap: controller.handleLogin,
              ),
              const SizedBox(height: 16),

              /// OR divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                        color: AppColor.lightGreyColor, thickness: 1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: TextStyle(
                          fontSize: 13, color: AppColor.coolGrayText),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                        color: AppColor.lightGreyColor, thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Social login buttonss
              Row(
                children: [
                  Expanded(
                    child: SocialLoginButton(
                      onTap: controller.handleAppleLogin,
                      icon: Image.asset(AppAssets.appleImage,height: 20,)
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SocialLoginButton(
                      onTap: controller.handleGoogleLogin,
                        icon: Image.asset(AppAssets.googleImage,height: 20,),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                        fontSize: 13, color: AppColor.coolGrayText),
                  ),
                  GestureDetector(
                    onTap: controller.navigateToSignUp,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColor.brownAccentPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

