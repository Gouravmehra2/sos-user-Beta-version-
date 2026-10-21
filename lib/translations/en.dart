// English translations
const Map<String, String> en = {
  // ── Onboarding ─────────────────────────────────────────────────────────────
  'onboarding_next': 'Next',
  'onboarding_skip': 'Skip',
  'onboarding_slide1_title': 'Instant\nExpert Help',
  'onboarding_slide1_desc':
      'Book trusted technicians and home\nservices anytime, anywhere.',
  'onboarding_slide2_title': 'Verified Service\nExperts',
  'onboarding_slide2_desc':
      'Every professional is background-\nverified and quality-checked.',
  'onboarding_slide3_title': 'SOS.\nEvery Service.',
  'onboarding_slide3_desc':
      'From appliance repair to emergency\nsupport — Squad On Site has you\ncovered.',

  // ── Login Bottom Sheet ─────────────────────────────────────────────────────
  'login_sheet_headline': 'Explore Now',
  'login_sheet_subheadline':
      'Book trusted technicians and\nprofessional home services in minutes.',
  'login_sheet_guest_btn': 'Login as Guest',
  'login_sheet_phone_btn': 'Continue with Phone',
  'login_sheet_email_btn': 'Continue with Email',

  // ── Login Screen (phone) ───────────────────────────────────────────────────
  'login_title': 'Sign In',
  'login_subtitle': 'Enter your details to continue\nwith Squad On Site',
  'login_hint_phone': 'Phone Number',
  'login_hint_password': 'Password',
  'login_forgot_password': 'Forgot Password?',
  'login_sign_in_btn': 'Sign In',
  'login_or_divider': 'or',
  'login_no_account': "Don't have an account? ",
  'login_sign_up_link': 'Sign Up',

  // ── Email Login Screen ─────────────────────────────────────────────────────
  'email_login_hint_email': 'Enter your Email',

  // ── Sign Up Screen ─────────────────────────────────────────────────────────
  'signup_title': 'Sign Up',
  'signup_subtitle_phone': "We'll send a code to verify your account.",
  'signup_subtitle_email': "We'll send a code to verify your email.",
  'signup_hint_email': 'Enter your email',
  'signup_continue_btn': 'Continue',
  'signup_have_account': 'Already having an account? ',
  'signup_sign_in_link': 'Sign In',

  // ── OTP Screen ─────────────────────────────────────────────────────────────
  'otp_title_phone': 'Verify Number',
  'otp_title_email': 'Verify Email',
  'reset_otp_title': 'Reset Password',
  'reset_otp_continue': 'Continue',
  'reset_otp_expires_in': 'Code expires in %s',
  'reset_otp_expired': 'This code has expired. Request a new code.',
  'reset_session_expired':
      'This reset session expired. Please request a new code.',
  'reset_request_timeout':
      'Request timed out. Wait for the SMS before manually resending.',
  'forgot_request_timeout':
      'Request timed out. Wait for the SMS before manually requesting another code.',
  'network_retry': 'Unable to connect. Check your connection and try again.',
  'unexpected_server_response': 'Unexpected server response. Please try again.',
  'otp_verify_btn': 'Verify & Continue',
  'otp_no_code': "Didn't receive an OTP? ",
  'otp_subtitle': 'We sent a 6-digit code to %s',
  'otp_resend': 'Resend Code',
  'otp_resend_countdown': 'Resend Code in %s',
  'otp_change_number': 'Change Number?',
  'otp_change_email': 'Change Email?',

  // ── Forgot Password Screen ─────────────────────────────────────────────────
  'forgot_title': 'Forgot Password?',
  'forgot_subtitle_phone':
      "Enter your phone number and we'll send a\npassword reset code.",
  'forgot_subtitle_email':
      "Enter your email and we'll send a\npassword reset code to your registered phone.",
  'forgot_hint_phone': 'Enter your phone number',
  'forgot_hint_email': 'Enter your email',
  'forgot_btn': 'Send Reset Code',
  'forgot_resend': 'Resend Code',
  'forgot_back_to_login': 'Back to Login',
  'reset_password_title': 'Create New Password',
  'reset_password_subtitle': 'Choose a password with at least 6 characters.',
  'reset_password_new_label': 'New password',
  'reset_password_new_hint': 'Enter your new password',
  'reset_password_confirm_label': 'Confirm password',
  'reset_password_confirm_hint': 'Enter your new password again',
  'reset_password_submit': 'Reset Password',
  'reset_password_required': 'Enter a new password.',
  'reset_password_min_length': 'Password must be at least 6 characters.',
  'reset_password_confirm_required': 'Confirm your new password.',
  'reset_password_mismatch': 'Passwords do not match.',
  'reset_password_success': 'Password reset successfully.',
  'reset_password_timeout':
      'Request timed out. Your password may have been changed; try logging in before submitting again.',

  // ── Location Permission Screen ─────────────────────────────────────────────
  'location_perm_title': 'Enable Location Access',
  'location_perm_subtitle':
      'Allow location access to get accurate\nservice in your area.',
  'location_perm_allow_btn': 'Allow Location Access',
  'location_perm_manual_btn': 'Enter Manually',

  // ── Location Detail Screen ─────────────────────────────────────────────────
  'location_detail_title': 'Enter Your Location',
  'location_detail_search_hint': 'Search for area, street, or landmark',
  'location_detail_use_current': 'Use Current Location',
  'location_detail_enter_details': 'Enter Details',
  'location_detail_house_label': 'House / Flat / Block No.',
  'location_detail_apartment_label': 'Apartment / Road / Area',
  'location_detail_landmark_label': 'Landmark (Optional)',
  'location_detail_save_as': 'Save as',
  'location_detail_save_home': 'Home',
  'location_detail_save_office': 'Office',
  'location_detail_save_other': 'Other',
  'location_detail_confirm_btn': 'Confirm Location',
  'location_detail_house_required': 'House / Flat / Block No. is required',
  'location_detail_apartment_required': 'Apartment / Road / Area is required',

  // ── Map Screen ─────────────────────────────────────────────────────────────
  'map_search_placeholder': 'Select a Location',
  'map_selected_location_label': 'Selected Location',
  'map_tap_hint': 'Tap on the map to select a location',
  'map_confirm_btn': 'Confirm Location',

  // ── Select Location Screen ─────────────────────────────────────────────────
  'select_location_title': 'Select Location',
  'select_location_search_hint': "Search for 'AC Repair' or 'Plumber'",
  'select_location_saved_addresses': 'SAVED ADDRESSES',
  'select_location_use_current': 'Use Current\nLocation',
  'select_location_add_new': 'Add New\nAddress',
  'select_location_request_friend': 'Request from\nFriend',
  'select_location_view_all': 'View All',
  'select_location_selected_badge': 'SELECTED',
  'select_location_add_address_btn': '+ Add New Address',
  'select_location_confirm_btn': 'Confirm Location',

  // ── Home Screen ────────────────────────────────────────────────────────────
  'home_greeting_morning': 'Good Morning',
  'home_greeting_afternoon': 'Good Afternoon',
  'home_greeting_evening': 'Good Evening',
  'home_search_hint': 'Search for AC Repair or Plumber',
  'home_section_service_categories': 'Service Categories',
  'home_section_special_offers': 'Special Offers',
  'home_section_membership': 'Membership Plan',
  'home_section_popular_services': 'Popular Services',
  'home_section_user_stories': "User's Stories",
  'home_view_all': 'View All',
  'home_sos_need_help': 'Need urgent help?',
  'home_sos_subtitle': 'Emergency SOS Support',
  'home_sos_btn': 'SOS',
  'home_footer_tagline1': 'Love Your\n',
  'home_footer_tagline2': 'Living',
  'home_footer_tagline3': "We do the work so you don't have too",
  'home_offer_tag_exclusive': 'EXCLUSIVE DEAL',
  'home_offer_tag_limited': 'LIMITED TIME',
  'home_offer1_title': 'Summer Offer\n20% Off AC\nServices',
  'home_offer2_title': 'Winter Offer\n15% Off\nHeating Setup',
  'home_offer_book_now': 'Book Now',
  'home_popular_reviews': '123 Reviews',
  'home_popular_book_service': 'Book a Service',
  'home_story1_title': 'Watch how we fixed\nthe water heater',
  'home_story2_title': 'Got cleaned water\nheater fixed',
  'home_story3_title': 'Got their home\nRepairs &...',

  // ── Service Categories ─────────────────────────────────────────────────────
  'home_cat_smart_home': 'Smart Home Installations',
  'home_cat_tv_mount': 'TV\nMounting',
  'home_cat_wifi': 'WiFi &\nNetworking',
  'home_cat_computer': 'Computer & Device Support',
  'home_cat_security': 'Security & Surveillance',
  'home_cat_audio_video': 'Audio & Video\nDevice Setup',

  // ── Dashboard Bottom Navigation ────────────────────────────────────────────
  'nav_home': 'Home',
  'nav_services': 'Services',
  'nav_bookings': 'Bookings',
  'nav_profile': 'Profile',

  // ── Validation Messages ────────────────────────────────────────────────────
  'validation_required': 'This field is required',
  'validation_email': 'Enter a valid email address',
  'validation_password_strength':
      'Password must contain uppercase, lowercase, number, special character and be at least 8 characters',
  'validation_strong_password':
      'Password must contain uppercase, lowercase, number, special character and be at least 8 characters',
  'validation_has_uppercase': 'Must contain at least one uppercase letter',
  'validation_has_digit': 'Must contain at least one number',
  'validation_has_special_char': 'Must contain at least one special character',
  'validation_fields_no_match': 'Fields do not match',
  'validation_invalid_format': 'Invalid format',
  'validation_email_required': 'Email is required',
  'validation_phone_required': 'Phone number is required',
  'validation_password_required': 'Password is required',
  'language_arabic': 'العربية',
  'language_english': 'English',
  'language_spanish': 'Spanish',
  'sign_in_failed': 'Sign in failed',
  'signup_failed': 'Sign up failed',

  // ── Profile Screen ────────────────────────────────────────────────────────
  'profile_member_since': 'Member since',
  'profile_quick_bookings': 'My Bookings',
  'profile_quick_payment': 'Payment',
  'profile_quick_addresses': 'Addresses',
  'profile_quick_support': 'Support',
  'profile_subscription_active': 'ACTIVE',
  'profile_subscription_name': 'SquadCare+',
  'profile_view_benefits': 'View Benefits',
  'profile_savings_label': 'SAVINGS THIS MONTH',
  'profile_wallet': 'Wallet',
  'profile_coupons': 'Coupons',
  'profile_settings_personal': 'Personal Information',
  'profile_settings_notifications': 'Notification Settings',
  'profile_settings_language': 'Language',
  'profile_settings_security': 'Security',
  'profile_settings_change_password': 'Change password',
  'profile_settings_booking_safety': 'Booking Safety Guide',
  'profile_settings_terms': 'Terms & Conditions',
  'profile_settings_privacy': 'Privacy Policy',
  'profile_referral_code': 'Referral Code',
  'profile_copied': 'Copied',
  'profile_referral_copied': 'Referral code copied!',
  'profile_delete_account': 'Delete account',
  'profile_logout': 'Logout from SOS',
  'change_password_title': 'Change password',
  'change_password_subtitle':
      'Choose a strong password to help protect your account.',
  'change_password_old_label': 'Old password',
  'change_password_old_hint': 'Enter your old password',
  'change_password_new_label': 'New password',
  'change_password_new_hint': 'Enter a new password',
  'change_password_confirm_label': 'Confirm new password',
  'change_password_confirm_hint': 'Re-enter your new password',
  'change_password_old_required': 'Enter your old password',
  'change_password_new_required': 'Enter a new password',
  'change_password_confirm_required': 'Confirm your new password',
  'change_password_mismatch': 'Passwords do not match',
  'change_password_submit': 'Update password',
  'change_password_success': 'Your password has been updated.',
  'change_password_failed': 'Unable to update your password. Please try again.',

  'location_gps_off_title': 'Location is turned off',
  'location_gps_off_body':
      'Your device location is currently turned off. Turn on location services to continue.',
  'location_denied_forever_title': 'Location permission required',
  'location_denied_forever_body':
      'Location permission has been permanently denied. Please enable it from your device settings to continue.',

  // Dialog actions
  'location_dialog_cancel': 'Not now',
  'location_dialog_open_settings': 'Turn on Location',
  'location_dialog_open_app_settings': 'Open App Settings',

  'location_enable_steps_title': 'How to enable location',

  'location_enable_step_1': 'Tap "Open App Settings" below.',

  'location_enable_step_2':
      'Open Location or Permissions in your device settings.',

  'location_enable_step_3': 'Allow location access for this app.',

  'location_enable_step_4': 'Return to the app and try again.',

  'signup_hint_name': 'Enter your name',
  'signup_hint_confirm_password': 'Confirm your password',
  'register': 'Register',

  // Application-wide UI messages.
  "+3 from yesterday": "+3 from yesterday",
  "1 year": "1 year",
  "10-digit phone number": "10-digit phone number",
  "100% Secure": "100% Secure",
  "2 years": "2 years",
  "24/7 priority assistance for marketplace safety.":
      "24/7 priority assistance for marketplace safety.",
  "3 years": "3 years",
  "5 June, 2026, 16:16": "5 June, 2026, 16:16",
  "A previous payment needs verification. Check it before starting another purchase.":
      "A previous payment needs verification. Check it before starting another purchase.",
  "AC & Appliance": "AC & Appliance",
  "Add Money": "Add Money",
  "Address saved successfully.": "Address saved successfully.",
  "Address updated": "Address updated",
  "Address updated successfully.": "Address updated successfully.",
  "Address updated, but could not set the default. Retry setting the default from your saved addresses.":
      "Address updated, but could not set the default. Retry setting the default from your saved addresses.",
  "Amount Paid": "Amount Paid",
  "Apple registration details are incomplete.":
      "Apple registration details are incomplete.",
  "Apple registration expired. Please sign in with Apple again.":
      "Apple registration expired. Please sign in with Apple again.",
  "Apple returned incomplete credentials. Please sign in again.":
      "Apple returned incomplete credentials. Please sign in again.",
  "Apple sign-in": "Apple sign-in",
  "Apple sign-in is unavailable on this device.":
      "Apple sign-in is unavailable on this device.",
  "Applying coupon: @p0": "Applying coupon: @p0",
  "Are you sure you want to delete this account? This action is irreversible.":
      "Are you sure you want to delete this account? This action is irreversible.",
  "Are you sure you want to logout from this device?":
      "Are you sure you want to logout from this device?",
  "Available Mon-Fri from 9am to 6pm PST.":
      "Available Mon-Fri from 9am to 6pm PST.",
  "Back to Home": "Back to Home",
  "Beauty &\nPersonal Care": "Beauty &\nPersonal Care",
  "Before your service": "Before your service",
  "Book Service": "Book Service",
  "Book trusted experts\nat your doorstep.":
      "Book trusted experts\nat your doorstep.",
  "Booking Confirmation": "Booking Confirmation",
  "Booking Confirmed": "Booking Confirmed",
  "Booking Error": "Booking Error",
  "Booking ID": "Booking ID",
  "Booking Status": "Booking Status",
  "Booking activity": "Booking activity",
  "Booking details": "Booking details",
  "Booking for Jagriti at CXO Suites, Ground Floor, IT Park":
      "Booking for Jagriti at CXO Suites, Ground Floor, IT Park",
  "Booking for someone else": "Booking for someone else",
  "Booking total": "Booking total",
  "Browse our FAQ and guides for instant answers.":
      "Browse our FAQ and guides for instant answers.",
  "Business\nServices": "Business\nServices",
  "Business Services": "Business Services",
  "Call": "Call",
  "Call Emergency Services": "Call Emergency Services",
  "Call Now": "Call Now",
  "Call Safety Team": "Call Safety Team",
  "Call Support": "Call Support",
  "Camera": "Camera",
  "Cancel": "Cancel",
  "Carbonite unlimited backup & Office for your team.":
      "Carbonite unlimited backup & Office for your team.",
  "Carpentry": "Carpentry",
  "Change Password": "Change Password",
  "Change map location": "Change map location",
  "Chat": "Chat",
  "Chat Now": "Chat Now",
  "Chat Support": "Chat Support",
  "Chat with Us": "Chat with Us",
  "Check Pricing Before Work Starts": "Check Pricing Before Work Starts",
  "Check Status": "Check Status",
  "Check payment": "Check payment",
  "Choose a saved address or enter a new service address.":
      "Choose a saved address or enter a new service address.",
  "Cleaning": "Cleaning",
  "Clear search": "Clear search",
  "Close": "Close",
  "Close image": "Close image",
  "Close video": "Close video",
  "Complete Secure Payment": "Complete Secure Payment",
  "Complete your phone number and password, then verify your phone by OTP.":
      "Complete your phone number and password, then verify your phone by OTP.",
  "Completed": "Completed",
  "Confirm & Book": "Confirm & Book",
  "Connection timeout. Please try again.":
      "Connection timeout. Please try again.",
  "Contact Support": "Contact Support",
  "Contact local police, ambulance, or fire services.":
      "Contact local police, ambulance, or fire services.",
  "Continue to payment": "Continue to payment",
  "Could not delete address": "Could not delete address",
  "Could not find an address here. Retry or enter the address manually.":
      "Could not find an address here. Retry or enter the address manually.",
  "Could not move the map. Please try again.":
      "Could not move the map. Please try again.",
  "Could not save address.": "Could not save address.",
  "Could not save address. Please try again.":
      "Could not save address. Please try again.",
  "Could not save to your profile. Retry, or turn off Save this address to my profile to use it for this booking.":
      "Could not save to your profile. Retry, or turn off Save this address to my profile to use it for this booking.",
  "Coupon": "Coupon",
  "Covers 3 devices: laptops, desktops, printers, phones & more.":
      "Covers 3 devices: laptops, desktops, printers, phones & more.",
  "Covers 5 devices: laptops, desktops, printers, phones & routers.":
      "Covers 5 devices: laptops, desktops, printers, phones & routers.",
  "Current Device": "Current Device",
  "Customer score": "Customer score",
  "Data transformation timeout.": "Data transformation timeout.",
  "Date of Birth": "Date of Birth",
  "Default address": "Default address",
  "Delete": "Delete",
  "Delete account?": "Delete account?",
  "Delete address?": "Delete address?",
  "Description is required": "Description is required",
  "Diagnostic": "Diagnostic",
  "Didn't find\nwhat you were\n": "Didn't find\nwhat you were\n",
  "Download invoice": "Download invoice",
  "Earnings": "Earnings",
  "Edit": "Edit",
  "Edit Profile": "Edit Profile",
  "Electrical": "Electrical",
  "Email Address": "Email Address",
  "Email Support": "Email Support",
  "Email Verification": "Email Verification",
  "Emergency Assistance": "Emergency Assistance",
  "Emergency Services": "Emergency Services",
  "Enter a new address": "Enter a new address",
  "Enter address manually": "Enter address manually",
  "Enter an address": "Enter an address",
  "Enter code here": "Enter code here",
  "Enter coupon code": "Enter coupon code",
  "Error": "Error",
  "Essential internet security & backup for your business.":
      "Essential internet security & backup for your business.",
  "Everyday support for primary & peripheral devices.":
      "Everyday support for primary & peripheral devices.",
  "Expires 05/25": "Expires 05/25",
  "Expires 12/26": "Expires 12/26",
  "Explore Services": "Explore Services",
  "Explore plans": "Explore plans",
  "FEATURED": "FEATURED",
  "Failed to load more services.": "Failed to load more services.",
  "Failed to load more subcategories.": "Failed to load more subcategories.",
  "Failed to load services.": "Failed to load services.",
  "Failed to load subcategories.": "Failed to load subcategories.",
  "Full Name": "Full Name",
  "Gallery": "Gallery",
  "Gardening": "Gardening",
  "Gender": "Gender",
  "Go back to signup to request a new registration code.":
      "Go back to signup to request a new registration code.",
  "Good morning,": "Good morning,",
  "Google account details received": "Google account details received",
  "Google sign-in": "Google sign-in",
  "Handyman": "Handyman",
  "Health &\nWellness": "Health &\nWellness",
  "Help Us Maintain Quality": "Help Us Maintain Quality",
  "Home\nServices": "Home\nServices",
  "Home Appliances": "Home Appliances",
  "Home Revamp\n": "Home Revamp\n",
  "Home Services": "Home Services",
  "Home Theater": "Home Theater",
  "INVOICE": "INVOICE",
  "IT &\nTechnology": "IT &\nTechnology",
  "Image must be 5 MB or smaller.": "Image must be 5 MB or smaller.",
  "Instant Refunds": "Instant Refunds",
  "Instant Settlement": "Instant Settlement",
  "Instantly chat with our support team":
      "Instantly chat with our support team",
  "Invalid Places API response": "Invalid Places API response",
  "Invalid booking details.": "Invalid booking details.",
  "Invalid booking response": "Invalid booking response",
  "Invalid invoice download URL.": "Invalid invoice download URL.",
  "Invalid invoice download response.": "Invalid invoice download response.",
  "Invalid invoice response.": "Invalid invoice response.",
  "Invalid notifications response.": "Invalid notifications response.",
  "Invalid place coordinates": "Invalid place coordinates",
  "Invalid plan response": "Invalid plan response",
  "Invalid response.": "Invalid response.",
  "Invalid review response.": "Invalid review response.",
  "Invalid server certificate.": "Invalid server certificate.",
  "Invalid server response.": "Invalid server response.",
  "Invalid suggestions": "Invalid suggestions",
  "Invalid technician review response.": "Invalid technician review response.",
  "Invoice": "Invoice",
  "Invoice details are missing.": "Invoice details are missing.",
  "Jobs today": "Jobs today",
  "Knowledge Base": "Knowledge Base",
  "Last Login": "Last Login",
  "Live Chat": "Live Chat",
  "Live Tracking": "Live Tracking",
  "Loading @p0": "Loading @p0",
  "Location Details": "Location Details",
  "Location Error": "Location Error",
  "Location access denied": "Location access denied",
  "Location access required": "Location access required",
  "Location required": "Location required",
  "Location unavailable": "Location unavailable",
  "Log in": "Log in",
  "Logout": "Logout",
  "Logout?": "Logout?",
  "Marketing &\nBranding": "Marketing &\nBranding",
  "Message": "Message",
  "Message was not sent.": "Message was not sent.",
  "Missing place coordinates": "Missing place coordinates",
  "Missing policy body.": "Missing policy body.",
  "Missing updated address list.": "Missing updated address list.",
  "Mobile Verification": "Mobile Verification",
  "My Jobs": "My Jobs",
  "My bookings": "My bookings",
  "My plans": "My plans",
  "Needs attention": "Needs attention",
  "Network Setup": "Network Setup",
  "Networking": "Networking",
  "No Location": "No Location",
  "No address found": "No address found",
  "No internet connection.": "No internet connection.",
  "No plans are currently available.": "No plans are currently available.",
  "Not Found": "Not Found",
  "Not included": "Not included",
  "Notifications": "Notifications",
  "Notifications from the SquadOnSite app":
      "Notifications from the SquadOnSite app",
  "OK": "OK",
  "PC": "PC",
  "Painting": "Painting",
  "Pause": "Pause",
  "Pay After Service Completion": "Pay After Service Completion",
  "Payment Failed": "Payment Failed",
  "Payment Options": "Payment Options",
  "Payment Pending": "Payment Pending",
  "Payment attempt not found.": "Payment attempt not found.",
  "Payment awaiting verification. Coverage is not active yet.":
      "Payment awaiting verification. Coverage is not active yet.",
  "Payment details": "Payment details",
  "Payment not verified. This plan does not grant access.":
      "Payment not verified. This plan does not grant access.",
  "Pending": "Pending",
  "Pest Control": "Pest Control",
  "Plans": "Plans",
  "Play": "Play",
  "Please allow current location access to continue.":
      "Please allow current location access to continue.",
  "Please allow location access so we can use your current location.":
      "Please allow location access so we can use your current location.",
  "Please choose a service package.": "Please choose a service package.",
  "Please enable location access in app settings to continue.":
      "Please enable location access in app settings to continue.",
  "Please enter @p0": "Please enter @p0",
  "Please enter a valid amount": "Please enter a valid amount",
  "Please provide as much detail as possible so our experts can assist you effectively...":
      "Please provide as much detail as possible so our experts can assist you effectively...",
  "Please select a location on the map.":
      "Please select a location on the map.",
  "Please select your date of birth.": "Please select your date of birth.",
  "Please select your gender.": "Please select your gender.",
  "Please try again or allow location access.":
      "Please try again or allow location access.",
  "Please try again or enter your address manually.":
      "Please try again or enter your address manually.",
  "Please try again.": "Please try again.",
  "Please try again. Your address has not been removed.":
      "Please try again. Your address has not been removed.",
  "Plumbing": "Plumbing",
  "Price mismatch": "Price mismatch",
  "Printer": "Printer",
  "Privacy policy content is incomplete.":
      "Privacy policy content is incomplete.",
  "Processing payment of \$@p0": "Processing payment of \$@p0",
  "Processing...": "Processing...",
  "Professional\nCleaning for a\nHealthier Home":
      "Professional\nCleaning for a\nHealthier Home",
  "Professional\nServices": "Professional\nServices",
  "Professional solutions for your business needs.":
      "Professional solutions for your business needs.",
  "Profile updated successfully.": "Profile updated successfully.",
  "Promo Code": "Promo Code",
  "Quick actions": "Quick actions",
  "Rate & Share Feedback": "Rate & Share Feedback",
  "Rating": "Rating",
  "Read Terms & Conditions": "Read Terms & Conditions",
  "Recent": "Recent",
  "Redeeming code: @p0": "Redeeming code: @p0",
  "Refresh my plans": "Refresh my plans",
  "Refunds are credited instantly": "Refunds are credited instantly",
  "Repair": "Repair",
  "Repair & care": "Repair & care",
  "Report\nMisconduct": "Report\nMisconduct",
  "Report an Issue": "Report an Issue",
  "Request Call Back": "Request Call Back",
  "Request failed": "Request failed",
  "Request timeout. Please try again.": "Request timeout. Please try again.",
  "Request was cancelled.": "Request was cancelled.",
  "Retry": "Retry",
  "Retry plans": "Retry plans",
  "Review & Approve Estimate": "Review & Approve Estimate",
  "SEND TIP": "SEND TIP",
  "SKIP": "SKIP",
  "SOS Safety Team": "SOS Safety Team",
  "Save Address": "Save Address",
  "Save Profile": "Save Profile",
  "Save this address to my profile": "Save this address to my profile",
  "Saving...": "Saving...",
  "Schedule & location": "Schedule & location",
  "Search address on map…": "Search address on map…",
  "Search service & book your service": "Search service & book your service",
  "Search services, ID or location": "Search services, ID or location",
  "Security PIN": "Security PIN",
  "Select Photo": "Select Photo",
  "Select a package": "Select a package",
  "Select date of birth": "Select date of birth",
  "Send Message": "Send Message",
  "Send us an email and we'll reply": "Send us an email and we'll reply",
  "Server Error": "Server Error",
  "Server protection & encrypted backup for your business.":
      "Server protection & encrypted backup for your business.",
  "Server response timeout. Please try again.":
      "Server response timeout. Please try again.",
  "Service Rating": "Service Rating",
  "Service information": "Service information",
  "Service not yet started": "Service not yet started",
  "Set as default address": "Set as default address",
  "Setup & repair": "Setup & repair",
  "Share": "Share",
  "Share Live Location": "Share Live Location",
  "Share Location": "Share Location",
  "Share your experience (optional)": "Share your experience (optional)",
  "Sign in": "Sign in",
  "Sign up": "Sign up",
  "Smart Home": "Smart Home",
  "Something went wrong on our end. Your payment may still be processing — please check My Bookings before retrying.":
      "Something went wrong on our end. Your payment may still be processing — please check My Bookings before retrying.",
  "Something went wrong with your payment.":
      "Something went wrong with your payment.",
  "Something went wrong.": "Something went wrong.",
  "Special instructions": "Special instructions",
  "SquadOnSite Notifications": "SquadOnSite Notifications",
  "Start Service with OTP": "Start Service with OTP",
  "Status": "Status",
  "Stay Informed Throughout the Job": "Stay Informed Throughout the Job",
  "Subject is required": "Subject is required",
  "Submit a Review": "Submit a Review",
  "Subscribe to @p0": "Subscribe to @p0",
  "Subscribe to this plan": "Subscribe to this plan",
  "Success": "Success",
  "TV Mount AC": "TV Mount AC",
  "TV Mounting": "TV Mounting",
  "Take Photo": "Take Photo",
  "Talk to our support team": "Talk to our support team",
  "Technician Arrived": "Technician Arrived",
  "Technician Assigned": "Technician Assigned",
  "Technician Rating": "Technician Rating",
  "Technician on the way": "Technician on the way",
  "Technician: Michael Johnson": "Technician: Michael Johnson",
  "The @p0 could not be loaded. Please try again.":
      "The @p0 could not be loaded. Please try again.",
  "The server did not return a login token. Please try again.":
      "The server did not return a login token. Please try again.",
  "The server did not return a valid phone number.":
      "The server did not return a valid phone number.",
  "The server did not return valid Google account details.":
      "The server did not return valid Google account details.",
  "The server did not return valid app tokens.":
      "The server did not return valid app tokens.",
  "The server did not return valid app tokens. Please try again.":
      "The server did not return valid app tokens. Please try again.",
  "This week": "This week",
  "Tip your Technician": "Tip your Technician",
  "Tools & equipment": "Tools & equipment",
  "Total": "Total",
  "Track Booking →": "Track Booking →",
  "Track Service Updates": "Track Service Updates",
  "Transportation\nServices": "Transportation\nServices",
  "Trusted professionals for all your home maintenance and repair needs.":
      "Trusted professionals for all your home maintenance and repair needs.",
  "Try Again": "Try Again",
  "Try again": "Try again",
  "Type a message...": "Type a message...",
  "Unable to complete Apple sign-in. Please try again.":
      "Unable to complete Apple sign-in. Please try again.",
  "Unable to complete Google sign-in. Please try again.":
      "Unable to complete Google sign-in. Please try again.",
  "Unable to delete your account. Please try again.":
      "Unable to delete your account. Please try again.",
  "Unable to fetch location": "Unable to fetch location",
  "Unable to load chat history.": "Unable to load chat history.",
  "Unable to load more chat messages.": "Unable to load more chat messages.",
  "Unable to load notifications. Please try again.":
      "Unable to load notifications. Please try again.",
  "Unable to load profile details.": "Unable to load profile details.",
  "Unable to load service": "Unable to load service",
  "Unable to load this service. Please try again.":
      "Unable to load this service. Please try again.",
  "Unable to load your address and phone. Please retry.":
      "Unable to load your address and phone. Please retry.",
  "Unable to load your bookings.": "Unable to load your bookings.",
  "Unable to load your bookings. Please try again.":
      "Unable to load your bookings. Please try again.",
  "Unable to load your profile. Please try again.":
      "Unable to load your profile. Please try again.",
  "Unable to logout. Please try again.": "Unable to logout. Please try again.",
  "Unable to refresh your purchases. Please try again.":
      "Unable to refresh your purchases. Please try again.",
  "Unable to send attachment.": "Unable to send attachment.",
  "Unable to sign in with Google. Please try again.":
      "Unable to sign in with Google. Please try again.",
  "Unable to start Apple sign-in. Please try again.":
      "Unable to start Apple sign-in. Please try again.",
  "Unable to update notification. Please try again.":
      "Unable to update notification. Please try again.",
  "Unable to update notifications. Please try again.":
      "Unable to update notifications. Please try again.",
  "Unable to update your profile.": "Unable to update your profile.",
  "Unable to upload profile image.": "Unable to upload profile image.",
  "Unable to verify Apple sign-in.": "Unable to verify Apple sign-in.",
  "Unable to verify Google signup. Please try again.":
      "Unable to verify Google signup. Please try again.",
  "Unable to verify your Google account. Please try again.":
      "Unable to verify your Google account. Please try again.",
  "Update Address": "Update Address",
  "Update contacts and safety team on your movement.":
      "Update contacts and safety team on your movement.",
  "Upload Evidence": "Upload Evidence",
  "Use current location": "Use current location",
  "Use previous location": "Use previous location",
  "Use this address": "Use this address",
  "Verify Professional Arrival": "Verify Professional Arrival",
  "Video": "Video",
  "Video must be 50 MB or smaller.": "Video must be 50 MB or smaller.",
  "View details": "View details",
  "View plan details": "View plan details",
  "Wallet Payment": "Wallet Payment",
  "What’s included": "What’s included",
  "Write a note for the technician...": "Write a note for the technician...",
  "Write your review here...": "Write your review here...",
  "Your address was saved, but could not be selected. Choose it from saved addresses.":
      "Your address was saved, but could not be selected. Choose it from saved addresses.",
  "Your money is safe with us": "Your money is safe with us",
  "Your payment is still being processed. Please wait and try again.":
      "Your payment is still being processed. Please wait and try again.",
  "Your technician": "Your technician",
  "Zoom in": "Zoom in",
  "Zoom out": "Zoom out",
  "e.g. #ORD-77291": "e.g. #ORD-77291",
  "e.g. Booking inquiry or Technical issue":
      "e.g. Booking inquiry or Technical issue",

  // Application-wide UI messages.
  "\"When SOS is triggered, location and booking details are shared automatically with these contacts.\"":
      "\"When SOS is triggered, location and booking details are shared automatically with these contacts.\"",
  "%\nOFF": "%\nOFF",
  "(@p0 reviews)": "(@p0 reviews)",
  "(Optional)": "(Optional)",
  "+ Add": "+ Add",
  "100% of your tips goes to our\ntechnicians only.":
      "100% of your tips goes to our\ntechnicians only.",
  "15 Minutes": "15 Minutes",
  "24 Hours": "24 Hours",
  "4.3 (124 Reviews)": "4.3 (124 Reviews)",
  "@p0 (@p1 Reviews)": "@p0 (@p1 Reviews)",
  "@p0 (@p1 reviews)": "@p0 (@p1 reviews)",
  "@p0 @p1 · @p2 months": "@p0 @p1 · @p2 months",
  "@p0 booked service@p1": "@p0 booked service@p1",
  "@p0 charged once for @p1 months. Enter your card details securely in Stripe to pay.":
      "@p0 charged once for @p1 months. Enter your card details securely in Stripe to pay.",
  "@p0 min per service": "@p0 min per service",
  "@p0 unavailable": "@p0 unavailable",
  "@p0 unread": "@p0 unread",
  "@p0 · @p1 months · one-time payment": "@p0 · @p1 months · one-time payment",
  "@p0% off": "@p0% off",
  "Add": "Add",
  "Add New Card": "Add New Card",
  "Add New Payment Method": "Add New Payment Method",
  "Add a Note ": "Add a Note ",
  "Additional Contact": "Additional Contact",
  "Additional items": "Additional items",
  "All fees are listed in @p0.": "All fees are listed in @p0.",
  "All read": "All read",
  "All services booked through SOS are monitored and supported to ensure a safe, transparent, and reliable experience. Follow these simple steps for a smooth service journey.":
      "All services booked through SOS are monitored and supported to ensure a safe, transparent, and reliable experience. Follow these simple steps for a smooth service journey.",
  "All services, one app.": "All services, one app.",
  "Alternative Phone": "Alternative Phone",
  "Amount paid": "Amount paid",
  "Apple registration expired. Go back and sign in with Apple again.":
      "Apple registration expired. Go back and sign in with Apple again.",
  "Apply": "Apply",
  "Apply a coupon code at checkout to get instant discount on your service booking.":
      "Apply a coupon code at checkout to get instant discount on your service booking.",
  "Are you sure you want to delete this address?":
      "Are you sure you want to delete this address?",
  "Assignment details will appear here when available.":
      "Assignment details will appear here when available.",
  "Attach screenshots or relevant files":
      "Attach screenshots or relevant files",
  "Availability": "Availability",
  "Available Coupons": "Available Coupons",
  "Average wait time: ~ 2 mins": "Average wait time: ~ 2 mins",
  "BOOK": "BOOK",
  "BOOK NOW": "BOOK NOW",
  "Best deal": "Best deal",
  "Book now": "Book now",
  "Booked services": "Booked services",
  "Booking Confirmed!": "Booking Confirmed!",
  "Booking ID: #A12345": "Booking ID: #A12345",
  "Booking ID: @p0": "Booking ID: @p0",
  "Booking Service ID: SOS-1202": "Booking Service ID: SOS-1202",
  "Building and floor details are saved separately and won’t move the map pin.":
      "Building and floor details are saved separately and won’t move the map pin.",
  "CANCELLATION POLICY": "CANCELLATION POLICY",
  "CURRENT BALANCE": "CURRENT BALANCE",
  "Change": "Change",
  "Change Picture": "Change Picture",
  "Change service address": "Change service address",
  "Choose how you'd like to add your profile photo":
      "Choose how you'd like to add your profile photo",
  "Clear filters": "Clear filters",
  "Confirming your booking…": "Confirming your booking…",
  "Connect instantly with our technical experts.":
      "Connect instantly with our technical experts.",
  "Contact number not available": "Contact number not available",
  "Could not load @p0": "Could not load @p0",
  "Covers 3 Devices - Laptops, Desktops,\nPrinters, Phones etc.":
      "Covers 3 Devices - Laptops, Desktops,\nPrinters, Phones etc.",
  "Current location updated": "Current location updated",
  "Currently Assigned Technician": "Currently Assigned Technician",
  "Delete Account": "Delete Account",
  "EMERGENCY SOS": "EMERGENCY SOS",
  "ENTER AMOUNT": "ENTER AMOUNT",
  "EXPERT": "EXPERT",
  "Email Us": "Email Us",
  "Enter your manual code below to\nadd it to your wallet.":
      "Enter your manual code below to\nadd it to your wallet.",
  "Estimated Arrival": "Estimated Arrival",
  "Excellent": "Excellent",
  "Expires: @p0": "Expires: @p0",
  "Explore by Category": "Explore by Category",
  "Explore by Services": "Explore by Services",
  "Fair": "Fair",
  "Fetching your location...": "Fetching your location...",
  "Fetching your purchase details.": "Fetching your purchase details.",
  "Give your home a fresh new look\nwith our expert painting services.":
      "Give your home a fresh new look\nwith our expert painting services.",
  "Go to Home": "Go to Home",
  "Good": "Good",
  "HEY!": "HEY!",
  "HEY, @p0!": "HEY, @p0!",
  "Have a Promo Code?": "Have a Promo Code?",
  "Help us reduce the time of a technician by avoiding service cancellation. A 100% cancellation charge will be applied if the technician is assigned.":
      "Help us reduce the time of a technician by avoiding service cancellation. A 100% cancellation charge will be applied if the technician is assigned.",
  "Home service": "Home service",
  "How can we help?": "How can we help?",
  "How it works?": "How it works?",
  "How was your experience with Michael Johnson?":
      "How was your experience with Michael Johnson?",
  "Includes your service and selected add-ons. Charged in USD.":
      "Includes your service and selected add-ons. Charged in USD.",
  "Invoice details are unavailable.": "Invoice details are unavailable.",
  "LIMITED TIME OFFER": "LIMITED TIME OFFER",
  "LINK >": "LINK >",
  "Loading your bookings…": "Loading your bookings…",
  "Loading your plans…": "Loading your plans…",
  "Loading…": "Loading…",
  "Log In": "Log In",
  "Looking for?": "Looking for?",
  "Mark all read": "Mark all read",
  "Monday — Sunday": "Monday — Sunday",
  "Money added to your SOS wallet can be used for instant bookings and payments across all network services. Standard T&Cs apply.":
      "Money added to your SOS wallet can be used for instant bookings and payments across all network services. Standard T&Cs apply.",
  "NEW": "NEW",
  "No address selected": "No address selected",
  "No bookings yet": "No bookings yet",
  "No matching bookings": "No matching bookings",
  "No service lines are available.": "No service lines are available.",
  "No services available.": "No services available.",
  "No services found.": "No services found.",
  "Not Verified": "Not Verified",
  "Not available": "Not available",
  "ON PAINTING\nSERVICES": "ON PAINTING\nSERVICES",
  "OTP: 1202": "OTP: 1202",
  "Offer ends at 11:59 PM": "Offer ends at 11:59 PM",
  "On the way": "On the way",
  "One-time payment · @p0 months": "One-time payment · @p0 months",
  "Optional — share anything the pro should know":
      "Optional — share anything the pro should know",
  "Our dedicated support team typically responds within 24 hours to ensure your SOS experience is seamless.":
      "Our dedicated support team typically responds within 24 hours to ensure your SOS experience is seamless.",
  "Our expert agents are ready to assist you with any technical hurdles or service requests.":
      "Our expert agents are ready to assist you with any technical hurdles or service requests.",
  "Paid: @p0": "Paid: @p0",
  "Pay by Cash / UPI on Service": "Pay by Cash / UPI on Service",
  "Pay by any UPI app": "Pay by any UPI app",
  "Pay via QR Code": "Pay via QR Code",
  "Payment is not confirmed yet. Check payment again shortly.":
      "Payment is not confirmed yet. Check payment again shortly.",
  "Payment received. Your booking is pending service confirmation.":
      "Payment received. Your booking is pending service confirmation.",
  "Permanently remove account": "Permanently remove account",
  "Plan price": "Plan price",
  "Please report it immediately through the app.":
      "Please report it immediately through the app.",
  "Please wait while we verify your payment.":
      "Please wait while we verify your payment.",
  "Poor": "Poor",
  "Prefer not to call?": "Prefer not to call?",
  "Previous rating: @p0 star@p1": "Previous rating: @p0 star@p1",
  "Pro SOS Plan": "Pro SOS Plan",
  "Proceed to Pay": "Proceed to Pay",
  "Protecting You Every Step of the Way":
      "Protecting You Every Step of the Way",
  "Purchases unavailable": "Purchases unavailable",
  "Quantity: @p0": "Quantity: @p0",
  "Quick Actions": "Quick Actions",
  "Rate Your Experience": "Rate Your Experience",
  "Read": "Read",
  "Ready for jobs": "Ready for jobs",
  "Redeem": "Redeem",
  "Remove": "Remove",
  "Report Safety Concerns": "Report Safety Concerns",
  "Search on the map or enter the address below":
      "Search on the map or enter the address below",
  "Select Payment Method": "Select Payment Method",
  "Select gender": "Select gender",
  "Service": "Service",
  "Service Completed!": "Service Completed!",
  "Service ID is missing.": "Service ID is missing.",
  "Service address": "Service address",
  "Service date: @p0": "Service date: @p0",
  "Service details are not available.": "Service details are not available.",
  "Service review submitted successfully.":
      "Service review submitted successfully.",
  "Sign in to see your purchases.": "Sign in to see your purchases.",
  "Speak with our support team": "Speak with our support team",
  "Special": "Special",
  "Starting From": "Starting From",
  "Starts: @p0": "Starts: @p0",
  "Submit Rating": "Submit Rating",
  "Subscribe Now": "Subscribe Now",
  "Suggest us a Service": "Suggest us a Service",
  "Suggest us a service & we'll look into it":
      "Suggest us a service & we'll look into it",
  "Support Agent": "Support Agent",
  "Support Hours": "Support Hours",
  "T&C Apply": "T&C Apply",
  "TO PREVENT ACCIDENTAL TRIGGERS": "TO PREVENT ACCIDENTAL TRIGGERS",
  "TONIGHT\nONLY!": "TONIGHT\nONLY!",
  "Tap & Hold for 3 Seconds": "Tap & Hold for 3 Seconds",
  "Tap to rate": "Tap to rate",
  "Technician not assigned": "Technician not assigned",
  "Technician review submitted successfully.":
      "Technician review submitted successfully.",
  "Terms of Service are available in the app’s Terms & Conditions.":
      "Terms of Service are available in the app’s Terms & Conditions.",
  "Thank Michael for a\ngreat service!": "Thank Michael for a\ngreat service!",
  "Thank you for choosing SOS Services. We SquadOnSite technicians are always up for you.":
      "Thank you for choosing SOS Services. We SquadOnSite technicians are always up for you.",
  "Thank you for choosing us!": "Thank you for choosing us!",
  "This booking does not contain a valid service ID.":
      "This booking does not contain a valid service ID.",
  "This includes:": "This includes:",
  "This service is currently unavailable.":
      "This service is currently unavailable.",
  "To Pay: ": "To Pay: ",
  "Today jobs": "Today jobs",
  "Today, 10:24 AM": "Today, 10:24 AM",
  "Total (USD)": "Total (USD)",
  "Track Now": "Track Now",
  "Try another search or view all bookings.":
      "Try another search or view all bookings.",
  "Unable to load bookings": "Unable to load bookings",
  "Unable to play this video.": "Unable to play this video.",
  "Unlock SOS Wallet": "Unlock SOS Wallet",
  "Unread": "Unread",
  "Update Rating": "Update Rating",
  "Updating...": "Updating...",
  "Upload Profile Photo": "Upload Profile Photo",
  "Uploading...": "Uploading...",
  "Use any UPI app on the phone to pay": "Use any UPI app on the phone to pay",
  "VALID TILL": "VALID TILL",
  "Valid": "Valid",
  "Verified": "Verified",
  "Very Good": "Very Good",
  "View Invoice": "View Invoice",
  "View Less": "View Less",
  "View More Bank": "View More Bank",
  "View My Bookings": "View My Bookings",
  "View Used Coupons": "View Used Coupons",
  "View all": "View all",
  "View and download your invoice": "View and download your invoice",
  "Visa, Mastercard, Rupay & more": "Visa, Mastercard, Rupay & more",
  "Wallet Transactions": "Wallet Transactions",
  "We'll keep you posted on your\nservice requests and latest offers":
      "We'll keep you posted on your\nservice requests and latest offers",
  "We're here to help": "We're here to help",
  "We're here to help you 24/7 with expert technical assistance.":
      "We're here to help you 24/7 with expert technical assistance.",
  "White Tesla Model 3 • ABC-123": "White Tesla Model 3 • ABC-123",
  "Write a Review ": "Write a Review ",
  "You have no plan purchases yet.": "You have no plan purchases yet.",
  "You will receive an update once a technician is assigned.":
      "You will receive an update once a technician is assigned.",
  "You're all caught up": "You're all caught up",
  "Your Emergency Contacts": "Your Emergency Contacts",
  "Your booking has been confirmed and payment of \$@p0 has been processed successfully.":
      "Your booking has been confirmed and payment of \$@p0 has been processed successfully.",
  "Your next plan starts here": "Your next plan starts here",
  "Your purchase details could not be loaded.":
      "Your purchase details could not be loaded.",
  "Your purchased plans and coverage details will appear here.":
      "Your purchased plans and coverage details will appear here.",
  "Your service bookings will appear here.":
      "Your service bookings will appear here.",
  "Your support is our priority": "Your support is our priority",
  "Zoom in and move the map so the pin marks your exact entrance.":
      "Zoom in and move the map so the pin marks your exact entrance.",
  "per month": "per month",

  // Shared labels, statuses, validation and service descriptions.
  "03:15 PM": "03:15 PM",
  "1 Onboarding Non-Refundable.": "1 Onboarding Non-Refundable.",
  "1 onboarding · non-refundable": "1 onboarding · non-refundable",
  "10:30 AM": "10:30 AM",
  "12 service calls · 3 per quarter": "12 service calls · 3 per quarter",
  "12:45 PM": "12:45 PM",
  "20 service calls · 5 per quarter": "20 service calls · 5 per quarter",
  "24/7 on-demand assistance": "24/7 on-demand assistance",
  "25 - 30 mins": "25 - 30 mins",
  "4 service calls · 1 per quarter": "4 service calls · 1 per quarter",
  "8 Tickets - 2/Quarter.": "8 Tickets - 2/Quarter.",
  "AC Repair": "AC Repair",
  "AM": "AM",
  "About This Service": "About This Service",
  "Account Security": "Account Security",
  "Active Session": "Active Session",
  "Address line *": "Address line *",
  "Address not provided": "Address not provided",
  "Address search is busy. Please wait and retry.":
      "Address search is busy. Please wait and retry.",
  "Address search is temporarily unavailable. Please retry later.":
      "Address search is temporarily unavailable. Please retry later.",
  "Address search is temporarily unavailable. Please retry.":
      "Address search is temporarily unavailable. Please retry.",
  "Address search timed out. Please retry.":
      "Address search timed out. Please retry.",
  "Adjustments": "Adjustments",
  "Advanced SOS": "Advanced SOS",
  "All": "All",
  "All Services": "All Services",
  "All approved estimates remain recorded for your reference.":
      "All approved estimates remain recorded for your reference.",
  "Amount": "Amount",
  "An error occurred.": "An error occurred.",
  "Android • Chandigarh": "Android • Chandigarh",
  "Any issue not reflected in the booking":
      "Any issue not reflected in the booking",
  "Apple Pay UPI": "Apple Pay UPI",
  "Apple authorization": "Apple authorization",
  "Apple identity, authorization code and challenge tokens are required.":
      "Apple identity, authorization code and challenge tokens are required.",
  "Apple sign-in is currently available on Apple devices only.":
      "Apple sign-in is currently available on Apple devices only.",
  "Appliance Repair": "Appliance Repair",
  "Apr": "Apr",
  "April": "April",
  "Area": "Area",
  "Aug": "Aug",
  "August": "August",
  "Authentication required": "Authentication required",
  "Available Add-ons": "Available Add-ons",
  "Average wait ~ 2 mins": "Average wait ~ 2 mins",
  "Axis\nBank": "Axis\nBank",
  "BHIM UPI": "BHIM UPI",
  "BILL TO": "BILL TO",
  "Balance Due": "Balance Due",
  "Before work begins, verify the professional assigned to your booking and share the OTP only after they arrive at your location.":
      "Before work begins, verify the professional assigned to your booking and share the OTP only after they arrive at your location.",
  "Booked on": "Booked on",
  "Booked price": "Booked price",
  "Booking Period": "Booking Period",
  "Building / Flat / Floor (optional)": "Building / Flat / Floor (optional)",
  "Business": "Business",
  "Business Enterprise": "Business Enterprise",
  "Business Professional": "Business Professional",
  "Business Starter": "Business Starter",
  "Cancelled": "Cancelled",
  "Carbonite Data Backup.": "Carbonite Data Backup.",
  "Carbonite data backup": "Carbonite data backup",
  "Cash on Delivery": "Cash on Delivery",
  "Chat is offline. Please try again.": "Chat is offline. Please try again.",
  "Chat support · 5-minute response target":
      "Chat support · 5-minute response target",
  "Check your previous payment before starting another purchase.":
      "Check your previous payment before starting another purchase.",
  "Choose Package": "Choose Package",
  "City": "City",
  "Confirmed": "Confirmed",
  "Contact Number": "Contact Number",
  "Could not load this place. Please search again.":
      "Could not load this place. Please search again.",
  "Could not load this place. Retry or enter the address manually.":
      "Could not load this place. Retry or enter the address manually.",
  "Could not load video": "Could not load video",
  "Could not read place search results. Try again.":
      "Could not read place search results. Try again.",
  "Could not search places. Check your connection and try again.":
      "Could not search places. Check your connection and try again.",
  "Covers Printer, Modem, Router.": "Covers Printer, Modem, Router.",
  "Covers phones and tablets": "Covers phones and tablets",
  "Covers printer, modem and router": "Covers printer, modem and router",
  "Credit & Debit Cards": "Credit & Debit Cards",
  "Current location": "Current location",
  "Customer": "Customer",
  "Date to be confirmed": "Date to be confirmed",
  "Dec": "Dec",
  "December": "December",
  "Dedicated account manager": "Dedicated account manager",
  "Describe your issue": "Describe your issue",
  "Duke (Dad)": "Duke (Dad)",
  "Edit Service Rating": "Edit Service Rating",
  "Edit Technician Rating": "Edit Technician Rating",
  "Email": "Email",
  "Email is already registered. Please log in.":
      "Email is already registered. Please log in.",
  "Endpoint security included": "Endpoint security included",
  "Enter a valid 10-digit number": "Enter a valid 10-digit number",
  "Enter a valid phone number": "Enter a valid phone number",
  "Enter the person's name": "Enter the person's name",
  "Estimated Time": "Estimated Time",
  "Every Time": "Every Time",
  "Expert Home": "Expert Home",
  "FAQs": "FAQs",
  "Feb": "Feb",
  "February": "February",
  "Female": "Female",
  "Finding Technician": "Finding Technician",
  "Frequently asked questions": "Frequently asked questions",
  "Google did not return an access token. Please try again.":
      "Google did not return an access token. Please try again.",
  "Google verification expired or was rejected. Please sign in again.":
      "Google verification expired or was rejected. Please sign in again.",
  "Greater Kailash": "Greater Kailash",
  "HDFC\nBank": "HDFC\nBank",
  "HSBC\nBank": "HSBC\nBank",
  "How It Works": "How It Works",
  "How it works": "How it works",
  "How was the service?": "How was the service?",
  "How was your technician?": "How was your technician?",
  "ICICI\nBank": "ICICI\nBank",
  "INVOICE DETAILS": "INVOICE DETAILS",
  "IOB\nBank": "IOB\nBank",
  "Image": "Image",
  "Includes Security – 5 Devices.": "Includes Security – 5 Devices.",
  "Incorrect professional assignment": "Incorrect professional assignment",
  "Indirapuram": "Indirapuram",
  "Internal server error.": "Internal server error.",
  "Invalid payment order": "Invalid payment order",
  "Invalid profile response": "Invalid profile response",
  "Invoice Date": "Invoice Date",
  "Invoice Number": "Invoice Number",
  "Invoice URL is unavailable.": "Invoice URL is unavailable.",
  "Jan": "Jan",
  "January": "January",
  "Jul": "Jul",
  "July": "July",
  "Jun": "Jun",
  "June": "June",
  "Just now": "Just now",
  "Last updated": "Last updated",
  "Location": "Location",
  "Love Your": "Love Your",
  "Make payments only after the service has been completed and reviewed.":
      "Make payments only after the service has been completed and reviewed.",
  "Male": "Male",
  "Mar": "Mar",
  "March": "March",
  "Mastercard •••• 8810": "Mastercard •••• 8810",
  "May": "May",
  "Maya": "Maya",
  "Monitor booking progress, service status, and important updates directly within the app.":
      "Monitor booking progress, service status, and important updates directly within the app.",
  "More": "More",
  "Name": "Name",
  "Neha Verma": "Neha Verma",
  "Netbanking": "Netbanking",
  "New update": "New update",
  "No additional comments": "No additional comments",
  "No app account exists for this Google email. Please sign up.":
      "No app account exists for this Google email. Please sign up.",
  "No internet connection. Please try again.":
      "No internet connection. Please try again.",
  "No payment was taken. Please refresh the service prices and try again.":
      "No payment was taken. Please refresh the service prices and try again.",
  "No places found. Try a different search.":
      "No places found. Try a different search.",
  "Not Included": "Not Included",
  "Nov": "Nov",
  "November": "November",
  "Oct": "Oct",
  "October": "October",
  "Office 365 included": "Office 365 included",
  "Office Pro Plus & server backup": "Office Pro Plus & server backup",
  "Office Pro Plus · 3 devices": "Office Pro Plus · 3 devices",
  "Optional notification setup": "Optional notification setup",
  "Order ID": "Order ID",
  "Our Care": "Our Care",
  "PAYMENT SUMMARY": "PAYMENT SUMMARY",
  "PM": "PM",
  "Paid Amount": "Paid Amount",
  "Pay by UPI": "Pay by UPI",
  "PayPal Payments": "PayPal Payments",
  "Payment Breakdown": "Payment Breakdown",
  "Payment ID": "Payment ID",
  "Payment Status": "Payment Status",
  "Payment canceled. No plan was activated.":
      "Payment canceled. No plan was activated.",
  "Payment failed. Check payment before trying another purchase.":
      "Payment failed. Check payment before trying another purchase.",
  "Payment is not confirmed yet. Use Check payment to retry.":
      "Payment is not confirmed yet. Use Check payment to retry.",
  "Payment is processing. Use Check payment to verify it later.":
      "Payment is processing. Use Check payment to verify it later.",
  "Payment provider": "Payment provider",
  "Payments are temporarily unavailable. Please try again later.":
      "Payments are temporarily unavailable. Please try again later.",
  "Person's contact number": "Person's contact number",
  "Person's full name": "Person's full name",
  "Phone": "Phone",
  "Plan pricing changed. Refresh plans and review the new price before paying.":
      "Plan pricing changed. Refresh plans and review the new price before paying.",
  "Please sign in before purchasing a plan.":
      "Please sign in before purchasing a plan.",
  "Plumbing Service": "Plumbing Service",
  "Pro SOS": "Pro SOS",
  "Profile update failed.": "Profile update failed.",
  "Qty": "Qty",
  "Quality Service,": "Quality Service,",
  "Rate our service": "Rate our service",
  "Rate technician": "Rate technician",
  "Rate your service experience and provide feedback once the job is completed.":
      "Rate your service experience and provide feedback once the job is completed.",
  "Read less": "Read less",
  "Read more": "Read more",
  "Real-time tracking keeps everything transparent and documented.":
      "Real-time tracking keeps everything transparent and documented.",
  "Recommended Payments": "Recommended Payments",
  "Reena (Mom)": "Reena (Mom)",
  "Repair Services": "Repair Services",
  "Reply in 24 hours": "Reply in 24 hours",
  "Request failed.": "Request failed.",
  "Request failed. Please try again.": "Request failed. Please try again.",
  "Requested resource not found.": "Requested resource not found.",
  "Requirements": "Requirements",
  "Residential": "Residential",
  "Review the service estimate and any additional work recommendations carefully. Approve only the charges you agree with.":
      "Review the service estimate and any additional work recommendations carefully. Approve only the charges you agree with.",
  "Ritika Sharma": "Ritika Sharma",
  "SBI\nBank": "SBI\nBank",
  "SERVICES ORDERED": "SERVICES ORDERED",
  "Safety concerns during service": "Safety concerns during service",
  "Sarah (Sis)": "Sarah (Sis)",
  "Scheduled Date": "Scheduled Date",
  "Searching places…": "Searching places…",
  "Search…": "Search…",
  "Sector 15, Noida": "Sector 15, Noida",
  "Secure payments help maintain accurate records and enable faster support if required.":
      "Secure payments help maintain accurate records and enable faster support if required.",
  "Security for 5 devices": "Security for 5 devices",
  "Selected add-on": "Selected add-on",
  "Selected variant": "Selected variant",
  "Sep": "Sep",
  "September": "September",
  "Service\nCompleted!": "Service\nCompleted!",
  "Service Address": "Service Address",
  "Service Name": "Service Name",
  "Service Option": "Service Option",
  "Service booking": "Service booking",
  "Service date": "Service date",
  "Service is in progress": "Service is in progress",
  "Servicing...": "Servicing...",
  "Sign-in was cancelled.": "Sign-in was cancelled.",
  "Smart Lock - Video Doorbell Setup": "Smart Lock - Video Doorbell Setup",
  "Smart SOS": "Smart SOS",
  "Something went wrong. Please try again.":
      "Something went wrong. Please try again.",
  "Special Instructions": "Special Instructions",
  "SquadOnSite": "SquadOnSite",
  "State": "State",
  "Street (optional)": "Street (optional)",
  "Subject": "Subject",
  "Subtotal": "Subtotal",
  "Support attachment image": "Support attachment image",
  "Support · 8 AM–8 PM EST": "Support · 8 AM–8 PM EST",
  "Support · 8 AM–midnight EST": "Support · 8 AM–midnight EST",
  "Support · 9 AM–5 PM EST": "Support · 9 AM–5 PM EST",
  "Support. EST 8 AM – EST 8 PM": "Support. EST 8 AM – EST 8 PM",
  "TERMS OF SERVICE": "TERMS OF SERVICE",
  "TV Installation": "TV Installation",
  "Technician Michael Johnson is on the way":
      "Technician Michael Johnson is on the way",
  "Technician is arrived,\nShare the otp and get the service star.":
      "Technician is arrived,\nShare the otp and get the service star.",
  "Technicians": "Technicians",
  "Thank you for choosing us!\nRate our technicians!":
      "Thank you for choosing us!\nRate our technicians!",
  "Thank you for connecting!": "Thank you for connecting!",
  "Thank you for mailing us!": "Thank you for mailing us!",
  "The checkout amount does not match your service and add-ons total. ":
      "The checkout amount does not match your service and add-ons total. ",
  "The server rejected the request without an error message (HTTP 400).":
      "The server rejected the request without an error message (HTTP 400).",
  "Thermostats Installation": "Thermostats Installation",
  "This account is not allowed to purchase plans.":
      "This account is not allowed to purchase plans.",
  "This helps ensure the right professional is attending your service.":
      "This helps ensure the right professional is attending your service.",
  "This plan or purchase is no longer available.":
      "This plan or purchase is no longer available.",
  "This search could not be processed. Try another address.":
      "This search could not be processed. Try another address.",
  "Today": "Today",
  "Today • 11:12 AM": "Today • 11:12 AM",
  "Too many attempts. Please wait and try again.":
      "Too many attempts. Please wait and try again.",
  "Tools & Equipment": "Tools & Equipment",
  "Total Amount": "Total Amount",
  "Total amount": "Total amount",
  "Transaction ID": "Transaction ID",
  "Trusted": "Trusted",
  "UPI / GPay": "UPI / GPay",
  "Unable to complete the request. Please retry. If you paid, use Check payment.":
      "Unable to complete the request. Please retry. If you paid, use Check payment.",
  "Unable to connect. Please check your connection and retry.":
      "Unable to connect. Please check your connection and retry.",
  "Unable to connect. Please try again.":
      "Unable to connect. Please try again.",
  "Unable to load notifications.": "Unable to load notifications.",
  "Unable to load the invoice.": "Unable to load the invoice.",
  "Unable to load the invoice. Please try again.":
      "Unable to load the invoice. Please try again.",
  "Unable to open invoice.": "Unable to open invoice.",
  "Unable to submit the service review.":
      "Unable to submit the service review.",
  "Unable to submit the technician review.":
      "Unable to submit the technician review.",
  "Unable to verify Google account details. Please try again.":
      "Unable to verify Google account details. Please try again.",
  "Unapproved additional charges": "Unapproved additional charges",
  "Unauthorized. Please login again.": "Unauthorized. Please login again.",
  "Unexpected server response": "Unexpected server response",
  "Unit Price": "Unit Price",
  "United States": "United States",
  "Unprofessional behavior": "Unprofessional behavior",
  "User": "User",
  "Verification": "Verification",
  "Video unavailable": "Video unavailable",
  "Vikas Kumar": "Vikas Kumar",
  "Visa Card •••• 4492": "Visa Card •••• 4492",
  "We are Done!": "We are Done!",
  "We are finding the best technician for you":
      "We are finding the best technician for you",
  "We are hoping everything is going smooth.":
      "We are hoping everything is going smooth.",
  "We hope your issue was resolved.\nReach out anytime if you need further time.":
      "We hope your issue was resolved.\nReach out anytime if you need further time.",
  "We will get back to you within 24 to 48 hours":
      "We will get back to you within 24 to 48 hours",
  "We will notify you once\na technician is assigned":
      "We will notify you once\na technician is assigned",
  "Website": "Website",
  "What's Included": "What's Included",
  "Work": "Work",
  "Yesterday": "Yesterday",
  "You do not have permission.": "You do not have permission.",
  "You have a new notification": "You have a new notification",
  "Your Home,": "Your Home,",
  "Your location": "Your location",
  "Your reviews help us improve service quality and recognize top-performing professionals.":
      "Your reviews help us improve service quality and recognize top-performing professionals.",
  "Your session expired. Please sign in again.":
      "Your session expired. Please sign in again.",
  "Your session has expired. Sign in again to search.":
      "Your session has expired. Sign in again to search.",
  "ZIP / Postal code": "ZIP / Postal code",
  "privacy policy": "privacy policy",
  "terms and conditions": "terms and conditions",

  // Bundled legal document translations.
  "Your privacy matters": "Your privacy matters",
  "SquadOnSite · Customer Privacy Policy":
      "SquadOnSite · Customer Privacy Policy",
  "This policy explains how personal information is used when you create an account, book a service, make a payment, or communicate through SquadOnSite (SOS). It also explains the choices available to you.":
      "This policy explains how personal information is used when you create an account, book a service, make a payment, or communicate through SquadOnSite (SOS). It also explains the choices available to you.",
  "1. About this policy": "1. About this policy",
  "SquadOnSite connects customers with service professionals. This policy covers personal information handled in connection with the customer app and related service interactions. Third-party services you choose to use may also have their own privacy policies.":
      "SquadOnSite connects customers with service professionals. This policy covers personal information handled in connection with the customer app and related service interactions. Third-party services you choose to use may also have their own privacy policies.",
  "2. Information you provide": "2. Information you provide",
  "Account details: your name, email address, phone number, and information used to sign in or verify your account.":
      "Account details: your name, email address, phone number, and information used to sign in or verify your account.",
  "Profile details: your profile photo, date of birth, gender, and alternate contact details when you provide them.":
      "Profile details: your profile photo, date of birth, gender, and alternate contact details when you provide them.",
  "Service details: saved addresses, location coordinates, booking instructions, appointment times, selected services, and booking history.":
      "Service details: saved addresses, location coordinates, booking instructions, appointment times, selected services, and booking history.",
  "Communications and feedback: messages, service reviews, ratings, and information you share when asking for assistance.":
      "Communications and feedback: messages, service reviews, ratings, and information you share when asking for assistance.",
  "Payment records: transaction references, payment status, wallet activity, refunds, and amounts associated with your bookings.":
      "Payment records: transaction references, payment status, wallet activity, refunds, and amounts associated with your bookings.",
  "If you provide another person's contact details or address, make sure you have permission to share them. Avoid including unnecessary sensitive information in booking instructions, reviews, or messages.":
      "If you provide another person's contact details or address, make sure you have permission to share them. Avoid including unnecessary sensitive information in booking instructions, reviews, or messages.",
  "3. Information from your device and sign-in providers":
      "3. Information from your device and sign-in providers",
  "The app uses session identifiers and locally stored account information to keep you signed in. Push notification tokens help deliver notifications to your device.":
      "The app uses session identifiers and locally stored account information to keep you signed in. Push notification tokens help deliver notifications to your device.",
  "If you choose Google or Apple sign-in, we receive the account details and authentication information made available by that provider, such as your name, email address, and account identifier. The information available depends on your provider settings.":
      "If you choose Google or Apple sign-in, we receive the account details and authentication information made available by that provider, such as your name, email address, and account identifier. The information available depends on your provider settings.",
  "4. How information is used": "4. How information is used",
  "Create and manage your account, authenticate sign-ins, and maintain your session.":
      "Create and manage your account, authenticate sign-ins, and maintain your session.",
  "Find service locations, arrange bookings, assign professionals, and provide booking status updates.":
      "Find service locations, arrange bookings, assign professionals, and provide booking status updates.",
  "Process payments and maintain records of transactions, wallet balances, and refunds.":
      "Process payments and maintain records of transactions, wallet balances, and refunds.",
  "Enable service communications, respond to questions, and address booking issues.":
      "Enable service communications, respond to questions, and address booking issues.",
  "Investigate misuse, resolve disputes, and meet applicable legal obligations.":
      "Investigate misuse, resolve disputes, and meet applicable legal obligations.",
  "5. Location and device permissions": "5. Location and device permissions",
  "When you use a location feature and grant permission, the app can obtain your device location to help select a service address. You can also enter an address manually. A service address remains necessary to arrange an on-site visit.":
      "When you use a location feature and grant permission, the app can obtain your device location to help select a service address. You can also enter an address manually. A service address remains necessary to arrange an on-site visit.",
  "Camera or photo access supports features such as choosing a profile image. Notification permission allows the app to show booking and service updates.":
      "Camera or photo access supports features such as choosing a profile image. Notification permission allows the app to show booking and service updates.",
  "You can change these permissions in your device settings. Disabling a permission may limit the related feature. Changing permissions does not automatically delete information already submitted.":
      "You can change these permissions in your device settings. Disabling a permission may limit the related feature. Changing permissions does not automatically delete information already submitted.",
  "6. Service professionals and other recipients":
      "6. Service professionals and other recipients",
  "Information needed to arrange and complete a booking, such as your service address, contact details, requested service, and instructions, may be shared with the assigned service professional.":
      "Information needed to arrange and complete a booking, such as your service address, contact details, requested service, and instructions, may be shared with the assigned service professional.",
  "Service providers supporting authentication, maps, notifications, payments, and app infrastructure process information required for their roles. Integrations used by the app include Google Maps, Firebase Cloud Messaging, Google and Apple sign-in, and Stripe for supported payment flows.":
      "Service providers supporting authentication, maps, notifications, payments, and app infrastructure process information required for their roles. Integrations used by the app include Google Maps, Firebase Cloud Messaging, Google and Apple sign-in, and Stripe for supported payment flows.",
  "Information may also be disclosed where required by applicable law or needed to address fraud, safety concerns, or legal claims.":
      "Information may also be disclosed where required by applicable law or needed to address fraud, safety concerns, or legal claims.",
  "7. Payments": "7. Payments",
  "For supported payment flows, payment details are processed through the payment provider. SquadOnSite uses transaction identifiers, amounts, and payment results to update bookings and payment records. The provider's own privacy policy explains its handling of payment information.":
      "For supported payment flows, payment details are processed through the payment provider. SquadOnSite uses transaction identifiers, amounts, and payment results to update bookings and payment records. The provider's own privacy policy explains its handling of payment information.",
  "Do not send card security codes, passwords, or one-time verification codes in service instructions or support messages.":
      "Do not send card security codes, passwords, or one-time verification codes in service instructions or support messages.",
  "8. Storage and retention": "8. Storage and retention",
  "Information may be held on your device and in systems used to operate the service. Retention depends on the type of information, the purpose for which it was collected, and applicable recordkeeping requirements. Booking and payment records may need to be retained to resolve disputes or meet legal obligations.":
      "Information may be held on your device and in systems used to operate the service. Retention depends on the type of information, the purpose for which it was collected, and applicable recordkeeping requirements. Booking and payment records may need to be retained to resolve disputes or meet legal obligations.",
  "Signing out or uninstalling the app does not by itself delete your account or records held by the service. Storage locations and international processing depend on the providers supporting the service.":
      "Signing out or uninstalling the app does not by itself delete your account or records held by the service. Storage locations and international processing depend on the providers supporting the service.",
  "9. Account security": "9. Account security",
  "No method of electronic transmission or storage can guarantee complete security. Protect your device and sign-in credentials, and avoid sharing access to your account. Report suspected unauthorized account activity by emailing support@sosgeek.tech.":
      "No method of electronic transmission or storage can guarantee complete security. Protect your device and sign-in credentials, and avoid sharing access to your account. Report suspected unauthorized account activity by emailing support@sosgeek.tech.",
  "10. Your choices and privacy requests":
      "10. Your choices and privacy requests",
  "Review and update available account details in the Personal Information screen.":
      "Review and update available account details in the Personal Information screen.",
  "Manage location, camera, photos, and notification permissions through your device settings.":
      "Manage location, camera, photos, and notification permissions through your device settings.",
  "Manage access granted to Google or Apple sign-in through the relevant provider's account settings.":
      "Manage access granted to Google or Apple sign-in through the relevant provider's account settings.",
  "Depending on the law that applies to you, you may have rights to request access, correction, deletion, or a copy of your information, or to object to or restrict certain processing. Some requests may be subject to identity verification and legal exceptions, including required retention of transaction records.":
      "Depending on the law that applies to you, you may have rights to request access, correction, deletion, or a copy of your information, or to object to or restrict certain processing. Some requests may be subject to identity verification and legal exceptions, including required retention of transaction records.",
  "11. Children's privacy": "11. Children's privacy",
  "The service is designed for customers who can arrange and pay for service bookings. If you believe a child has provided personal information without appropriate authorization, raise the concern by emailing support@sosgeek.tech so it can be reviewed.":
      "The service is designed for customers who can arrange and pay for service bookings. If you believe a child has provided personal information without appropriate authorization, raise the concern by emailing support@sosgeek.tech so it can be reviewed.",
  "12. Policy updates": "12. Policy updates",
  "This policy may be revised as the service or its information practices change. Review the policy available in the app for the current wording. Additional notice or consent may be required by applicable law for certain changes.":
      "This policy may be revised as the service or its information practices change. Review the policy available in the app for the current wording. Additional notice or consent may be required by applicable law for certain changes.",
  "13. Privacy questions": "13. Privacy questions",
  "When contacting SquadOnSite about privacy by emailing support@sosgeek.tech, describe your question or request and provide only the account details needed to identify your account. Do not include your password or payment security codes.":
      "When contacting SquadOnSite about privacy by emailing support@sosgeek.tech, describe your question or request and provide only the account details needed to identify your account. Do not include your password or payment security codes.",
  "Published Privacy Policy: https://sosgeeks.com/privacy-policy/":
      "Published Privacy Policy: https://sosgeeks.com/privacy-policy/",
  "Website: https://sosgeeks.com/ Support and privacy enquiries: support@sosgeek.tech":
      "Website: https://sosgeeks.com/ Support and privacy enquiries: support@sosgeek.tech",
  "Terms & Conditions": "Terms & Conditions",
  "SquadOnSite · Customer services & support plans":
      "SquadOnSite · Customer services & support plans",
  "Please read these terms before creating an account, booking a service, or purchasing a support plan. They explain your responsibilities and how bookings, payments, and plan benefits work. Review the specific service or plan details before confirming an order.":
      "Please read these terms before creating an account, booking a service, or purchasing a support plan. They explain your responsibilities and how bookings, payments, and plan benefits work. Review the specific service or plan details before confirming an order.",
  "1. About SquadOnSite": "1. About SquadOnSite",
  "SquadOnSite (SOS) connects customers with service professionals and provides access to service booking and technology support options. The scope of a service depends on the booking or plan you select. These terms apply to the customer app and related service interactions.":
      "SquadOnSite (SOS) connects customers with service professionals and provides access to service booking and technology support options. The scope of a service depends on the booking or plan you select. These terms apply to the customer app and related service interactions.",
  "2. Your account": "2. Your account",
  "Provide accurate contact details and keep your account information up to date.":
      "Provide accurate contact details and keep your account information up to date.",
  "You must have the legal capacity and authority to place an order. If you act for a business or another person, you must be authorized to do so.":
      "You must have the legal capacity and authority to place an order. If you act for a business or another person, you must be authorized to do so.",
  "Keep your sign-in credentials private. Do not share passwords or verification codes with service professionals or in support messages.":
      "Keep your sign-in credentials private. Do not share passwords or verification codes with service professionals or in support messages.",
  "Report suspected unauthorized account activity by emailing support@sosgeek.tech.":
      "Report suspected unauthorized account activity by emailing support@sosgeek.tech.",
  "3. Booking a service": "3. Booking a service",
  "Check the selected service, address, appointment time, instructions, and displayed charges before submitting a booking. Availability depends on the service area and the professionals available. Refer to your booking confirmation and status for the accepted appointment details.":
      "Check the selected service, address, appointment time, instructions, and displayed charges before submitting a booking. Availability depends on the service area and the professionals available. Refer to your booking confirmation and status for the accepted appointment details.",
  "Provide safe access to the service location and obtain permission before arranging work on property or equipment belonging to someone else. Changes to the agreed work or additional charges should be discussed and agreed before that additional work begins.":
      "Provide safe access to the service location and obtain permission before arranging work on property or equipment belonging to someone else. Changes to the agreed work or additional charges should be discussed and agreed before that additional work begins.",
  "4. Residential and business plans": "4. Residential and business plans",
  "Plan coverage is limited to the devices, services, ticket allowances, and support hours described in the selected offer. Residential options include Smart SOS, Pro SOS, and Advanced SOS. Business options include Starter, Professional, and Enterprise bundles.":
      "Plan coverage is limited to the devices, services, ticket allowances, and support hours described in the selected offer. Residential options include Smart SOS, Pro SOS, and Advanced SOS. Business options include Starter, Professional, and Enterprise bundles.",
  "Review the selected duration, supported devices, included software, backup services, and service-call allowances. A ticket or service-call allowance does not mean unlimited support. Do not assume unused allowances roll over, additional devices are included, or coverage extends beyond the stated term unless your order expressly confirms this.":
      "Review the selected duration, supported devices, included software, backup services, and service-call allowances. A ticket or service-call allowance does not mean unlimited support. Do not assume unused allowances roll over, additional devices are included, or coverage extends beyond the stated term unless your order expressly confirms this.",
  "Support hours shown in EST refer to Eastern Standard Time. A stated response target, such as five-minute chat support, describes the initial response rather than a guarantee that an issue will be resolved within that time.":
      "Support hours shown in EST refer to Eastern Standard Time. A stated response target, such as five-minute chat support, describes the initial response rather than a guarantee that an issue will be resolved within that time.",
  "5. Prices and payment": "5. Prices and payment",
  "Before authorizing payment, confirm the currency, total payable amount, taxes or additional fees, billing schedule, and selected term in the final order. An annual payment and a monthly payment option can have different totals; do not assume one is calculated by dividing the other by twelve.":
      "Before authorizing payment, confirm the currency, total payable amount, taxes or additional fees, billing schedule, and selected term in the final order. An annual payment and a monthly payment option can have different totals; do not assume one is calculated by dividing the other by twelve.",
  "A plan listing or viewing plan details does not create a paid subscription. A purchase requires a confirmed order and successful payment. Use only the payment methods offered in the authorized checkout. Never send card security codes or payment credentials in messages.":
      "A plan listing or viewing plan details does not create a paid subscription. A purchase requires a confirmed order and successful payment. Use only the payment methods offered in the authorized checkout. Never send card security codes or payment credentials in messages.",
  "6. Renewal, cancellation, and refunds":
      "6. Renewal, cancellation, and refunds",
  "Review the renewal arrangement and cancellation process disclosed with your order before purchasing. Do not assume a plan renews automatically or ends automatically unless the order states this. Recurring charges require the relevant authorization.":
      "Review the renewal arrangement and cancellation process disclosed with your order before purchasing. Do not assume a plan renews automatically or ends automatically unless the order states this. Recurring charges require the relevant authorization.",
  "Cancellation, rescheduling, and refund eligibility depend on the terms disclosed for the booking or plan and applicable consumer law. A residential offer may identify onboarding as non-refundable; any such condition must be disclosed before purchase and remains subject to rights that cannot legally be excluded.":
      "Cancellation, rescheduling, and refund eligibility depend on the terms disclosed for the booking or plan and applicable consumer law. A residential offer may identify onboarding as non-refundable; any such condition must be disclosed before purchase and remains subject to rights that cannot legally be excluded.",
  "Deleting your account or uninstalling the app does not by itself establish that an existing booking or payment arrangement has been cancelled. Resolve outstanding bookings and any recurring-payment arrangement through the applicable service channel.":
      "Deleting your account or uninstalling the app does not by itself establish that an existing booking or payment arrangement has been cancelled. Resolve outstanding bookings and any recurring-payment arrangement through the applicable service channel.",
  "7. Devices, backups, and remote assistance":
      "7. Devices, backups, and remote assistance",
  "You must be authorized to request access to or work on a device. Back up important files before service and explain any access restrictions. Remote access should be granted only for assistance you have requested and should end when that assistance is complete.":
      "You must be authorized to request access to or work on a device. Back up important files before service and explain any access restrictions. Remote access should be granted only for assistance you have requested and should end when that assistance is complete.",
  "Backup, security, and software benefits apply only where included in your plan and may require installation, activation, compatible equipment, and compliance with the relevant provider's licence terms. No security product or backup process can guarantee protection from every threat or recovery of every file.":
      "Backup, security, and software benefits apply only where included in your plan and may require installation, activation, compatible equipment, and compliance with the relevant provider's licence terms. No security product or backup process can guarantee protection from every threat or recovery of every file.",
  "8. Acceptable use": "8. Acceptable use",
  "Use the app and support services lawfully and respectfully.":
      "Use the app and support services lawfully and respectfully.",
  "Do not submit fraudulent bookings, impersonate another person, misuse payment methods, or provide content you are not entitled to share.":
      "Do not submit fraudulent bookings, impersonate another person, misuse payment methods, or provide content you are not entitled to share.",
  "Do not attempt unauthorized access, disrupt the service, or use assistance to bypass another party's security or software licences.":
      "Do not attempt unauthorized access, disrupt the service, or use assistance to bypass another party's security or software licences.",
  "Keep reviews and messages relevant and avoid disclosing another person's private information.":
      "Keep reviews and messages relevant and avoid disclosing another person's private information.",
  "9. Privacy and communications": "9. Privacy and communications",
  "The Privacy Policy explains how account details, service addresses, communications, payment records, and device permissions relate to the service. Information needed to complete a booking may be shared with the assigned professional and relevant service providers.":
      "The Privacy Policy explains how account details, service addresses, communications, payment records, and device permissions relate to the service. Information needed to complete a booking may be shared with the assigned professional and relevant service providers.",
  "Keep your contact details current so you can receive booking and payment updates. Device notification permissions can be managed in your device settings.":
      "Keep your contact details current so you can receive booking and payment updates. Device notification permissions can be managed in your device settings.",
  "10. Third-party services": "10. Third-party services",
  "Features may use third-party authentication, maps, notifications, payment processing, software, or backup services. Their own terms and privacy policies may also apply. A plan's reference to a third-party product does not expand that product's licence or warranty.":
      "Features may use third-party authentication, maps, notifications, payment processing, software, or backup services. Their own terms and privacy policies may also apply. A plan's reference to a third-party product does not expand that product's licence or warranty.",
  "11. Service availability and responsibility":
      "11. Service availability and responsibility",
  "Service availability can be affected by connectivity, maintenance, device compatibility, and circumstances outside the parties' control. Explain any issue promptly and provide relevant booking or transaction details so it can be investigated.":
      "Service availability can be affected by connectivity, maintenance, device compatibility, and circumstances outside the parties' control. Explain any issue promptly and provide relevant booking or transaction details so it can be investigated.",
  "Nothing in these terms excludes or limits consumer rights, remedies, or responsibilities that cannot be excluded or limited under applicable law. No specific repair outcome, data recovery result, or uninterrupted availability is promised unless expressly confirmed for your service.":
      "Nothing in these terms excludes or limits consumer rights, remedies, or responsibilities that cannot be excluded or limited under applicable law. No specific repair outcome, data recovery result, or uninterrupted availability is promised unless expressly confirmed for your service.",
  "12. Account restrictions and outstanding orders":
      "12. Account restrictions and outstanding orders",
  "Misuse, security concerns, or unlawful activity may require access restrictions while the matter is investigated. Any restriction should be handled consistently with applicable law and obligations relating to existing orders. Keep a record of your booking and payment confirmations.":
      "Misuse, security concerns, or unlawful activity may require access restrictions while the matter is investigated. Any restriction should be handled consistently with applicable law and obligations relating to existing orders. Keep a record of your booking and payment confirmations.",
  "13. Questions and updates": "13. Questions and updates",
  "For questions about an order or these terms, email support@sosgeek.tech and include the relevant booking or transaction reference. Do not include passwords or payment security codes.":
      "For questions about an order or these terms, email support@sosgeek.tech and include the relevant booking or transaction reference. Do not include passwords or payment security codes.",
  "These terms may be updated as the service changes. Review the version presented with your order. Changes remain subject to any notice, consent, or other requirements of applicable law.":
      "These terms may be updated as the service changes. Review the version presented with your order. Changes remain subject to any notice, consent, or other requirements of applicable law.",
  "Published Terms of Service: https://sosgeeks.com/terms-of-service/":
      "Published Terms of Service: https://sosgeeks.com/terms-of-service/",

  // Counts, relative dates and server status display labels.
  "@count booked service": "@count booked service",
  "@count booked services": "@count booked services",
  "Previous rating: @count star": "Previous rating: @count star",
  "Previous rating: @count stars": "Previous rating: @count stars",
  "@count minutes ago": "@count minutes ago",
  "@count hours ago": "@count hours ago",
  "@count days ago": "@count days ago",
  "Paid": "Paid",
  "PAID": "Paid",
  "paid": "Paid",
  "Unpaid": "Unpaid",
  "UNPAID": "Unpaid",
  "unpaid": "Unpaid",
  "Failed": "Failed",
  "FAILED": "Failed",
  "failed": "Failed",
  "In Progress": "In Progress",
  "IN PROGRESS": "In progress",
  "in_progress": "In progress",
  "In progress": "In progress",
  "Assigned": "Assigned",
  "ASSIGNED": "Assigned",
  "assigned": "Assigned",
  "On the Way": "On the Way",
  "ON THE WAY": "On the Way",
  "on_the_way": "On the Way",
  "Checkout": "Checkout",
  "CHECKOUT": "Checkout",
  "checkout": "Checkout",
  "Ongoing": "Ongoing",
  "ONGOING": "Ongoing",
  "ongoing": "Ongoing",
  "Replaced": "Replaced",
  "REPLACED": "Replaced",
  "replaced": "Replaced",
  "Expired": "Expired",
  "EXPIRED": "Expired",
  "expired": "Expired",
  "Active": "Active",
  "ACTIVE": "Active",
  "active": "Active",
  "Refunded": "Refunded",
  "REFUNDED": "Refunded",
  "refunded": "Refunded",
  "CANCELLED": "Cancelled",
  "cancelled": "Cancelled",
  "CONFIRMED": "Confirmed",
  "confirmed": "Confirmed",
  "Enter a valid @count-digit phone number":
      "Enter a valid @count-digit phone number",
  "Minimum @count characters required": "Minimum @count characters required",
  "Maximum @count characters allowed": "Maximum @count characters allowed",
  "Enter a valid @count-digit number for @country":
      "Enter a valid @count-digit number for @country",
};
