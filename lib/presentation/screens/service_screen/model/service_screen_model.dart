import 'package:squadonsite/core/pagination/pagination_info.dart';

/// Backward-compatible alias so existing screens don't need changes.
typedef ServiceModel = ServiceItem;

class SubcategoryResponse {
  final bool success;
  final List<SubcategoryItem> subcategories;
  final bool hasMore;

  const SubcategoryResponse({
    required this.success,
    required this.subcategories,
    this.hasMore = false,
  });

  factory SubcategoryResponse.fromJson(
    Map<String, dynamic> json, {
    int page = 1,
    int limit = 10,
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final list = data['subcategories'] as List<dynamic>? ?? [];
    final subcategories = list
        .map((e) => SubcategoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return SubcategoryResponse(
      success: json['success'] == true,
      subcategories: subcategories,
      hasMore: PaginationInfo.fromResponse(
        response: json,
        data: data,
        page: page,
        limit: limit,
        itemCount: subcategories.length,
      ).hasMore,
    );
  }
}

class SubcategoryItem {
  final String id;
  final String name;
  final String image;
  final String icon;
  final num startingFromPrice;

  const SubcategoryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.icon,
    required this.startingFromPrice,
  });

  factory SubcategoryItem.fromJson(Map<String, dynamic> json) {
    return SubcategoryItem(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      startingFromPrice: json['startingFromPrice'] as num? ?? 0,
    );
  }
}

class ServiceListResponse {
  final bool success;
  final List<ServiceItem> services;
  final bool hasMore;

  const ServiceListResponse({
    required this.success,
    required this.services,
    this.hasMore = false,
  });

