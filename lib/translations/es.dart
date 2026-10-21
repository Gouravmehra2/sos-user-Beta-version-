// Spanish translations
const Map<String, String> es = {
  // ── Onboarding ─────────────────────────────────────────────────────────────
  'onboarding_next': 'Siguiente',
  'onboarding_skip': 'Omitir',
  'onboarding_slide1_title': 'Ayuda Experta\nInstantánea',
  'onboarding_slide1_desc':
      'Reserva técnicos de confianza y servicios\na domicilio en cualquier momento y lugar.',
  'onboarding_slide2_title': 'Expertos de Servicio\nVerificados',
  'onboarding_slide2_desc':
      'Cada profesional ha pasado una verificación\nde antecedentes y control de calidad.',
  'onboarding_slide3_title': 'Aplicación SOS.\nTodo el Servicio.',
  'onboarding_slide3_desc':
      'Desde reparación de electrodomésticos hasta\nemergencias — Squad On Site te tiene\ncubierto.',

  // ── Login Bottom Sheet ─────────────────────────────────────────────────────
  'login_sheet_headline': 'Explorar Ahora',
  'login_sheet_subheadline':
      'Reserva técnicos de confianza y servicios\nprofesionales en minutos.',
  'login_sheet_guest_btn': 'Entrar como Invitado',
  'login_sheet_phone_btn': 'Continuar con Teléfono',
  'login_sheet_email_btn': 'Continuar con Email',

  // ── Login Screen (phone) ───────────────────────────────────────────────────
  'login_title': 'Iniciar Sesión',
  'login_subtitle': 'Ingresa tus datos para continuar\ncon Squad On Site',
  'login_hint_phone': 'Número de Teléfono',
  'login_hint_password': 'Contraseña',
  'login_forgot_password': '¿Olvidaste tu Contraseña?',
  'login_sign_in_btn': 'Iniciar Sesión',
  'login_or_divider': 'o',
  'login_no_account': '¿No tienes una cuenta? ',
  'login_sign_up_link': 'Regístrate',

  // ── Email Login Screen ─────────────────────────────────────────────────────
  'email_login_hint_email': 'Ingresa tu Email',

  // ── Sign Up Screen ─────────────────────────────────────────────────────────
  'signup_title': 'Registrarse',
  'signup_subtitle_phone': 'Te enviaremos un código para verificar tu cuenta.',
  'signup_subtitle_email': 'Te enviaremos un código para verificar tu email.',
  'signup_hint_email': 'Ingresa tu email',
  'signup_continue_btn': 'Continuar',
  'signup_have_account': '¿Ya tienes una cuenta? ',
  'signup_sign_in_link': 'Iniciar Sesión',

  // ── OTP Screen ─────────────────────────────────────────────────────────────
  'otp_title_phone': 'Verificar Número',
  'otp_title_email': 'Verificar Email',
  'reset_otp_title': 'Restablecer contraseña',
  'reset_otp_continue': 'Continuar',
  'reset_otp_expires_in': 'El código vence en %s',
  'reset_otp_expired': 'El código venció. Solicita uno nuevo.',
  'reset_session_expired': 'La sesión venció. Solicita un código nuevo.',
  'reset_request_timeout':
      'La solicitud tardó demasiado. Espera el SMS antes de reenviar.',
  'forgot_request_timeout':
      'La solicitud tardó demasiado. Espera el SMS antes de solicitar otro código.',
  'network_retry':
      'No se pudo conectar. Revisa tu conexión e inténtalo de nuevo.',
  'unexpected_server_response':
      'Respuesta inesperada del servidor. Inténtalo de nuevo.',
  'otp_verify_btn': 'Verificar y Continuar',
  'otp_no_code': '¿No recibiste un código? ',
  'otp_subtitle': 'Enviamos un código de 6 dígitos a %s',
  'otp_resend': 'Reenviar Código',
  'otp_resend_countdown': 'Reenviar Código en %s',
  'otp_change_number': '¿Cambiar Número?',
  'otp_change_email': '¿Cambiar Email?',

  // ── Forgot Password Screen ─────────────────────────────────────────────────
  'forgot_title': '¿Olvidaste tu Contraseña?',
  'forgot_subtitle_phone':
      'Ingresa tu teléfono y enviaremos un código\npara restablecer tu contraseña.',
  'forgot_subtitle_email':
      'Ingresa tu email y enviaremos el código\na tu teléfono registrado.',
  'forgot_hint_phone': 'Ingresa tu número de teléfono',
  'forgot_hint_email': 'Ingresa tu email',
  'forgot_btn': 'Enviar código de restablecimiento',
  'forgot_resend': 'Reenviar código',
  'forgot_back_to_login': 'Volver al Inicio de Sesión',
  'reset_password_title': 'Crear nueva contraseña',
  'reset_password_subtitle': 'Elige una contraseña de al menos 6 caracteres.',
  'reset_password_new_label': 'Nueva contraseña',
  'reset_password_new_hint': 'Ingresa tu nueva contraseña',
  'reset_password_confirm_label': 'Confirmar contraseña',
  'reset_password_confirm_hint': 'Ingresa de nuevo tu nueva contraseña',
  'reset_password_submit': 'Restablecer contraseña',
  'reset_password_required': 'Ingresa una nueva contraseña.',
  'reset_password_min_length':
      'La contraseña debe tener al menos 6 caracteres.',
  'reset_password_confirm_required': 'Confirma tu nueva contraseña.',
  'reset_password_mismatch': 'Las contraseñas no coinciden.',
  'reset_password_success': 'La contraseña se restableció correctamente.',
  'reset_password_timeout':
      'La solicitud tardó demasiado. Puede que la contraseña haya cambiado; intenta iniciar sesión antes de volver a enviarla.',

  // ── Location Permission Screen ─────────────────────────────────────────────
  'location_perm_title': 'Habilitar Acceso a Ubicación',
  'location_perm_subtitle':
      'Permite el acceso a la ubicación para obtener\nservicio preciso en tu área.',
  'location_perm_allow_btn': 'Permitir Acceso a Ubicación',
  'location_perm_manual_btn': 'Ingresar Manualmente',

  // ── Location Detail Screen ─────────────────────────────────────────────────
  'location_detail_title': 'Ingresa tu Ubicación',
  'location_detail_search_hint': 'Buscar área, calle o punto de referencia',
  'location_detail_use_current': 'Usar Ubicación Actual',
  'location_detail_enter_details': 'Ingresar Detalles',
  'location_detail_house_label': 'Casa / Depto / Bloque No.',
  'location_detail_apartment_label': 'Apartamento / Calle / Área',
  'location_detail_landmark_label': 'Referencia (Opcional)',
  'location_detail_save_as': 'Guardar como',
  'location_detail_save_home': 'Casa',
  'location_detail_save_office': 'Oficina',
  'location_detail_save_other': 'Otro',
  'location_detail_confirm_btn': 'Confirmar Ubicación',
  'location_detail_house_required': 'Casa / Depto / Bloque No. es requerido',
  'location_detail_apartment_required':
      'Apartamento / Calle / Área es requerido',

  // ── Map Screen ─────────────────────────────────────────────────────────────
  'map_search_placeholder': 'Seleccionar una Ubicación',
  'map_selected_location_label': 'Ubicación Seleccionada',
  'map_tap_hint': 'Toca el mapa para seleccionar una ubicación',
  'map_confirm_btn': 'Confirmar Ubicación',

  // ── Select Location Screen ─────────────────────────────────────────────────
  'select_location_title': 'Seleccionar Ubicación',
  'select_location_search_hint': "Buscar 'Reparación de AC' o 'Plomero'",
  'select_location_saved_addresses': 'DIRECCIONES GUARDADAS',
  'select_location_use_current': 'Usar Ubicación\nActual',
  'select_location_add_new': 'Agregar Nueva\nDirección',
  'select_location_request_friend': 'Solicitar a\nun Amigo',
  'select_location_view_all': 'Ver Todos',
  'select_location_selected_badge': 'SELECCIONADO',
  'select_location_add_address_btn': '+ Agregar Nueva Dirección',
  'select_location_confirm_btn': 'Confirmar Ubicación',

  // ── Home Screen ────────────────────────────────────────────────────────────
  'home_greeting_morning': 'Buenos Días',
  'home_greeting_afternoon': 'Buenas Tardes',
  'home_greeting_evening': 'Buenas Noches',
  'home_search_hint': 'Buscar Reparación de AC o Plomero',
  'home_section_service_categories': 'Categorías de Servicio',
  'home_section_special_offers': 'Ofertas Especiales',
  'home_section_membership': 'Plan de Membresía',
  'home_section_popular_services': 'Servicios Populares',
  'home_section_user_stories': 'Historias de Usuarios',
  'home_view_all': 'Ver Todos',
  'home_sos_need_help': '¿Necesitas ayuda urgente?',
  'home_sos_subtitle': 'Soporte de Emergencia SOS',
  'home_sos_btn': 'SOS',
  'home_footer_tagline1': 'Ama tu\n',
  'home_footer_tagline2': 'Hogar',
  'home_footer_tagline3':
      'Hacemos el trabajo para que tú no tengas que hacerlo',
  'home_offer_tag_exclusive': 'OFERTA EXCLUSIVA',
  'home_offer_tag_limited': 'TIEMPO LIMITADO',
  'home_offer1_title': 'Oferta de Verano\n20% Off Servicios\nde AC',
  'home_offer2_title': 'Oferta de Invierno\n15% Off\nCalefacción',
  'home_offer_book_now': 'Reservar Ahora',
  'home_popular_reviews': '123 Reseñas',
  'home_popular_book_service': 'Reservar Servicio',
  'home_story1_title': 'Mira cómo reparamos\nel calentador de agua',
  'home_story2_title': 'Calentador de agua\nlimpio y reparado',
  'home_story3_title': 'Reparaciones en\nel hogar &...',

  // ── Service Categories ─────────────────────────────────────────────────────
  'home_cat_smart_home': 'Instalaciones de Hogar Inteligente',
  'home_cat_tv_mount': 'Instalación\nde TV',
  'home_cat_wifi': 'WiFi y\nRedes',
  'home_cat_computer': 'Soporte de Computadoras',
  'home_cat_security': 'Seguridad y Vigilancia',
  'home_cat_audio_video': 'Configuración de\nAudio y Video',

  // ── Dashboard Bottom Navigation ────────────────────────────────────────────
  'nav_home': 'Inicio',
  'nav_services': 'Servicios',
  'nav_bookings': 'Reservas',
  'nav_profile': 'Perfil',

  // ── Validation Messages ────────────────────────────────────────────────────
  'validation_required': 'Este campo es requerido',
  'validation_email': 'Ingresa una dirección de email válida',
  'validation_password_strength':
      'La contraseña debe contener mayúsculas, minúsculas, número, carácter especial y al menos 8 caracteres',
  'validation_strong_password':
      'La contraseña debe contener mayúsculas, minúsculas, número, carácter especial y al menos 8 caracteres',
  'validation_has_uppercase': 'Debe contener al menos una letra mayúscula',
  'validation_has_digit': 'Debe contener al menos un número',
  'validation_has_special_char': 'Debe contener al menos un carácter especial',
  'validation_fields_no_match': 'Los campos no coinciden',
  'validation_invalid_format': 'Formato inválido',
  'validation_email_required': 'El email es requerido',
  'validation_phone_required': 'El número de teléfono es requerido',
  'validation_password_required': 'La contraseña es requerida',
  'language_arabic': 'العربية',
  'language_english': 'English',
  'language_spanish': 'Spanish',
  'sign_in_failed': 'Error al iniciar sesión',
  'signup_failed': 'Error al registrarse',

  // ── Profile Screen ────────────────────────────────────────────────────────
  'profile_member_since': 'Miembro desde',
  'profile_quick_bookings': 'Mis Reservas',
  'profile_quick_payment': 'Pago',
  'profile_quick_addresses': 'Direcciones',
  'profile_quick_support': 'Soporte',
  'profile_subscription_active': 'ACTIVO',
  'profile_subscription_name': 'SquadCare+',
  'profile_view_benefits': 'Ver Beneficios',
  'profile_savings_label': 'AHORRO ESTE MES',
  'profile_wallet': 'Billetera',
  'profile_coupons': 'Cupones',
  'profile_settings_personal': 'Información Personal',
  'profile_settings_notifications': 'Configuración de Notificaciones',
  'profile_settings_language': 'Idioma',
  'profile_settings_security': 'Seguridad',
  'profile_settings_change_password': 'Cambiar contraseña',
  'profile_settings_booking_safety': 'Guía de Seguridad de Reservas',
  'profile_settings_terms': 'Términos y condiciones',
  'profile_settings_privacy': 'Política de Privacidad',
  'profile_referral_code': 'Código de Referido',
  'profile_copied': 'Copiado',
  'profile_referral_copied': '¡Código de referido copiado!',
  'profile_delete_account': 'Eliminar cuenta',
  'profile_logout': 'Cerrar Sesión de 1App',
  'change_password_title': 'Cambiar contraseña',
  'change_password_subtitle':
      'Elige una contraseña segura para proteger tu cuenta.',
  'change_password_old_label': 'Contraseña actual',
  'change_password_old_hint': 'Ingresa tu contraseña actual',
  'change_password_new_label': 'Nueva contraseña',
  'change_password_new_hint': 'Ingresa una nueva contraseña',
  'change_password_confirm_label': 'Confirmar nueva contraseña',
  'change_password_confirm_hint': 'Vuelve a ingresar tu nueva contraseña',
  'change_password_old_required': 'Ingresa tu contraseña actual',
  'change_password_new_required': 'Ingresa una nueva contraseña',
  'change_password_confirm_required': 'Confirma tu nueva contraseña',
  'change_password_mismatch': 'Las contraseñas no coinciden',
  'change_password_submit': 'Actualizar contraseña',
  'change_password_success': 'Tu contraseña se actualizó correctamente.',
  'change_password_failed':
      'No se pudo actualizar la contraseña. Inténtalo de nuevo.',

  'location_gps_off_title': 'La ubicación está desactivada',
  'location_gps_off_body':
      'La ubicación de tu dispositivo está desactivada. Activa los servicios de ubicación para continuar.',
  'location_denied_forever_title': 'Se necesita permiso de ubicación',
  'location_denied_forever_body':
      'El permiso de ubicación está denegado permanentemente. Actívalo desde los ajustes de tu dispositivo para continuar.',

  // Dialog actions
  'location_dialog_cancel': 'Ahora no',
  'location_dialog_open_settings': 'Activar ubicación',
  'location_dialog_open_app_settings': 'Abrir ajustes de la app',

  'location_enable_steps_title': 'Cómo activar la ubicación',

  'location_enable_step_1': 'Pulsa "Abrir ajustes de la app" a continuación.',

  'location_enable_step_2':
      'Abre Ubicación o Permisos en los ajustes de tu dispositivo.',

  'location_enable_step_3':
      'Permite el acceso a la ubicación para esta aplicación.',

  'location_enable_step_4': 'Regresa a la aplicación e inténtalo de nuevo.',
  'signup_hint_name': 'Ingresa tu nombre',
  'signup_hint_confirm_password': 'Confirma tu contraseña',
  'register': 'Registrarse',
};
