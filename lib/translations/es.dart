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
  'profile_logout': 'Cerrar Sesión de SOS',
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

  // Application-wide UI messages.
  "+3 from yesterday": "+3 desde ayer",
  "1 year": "1 año",
  "10-digit phone number": "Número de teléfono de 10 dígitos",
  "100% Secure": "100 % seguro",
  "2 years": "2 años",
  "24/7 priority assistance for marketplace safety.":
      "Asistencia prioritaria de seguridad las 24 horas.",
  "3 years": "3 años",
  "5 June, 2026, 16:16": "5 de junio de 2026, 16:16",
  "A previous payment needs verification. Check it before starting another purchase.":
      "Hay un pago anterior pendiente de verificación. Compruébalo antes de realizar otra compra.",
  "AC & Appliance": "Aire acondicionado y electrodomésticos",
  "Add Money": "Añadir dinero",
  "Address saved successfully.": "Dirección guardada correctamente.",
  "Address updated": "Dirección actualizada",
  "Address updated successfully.": "Dirección actualizada correctamente.",
  "Address updated, but could not set the default. Retry setting the default from your saved addresses.":
      "Dirección actualizada, pero no se pudo establecer como predeterminada. Inténtalo desde tus direcciones guardadas.",
  "Amount Paid": "Importe pagado",
  "Apple registration details are incomplete.":
      "Los datos de registro de Apple están incompletos.",
  "Apple registration expired. Please sign in with Apple again.":
      "El registro de Apple ha caducado. Vuelve a iniciar sesión con Apple.",
  "Apple returned incomplete credentials. Please sign in again.":
      "Apple devolvió credenciales incompletas. Vuelve a iniciar sesión.",
  "Apple sign-in": "Iniciar sesión con Apple",
  "Apple sign-in is unavailable on this device.":
      "El inicio de sesión con Apple no está disponible en este dispositivo.",
  "Applying coupon: @p0": "Aplicando cupón: @p0",
  "Are you sure you want to delete this account? This action is irreversible.":
      "¿Seguro que quieres eliminar esta cuenta? Esta acción es irreversible.",
  "Are you sure you want to logout from this device?":
      "¿Seguro que quieres cerrar sesión en este dispositivo?",
  "Available Mon-Fri from 9am to 6pm PST.":
      "Disponible de lunes a viernes, de 9:00 a 18:00 PST.",
  "Back to Home": "Volver al inicio",
  "Beauty &\nPersonal Care": "Belleza y\ncuidado personal",
  "Before your service": "Antes del servicio",
  "Book Service": "Reservar servicio",
  "Book trusted experts\nat your doorstep.":
      "Reserva profesionales de confianza\na domicilio.",
  "Booking Confirmation": "Confirmación de reserva",
  "Booking Confirmed": "Reserva confirmada",
  "Booking Error": "Error de reserva",
  "Booking ID": "ID de reserva",
  "Booking Status": "Estado de la reserva",
  "Booking activity": "Actividad de reservas",
  "Booking details": "Detalles de la reserva",
  "Booking for Jagriti at CXO Suites, Ground Floor, IT Park":
      "Reserva para Jagriti en CXO Suites, planta baja, IT Park",
  "Booking for someone else": "Reservar para otra persona",
  "Booking total": "Total de la reserva",
  "Browse our FAQ and guides for instant answers.":
      "Consulta nuestras preguntas frecuentes y guías para obtener respuestas al instante.",
  "Business\nServices": "Servicios\nempresariales",
  "Business Services": "Servicios empresariales",
  "Call": "Llamar",
  "Call Emergency Services": "Llamar a emergencias",
  "Call Now": "Llamar ahora",
  "Call Safety Team": "Llamar al equipo de seguridad",
  "Call Support": "Asistencia telefónica",
  "Camera": "Cámara",
  "Cancel": "Cancelar",
  "Carbonite unlimited backup & Office for your team.":
      "Copias de seguridad ilimitadas de Carbonite y Office para tu equipo.",
  "Carpentry": "Carpintería",
  "Change Password": "Cambiar contraseña",
  "Change map location": "Cambiar ubicación en el mapa",
  "Chat": "Chat",
  "Chat Now": "Chatear ahora",
  "Chat Support": "Asistencia por chat",
  "Chat with Us": "Chatea con nosotros",
  "Check Pricing Before Work Starts":
      "Comprueba el precio antes de comenzar el trabajo",
  "Check Status": "Consultar estado",
  "Check payment": "Comprobar pago",
  "Choose a saved address or enter a new service address.":
      "Elige una dirección guardada o introduce una nueva dirección para el servicio.",
  "Cleaning": "Limpieza",
  "Clear search": "Borrar búsqueda",
  "Close": "Cerrar",
  "Close image": "Cerrar imagen",
  "Close video": "Cerrar vídeo",
  "Complete Secure Payment": "Completar pago seguro",
  "Complete your phone number and password, then verify your phone by OTP.":
      "Completa tu teléfono y contraseña, y después verifica el teléfono con el código recibido.",
  "Completed": "Completado",
  "Confirm & Book": "Confirmar y reservar",
  "Connection timeout. Please try again.":
      "Se agotó el tiempo de conexión. Inténtalo de nuevo.",
  "Contact Support": "Contactar con soporte",
  "Contact local police, ambulance, or fire services.":
      "Contacta con la policía, ambulancia o bomberos locales.",
  "Continue to payment": "Continuar al pago",
  "Could not delete address": "No se pudo eliminar la dirección",
  "Could not find an address here. Retry or enter the address manually.":
      "No se encontró una dirección aquí. Inténtalo de nuevo o introdúcela manualmente.",
  "Could not move the map. Please try again.":
      "No se pudo mover el mapa. Inténtalo de nuevo.",
  "Could not save address.": "No se pudo guardar la dirección.",
  "Could not save address. Please try again.":
      "No se pudo guardar la dirección. Inténtalo de nuevo.",
  "Could not save to your profile. Retry, or turn off Save this address to my profile to use it for this booking.":
      "No se pudo guardar en tu perfil. Reinténtalo o desactiva Guardar esta dirección en mi perfil para usarla en esta reserva.",
  "Coupon": "Cupón",
  "Covers 3 devices: laptops, desktops, printers, phones & more.":
      "Cubre 3 dispositivos: portátiles, ordenadores, impresoras, teléfonos y más.",
  "Covers 5 devices: laptops, desktops, printers, phones & routers.":
      "Cubre 5 dispositivos: portátiles, ordenadores, impresoras, teléfonos y routers.",
  "Current Device": "Dispositivo actual",
  "Customer score": "Puntuación del cliente",
  "Data transformation timeout.":
      "Se agotó el tiempo de procesamiento de datos.",
  "Date of Birth": "Fecha de nacimiento",
  "Default address": "Dirección predeterminada",
  "Delete": "Eliminar",
  "Delete account?": "¿Eliminar cuenta?",
  "Delete address?": "¿Eliminar dirección?",
  "Description is required": "La descripción es obligatoria",
  "Diagnostic": "Diagnóstico",
  "Didn't find\nwhat you were\n":
      "¿No encontraste\nlo que estabas\nbuscando?\n",
  "Download invoice": "Descargar factura",
  "Earnings": "Ingresos",
  "Edit": "Editar",
  "Edit Profile": "Editar perfil",
  "Electrical": "Electricidad",
  "Email Address": "Correo electrónico",
  "Email Support": "Asistencia por correo",
  "Email Verification": "Verificación del correo",
  "Emergency Assistance": "Asistencia de emergencia",
  "Emergency Services": "Servicios de emergencia",
  "Enter a new address": "Introducir una dirección nueva",
  "Enter address manually": "Introducir dirección manualmente",
  "Enter an address": "Introduce una dirección",
  "Enter code here": "Introduce el código aquí",
  "Enter coupon code": "Introduce el código del cupón",
  "Error": "Error",
  "Essential internet security & backup for your business.":
      "Seguridad de Internet y copias de seguridad esenciales para tu empresa.",
  "Everyday support for primary & peripheral devices.":
      "Asistencia diaria para dispositivos principales y periféricos.",
  "Expires 05/25": "Caduca 05/25",
  "Expires 12/26": "Caduca 12/26",
  "Explore Services": "Explorar servicios",
  "Explore plans": "Explorar planes",
  "FEATURED": "DESTACADO",
  "Failed to load more services.": "No se pudieron cargar más servicios.",
  "Failed to load more subcategories.":
      "No se pudieron cargar más subcategorías.",
  "Failed to load services.": "No se pudieron cargar los servicios.",
  "Failed to load subcategories.": "No se pudieron cargar las subcategorías.",
  "Full Name": "Nombre completo",
  "Gallery": "Galería",
  "Gardening": "Jardinería",
  "Gender": "Género",
  "Go back to signup to request a new registration code.":
      "Vuelve al registro para solicitar un nuevo código.",
  "Good morning,": "Buenos días,",
  "Google account details received": "Datos de la cuenta de Google recibidos",
  "Google sign-in": "Iniciar sesión con Google",
  "Handyman": "Mantenimiento general",
  "Health &\nWellness": "Salud y\nbienestar",
  "Help Us Maintain Quality": "Ayúdanos a mantener la calidad",
  "Home\nServices": "Servicios\ndel hogar",
  "Home Appliances": "Electrodomésticos",
  "Home Revamp\n": "Renueva tu hogar\n",
  "Home Services": "Servicios del hogar",
  "Home Theater": "Cine en casa",
  "INVOICE": "FACTURA",
  "IT &\nTechnology": "Informática y\ntecnología",
  "Image must be 5 MB or smaller.":
      "La imagen debe tener un tamaño máximo de 5 MB.",
  "Instant Refunds": "Reembolsos instantáneos",
  "Instant Settlement": "Liquidación instantánea",
  "Instantly chat with our support team":
      "Chatea al instante con nuestro equipo de soporte",
  "Invalid Places API response": "Respuesta no válida de la API de Places",
  "Invalid booking details.": "Datos de reserva no válidos.",
  "Invalid booking response": "Respuesta de reserva no válida",
  "Invalid invoice download URL.": "URL de descarga de factura no válida.",
  "Invalid invoice download response.":
      "Respuesta de descarga de factura no válida.",
  "Invalid invoice response.": "Respuesta de factura no válida.",
  "Invalid notifications response.": "Respuesta de notificaciones no válida.",
  "Invalid place coordinates": "Coordenadas del lugar no válidas",
  "Invalid plan response": "Respuesta del plan no válida",
  "Invalid response.": "Respuesta no válida.",
  "Invalid review response.": "Respuesta de reseña no válida.",
  "Invalid server certificate.": "Certificado del servidor no válido.",
  "Invalid server response.": "Respuesta del servidor no válida.",
  "Invalid suggestions": "Sugerencias no válidas",
  "Invalid technician review response.":
      "Respuesta de valoración del técnico no válida.",
  "Invoice": "Factura",
  "Invoice details are missing.": "Faltan los datos de la factura.",
  "Jobs today": "Trabajos de hoy",
  "Knowledge Base": "Base de conocimientos",
  "Last Login": "Último acceso",
  "Live Chat": "Chat en directo",
  "Live Tracking": "Seguimiento en directo",
  "Loading @p0": "Cargando @p0",
  "Location Details": "Detalles de ubicación",
  "Location Error": "Error de ubicación",
  "Location access denied": "Acceso a la ubicación denegado",
  "Location access required": "Se requiere acceso a la ubicación",
  "Location required": "Ubicación obligatoria",
  "Location unavailable": "Ubicación no disponible",
  "Log in": "Iniciar sesión",
  "Logout": "Cerrar sesión",
  "Logout?": "¿Cerrar sesión?",
  "Marketing &\nBranding": "Marketing y\nmarca",
  "Message": "Mensaje",
  "Message was not sent.": "No se envió el mensaje.",
  "Missing place coordinates": "Faltan las coordenadas del lugar",
  "Missing policy body.": "Falta el contenido de la política.",
  "Missing updated address list.": "Falta la lista actualizada de direcciones.",
  "Mobile Verification": "Verificación del móvil",
  "My Jobs": "Mis trabajos",
  "My bookings": "Mis reservas",
  "My plans": "Mis planes",
  "Needs attention": "Requiere atención",
  "Network Setup": "Configuración de red",
  "Networking": "Redes",
  "No Location": "Sin ubicación",
  "No address found": "No se encontró ninguna dirección",
  "No internet connection.": "Sin conexión a Internet.",
  "No plans are currently available.": "No hay planes disponibles actualmente.",
  "Not Found": "No encontrado",
  "Not included": "No incluido",
  "Notifications": "Notificaciones",
  "Notifications from the SquadOnSite app":
      "Notificaciones de la app SquadOnSite",
  "OK": "Aceptar",
  "PC": "PC",
  "Painting": "Pintura",
  "Pause": "Pausar",
  "Pay After Service Completion": "Paga al finalizar el servicio",
  "Payment Failed": "Pago fallido",
  "Payment Options": "Opciones de pago",
  "Payment Pending": "Pago pendiente",
  "Payment attempt not found.": "No se encontró el intento de pago.",
  "Payment awaiting verification. Coverage is not active yet.":
      "Pago pendiente de verificación. La cobertura aún no está activa.",
  "Payment details": "Detalles del pago",
  "Payment not verified. This plan does not grant access.":
      "Pago no verificado. Este plan aún no permite el acceso.",
  "Pending": "Pendiente",
  "Pest Control": "Control de plagas",
  "Plans": "Planes",
  "Play": "Reproducir",
  "Please allow current location access to continue.":
      "Permite el acceso a tu ubicación actual para continuar.",
  "Please allow location access so we can use your current location.":
      "Permite el acceso a la ubicación para usar tu ubicación actual.",
  "Please choose a service package.": "Selecciona un paquete de servicio.",
  "Please enable location access in app settings to continue.":
      "Activa el acceso a la ubicación en los ajustes de la app para continuar.",
  "Please enter @p0": "Introduce @p0",
  "Please enter a valid amount": "Introduce un importe válido",
  "Please provide as much detail as possible so our experts can assist you effectively...":
      "Proporciona todos los detalles posibles para que nuestros expertos puedan ayudarte...",
  "Please select a location on the map.":
      "Selecciona una ubicación en el mapa.",
  "Please select your date of birth.": "Selecciona tu fecha de nacimiento.",
  "Please select your gender.": "Selecciona tu género.",
  "Please try again or allow location access.":
      "Inténtalo de nuevo o permite el acceso a la ubicación.",
  "Please try again or enter your address manually.":
      "Inténtalo de nuevo o introduce tu dirección manualmente.",
  "Please try again.": "Inténtalo de nuevo.",
  "Please try again. Your address has not been removed.":
      "Inténtalo de nuevo. No se ha eliminado tu dirección.",
  "Plumbing": "Fontanería",
  "Price mismatch": "El precio no coincide",
  "Printer": "Impresora",
  "Privacy policy content is incomplete.":
      "El contenido de la política de privacidad está incompleto.",
  "Processing payment of \$@p0": "Procesando el pago de \$@p0",
  "Processing...": "Procesando...",
  "Professional\nCleaning for a\nHealthier Home":
      "Limpieza\nprofesional para un\nhogar más saludable",
  "Professional\nServices": "Servicios\nprofesionales",
  "Professional solutions for your business needs.":
      "Soluciones profesionales para las necesidades de tu empresa.",
  "Profile updated successfully.": "Perfil actualizado correctamente.",
  "Promo Code": "Código promocional",
  "Quick actions": "Acciones rápidas",
  "Rate & Share Feedback": "Valora y comparte tu opinión",
  "Rating": "Valoración",
  "Read Terms & Conditions": "Leer Términos y Condiciones",
  "Recent": "Recientes",
  "Redeeming code: @p0": "Canjeando código: @p0",
  "Refresh my plans": "Actualizar mis planes",
  "Refunds are credited instantly": "Los reembolsos se abonan al instante",
  "Repair": "Reparación",
  "Repair & care": "Reparación y cuidado",
  "Report\nMisconduct": "Denunciar\nconducta indebida",
  "Report an Issue": "Informar de un problema",
  "Request Call Back": "Solicitar una llamada",
  "Request failed": "Solicitud fallida",
  "Request timeout. Please try again.":
      "Se agotó el tiempo de la solicitud. Inténtalo de nuevo.",
  "Request was cancelled.": "La solicitud se canceló.",
  "Retry": "Reintentar",
  "Retry plans": "Volver a cargar planes",
  "Review & Approve Estimate": "Revisar y aprobar el presupuesto",
  "SEND TIP": "ENVIAR PROPINA",
  "SKIP": "OMITIR",
  "SOS Safety Team": "Equipo de seguridad SOS",
  "Save Address": "Guardar dirección",
  "Save Profile": "Guardar perfil",
  "Save this address to my profile": "Guardar esta dirección en mi perfil",
  "Saving...": "Guardando...",
  "Schedule & location": "Fecha y ubicación",
  "Search address on map…": "Buscar dirección en el mapa…",
  "Search service & book your service": "Busca y reserva tu servicio",
  "Search services, ID or location": "Buscar por servicio, ID o ubicación",
  "Security PIN": "PIN de seguridad",
  "Select Photo": "Seleccionar foto",
  "Select a package": "Selecciona un paquete",
  "Select date of birth": "Seleccionar fecha de nacimiento",
  "Send Message": "Enviar mensaje",
  "Send us an email and we'll reply": "Envíanos un correo y te responderemos",
  "Server Error": "Error del servidor",
  "Server protection & encrypted backup for your business.":
      "Protección de servidores y copias de seguridad cifradas para tu empresa.",
  "Server response timeout. Please try again.":
      "Se agotó el tiempo de respuesta del servidor. Inténtalo de nuevo.",
  "Service Rating": "Valoración del servicio",
  "Service information": "Información del servicio",
  "Service not yet started": "El servicio aún no ha comenzado",
  "Set as default address": "Establecer como dirección predeterminada",
  "Setup & repair": "Instalación y reparación",
  "Share": "Compartir",
  "Share Live Location": "Compartir ubicación en directo",
  "Share Location": "Compartir ubicación",
  "Share your experience (optional)": "Comparte tu experiencia (opcional)",
  "Sign in": "Iniciar sesión",
  "Sign up": "Registrarse",
  "Smart Home": "Hogar inteligente",
  "Something went wrong on our end. Your payment may still be processing — please check My Bookings before retrying.":
      "Ocurrió un error. Tu pago puede seguir procesándose; comprueba Mis reservas antes de volver a intentarlo.",
  "Something went wrong with your payment.": "Ocurrió un error con tu pago.",
  "Something went wrong.": "Ocurrió un error.",
  "Special instructions": "Instrucciones especiales",
  "SquadOnSite Notifications": "Notificaciones de SquadOnSite",
  "Start Service with OTP": "Inicia el servicio con el código de verificación",
  "Status": "Estado",
  "Stay Informed Throughout the Job": "Mantente informado durante el trabajo",
  "Subject is required": "El asunto es obligatorio",
  "Submit a Review": "Enviar una reseña",
  "Subscribe to @p0": "Suscribirse a @p0",
  "Subscribe to this plan": "Suscribirse a este plan",
  "Success": "Éxito",
  "TV Mount AC": "Montaje de TV y aire acondicionado",
  "TV Mounting": "Montaje de TV",
  "Take Photo": "Tomar foto",
  "Talk to our support team": "Habla con nuestro equipo de soporte",
  "Technician Arrived": "El técnico ha llegado",
  "Technician Assigned": "Técnico asignado",
  "Technician Rating": "Valoración del técnico",
  "Technician on the way": "Técnico en camino",
  "Technician: Michael Johnson": "Técnico: Michael Johnson",
  "The @p0 could not be loaded. Please try again.":
      "No se pudo cargar @p0. Inténtalo de nuevo.",
  "The server did not return a login token. Please try again.":
      "El servidor no devolvió un token de acceso. Inténtalo de nuevo.",
  "The server did not return a valid phone number.":
      "El servidor no devolvió un número de teléfono válido.",
  "The server did not return valid Google account details.":
      "El servidor no devolvió datos válidos de la cuenta de Google.",
  "The server did not return valid app tokens.":
      "El servidor no devolvió tokens de sesión válidos.",
  "The server did not return valid app tokens. Please try again.":
      "El servidor no devolvió tokens de sesión válidos. Inténtalo de nuevo.",
  "This week": "Esta semana",
  "Tip your Technician": "Da una propina a tu técnico",
  "Tools & equipment": "Herramientas y equipo",
  "Total": "Total",
  "Track Booking →": "Seguir reserva →",
  "Track Service Updates": "Seguir actualizaciones del servicio",
  "Transportation\nServices": "Servicios de\ntransporte",
  "Trusted professionals for all your home maintenance and repair needs.":
      "Profesionales de confianza para todas tus necesidades de mantenimiento y reparación del hogar.",
  "Try Again": "Intentar de nuevo",
  "Try again": "Intentar de nuevo",
  "Type a message...": "Escribe un mensaje...",
  "Unable to complete Apple sign-in. Please try again.":
      "No se pudo completar el inicio de sesión con Apple. Inténtalo de nuevo.",
  "Unable to complete Google sign-in. Please try again.":
      "No se pudo completar el inicio de sesión con Google. Inténtalo de nuevo.",
  "Unable to delete your account. Please try again.":
      "No se pudo eliminar tu cuenta. Inténtalo de nuevo.",
  "Unable to fetch location": "No se pudo obtener la ubicación",
  "Unable to load chat history.": "No se pudo cargar el historial del chat.",
  "Unable to load more chat messages.": "No se pudieron cargar más mensajes.",
  "Unable to load notifications. Please try again.":
      "No se pudieron cargar las notificaciones. Inténtalo de nuevo.",
  "Unable to load profile details.":
      "No se pudieron cargar los datos del perfil.",
  "Unable to load service": "No se pudo cargar el servicio",
  "Unable to load this service. Please try again.":
      "No se pudo cargar este servicio. Inténtalo de nuevo.",
  "Unable to load your address and phone. Please retry.":
      "No se pudieron cargar tu dirección y teléfono. Inténtalo de nuevo.",
  "Unable to load your bookings.": "No se pudieron cargar tus reservas.",
  "Unable to load your bookings. Please try again.":
      "No se pudieron cargar tus reservas. Inténtalo de nuevo.",
  "Unable to load your profile. Please try again.":
      "No se pudo cargar tu perfil. Inténtalo de nuevo.",
  "Unable to logout. Please try again.":
      "No se pudo cerrar sesión. Inténtalo de nuevo.",
  "Unable to refresh your purchases. Please try again.":
      "No se pudieron actualizar tus compras. Inténtalo de nuevo.",
  "Unable to send attachment.": "No se pudo enviar el archivo adjunto.",
  "Unable to sign in with Google. Please try again.":
      "No se pudo iniciar sesión con Google. Inténtalo de nuevo.",
  "Unable to start Apple sign-in. Please try again.":
      "No se pudo iniciar el acceso con Apple. Inténtalo de nuevo.",
  "Unable to update notification. Please try again.":
      "No se pudo actualizar la notificación. Inténtalo de nuevo.",
  "Unable to update notifications. Please try again.":
      "No se pudieron actualizar las notificaciones. Inténtalo de nuevo.",
  "Unable to update your profile.": "No se pudo actualizar tu perfil.",
  "Unable to upload profile image.": "No se pudo subir la imagen de perfil.",
  "Unable to verify Apple sign-in.":
      "No se pudo verificar el inicio de sesión con Apple.",
  "Unable to verify Google signup. Please try again.":
      "No se pudo comprobar el registro con Google. Inténtalo de nuevo.",
  "Unable to verify your Google account. Please try again.":
      "No se pudo verificar tu cuenta de Google. Inténtalo de nuevo.",
  "Update Address": "Actualizar dirección",
  "Update contacts and safety team on your movement.":
      "Actualiza a tus contactos y al equipo de seguridad sobre tu ubicación.",
  "Upload Evidence": "Subir pruebas",
  "Use current location": "Usar ubicación actual",
  "Use previous location": "Usar ubicación anterior",
  "Use this address": "Usar esta dirección",
  "Verify Professional Arrival": "Verifica la llegada del profesional",
  "Video": "Vídeo",
  "Video must be 50 MB or smaller.":
      "El vídeo debe tener un tamaño máximo de 50 MB.",
  "View details": "Ver detalles",
  "View plan details": "Ver detalles del plan",
  "Wallet Payment": "Pago con monedero",
  "What’s included": "Qué incluye",
  "Write a note for the technician...": "Escribe una nota para el técnico...",
  "Write your review here...": "Escribe tu reseña aquí...",
  "Your address was saved, but could not be selected. Choose it from saved addresses.":
      "Tu dirección se guardó, pero no se pudo seleccionar. Elígela entre las direcciones guardadas.",
  "Your money is safe with us": "Tu dinero está seguro con nosotros",
  "Your payment is still being processed. Please wait and try again.":
      "Tu pago sigue procesándose. Espera e inténtalo de nuevo.",
  "Your technician": "Tu técnico",
  "Zoom in": "Acercar",
  "Zoom out": "Alejar",
  "e.g. #ORD-77291": "p. ej., #ORD-77291",
  "e.g. Booking inquiry or Technical issue":
      "p. ej., consulta sobre una reserva o problema técnico",

  // Application-wide UI messages.
  "\"When SOS is triggered, location and booking details are shared automatically with these contacts.\"":
      "«Al activar SOS, la ubicación y los datos de la reserva se comparten automáticamente con estos contactos».",
  "%\nOFF": "%\nDE DESCUENTO",
  "(@p0 reviews)": "(@p0 reseñas)",
  "(Optional)": "(Opcional)",
  "+ Add": "+ Añadir",
  "100% of your tips goes to our\ntechnicians only.":
      "El 100 % de tus propinas va\nexclusivamente a nuestros técnicos.",
  "15 Minutes": "15 minutos",
  "24 Hours": "24 horas",
  "4.3 (124 Reviews)": "4,3 (124 reseñas)",
  "@p0 (@p1 Reviews)": "@p0 (@p1 reseñas)",
  "@p0 (@p1 reviews)": "@p0 (@p1 reseñas)",
  "@p0 @p1 · @p2 months": "@p0 @p1 · @p2 meses",
  "@p0 booked service@p1": "@p0 servicios reservados@p1",
  "@p0 charged once for @p1 months. Enter your card details securely in Stripe to pay.":
      "@p0 en un único pago por @p1 meses. Introduce tu tarjeta de forma segura en Stripe para pagar.",
  "@p0 min per service": "@p0 min por servicio",
  "@p0 unavailable": "@p0 no disponible",
  "@p0 unread": "@p0 sin leer",
  "@p0 · @p1 months · one-time payment": "@p0 · @p1 meses · pago único",
  "@p0% off": "@p0 % de descuento",
  "Add": "Añadir",
  "Add New Card": "Añadir tarjeta nueva",
  "Add New Payment Method": "Añadir método de pago",
  "Add a Note ": "Añadir una nota ",
  "Additional Contact": "Contacto adicional",
  "Additional items": "Elementos adicionales",
  "All fees are listed in @p0.": "Todas las tarifas se muestran en @p0.",
  "All read": "Todo leído",
  "All services booked through SOS are monitored and supported to ensure a safe, transparent, and reliable experience. Follow these simple steps for a smooth service journey.":
      "Todos los servicios reservados a través de SOS cuentan con seguimiento y asistencia para ofrecer una experiencia segura, transparente y fiable. Sigue estos pasos para disfrutar de un servicio sin inconvenientes.",
  "All services, one app.": "Todos los servicios, una sola app.",
  "Alternative Phone": "Teléfono alternativo",
  "Amount paid": "Importe pagado",
  "Apple registration expired. Go back and sign in with Apple again.":
      "El registro de Apple ha caducado. Vuelve atrás e inicia sesión con Apple de nuevo.",
  "Apply": "Aplicar",
  "Apply a coupon code at checkout to get instant discount on your service booking.":
      "Aplica un cupón al pagar para obtener un descuento inmediato en tu reserva.",
  "Are you sure you want to delete this address?":
      "¿Seguro que quieres eliminar esta dirección?",
  "Assignment details will appear here when available.":
      "Los datos de la asignación aparecerán aquí cuando estén disponibles.",
  "Attach screenshots or relevant files":
      "Adjunta capturas de pantalla o archivos relevantes",
  "Availability": "Disponibilidad",
  "Available Coupons": "Cupones disponibles",
  "Average wait time: ~ 2 mins": "Tiempo de espera medio: unos 2 min",
  "BOOK": "RESERVAR",
  "BOOK NOW": "RESERVAR AHORA",
  "Best deal": "Mejor oferta",
  "Book now": "Reservar ahora",
  "Booked services": "Servicios reservados",
  "Booking Confirmed!": "¡Reserva confirmada!",
  "Booking ID: #A12345": "ID de reserva: #A12345",
  "Booking ID: @p0": "ID de reserva: @p0",
  "Booking Service ID: SOS-1202": "ID del servicio reservado: SOS-1202",
  "Building and floor details are saved separately and won’t move the map pin.":
      "Los datos del edificio y la planta se guardan por separado y no mueven el marcador.",
  "CANCELLATION POLICY": "POLÍTICA DE CANCELACIÓN",
  "CURRENT BALANCE": "SALDO ACTUAL",
  "Change": "Cambiar",
  "Change Picture": "Cambiar foto",
  "Change service address": "Cambiar dirección del servicio",
  "Choose how you'd like to add your profile photo":
      "Elige cómo quieres añadir tu foto de perfil",
  "Clear filters": "Borrar filtros",
  "Confirming your booking…": "Confirmando tu reserva…",
  "Connect instantly with our technical experts.":
      "Conecta al instante con nuestros expertos técnicos.",
  "Contact number not available": "Número de contacto no disponible",
  "Could not load @p0": "No se pudo cargar @p0",
  "Covers 3 Devices - Laptops, Desktops,\nPrinters, Phones etc.":
      "Cubre 3 dispositivos: portátiles, ordenadores,\nimpresoras, teléfonos, etc.",
  "Current location updated": "Ubicación actual actualizada",
  "Currently Assigned Technician": "Técnico asignado actualmente",
  "Delete Account": "Eliminar cuenta",
  "EMERGENCY SOS": "EMERGENCIA SOS",
  "ENTER AMOUNT": "INTRODUCE EL IMPORTE",
  "EXPERT": "EXPERTO",
  "Email Us": "Escríbenos",
  "Enter your manual code below to\nadd it to your wallet.":
      "Introduce tu código manual abajo\npara añadirlo a tu monedero.",
  "Estimated Arrival": "Llegada estimada",
  "Excellent": "Excelente",
  "Expires: @p0": "Caduca: @p0",
  "Explore by Category": "Explorar por categoría",
  "Explore by Services": "Explorar por servicio",
  "Fair": "Regular",
  "Fetching your location...": "Obteniendo tu ubicación...",
  "Fetching your purchase details.": "Obteniendo los datos de tu compra.",
  "Give your home a fresh new look\nwith our expert painting services.":
      "Dale un aire nuevo a tu hogar\ncon nuestros servicios de pintura.",
  "Go to Home": "Ir al inicio",
  "Good": "Bueno",
  "HEY!": "¡HOLA!",
  "HEY, @p0!": "¡HOLA, @p0!",
  "Have a Promo Code?": "¿Tienes un código promocional?",
  "Help us reduce the time of a technician by avoiding service cancellation. A 100% cancellation charge will be applied if the technician is assigned.":
      "Ayúdanos a ahorrar tiempo al técnico evitando cancelaciones. Se aplicará un cargo de cancelación del 100 % si el técnico ya está asignado.",
  "Home service": "Servicio a domicilio",
  "How can we help?": "¿Cómo podemos ayudarte?",
  "How it works?": "¿Cómo funciona?",
  "How was your experience with Michael Johnson?":
      "¿Cómo fue tu experiencia con Michael Johnson?",
  "Includes your service and selected add-ons. Charged in USD.":
      "Incluye el servicio y los complementos seleccionados. Se cobra en USD.",
  "Invoice details are unavailable.":
      "Los datos de la factura no están disponibles.",
  "LIMITED TIME OFFER": "OFERTA POR TIEMPO LIMITADO",
  "LINK >": "ENLACE >",
  "Loading your bookings…": "Cargando tus reservas…",
  "Loading your plans…": "Cargando tus planes…",
  "Loading…": "Cargando…",
  "Log In": "Iniciar sesión",
  "Looking for?": "¿Lo que buscas?",
  "Mark all read": "Marcar todo como leído",
  "Monday — Sunday": "Lunes — domingo",
  "Money added to your SOS wallet can be used for instant bookings and payments across all network services. Standard T&Cs apply.":
      "El dinero añadido a tu monedero SOS puede usarse para reservas y pagos instantáneos en todos los servicios de la red. Se aplican los términos habituales.",
  "NEW": "NUEVO",
  "No address selected": "Ninguna dirección seleccionada",
  "No bookings yet": "Aún no hay reservas",
  "No matching bookings": "No hay reservas que coincidan",
  "No service lines are available.": "No hay líneas de servicio disponibles.",
  "No services available.": "No hay servicios disponibles.",
  "No services found.": "No se encontraron servicios.",
  "Not Verified": "No verificado",
  "Not available": "No disponible",
  "ON PAINTING\nSERVICES": "EN SERVICIOS\nDE PINTURA",
  "OTP: 1202": "Código: 1202",
  "Offer ends at 11:59 PM": "La oferta termina a las 23:59",
  "On the way": "En camino",
  "One-time payment · @p0 months": "Pago único · @p0 meses",
  "Optional — share anything the pro should know":
      "Opcional: indica lo que el profesional deba saber",
  "Our dedicated support team typically responds within 24 hours to ensure your SOS experience is seamless.":
      "Nuestro equipo de soporte suele responder en 24 horas para que tu experiencia con SOS sea fluida.",
  "Our expert agents are ready to assist you with any technical hurdles or service requests.":
      "Nuestros agentes expertos están listos para ayudarte con cualquier problema técnico o solicitud de servicio.",
  "Paid: @p0": "Pagado: @p0",
  "Pay by Cash / UPI on Service": "Pagar en efectivo o UPI durante el servicio",
  "Pay by any UPI app": "Pagar con cualquier app UPI",
  "Pay via QR Code": "Pagar con código QR",
  "Payment is not confirmed yet. Check payment again shortly.":
      "El pago aún no está confirmado. Vuelve a comprobarlo en breve.",
  "Payment received. Your booking is pending service confirmation.":
      "Pago recibido. Tu reserva está pendiente de confirmación del servicio.",
  "Permanently remove account": "Eliminar la cuenta permanentemente",
  "Plan price": "Precio del plan",
  "Please report it immediately through the app.":
      "Notifícalo inmediatamente a través de la app.",
  "Please wait while we verify your payment.":
      "Espera mientras verificamos tu pago.",
  "Poor": "Malo",
  "Prefer not to call?": "¿Prefieres no llamar?",
  "Previous rating: @p0 star@p1": "Valoración anterior: @p0 estrella@p1",
  "Pro SOS Plan": "Plan Pro SOS",
  "Proceed to Pay": "Proceder al pago",
  "Protecting You Every Step of the Way": "Te protegemos en cada paso",
  "Purchases unavailable": "Compras no disponibles",
  "Quantity: @p0": "Cantidad: @p0",
  "Quick Actions": "Acciones rápidas",
  "Rate Your Experience": "Valora tu experiencia",
  "Read": "Leído",
  "Ready for jobs": "Disponible para trabajos",
  "Redeem": "Canjear",
  "Remove": "Quitar",
  "Report Safety Concerns": "Informar de problemas de seguridad",
  "Search on the map or enter the address below":
      "Busca en el mapa o introduce la dirección abajo",
  "Select Payment Method": "Seleccionar método de pago",
  "Select gender": "Seleccionar género",
  "Service": "Servicio",
  "Service Completed!": "¡Servicio completado!",
  "Service ID is missing.": "Falta el ID del servicio.",
  "Service address": "Dirección del servicio",
  "Service date: @p0": "Fecha del servicio: @p0",
  "Service details are not available.":
      "Los datos del servicio no están disponibles.",
  "Service review submitted successfully.":
      "Valoración del servicio enviada correctamente.",
  "Sign in to see your purchases.": "Inicia sesión para ver tus compras.",
  "Speak with our support team": "Habla con nuestro equipo de soporte",
  "Special": "Especial",
  "Starting From": "Desde",
  "Starts: @p0": "Comienza: @p0",
  "Submit Rating": "Enviar valoración",
  "Subscribe Now": "Suscribirse ahora",
  "Suggest us a Service": "Sugiérenos un servicio",
  "Suggest us a service & we'll look into it":
      "Sugiérenos un servicio y lo estudiaremos",
  "Support Agent": "Agente de soporte",
  "Support Hours": "Horario de soporte",
  "T&C Apply": "Se aplican términos",
  "TO PREVENT ACCIDENTAL TRIGGERS": "PARA EVITAR ACTIVACIONES ACCIDENTALES",
  "TONIGHT\nONLY!": "¡SOLO\nESTA NOCHE!",
  "Tap & Hold for 3 Seconds": "Mantén pulsado durante 3 segundos",
  "Tap to rate": "Toca para valorar",
  "Technician not assigned": "Técnico no asignado",
  "Technician review submitted successfully.":
      "Valoración del técnico enviada correctamente.",
  "Terms of Service are available in the app’s Terms & Conditions.":
      "Las condiciones del servicio están en Términos y Condiciones de la app.",
  "Thank Michael for a\ngreat service!":
      "¡Agradece a Michael\nsu excelente servicio!",
  "Thank you for choosing SOS Services. We SquadOnSite technicians are always up for you.":
      "Gracias por elegir los servicios SOS. Nuestros técnicos de SquadOnSite están siempre a tu disposición.",
  "Thank you for choosing us!": "¡Gracias por elegirnos!",
  "This booking does not contain a valid service ID.":
      "Esta reserva no contiene un ID de servicio válido.",
  "This includes:": "Esto incluye:",
  "This service is currently unavailable.":
      "Este servicio no está disponible actualmente.",
  "To Pay: ": "Importe a pagar: ",
  "Today jobs": "Trabajos de hoy",
  "Today, 10:24 AM": "Hoy, 10:24",
  "Total (USD)": "Total (USD)",
  "Track Now": "Seguir ahora",
  "Try another search or view all bookings.":
      "Prueba otra búsqueda o consulta todas las reservas.",
  "Unable to load bookings": "No se pudieron cargar las reservas",
  "Unable to play this video.": "No se pudo reproducir este vídeo.",
  "Unlock SOS Wallet": "Activar monedero SOS",
  "Unread": "Sin leer",
  "Update Rating": "Actualizar valoración",
  "Updating...": "Actualizando...",
  "Upload Profile Photo": "Subir foto de perfil",
  "Uploading...": "Subiendo...",
  "Use any UPI app on the phone to pay":
      "Usa cualquier app UPI del teléfono para pagar",
  "VALID TILL": "VÁLIDO HASTA",
  "Valid": "Válido",
  "Verified": "Verificado",
  "Very Good": "Muy bueno",
  "View Invoice": "Ver factura",
  "View Less": "Ver menos",
  "View More Bank": "Ver más bancos",
  "View My Bookings": "Ver mis reservas",
  "View Used Coupons": "Ver cupones usados",
  "View all": "Ver todo",
  "View and download your invoice": "Ver y descargar tu factura",
  "Visa, Mastercard, Rupay & more": "Visa, Mastercard, Rupay y más",
  "Wallet Transactions": "Movimientos del monedero",
  "We'll keep you posted on your\nservice requests and latest offers":
      "Te mantendremos informado de tus\nsolicitudes de servicio y últimas ofertas",
  "We're here to help": "Estamos aquí para ayudarte",
  "We're here to help you 24/7 with expert technical assistance.":
      "Estamos a tu disposición las 24 horas con asistencia técnica especializada.",
  "White Tesla Model 3 • ABC-123": "Tesla Model 3 blanco • ABC-123",
  "Write a Review ": "Escribir una reseña ",
  "You have no plan purchases yet.": "Aún no has comprado ningún plan.",
  "You will receive an update once a technician is assigned.":
      "Recibirás una actualización cuando se asigne un técnico.",
  "You're all caught up": "Estás al día",
  "Your Emergency Contacts": "Tus contactos de emergencia",
  "Your booking has been confirmed and payment of \$@p0 has been processed successfully.":
      "Tu reserva se ha confirmado y el pago de \$@p0 se ha procesado correctamente.",
  "Your next plan starts here": "Tu próximo plan comienza aquí",
  "Your purchase details could not be loaded.":
      "No se pudieron cargar los datos de tu compra.",
  "Your purchased plans and coverage details will appear here.":
      "Tus planes comprados y datos de cobertura aparecerán aquí.",
  "Your service bookings will appear here.":
      "Tus reservas de servicio aparecerán aquí.",
  "Your support is our priority": "Tu asistencia es nuestra prioridad",
  "Zoom in and move the map so the pin marks your exact entrance.":
      "Acerca y mueve el mapa para que el marcador señale tu entrada exacta.",
  "per month": "al mes",

  // Shared labels, statuses, validation and service descriptions.
  "03:15 PM": "15:15",
  "1 Onboarding Non-Refundable.": "1 incorporación no reembolsable.",
  "1 onboarding · non-refundable": "1 incorporación · no reembolsable",
  "10:30 AM": "10:30",
  "12 service calls · 3 per quarter":
      "12 visitas de servicio · 3 por trimestre",
  "12:45 PM": "12:45",
  "20 service calls · 5 per quarter":
      "20 visitas de servicio · 5 por trimestre",
  "24/7 on-demand assistance": "Asistencia bajo demanda las 24 horas",
  "25 - 30 mins": "25 - 30 min",
  "4 service calls · 1 per quarter": "4 visitas de servicio · 1 por trimestre",
  "8 Tickets - 2/Quarter.": "8 solicitudes: 2 por trimestre.",
  "AC Repair": "Reparación de aire acondicionado",
  "AM": "a. m.",
  "About This Service": "Acerca de este servicio",
  "Account Security": "Seguridad de la cuenta",
  "Active Session": "Sesión activa",
  "Address line *": "Dirección *",
  "Address not provided": "Dirección no proporcionada",
  "Address search is busy. Please wait and retry.":
      "La búsqueda está ocupada. Espera e inténtalo de nuevo.",
  "Address search is temporarily unavailable. Please retry later.":
      "La búsqueda de direcciones no está disponible temporalmente. Inténtalo más tarde.",
  "Address search is temporarily unavailable. Please retry.":
      "La búsqueda de direcciones no está disponible temporalmente. Inténtalo de nuevo.",
  "Address search timed out. Please retry.":
      "La búsqueda de direcciones tardó demasiado. Inténtalo de nuevo.",
  "Adjustments": "Ajustes",
  "Advanced SOS": "Advanced SOS",
  "All": "Todos",
  "All Services": "Todos los servicios",
  "All approved estimates remain recorded for your reference.":
      "Todos los presupuestos aprobados quedan registrados para tu consulta.",
  "Amount": "Importe",
  "An error occurred.": "Se produjo un error.",
  "Android • Chandigarh": "Android • Chandigarh",
  "Any issue not reflected in the booking":
      "Cualquier problema no reflejado en la reserva",
  "Apple Pay UPI": "Apple Pay UPI",
  "Apple authorization": "Autorización de Apple",
  "Apple identity, authorization code and challenge tokens are required.":
      "Se requieren la identidad de Apple, el código de autorización y el token de desafío.",
  "Apple sign-in is currently available on Apple devices only.":
      "El inicio de sesión con Apple solo está disponible en dispositivos Apple.",
  "Appliance Repair": "Reparación de electrodomésticos",
  "Apr": "abr",
  "April": "Abril",
  "Area": "Zona",
  "Aug": "ago",
  "August": "Agosto",
  "Authentication required": "Se requiere autenticación",
  "Available Add-ons": "Complementos disponibles",
  "Average wait ~ 2 mins": "Espera media: unos 2 min",
  "Axis\nBank": "Axis\nBank",
  "BHIM UPI": "BHIM UPI",
  "BILL TO": "FACTURAR A",
  "Balance Due": "Saldo pendiente",
  "Before work begins, verify the professional assigned to your booking and share the OTP only after they arrive at your location.":
      "Antes de comenzar, comprueba el profesional asignado y comparte el código solo después de que llegue a tu ubicación.",
  "Booked on": "Fecha de reserva",
  "Booked price": "Precio reservado",
  "Booking Period": "Periodo de reserva",
  "Building / Flat / Floor (optional)": "Edificio / piso / planta (opcional)",
  "Business": "Empresas",
  "Business Enterprise": "Business Enterprise",
  "Business Professional": "Business Professional",
  "Business Starter": "Business Starter",
  "Cancelled": "Cancelado",
  "Carbonite Data Backup.": "Copia de seguridad Carbonite.",
  "Carbonite data backup": "Copia de seguridad Carbonite",
  "Cash on Delivery": "Pago contra entrega",
  "Chat is offline. Please try again.":
      "El chat no está conectado. Inténtalo de nuevo.",
  "Chat support · 5-minute response target":
      "Soporte por chat · respuesta objetivo de 5 min",
  "Check your previous payment before starting another purchase.":
      "Comprueba tu pago anterior antes de realizar otra compra.",
  "Choose Package": "Elegir paquete",
  "City": "Ciudad",
  "Confirmed": "Confirmado",
  "Contact Number": "Número de contacto",
  "Could not load this place. Please search again.":
      "No se pudo cargar este lugar. Busca de nuevo.",
  "Could not load this place. Retry or enter the address manually.":
      "No se pudo cargar este lugar. Reinténtalo o introduce la dirección manualmente.",
  "Could not load video": "No se pudo cargar el vídeo",
  "Could not read place search results. Try again.":
      "No se pudieron leer los resultados. Busca de nuevo.",
  "Could not search places. Check your connection and try again.":
      "No se pudieron buscar lugares. Comprueba tu conexión e inténtalo de nuevo.",
  "Covers Printer, Modem, Router.": "Cubre impresora, módem y router.",
  "Covers phones and tablets": "Cubre teléfonos y tabletas",
  "Covers printer, modem and router": "Cubre impresora, módem y router",
  "Credit & Debit Cards": "Tarjetas de crédito y débito",
  "Current location": "Ubicación actual",
  "Customer": "Cliente",
  "Date to be confirmed": "Fecha por confirmar",
  "Dec": "dic",
  "December": "Diciembre",
  "Dedicated account manager": "Gestor de cuenta dedicado",
  "Describe your issue": "Describe tu problema",
  "Duke (Dad)": "Duke (papá)",
  "Edit Service Rating": "Editar valoración del servicio",
  "Edit Technician Rating": "Editar valoración del técnico",
  "Email": "Correo electrónico",
  "Email is already registered. Please log in.":
      "El correo ya está registrado. Inicia sesión.",
  "Endpoint security included": "Seguridad de terminales incluida",
  "Enter a valid 10-digit number": "Introduce un número válido de 10 dígitos",
  "Enter a valid phone number": "Introduce un número de teléfono válido",
  "Enter the person's name": "Introduce el nombre de la persona",
  "Estimated Time": "Tiempo estimado",
  "Every Time": "Siempre",
  "Expert Home": "Expertos para el hogar",
  "FAQs": "Preguntas frecuentes",
  "Feb": "feb",
  "February": "Febrero",
  "Female": "Mujer",
  "Finding Technician": "Buscando técnico",
  "Frequently asked questions": "Preguntas frecuentes",
  "Google did not return an access token. Please try again.":
      "Google no devolvió un token de acceso. Inténtalo de nuevo.",
  "Google verification expired or was rejected. Please sign in again.":
      "La verificación de Google caducó o fue rechazada. Inicia sesión de nuevo.",
  "Greater Kailash": "Greater Kailash",
  "HDFC\nBank": "HDFC\nBank",
  "HSBC\nBank": "HSBC\nBank",
  "How It Works": "Cómo funciona",
  "How it works": "Cómo funciona",
  "How was the service?": "¿Cómo fue el servicio?",
  "How was your technician?": "¿Cómo fue tu técnico?",
  "ICICI\nBank": "ICICI\nBank",
  "INVOICE DETAILS": "DATOS DE LA FACTURA",
  "IOB\nBank": "IOB\nBank",
  "Image": "Imagen",
  "Includes Security – 5 Devices.": "Incluye seguridad para 5 dispositivos.",
  "Incorrect professional assignment": "Asignación incorrecta del profesional",
  "Indirapuram": "Indirapuram",
  "Internal server error.": "Error interno del servidor.",
  "Invalid payment order": "Orden de pago no válida",
  "Invalid profile response": "Respuesta de perfil no válida",
  "Invoice Date": "Fecha de factura",
  "Invoice Number": "Número de factura",
  "Invoice URL is unavailable.": "El enlace de la factura no está disponible.",
  "Jan": "ene",
  "January": "Enero",
  "Jul": "jul",
  "July": "Julio",
  "Jun": "jun",
  "June": "Junio",
  "Just now": "Ahora mismo",
  "Last updated": "Última actualización",
  "Location": "Ubicación",
  "Love Your": "Disfruta de",
  "Make payments only after the service has been completed and reviewed.":
      "Realiza pagos solo después de completar y revisar el servicio.",
  "Male": "Hombre",
  "Mar": "mar",
  "March": "Marzo",
  "Mastercard •••• 8810": "Mastercard •••• 8810",
  "May": "Mayo",
  "Maya": "Maya",
  "Monitor booking progress, service status, and important updates directly within the app.":
      "Consulta el progreso de la reserva, el estado del servicio y las actualizaciones importantes en la app.",
  "More": "Más",
  "Name": "Nombre",
  "Neha Verma": "Neha Verma",
  "Netbanking": "Banca en línea",
  "New update": "Nueva actualización",
  "No additional comments": "Sin comentarios adicionales",
  "No app account exists for this Google email. Please sign up.":
      "No existe una cuenta para este correo de Google. Regístrate.",
  "No internet connection. Please try again.":
      "Sin conexión a Internet. Inténtalo de nuevo.",
  "No payment was taken. Please refresh the service prices and try again.":
      "No se ha cobrado ningún pago. Actualiza los precios e inténtalo de nuevo.",
  "No places found. Try a different search.":
      "No se encontraron lugares. Prueba otra búsqueda.",
  "Not Included": "No incluido",
  "Nov": "nov",
  "November": "Noviembre",
  "Oct": "oct",
  "October": "Octubre",
  "Office 365 included": "Office 365 incluido",
  "Office Pro Plus & server backup":
      "Office Pro Plus y copias de seguridad del servidor",
  "Office Pro Plus · 3 devices": "Office Pro Plus · 3 dispositivos",
  "Optional notification setup": "Configuración opcional de notificaciones",
  "Order ID": "ID del pedido",
  "Our Care": "Nuestro cuidado",
  "PAYMENT SUMMARY": "RESUMEN DEL PAGO",
  "PM": "p. m.",
  "Paid Amount": "Importe pagado",
  "Pay by UPI": "Pagar por UPI",
  "PayPal Payments": "Pagos PayPal",
  "Payment Breakdown": "Desglose del pago",
  "Payment ID": "ID de pago",
  "Payment Status": "Estado del pago",
  "Payment canceled. No plan was activated.":
      "Pago cancelado. No se activó ningún plan.",
  "Payment failed. Check payment before trying another purchase.":
      "Pago fallido. Comprueba el pago antes de realizar otra compra.",
  "Payment is not confirmed yet. Use Check payment to retry.":
      "El pago aún no está confirmado. Usa Comprobar pago para reintentarlo.",
  "Payment is processing. Use Check payment to verify it later.":
      "El pago se está procesando. Usa Comprobar pago para verificarlo más tarde.",
  "Payment provider": "Proveedor de pagos",
  "Payments are temporarily unavailable. Please try again later.":
      "Los pagos no están disponibles temporalmente. Inténtalo más tarde.",
  "Person's contact number": "Teléfono de contacto de la persona",
  "Person's full name": "Nombre completo de la persona",
  "Phone": "Teléfono",
  "Plan pricing changed. Refresh plans and review the new price before paying.":
      "El precio del plan cambió. Actualiza los planes y revisa el precio antes de pagar.",
  "Please sign in before purchasing a plan.":
      "Inicia sesión antes de comprar un plan.",
  "Plumbing Service": "Servicio de fontanería",
  "Pro SOS": "Pro SOS",
  "Profile update failed.": "No se pudo actualizar el perfil.",
  "Qty": "Cant.",
  "Quality Service,": "Servicio de calidad,",
  "Rate our service": "Valora nuestro servicio",
  "Rate technician": "Valora al técnico",
  "Rate your service experience and provide feedback once the job is completed.":
      "Valora el servicio y comparte tu opinión al finalizar el trabajo.",
  "Read less": "Leer menos",
  "Read more": "Leer más",
  "Real-time tracking keeps everything transparent and documented.":
      "El seguimiento en tiempo real garantiza transparencia y documentación.",
  "Recommended Payments": "Pagos recomendados",
  "Reena (Mom)": "Reena (mamá)",
  "Repair Services": "Servicios de reparación",
  "Reply in 24 hours": "Respuesta en 24 horas",
  "Request failed.": "Solicitud fallida.",
  "Request failed. Please try again.": "Solicitud fallida. Inténtalo de nuevo.",
  "Requested resource not found.": "No se encontró el recurso solicitado.",
  "Requirements": "Requisitos",
  "Residential": "Residencial",
  "Review the service estimate and any additional work recommendations carefully. Approve only the charges you agree with.":
      "Revisa detenidamente el presupuesto y las recomendaciones de trabajo adicional. Aprueba solo los cargos con los que estés de acuerdo.",
  "Ritika Sharma": "Ritika Sharma",
  "SBI\nBank": "SBI\nBank",
  "SERVICES ORDERED": "SERVICIOS SOLICITADOS",
  "Safety concerns during service":
      "Problemas de seguridad durante el servicio",
  "Sarah (Sis)": "Sarah (hermana)",
  "Scheduled Date": "Fecha programada",
  "Searching places…": "Buscando lugares…",
  "Search…": "Buscar…",
  "Sector 15, Noida": "Sector 15, Noida",
  "Secure payments help maintain accurate records and enable faster support if required.":
      "Los pagos seguros permiten mantener registros precisos y ofrecer asistencia más rápida.",
  "Security for 5 devices": "Seguridad para 5 dispositivos",
  "Selected add-on": "Complemento seleccionado",
  "Selected variant": "Variante seleccionada",
  "Sep": "sep",
  "September": "Septiembre",
  "Service\nCompleted!": "¡Servicio\ncompletado!",
  "Service Address": "Dirección del servicio",
  "Service Name": "Nombre del servicio",
  "Service Option": "Opción de servicio",
  "Service booking": "Reserva de servicio",
  "Service date": "Fecha del servicio",
  "Service is in progress": "El servicio está en curso",
  "Servicing...": "Prestando servicio...",
  "Sign-in was cancelled.": "Se canceló el inicio de sesión.",
  "Smart Lock - Video Doorbell Setup":
      "Instalación de cerradura inteligente y videotimbre",
  "Smart SOS": "Smart SOS",
  "Something went wrong. Please try again.":
      "Ocurrió un error. Inténtalo de nuevo.",
  "Special Instructions": "Instrucciones especiales",
  "SquadOnSite": "SquadOnSite",
  "State": "Estado / provincia",
  "Street (optional)": "Calle (opcional)",
  "Subject": "Asunto",
  "Subtotal": "Subtotal",
  "Support attachment image": "Imagen adjunta de soporte",
  "Support · 8 AM–8 PM EST": "Soporte · 8:00–20:00 EST",
  "Support · 8 AM–midnight EST": "Soporte · 8:00–medianoche EST",
  "Support · 9 AM–5 PM EST": "Soporte · 9:00–17:00 EST",
  "Support. EST 8 AM – EST 8 PM": "Soporte. EST 8:00–20:00",
  "TERMS OF SERVICE": "TÉRMINOS DEL SERVICIO",
  "TV Installation": "Instalación de TV",
  "Technician Michael Johnson is on the way":
      "El técnico Michael Johnson está en camino",
  "Technician is arrived,\nShare the otp and get the service star.":
      "El técnico ha llegado.\nComparte el código para comenzar el servicio.",
  "Technicians": "Técnicos",
  "Thank you for choosing us!\nRate our technicians!":
      "¡Gracias por elegirnos!\n¡Valora a nuestros técnicos!",
  "Thank you for connecting!": "¡Gracias por contactar con nosotros!",
  "Thank you for mailing us!": "¡Gracias por escribirnos!",
  "The checkout amount does not match your service and add-ons total. ":
      "El importe del pago no coincide con el total del servicio y los complementos. ",
  "The server rejected the request without an error message (HTTP 400).":
      "El servidor rechazó la solicitud sin indicar el motivo (HTTP 400).",
  "Thermostats Installation": "Instalación de termostatos",
  "This account is not allowed to purchase plans.":
      "Esta cuenta no puede comprar planes.",
  "This helps ensure the right professional is attending your service.":
      "Esto ayuda a confirmar que el profesional correcto está realizando tu servicio.",
  "This plan or purchase is no longer available.":
      "Este plan o compra ya no está disponible.",
  "This search could not be processed. Try another address.":
      "No se pudo procesar la búsqueda. Prueba otra dirección.",
  "Today": "Hoy",
  "Today • 11:12 AM": "Hoy • 11:12",
  "Too many attempts. Please wait and try again.":
      "Demasiados intentos. Espera y vuelve a intentarlo.",
  "Tools & Equipment": "Herramientas y equipo",
  "Total Amount": "Importe total",
  "Total amount": "Importe total",
  "Transaction ID": "ID de transacción",
  "Trusted": "De confianza",
  "UPI / GPay": "UPI / GPay",
  "Unable to complete the request. Please retry. If you paid, use Check payment.":
      "No se pudo completar la solicitud. Reinténtalo. Si has pagado, usa Comprobar pago.",
  "Unable to connect. Please check your connection and retry.":
      "No se pudo conectar. Comprueba tu conexión y reinténtalo.",
  "Unable to connect. Please try again.":
      "No se pudo conectar. Inténtalo de nuevo.",
  "Unable to load notifications.": "No se pudieron cargar las notificaciones.",
  "Unable to load the invoice.": "No se pudo cargar la factura.",
  "Unable to load the invoice. Please try again.":
      "No se pudo cargar la factura. Inténtalo de nuevo.",
  "Unable to open invoice.": "No se pudo abrir la factura.",
  "Unable to submit the service review.":
      "No se pudo enviar la valoración del servicio.",
  "Unable to submit the technician review.":
      "No se pudo enviar la valoración del técnico.",
  "Unable to verify Google account details. Please try again.":
      "No se pudieron verificar los datos de Google. Inténtalo de nuevo.",
  "Unapproved additional charges": "Cargos adicionales no aprobados",
  "Unauthorized. Please login again.": "No autorizado. Inicia sesión de nuevo.",
  "Unexpected server response": "Respuesta inesperada del servidor",
  "Unit Price": "Precio unitario",
  "United States": "Estados Unidos",
  "Unprofessional behavior": "Comportamiento poco profesional",
  "User": "Usuario",
  "Verification": "Verificación",
  "Video unavailable": "Vídeo no disponible",
  "Vikas Kumar": "Vikas Kumar",
  "Visa Card •••• 4492": "Visa •••• 4492",
  "We are Done!": "¡Hemos terminado!",
  "We are finding the best technician for you":
      "Estamos buscando al mejor técnico para ti",
  "We are hoping everything is going smooth.": "Esperamos que todo vaya bien.",
  "We hope your issue was resolved.\nReach out anytime if you need further time.":
      "Esperamos que tu problema se haya resuelto.\nContacta con nosotros si necesitas más ayuda.",
  "We will get back to you within 24 to 48 hours":
      "Te responderemos en un plazo de 24 a 48 horas",
  "We will notify you once\na technician is assigned":
      "Te avisaremos cuando\nse asigne un técnico",
  "Website": "Sitio web",
  "What's Included": "Qué incluye",
  "Work": "Trabajo",
  "Yesterday": "Ayer",
  "You do not have permission.": "No tienes permiso.",
  "You have a new notification": "Tienes una nueva notificación",
  "Your Home,": "Tu hogar,",
  "Your location": "Tu ubicación",
  "Your reviews help us improve service quality and recognize top-performing professionals.":
      "Tus reseñas nos ayudan a mejorar la calidad y reconocer a los mejores profesionales.",
  "Your session expired. Please sign in again.":
      "Tu sesión ha caducado. Inicia sesión de nuevo.",
  "Your session has expired. Sign in again to search.":
      "Tu sesión ha caducado. Inicia sesión para buscar.",
  "ZIP / Postal code": "Código postal",
  "privacy policy": "política de privacidad",
  "terms and conditions": "términos y condiciones",

  // Bundled legal document translations.
  "Your privacy matters": "Tu privacidad importa",
  "SquadOnSite · Customer Privacy Policy":
      "SquadOnSite · Política de privacidad del cliente",
  "This policy explains how personal information is used when you create an account, book a service, make a payment, or communicate through SquadOnSite (SOS). It also explains the choices available to you.":
      "Esta política explica cómo se utiliza tu información personal al crear una cuenta, reservar un servicio, pagar o comunicarte a través de SquadOnSite (SOS). También explica las opciones que tienes.",
  "1. About this policy": "1. Acerca de esta política",
  "SquadOnSite connects customers with service professionals. This policy covers personal information handled in connection with the customer app and related service interactions. Third-party services you choose to use may also have their own privacy policies.":
      "SquadOnSite conecta a clientes con profesionales. Esta política cubre la información personal tratada en la app del cliente y las interacciones relacionadas con el servicio. Los servicios de terceros que utilices también pueden tener sus propias políticas de privacidad.",
  "2. Information you provide": "2. Información que proporcionas",
  "Account details: your name, email address, phone number, and information used to sign in or verify your account.":
      "Datos de la cuenta: nombre, correo electrónico, teléfono e información utilizada para iniciar sesión o verificar tu cuenta.",
  "Profile details: your profile photo, date of birth, gender, and alternate contact details when you provide them.":
      "Datos del perfil: foto, fecha de nacimiento, género y datos de contacto alternativos cuando los proporcionas.",
  "Service details: saved addresses, location coordinates, booking instructions, appointment times, selected services, and booking history.":
      "Datos del servicio: direcciones guardadas, coordenadas de ubicación, instrucciones de reserva, citas, servicios seleccionados e historial de reservas.",
  "Communications and feedback: messages, service reviews, ratings, and information you share when asking for assistance.":
      "Comunicaciones y opiniones: mensajes, reseñas, valoraciones e información que compartes al solicitar ayuda.",
  "Payment records: transaction references, payment status, wallet activity, refunds, and amounts associated with your bookings.":
      "Registros de pago: referencias de transacciones, estado de los pagos, actividad del monedero, reembolsos e importes asociados a tus reservas.",
  "If you provide another person's contact details or address, make sure you have permission to share them. Avoid including unnecessary sensitive information in booking instructions, reviews, or messages.":
      "Si proporcionas datos de contacto o la dirección de otra persona, asegúrate de tener su permiso. Evita incluir información sensible innecesaria en instrucciones, reseñas o mensajes.",
  "3. Information from your device and sign-in providers":
      "3. Información del dispositivo y proveedores de acceso",
  "The app uses session identifiers and locally stored account information to keep you signed in. Push notification tokens help deliver notifications to your device.":
      "La app utiliza identificadores de sesión e información de cuenta almacenada localmente para mantener tu sesión iniciada. Los tokens de notificaciones permiten enviar notificaciones a tu dispositivo.",
  "If you choose Google or Apple sign-in, we receive the account details and authentication information made available by that provider, such as your name, email address, and account identifier. The information available depends on your provider settings.":
      "Si eliges iniciar sesión con Google o Apple, recibimos los datos de cuenta y autenticación que facilita ese proveedor, como nombre, correo e identificador de cuenta. La información disponible depende de tus ajustes con el proveedor.",
  "4. How information is used": "4. Cómo se utiliza la información",
  "Create and manage your account, authenticate sign-ins, and maintain your session.":
      "Crear y gestionar tu cuenta, autenticar accesos y mantener tu sesión.",
  "Find service locations, arrange bookings, assign professionals, and provide booking status updates.":
      "Localizar servicios, organizar reservas, asignar profesionales y proporcionar actualizaciones de las reservas.",
  "Process payments and maintain records of transactions, wallet balances, and refunds.":
      "Procesar pagos y mantener registros de transacciones, saldos del monedero y reembolsos.",
  "Enable service communications, respond to questions, and address booking issues.":
      "Facilitar comunicaciones del servicio, responder preguntas y resolver incidencias de reservas.",
  "Investigate misuse, resolve disputes, and meet applicable legal obligations.":
      "Investigar usos indebidos, resolver disputas y cumplir obligaciones legales aplicables.",
  "5. Location and device permissions":
      "5. Ubicación y permisos del dispositivo",
  "When you use a location feature and grant permission, the app can obtain your device location to help select a service address. You can also enter an address manually. A service address remains necessary to arrange an on-site visit.":
      "Cuando usas una función de ubicación y das permiso, la app puede obtener la ubicación de tu dispositivo para ayudarte a elegir una dirección de servicio. También puedes introducirla manualmente. Sigue siendo necesaria una dirección para organizar una visita presencial.",
  "Camera or photo access supports features such as choosing a profile image. Notification permission allows the app to show booking and service updates.":
      "El acceso a cámara o fotos permite funciones como elegir una imagen de perfil. El permiso de notificaciones permite mostrar actualizaciones de reservas y servicios.",
  "You can change these permissions in your device settings. Disabling a permission may limit the related feature. Changing permissions does not automatically delete information already submitted.":
      "Puedes cambiar estos permisos en los ajustes del dispositivo. Desactivar un permiso puede limitar la función correspondiente. Cambiar los permisos no elimina automáticamente la información ya enviada.",
  "6. Service professionals and other recipients":
      "6. Profesionales y otros destinatarios",
  "Information needed to arrange and complete a booking, such as your service address, contact details, requested service, and instructions, may be shared with the assigned service professional.":
      "La información necesaria para organizar y completar una reserva, como dirección, datos de contacto, servicio solicitado e instrucciones, puede compartirse con el profesional asignado.",
  "Service providers supporting authentication, maps, notifications, payments, and app infrastructure process information required for their roles. Integrations used by the app include Google Maps, Firebase Cloud Messaging, Google and Apple sign-in, and Stripe for supported payment flows.":
      "Los proveedores de autenticación, mapas, notificaciones, pagos e infraestructura tratan la información necesaria para sus funciones. Las integraciones incluyen Google Maps, Firebase Cloud Messaging, Google y Apple para acceso, y Stripe para los pagos admitidos.",
  "Information may also be disclosed where required by applicable law or needed to address fraud, safety concerns, or legal claims.":
      "También puede divulgarse información cuando lo exija la ley o sea necesario para abordar fraude, seguridad o reclamaciones legales.",
  "7. Payments": "7. Pagos",
  "For supported payment flows, payment details are processed through the payment provider. SquadOnSite uses transaction identifiers, amounts, and payment results to update bookings and payment records. The provider's own privacy policy explains its handling of payment information.":
      "En los pagos admitidos, el proveedor de pagos procesa los datos de pago. SquadOnSite utiliza identificadores, importes y resultados de transacciones para actualizar reservas y registros. La política de privacidad del proveedor explica su tratamiento de los datos de pago.",
  "Do not send card security codes, passwords, or one-time verification codes in service instructions or support messages.":
      "No envíes códigos de seguridad de tarjetas, contraseñas ni códigos de verificación en instrucciones de servicio o mensajes de soporte.",
  "8. Storage and retention": "8. Almacenamiento y conservación",
  "Information may be held on your device and in systems used to operate the service. Retention depends on the type of information, the purpose for which it was collected, and applicable recordkeeping requirements. Booking and payment records may need to be retained to resolve disputes or meet legal obligations.":
      "La información puede almacenarse en tu dispositivo y en los sistemas que operan el servicio. Su conservación depende del tipo de información, su finalidad y los requisitos de registro aplicables. Puede ser necesario conservar registros de reservas y pagos para resolver disputas o cumplir obligaciones legales.",
  "Signing out or uninstalling the app does not by itself delete your account or records held by the service. Storage locations and international processing depend on the providers supporting the service.":
      "Cerrar sesión o desinstalar la app no elimina por sí solo tu cuenta ni los registros del servicio. Los lugares de almacenamiento y el tratamiento internacional dependen de los proveedores que apoyan el servicio.",
  "9. Account security": "9. Seguridad de la cuenta",
  "No method of electronic transmission or storage can guarantee complete security. Protect your device and sign-in credentials, and avoid sharing access to your account. Report suspected unauthorized account activity by emailing support@sosgeek.tech.":
      "Ningún método de transmisión o almacenamiento electrónico garantiza seguridad absoluta. Protege tu dispositivo y credenciales y evita compartir el acceso a tu cuenta. Informa de actividad no autorizada a support@sosgeek.tech.",
  "10. Your choices and privacy requests":
      "10. Tus opciones y solicitudes de privacidad",
  "Review and update available account details in the Personal Information screen.":
      "Revisa y actualiza los datos disponibles de tu cuenta en Información personal.",
  "Manage location, camera, photos, and notification permissions through your device settings.":
      "Gestiona los permisos de ubicación, cámara, fotos y notificaciones en los ajustes del dispositivo.",
  "Manage access granted to Google or Apple sign-in through the relevant provider's account settings.":
      "Gestiona el acceso concedido a Google o Apple desde los ajustes de tu cuenta con ese proveedor.",
  "Depending on the law that applies to you, you may have rights to request access, correction, deletion, or a copy of your information, or to object to or restrict certain processing. Some requests may be subject to identity verification and legal exceptions, including required retention of transaction records.":
      "Según la legislación aplicable, puedes tener derecho a solicitar acceso, corrección, eliminación o una copia de tu información, o a oponerte a determinados tratamientos o limitarlos. Algunas solicitudes pueden requerir verificación de identidad y estar sujetas a excepciones legales, incluida la conservación obligatoria de transacciones.",
  "11. Children's privacy": "11. Privacidad de menores",
  "The service is designed for customers who can arrange and pay for service bookings. If you believe a child has provided personal information without appropriate authorization, raise the concern by emailing support@sosgeek.tech so it can be reviewed.":
      "El servicio está diseñado para clientes capaces de organizar y pagar reservas. Si crees que un menor proporcionó información sin autorización adecuada, escribe a support@sosgeek.tech para que se revise.",
  "12. Policy updates": "12. Actualizaciones de la política",
  "This policy may be revised as the service or its information practices change. Review the policy available in the app for the current wording. Additional notice or consent may be required by applicable law for certain changes.":
      "Esta política puede revisarse al cambiar el servicio o sus prácticas de información. Consulta la versión disponible en la app. Ciertos cambios pueden requerir aviso o consentimiento adicional según la ley.",
  "13. Privacy questions": "13. Preguntas sobre privacidad",
  "When contacting SquadOnSite about privacy by emailing support@sosgeek.tech, describe your question or request and provide only the account details needed to identify your account. Do not include your password or payment security codes.":
      "Para consultar sobre privacidad, escribe a support@sosgeek.tech, describe tu pregunta o solicitud y proporciona solo los datos necesarios para identificar tu cuenta. No incluyas contraseñas ni códigos de seguridad de pago.",
  "Published Privacy Policy: https://sosgeeks.com/privacy-policy/":
      "Política de privacidad publicada: https://sosgeeks.com/privacy-policy/",
  "Website: https://sosgeeks.com/ Support and privacy enquiries: support@sosgeek.tech":
      "Sitio web: https://sosgeeks.com/ Consultas de soporte y privacidad: support@sosgeek.tech",
  "Terms & Conditions": "Términos y Condiciones",
  "SquadOnSite · Customer services & support plans":
      "SquadOnSite · Servicios al cliente y planes de soporte",
  "Please read these terms before creating an account, booking a service, or purchasing a support plan. They explain your responsibilities and how bookings, payments, and plan benefits work. Review the specific service or plan details before confirming an order.":
      "Lee estos términos antes de crear una cuenta, reservar un servicio o comprar un plan de soporte. Explican tus responsabilidades y el funcionamiento de reservas, pagos y beneficios. Revisa los detalles específicos antes de confirmar un pedido.",
  "1. About SquadOnSite": "1. Acerca de SquadOnSite",
  "SquadOnSite (SOS) connects customers with service professionals and provides access to service booking and technology support options. The scope of a service depends on the booking or plan you select. These terms apply to the customer app and related service interactions.":
      "SquadOnSite (SOS) conecta a clientes con profesionales y ofrece opciones de reserva de servicios y soporte tecnológico. El alcance depende de la reserva o plan elegido. Estos términos se aplican a la app del cliente y a las interacciones relacionadas con el servicio.",
  "2. Your account": "2. Tu cuenta",
  "Provide accurate contact details and keep your account information up to date.":
      "Proporciona datos de contacto precisos y mantén tu cuenta actualizada.",
  "You must have the legal capacity and authority to place an order. If you act for a business or another person, you must be authorized to do so.":
      "Debes tener capacidad legal y autorización para realizar un pedido. Si actúas por una empresa u otra persona, debes estar autorizado.",
  "Keep your sign-in credentials private. Do not share passwords or verification codes with service professionals or in support messages.":
      "Mantén tus credenciales privadas. No compartas contraseñas ni códigos con profesionales ni en mensajes de soporte.",
  "Report suspected unauthorized account activity by emailing support@sosgeek.tech.":
      "Informa de actividad no autorizada en tu cuenta a support@sosgeek.tech.",
  "3. Booking a service": "3. Reservar un servicio",
  "Check the selected service, address, appointment time, instructions, and displayed charges before submitting a booking. Availability depends on the service area and the professionals available. Refer to your booking confirmation and status for the accepted appointment details.":
      "Comprueba el servicio, dirección, cita, instrucciones y cargos antes de enviar una reserva. La disponibilidad depende de la zona y los profesionales disponibles. Consulta la confirmación y el estado de la reserva para conocer los detalles aceptados.",
  "Provide safe access to the service location and obtain permission before arranging work on property or equipment belonging to someone else. Changes to the agreed work or additional charges should be discussed and agreed before that additional work begins.":
      "Facilita acceso seguro al lugar y obtén permiso antes de solicitar trabajos en bienes de otra persona. Los cambios en el trabajo acordado y cargos adicionales deben discutirse y aceptarse antes de iniciarlos.",
  "4. Residential and business plans":
      "4. Planes residenciales y empresariales",
  "Plan coverage is limited to the devices, services, ticket allowances, and support hours described in the selected offer. Residential options include Smart SOS, Pro SOS, and Advanced SOS. Business options include Starter, Professional, and Enterprise bundles.":
      "La cobertura se limita a dispositivos, servicios, solicitudes y horarios descritos en la oferta. Las opciones residenciales incluyen Smart SOS, Pro SOS y Advanced SOS. Las empresariales incluyen Starter, Professional y Enterprise.",
  "Review the selected duration, supported devices, included software, backup services, and service-call allowances. A ticket or service-call allowance does not mean unlimited support. Do not assume unused allowances roll over, additional devices are included, or coverage extends beyond the stated term unless your order expressly confirms this.":
      "Revisa duración, dispositivos, software, copias de seguridad y visitas incluidas. Una asignación de solicitudes o visitas no equivale a soporte ilimitado. No supongas que se acumulan los beneficios sin usar, se incluyen más dispositivos o se amplía el plazo salvo confirmación expresa en el pedido.",
  "Support hours shown in EST refer to Eastern Standard Time. A stated response target, such as five-minute chat support, describes the initial response rather than a guarantee that an issue will be resolved within that time.":
      "EST indica la hora estándar del este. Un objetivo de respuesta, como cinco minutos por chat, se refiere a la respuesta inicial y no garantiza resolver el problema en ese plazo.",
  "5. Prices and payment": "5. Precios y pagos",
  "Before authorizing payment, confirm the currency, total payable amount, taxes or additional fees, billing schedule, and selected term in the final order. An annual payment and a monthly payment option can have different totals; do not assume one is calculated by dividing the other by twelve.":
      "Antes de autorizar el pago, confirma moneda, importe total, impuestos o cargos, calendario de facturación y plazo en el pedido final. El pago anual y la opción mensual pueden tener totales diferentes; no supongas que uno se obtiene dividiendo el otro entre doce.",
  "A plan listing or viewing plan details does not create a paid subscription. A purchase requires a confirmed order and successful payment. Use only the payment methods offered in the authorized checkout. Never send card security codes or payment credentials in messages.":
      "Ver un plan o sus detalles no crea una suscripción pagada. Comprar requiere un pedido confirmado y pago correcto. Usa solo los métodos ofrecidos en el pago autorizado. Nunca envíes credenciales ni códigos de seguridad de tarjetas en mensajes.",
  "6. Renewal, cancellation, and refunds":
      "6. Renovación, cancelación y reembolsos",
  "Review the renewal arrangement and cancellation process disclosed with your order before purchasing. Do not assume a plan renews automatically or ends automatically unless the order states this. Recurring charges require the relevant authorization.":
      "Revisa las condiciones de renovación y cancelación antes de comprar. No supongas que un plan se renueva o termina automáticamente salvo que lo indique el pedido. Los cargos recurrentes requieren autorización.",
  "Cancellation, rescheduling, and refund eligibility depend on the terms disclosed for the booking or plan and applicable consumer law. A residential offer may identify onboarding as non-refundable; any such condition must be disclosed before purchase and remains subject to rights that cannot legally be excluded.":
      "La cancelación, reprogramación y reembolso dependen de las condiciones de la reserva o plan y de la ley de consumo aplicable. Una oferta residencial puede indicar que la incorporación no es reembolsable; esto debe comunicarse antes de comprar y respetar los derechos irrenunciables.",
  "Deleting your account or uninstalling the app does not by itself establish that an existing booking or payment arrangement has been cancelled. Resolve outstanding bookings and any recurring-payment arrangement through the applicable service channel.":
      "Eliminar tu cuenta o desinstalar la app no confirma por sí solo la cancelación de una reserva o acuerdo de pago. Resuelve las reservas pendientes y pagos recurrentes mediante el canal de servicio correspondiente.",
  "7. Devices, backups, and remote assistance":
      "7. Dispositivos, copias de seguridad y asistencia remota",
  "You must be authorized to request access to or work on a device. Back up important files before service and explain any access restrictions. Remote access should be granted only for assistance you have requested and should end when that assistance is complete.":
      "Debes estar autorizado para solicitar acceso o trabajos en un dispositivo. Haz copias de los archivos importantes antes del servicio e informa de restricciones de acceso. Concede acceso remoto solo para la asistencia solicitada y finalízalo cuando termine.",
  "Backup, security, and software benefits apply only where included in your plan and may require installation, activation, compatible equipment, and compliance with the relevant provider's licence terms. No security product or backup process can guarantee protection from every threat or recovery of every file.":
      "Los beneficios de copias de seguridad, seguridad y software solo aplican si están incluidos en tu plan y pueden requerir instalación, activación, equipos compatibles y cumplimiento de licencias del proveedor. Ningún producto o proceso garantiza protección ante todas las amenazas ni recuperar todos los archivos.",
  "8. Acceptable use": "8. Uso aceptable",
  "Use the app and support services lawfully and respectfully.":
      "Usa la app y el soporte de forma legal y respetuosa.",
  "Do not submit fraudulent bookings, impersonate another person, misuse payment methods, or provide content you are not entitled to share.":
      "No envíes reservas fraudulentas, suplantes identidades, uses indebidamente pagos ni compartas contenido sin derecho a hacerlo.",
  "Do not attempt unauthorized access, disrupt the service, or use assistance to bypass another party's security or software licences.":
      "No intentes accesos no autorizados, interrumpas el servicio ni uses la asistencia para eludir la seguridad o licencias de terceros.",
  "Keep reviews and messages relevant and avoid disclosing another person's private information.":
      "Mantén reseñas y mensajes pertinentes y evita divulgar información privada de otras personas.",
  "9. Privacy and communications": "9. Privacidad y comunicaciones",
  "The Privacy Policy explains how account details, service addresses, communications, payment records, and device permissions relate to the service. Information needed to complete a booking may be shared with the assigned professional and relevant service providers.":
      "La Política de privacidad explica cómo los datos de cuenta, direcciones, comunicaciones, pagos y permisos se relacionan con el servicio. La información necesaria para completar una reserva puede compartirse con el profesional y los proveedores pertinentes.",
  "Keep your contact details current so you can receive booking and payment updates. Device notification permissions can be managed in your device settings.":
      "Mantén tus datos de contacto actualizados para recibir avisos de reservas y pagos. Puedes gestionar los permisos de notificaciones en los ajustes del dispositivo.",
  "10. Third-party services": "10. Servicios de terceros",
  "Features may use third-party authentication, maps, notifications, payment processing, software, or backup services. Their own terms and privacy policies may also apply. A plan's reference to a third-party product does not expand that product's licence or warranty.":
      "Las funciones pueden utilizar autenticación, mapas, notificaciones, pagos, software o copias de seguridad de terceros. También pueden aplicarse sus términos y políticas. Mencionar un producto en un plan no amplía su licencia ni garantía.",
  "11. Service availability and responsibility":
      "11. Disponibilidad y responsabilidad del servicio",
  "Service availability can be affected by connectivity, maintenance, device compatibility, and circumstances outside the parties' control. Explain any issue promptly and provide relevant booking or transaction details so it can be investigated.":
      "La disponibilidad puede verse afectada por conectividad, mantenimiento, compatibilidad y circunstancias fuera del control de las partes. Comunica cualquier problema pronto e incluye datos de reserva o transacción para investigarlo.",
  "Nothing in these terms excludes or limits consumer rights, remedies, or responsibilities that cannot be excluded or limited under applicable law. No specific repair outcome, data recovery result, or uninterrupted availability is promised unless expressly confirmed for your service.":
      "Estos términos no excluyen ni limitan derechos, recursos o responsabilidades que la ley no permita excluir o limitar. No se promete un resultado concreto de reparación, recuperación de datos ni disponibilidad ininterrumpida salvo confirmación expresa para tu servicio.",
  "12. Account restrictions and outstanding orders":
      "12. Restricciones de cuenta y pedidos pendientes",
  "Misuse, security concerns, or unlawful activity may require access restrictions while the matter is investigated. Any restriction should be handled consistently with applicable law and obligations relating to existing orders. Keep a record of your booking and payment confirmations.":
      "El uso indebido, los riesgos de seguridad o actividades ilegales pueden requerir restricciones mientras se investiga. Las restricciones deben respetar la ley y las obligaciones de pedidos existentes. Conserva confirmaciones de reservas y pagos.",
  "13. Questions and updates": "13. Preguntas y actualizaciones",
  "For questions about an order or these terms, email support@sosgeek.tech and include the relevant booking or transaction reference. Do not include passwords or payment security codes.":
      "Para preguntas sobre pedidos o estos términos, escribe a support@sosgeek.tech e incluye la referencia de reserva o transacción. No incluyas contraseñas ni códigos de seguridad de pago.",
  "These terms may be updated as the service changes. Review the version presented with your order. Changes remain subject to any notice, consent, or other requirements of applicable law.":
      "Estos términos pueden actualizarse al cambiar el servicio. Revisa la versión presentada con tu pedido. Los cambios están sujetos a requisitos legales de aviso, consentimiento u otros.",
  "Published Terms of Service: https://sosgeeks.com/terms-of-service/":
      "Términos del servicio publicados: https://sosgeeks.com/terms-of-service/",

  // Counts, relative dates and server status display labels.
  "@count booked service": "1 servicio reservado",
  "@count booked services": "@count servicios reservados",
  "Previous rating: @count star": "Valoración anterior: @count estrella",
  "Previous rating: @count stars": "Valoración anterior: @count estrellas",
  "@count minutes ago": "hace @count min",
  "@count hours ago": "hace @count h",
  "@count days ago": "hace @count días",
  "Paid": "Pagado",
  "PAID": "Pagado",
  "paid": "Pagado",
  "Unpaid": "Sin pagar",
  "UNPAID": "Sin pagar",
  "unpaid": "Sin pagar",
  "Failed": "Fallido",
  "FAILED": "Fallido",
  "failed": "Fallido",
  "In Progress": "En curso",
  "IN PROGRESS": "En curso",
  "in_progress": "En curso",
  "In progress": "En curso",
  "Assigned": "Asignado",
  "ASSIGNED": "Asignado",
  "assigned": "Asignado",
  "On the Way": "En camino",
  "ON THE WAY": "En camino",
  "on_the_way": "En camino",
  "Checkout": "Finalización del servicio",
  "CHECKOUT": "Finalización del servicio",
  "checkout": "Finalización del servicio",
  "Ongoing": "En curso",
  "ONGOING": "En curso",
  "ongoing": "En curso",
  "Replaced": "Reemplazado",
  "REPLACED": "Reemplazado",
  "replaced": "Reemplazado",
  "Expired": "Caducado",
  "EXPIRED": "Caducado",
  "expired": "Caducado",
  "Active": "Activo",
  "ACTIVE": "Activo",
  "active": "Activo",
  "Refunded": "Reembolsado",
  "REFUNDED": "Reembolsado",
  "refunded": "Reembolsado",
  "CANCELLED": "Cancelado",
  "cancelled": "Cancelado",
  "CONFIRMED": "Confirmado",
  "confirmed": "Confirmado",
  "Enter a valid @count-digit phone number":
      "Introduce un teléfono válido de @count dígitos",
  "Minimum @count characters required":
      "Se requieren al menos @count caracteres",
  "Maximum @count characters allowed":
      "Se permiten como máximo @count caracteres",
  "Enter a valid @count-digit number for @country":
      "Introduce un número válido de @count dígitos para @country",
};