  factory ServiceListResponse.fromJson(
    Map<String, dynamic> json, {
    int page = 1,
    int limit = 10,
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final list = data['services'] as List<dynamic>? ?? [];
    final services = list
        .map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return ServiceListResponse(
      success: json['success'] == true,
      services: services,
      hasMore: PaginationInfo.fromResponse(
        response: json,
        data: data,
        page: page,
        limit: limit,
        itemCount: services.length,
      ).hasMore,
    );
  }
}

class ServiceItem {
  final String id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final num actualPrice;
  final num offerPrice;
  final int serviceDuration;
  final double ratingsAverage;
  final int ratingsQuantity;
  final String featuredImage;
  final bool hasVariants;
  final List<VariantItem> variants;
  final List<AddonItem> addons;
  final List<IncludedItem> includedItems;
  final List<IncludedItem> excludedItems;
  final List<FaqItem> faqs;
  final List<GalleryItem> gallery;
  final List<RequirementItem> requirements;
  final List<ServiceToolItem> tools;
  final List<ProcessStep> processSteps;
  final num priceMin;
  final num priceMax;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.actualPrice,
    required this.offerPrice,
    required this.serviceDuration,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.featuredImage,
    this.hasVariants = false,
    this.variants = const [],
    required this.addons,
    required this.includedItems,
    required this.excludedItems,
    required this.faqs,
    required this.gallery,
    this.requirements = const [],
    this.tools = const [],
    this.processSteps = const [],
    this.priceMin = 0,
    this.priceMax = 0,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    final shortDesc = json['shortDescription'];
    final desc = shortDesc is List
        ? shortDesc.whereType<String>().join('\n')
        : shortDesc is String
        ? shortDesc
        : '';
    final priceMap = json['price'];
    return ServiceItem(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortDescription: desc,
      longDescription: json['longDescription'] as String? ?? '',
      actualPrice: json['actualPrice'] as num? ?? 0,
      offerPrice: json['offerPrice'] as num? ?? 0,
      serviceDuration: (json['serviceDuration'] as num?)?.toInt() ?? 0,
      ratingsAverage: (json['ratingsAverage'] as num?)?.toDouble() ?? 0.0,
      ratingsQuantity: (json['ratingsQuantity'] as num?)?.toInt() ?? 0,
      featuredImage: json['featuredImage'] as String? ?? '',
      hasVariants: json['hasVariants'] as bool? ?? false,
      variants: ((json['variants'] as List<dynamic>?) ?? [])
          .map((e) => VariantItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      addons: ((json['addons'] as List<dynamic>?) ?? [])
          .map((e) => AddonItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      includedItems: ((json['includedItems'] as List<dynamic>?) ?? [])
          .map((e) => IncludedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      excludedItems: ((json['excludedItems'] as List<dynamic>?) ?? [])
          .map((e) => IncludedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      faqs: ((json['faqs'] as List<dynamic>?) ?? [])
          .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gallery: ((json['gallery'] as List<dynamic>?) ?? [])
          .map((e) => GalleryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      requirements: ((json['requirements'] as List<dynamic>?) ?? [])
          .map((e) => RequirementItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      tools: ((json['tools'] as List<dynamic>?) ?? [])
          .map((e) => ServiceToolItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      processSteps: ((json['processSteps'] as List<dynamic>?) ?? [])
          .map((e) => ProcessStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceMin: priceMap is Map
          ? (priceMap['min'] as num? ?? 0)
          : priceMap is num
          ? priceMap
          : json['offerPrice'] as num? ?? 0,
      priceMax: priceMap is Map
          ? (priceMap['max'] as num? ?? 0)
          : priceMap is num
          ? priceMap
          : json['offerPrice'] as num? ?? 0,
    );
  }
}

class AddonItem {
  final String id;
  final String name;
  final num price;
  final String image;
  final String description;
  final bool isActive;

  const AddonItem({
    required this.id,
    required this.name,
    required this.price,
    this.image = '',
    this.description = '',
    this.isActive = true,
  });

  factory AddonItem.fromJson(Map<String, dynamic> json) => AddonItem(
    id: json['_id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    price: json['price'] as num? ?? 0,
    image: json['image'] as String? ?? '',
    description: json['description'] as String? ?? '',
    isActive: json['isActive'] as bool? ?? true,
  );
}

class IncludedItem {
  final String title;

  const IncludedItem({required this.title});

  factory IncludedItem.fromJson(Map<String, dynamic> json) =>
      IncludedItem(title: json['title'] as String? ?? '');
}

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
    question: json['question'] as String? ?? '',
    answer: json['answer'] as String? ?? '',
  );
}

class GalleryItem {
  final String url;
  final String type;

  const GalleryItem({required this.url, required this.type});

  factory GalleryItem.fromJson(Map<String, dynamic> json) => GalleryItem(
    url: json['url'] as String? ?? '',
    type: json['type'] as String? ?? 'image',
  );
}

class VariantItem {
  final String id;
  final String name;
  final String sizeCapacity;
  final String unit;
  final num actualPrice;
  final num discountPercentage;
  final num offerPrice;
  final int duration;
  final bool isActive;

  const VariantItem({
    required this.id,
    required this.name,
    required this.sizeCapacity,
    required this.unit,
    required this.actualPrice,
    required this.discountPercentage,
    required this.offerPrice,
    required this.duration,
    required this.isActive,
  });

  factory VariantItem.fromJson(Map<String, dynamic> json) => VariantItem(
    id: json['_id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    sizeCapacity: json['sizeCapacity'] as String? ?? '',
    unit: json['unit'] as String? ?? '',
    actualPrice: json['actualPrice'] as num? ?? 0,
    discountPercentage: json['discountPercentage'] as num? ?? 0,
    offerPrice: json['offerPrice'] as num? ?? 0,
    duration: (json['duration'] as num?)?.toInt() ?? 0,
    isActive: json['isActive'] as bool? ?? true,
  );
}

class RequirementItem {
  final String id;
  final String title;
  final String image;

  const RequirementItem({
    required this.id,
    required this.title,
    required this.image,
  });

  factory RequirementItem.fromJson(Map<String, dynamic> json) =>
      RequirementItem(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        image: json['image'] as String? ?? '',
      );
}

class ServiceToolItem {
  final String id;
  final String name;
  final String description;
  final String image;

  const ServiceToolItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory ServiceToolItem.fromJson(Map<String, dynamic> json) =>
      ServiceToolItem(
        id: json['_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        image: json['image'] as String? ?? '',
      );
}

class ProcessStep {
  final String id;
  final int stepNumber;
  final String title;
  final String description;
  final String image;

  const ProcessStep({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.image,
  });

  factory ProcessStep.fromJson(Map<String, dynamic> json) => ProcessStep(
    id: json['_id'] as String? ?? '',
    stepNumber: (json['stepNumber'] as num?)?.toInt() ?? 0,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    image: json['image'] as String? ?? '',
  );
}

// ── Featured service model ────────────────────────────────────────────────────────────

class FeaturedServiceItem {
  final String id;
  final String name;
  final num price;
  final double rating;
  final String featuredImage;

  const FeaturedServiceItem({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.featuredImage,
  });

  factory FeaturedServiceItem.fromJson(Map<String, dynamic> json) =>
      FeaturedServiceItem(
        id: json['id'] as String? ?? json['_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        price: json['price'] as num? ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        featuredImage: json['featuredImage'] as String? ?? '',
      );

  /// Convert to a minimal [ServiceItem] so BookServiceScreen can accept it.
  ServiceItem toServiceItem() => ServiceItem(
    id: id,
    name: name,
    shortDescription: '',
    longDescription: '',
    actualPrice: price,
    offerPrice: price,
    serviceDuration: 0,
    ratingsAverage: rating,
    ratingsQuantity: 0,
    featuredImage: featuredImage,
    addons: const [],
    includedItems: const [],
    excludedItems: const [],
    faqs: const [],
    gallery: const [],
  );
}

// ── Booking models ────────────────────────────────────────────────────────────

// Response from POST /bookings.
// The backend does NOT create a Booking yet — it creates a PaymentAttempt
// and a payment order with the provider. The booking is only created after
// POST /bookings/verify succeeds.
class CreateBookingResponse {
  /// `data.paymentAttempt._id` — used as `paymentAttemptId` in verify call.
  final String paymentAttemptId;

  /// `data.paymentOrder.id` — the Stripe PaymentIntent ID (pi_...).
  final String stripePaymentIntentId;

  final String clientSecret;
  final String publishableKey;
  final String currency;

  /// Amount in the currency's smallest unit (e.g. 10000 = USD 100.00).
  final int amountInCents;

  /// `data.paymentAttempt.totalAmount` — shown in the UI.
  final num totalAmount;
  final String serviceDate;

  const CreateBookingResponse({
    required this.paymentAttemptId,
    required this.stripePaymentIntentId,
    required this.clientSecret,
    required this.publishableKey,
    required this.currency,
    required this.amountInCents,
    required this.totalAmount,
    required this.serviceDate,
  });

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    // POST /bookings returns paymentAttempt (not a booking).
    final attempt = data['paymentAttempt'] as Map<String, dynamic>;
    final order = data['paymentOrder'] as Map<String, dynamic>;

    final provider = order['provider'] as String? ?? '';
    if (provider != 'stripe') {
      throw StateError(
        'Unsupported payment provider "$provider". Only Stripe is supported.',
      );
    }

    final key = order['publishableKey'] as String? ?? '';
    final secret = order['clientSecret'] as String? ?? '';
    if (!key.startsWith('pk_') || secret.isEmpty) {
      throw StateError(
        'Missing Stripe credentials. publishableKey="$key" clientSecret=${secret.isEmpty ? "empty" : "present"}',
      );
    }

    return CreateBookingResponse(
      paymentAttemptId: attempt['_id'] as String,
      stripePaymentIntentId: order['id'] as String,
      clientSecret: secret,
      publishableKey: key,
      currency: order['currency'] as String? ?? 'usd',
      amountInCents: (order['amount'] as num).toInt(),
      totalAmount: attempt['totalAmount'] as num? ?? 0,
      serviceDate: attempt['serviceDate'] as String? ?? '',
    );
  }
}

// Response from POST /bookings/verify.
// Only created when payment is confirmed by the provider.
class VerifyBookingResponse {
  final String bookingId;
  final num totalAmount;
  final String serviceDate;
  final String status; // "Pending" until ops confirms
  final String paymentStatus; // "Paid" when charge succeeded
  final String paymentProvider;
  final String paymentIntentId;
  final String transactionId;

  const VerifyBookingResponse({
    required this.bookingId,
    required this.totalAmount,
    required this.serviceDate,
    required this.status,
    required this.paymentStatus,
    required this.paymentProvider,
    required this.paymentIntentId,
    required this.transactionId,
  });

  factory VerifyBookingResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final booking = data['booking'] as Map<String, dynamic>;
    final details = booking['paymentDetails'] as Map<String, dynamic>? ?? {};
    return VerifyBookingResponse(
      bookingId: booking['_id'] as String? ?? '',
      totalAmount: booking['totalAmount'] as num? ?? 0,
      serviceDate: booking['serviceDate'] as String? ?? '',
      status: booking['status'] as String? ?? '',
      paymentStatus: booking['paymentStatus'] as String? ?? '',
      paymentProvider: details['provider'] as String? ?? '',
      paymentIntentId: details['orderId'] as String? ?? '',
      transactionId: details['transactionId'] as String? ?? '',
    );
  }
}
