import 'package:squadonsite/core/pagination/pagination_info.dart';

class BookingHistoryResponse {
  final bool success;
  final List<BookingHistoryItem> bookings;
  final bool hasMore;

  const BookingHistoryResponse({
    required this.success,
    required this.bookings,
    this.hasMore = false,
  });

  factory BookingHistoryResponse.fromJson(
    Map<String, dynamic> json, {
    int page = 1,
    int limit = 10,
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawBookings = data['bookings'] as List<dynamic>? ?? [];
    final bookings = rawBookings
        .whereType<Map<String, dynamic>>()
        .map(BookingHistoryItem.fromJson)
        .toList();
    return BookingHistoryResponse(
      success: json['success'] == true,
      bookings: bookings,
      hasMore: PaginationInfo.fromResponse(
        response: json,
        data: data,
        page: page,
        limit: limit,
        itemCount: bookings.length,
      ).hasMore,
    );
  }
}

// JSON keys _id and __v are exposed as id (or mongoId) and version.
// Empty variant/add-on arrays retain their JSON values until their schema is known.

class BookingHistoryItem {
  final BookingAddress address;
  final BookingPayment paymentDetails;
  final BookingTechnician assignedTechnician;
  final String id;
  final String user;
  final List<BookingService> services;
  final num totalAmount;
  final String phone;
  final DateTime? serviceDate;
  final String status;
  final String paymentStatus;
  final String specialInstructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num version;
  final BookingReview? technicianReview;

  const BookingHistoryItem({
    required this.address,
    required this.paymentDetails,
    required this.assignedTechnician,
    required this.id,
    required this.user,
    required this.services,
    required this.totalAmount,
    required this.phone,
    required this.serviceDate,
    required this.status,
    required this.paymentStatus,
    required this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.technicianReview,
  });

  factory BookingHistoryItem.fromJson(Map<String, dynamic> json) =>
      BookingHistoryItem(
        address: BookingAddress.fromJson(_map(json['address'])),
        paymentDetails: BookingPayment.fromJson(_map(json['paymentDetails'])),
        assignedTechnician: BookingTechnician.fromJson(
          _map(json['assignedTechnician']),
        ),
        id: _string(json['_id']),
        user: _string(json['user']),
        services: _list(
          json['services'],
        ).map((value) => BookingService.fromJson(_map(value))).toList(),
        totalAmount: _number(json['totalAmount']),
        phone: _string(json['phone']),
        serviceDate: _date(json['serviceDate']),
        status: _string(json['status']),
        paymentStatus: _string(json['paymentStatus']),
        specialInstructions: _string(json['specialInstructions']),
        createdAt: _date(json['createdAt']),
        updatedAt: _date(json['updatedAt']),
        version: _number(json['__v']),
        technicianReview: json['technicianReview'] is Map<String, dynamic>
            ? BookingReview.fromJson(
                json['technicianReview'] as Map<String, dynamic>,
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
    'address': address.toJson(),
    'paymentDetails': paymentDetails.toJson(),
    'assignedTechnician': assignedTechnician.toJson(),
    '_id': id,
    'user': user,
    'services': services.map((value) => value.toJson()).toList(),
    'totalAmount': totalAmount,
    'phone': phone,
    'serviceDate': serviceDate?.toIso8601String(),
    'status': status,
    'paymentStatus': paymentStatus,
    'specialInstructions': specialInstructions,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': version,
    if (technicianReview != null)
      'technicianReview': technicianReview!.toJson(),
  };
}

class BookingReview {
  final int rating;
  final String review;

  const BookingReview({required this.rating, required this.review});

  factory BookingReview.fromJson(Map<String, dynamic> json) => BookingReview(
    rating: _number(json['rating']).toInt(),
    review: _string(json['review']),
  );

  Map<String, dynamic> toJson() => {'rating': rating, 'review': review};
}

class BookingService {
  final BookingServiceDetails service;
  final num quantity;
  final String? variantId;
  final String variantName;
  final List<dynamic> selectedAddons;
  final num price;
  final String id;
  final BookingReview? existingReview;

  const BookingService({
    required this.service,
    required this.quantity,
    required this.variantId,
    required this.variantName,
    required this.selectedAddons,
    required this.price,
    required this.id,
    this.existingReview,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) => BookingService(
    service: BookingServiceDetails.fromJson(_map(json['service'])),
    quantity: _number(json['quantity']),
    variantId: json['variantId'] as String?,
    variantName: _string(json['variantName']),
    selectedAddons: _list(json['selectedAddons']),
    price: _number(json['price']),
    id: _string(json['_id']),
    existingReview: json['existingReview'] is Map<String, dynamic>
        ? BookingReview.fromJson(json['existingReview'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'service': service.toJson(),
    'quantity': quantity,
    'variantId': variantId,
    'variantName': variantName,
    'selectedAddons': selectedAddons,
    'price': price,
    '_id': id,
    if (existingReview != null) 'existingReview': existingReview!.toJson(),
  };
}

class BookingServiceDetails {
  final String mongoId;
  final String name;
  final List<String> shortDescription;
  final String longDescription;
  final String category;
  final String subcategory;
  final String serviceType;
  final String status;
  final bool isFeatured;
  final num serviceDuration;
  final bool hasVariants;
  final num actualPrice;
  final num discountPercentage;
  final num offerPrice;
  final List<dynamic> variants;
  final List<BookingAddon> addons;
  final List<BookingIncludedItem> includedItems;
  final List<BookingExcludedItem> excludedItems;
  final List<BookingFaq> faqs;
  final String featuredImage;
  final List<BookingGalleryItem> gallery;
  final List<BookingRequirement> requirements;
  final List<BookingTool> tools;
  final List<BookingProcessStep> processSteps;
  final bool isActive;
  final num ratingsAverage;
  final num ratingsQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num version;
  final num price;
  final num duration;
  final String description;
  final String id;
  final BookingReview? existingReview;

  const BookingServiceDetails({
    required this.mongoId,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.category,
    required this.subcategory,
    required this.serviceType,
    required this.status,
    required this.isFeatured,
    required this.serviceDuration,
    required this.hasVariants,
    required this.actualPrice,
    required this.discountPercentage,
    required this.offerPrice,
    required this.variants,
    required this.addons,
    required this.includedItems,
    required this.excludedItems,
    required this.faqs,
    required this.featuredImage,
    required this.gallery,
    required this.requirements,
    required this.tools,
    required this.processSteps,
    required this.isActive,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.price,
    required this.duration,
    required this.description,
    required this.id,
    this.existingReview,
  });

  factory BookingServiceDetails.fromJson(Map<String, dynamic> json) =>
      BookingServiceDetails(
        mongoId: _string(json['_id']),
        name: _string(json['name']),
        shortDescription: _list(json['shortDescription']).map(_string).toList(),
        longDescription: _string(json['longDescription']),
        category: _string(json['category']),
        subcategory: _string(json['subcategory']),
        serviceType: _string(json['serviceType']),
        status: _string(json['status']),
        isFeatured: json['isFeatured'] == true,
        serviceDuration: _number(json['serviceDuration']),
        hasVariants: json['hasVariants'] == true,
        actualPrice: _number(json['actualPrice']),
        discountPercentage: _number(json['discountPercentage']),
        offerPrice: _number(json['offerPrice']),
        variants: _list(json['variants']),
        addons: _list(
          json['addons'],
        ).map((value) => BookingAddon.fromJson(_map(value))).toList(),
        includedItems: _list(
          json['includedItems'],
        ).map((value) => BookingIncludedItem.fromJson(_map(value))).toList(),
        excludedItems: _list(
          json['excludedItems'],
        ).map((value) => BookingExcludedItem.fromJson(_map(value))).toList(),
        faqs: _list(
          json['faqs'],
        ).map((value) => BookingFaq.fromJson(_map(value))).toList(),
        featuredImage: _string(json['featuredImage']),
        gallery: _list(
          json['gallery'],
        ).map((value) => BookingGalleryItem.fromJson(_map(value))).toList(),
        requirements: _list(
          json['requirements'],
        ).map((value) => BookingRequirement.fromJson(_map(value))).toList(),
        tools: _list(
          json['tools'],
        ).map((value) => BookingTool.fromJson(_map(value))).toList(),
        processSteps: _list(
          json['processSteps'],
        ).map((value) => BookingProcessStep.fromJson(_map(value))).toList(),
        isActive: json['isActive'] == true,
        ratingsAverage: _number(json['ratingsAverage']),
        ratingsQuantity: _number(json['ratingsQuantity']),
        createdAt: _date(json['createdAt']),
        updatedAt: _date(json['updatedAt']),
        version: _number(json['__v']),
        price: _number(json['price']),
        duration: _number(json['duration']),
        description: _string(json['description']),
        id: _string(json['id']),
        existingReview: json['existingReview'] is Map<String, dynamic>
            ? BookingReview.fromJson(
                json['existingReview'] as Map<String, dynamic>,
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
    '_id': mongoId,
    'name': name,
    'shortDescription': shortDescription,
    'longDescription': longDescription,
    'category': category,
    'subcategory': subcategory,
    'serviceType': serviceType,
    'status': status,
    'isFeatured': isFeatured,
    'serviceDuration': serviceDuration,
    'hasVariants': hasVariants,
    'actualPrice': actualPrice,
    'discountPercentage': discountPercentage,
    'offerPrice': offerPrice,
    'variants': variants,
    'addons': addons.map((value) => value.toJson()).toList(),
    'includedItems': includedItems.map((value) => value.toJson()).toList(),
    'excludedItems': excludedItems.map((value) => value.toJson()).toList(),
    'faqs': faqs.map((value) => value.toJson()).toList(),
    'featuredImage': featuredImage,
    'gallery': gallery.map((value) => value.toJson()).toList(),
    'requirements': requirements.map((value) => value.toJson()).toList(),
    'tools': tools.map((value) => value.toJson()).toList(),
    'processSteps': processSteps.map((value) => value.toJson()).toList(),
    'isActive': isActive,
    'ratingsAverage': ratingsAverage,
    'ratingsQuantity': ratingsQuantity,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': version,
    'price': price,
    'duration': duration,
    'description': description,
    'id': id,
    if (existingReview != null) 'existingReview': existingReview!.toJson(),
  };
}

class BookingProcessStep {
  final num stepNumber;
  final String title;
  final String description;
  final String image;
  final String id;

  const BookingProcessStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.image,
    required this.id,
  });

  factory BookingProcessStep.fromJson(Map<String, dynamic> json) =>
      BookingProcessStep(
        stepNumber: _number(json['stepNumber']),
        title: _string(json['title']),
        description: _string(json['description']),
        image: _string(json['image']),
        id: _string(json['_id']),
      );

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'title': title,
    'description': description,
    'image': image,
    '_id': id,
  };
}

class BookingTool {
  final String name;
  final String image;
  final String description;
  final String id;

  const BookingTool({
    required this.name,
    required this.image,
    required this.description,
    required this.id,
  });

  factory BookingTool.fromJson(Map<String, dynamic> json) => BookingTool(
    name: _string(json['name']),
    image: _string(json['image']),
    description: _string(json['description']),
    id: _string(json['_id']),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'description': description,
    '_id': id,
  };
}

class BookingRequirement {
  final String title;
  final String image;
  final String mongoId;
  final String id;

  const BookingRequirement({
    required this.title,
    required this.image,
    required this.mongoId,
    required this.id,
  });

  factory BookingRequirement.fromJson(Map<String, dynamic> json) =>
      BookingRequirement(
        title: _string(json['title']),
        image: _string(json['image']),
        mongoId: _string(json['_id']),
        id: _string(json['id']),
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'image': image,
    '_id': mongoId,
    'id': id,
  };
}

class BookingGalleryItem {
  final String type;
  final String url;
  final num order;
  final String id;

  const BookingGalleryItem({
    required this.type,
    required this.url,
    required this.order,
    required this.id,
  });

  factory BookingGalleryItem.fromJson(Map<String, dynamic> json) =>
      BookingGalleryItem(
        type: _string(json['type']),
        url: _string(json['url']),
        order: _number(json['order']),
        id: _string(json['_id']),
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'url': url,
    'order': order,
    '_id': id,
  };
}

class BookingFaq {
  final String question;
  final String answer;
  final num order;
  final String id;

  const BookingFaq({
    required this.question,
    required this.answer,
    required this.order,
    required this.id,
  });

  factory BookingFaq.fromJson(Map<String, dynamic> json) => BookingFaq(
    question: _string(json['question']),
    answer: _string(json['answer']),
    order: _number(json['order']),
    id: _string(json['_id']),
  );

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'order': order,
    '_id': id,
  };
}

class BookingExcludedItem {
  final String title;
  final String icon;
  final String id;

  const BookingExcludedItem({
    required this.title,
    required this.icon,
    required this.id,
  });

  factory BookingExcludedItem.fromJson(Map<String, dynamic> json) =>
      BookingExcludedItem(
        title: _string(json['title']),
        icon: _string(json['icon']),
        id: _string(json['_id']),
      );

  Map<String, dynamic> toJson() => {'title': title, 'icon': icon, '_id': id};
}

class BookingIncludedItem {
  final String title;
  final String icon;
  final String id;

  const BookingIncludedItem({
    required this.title,
    required this.icon,
    required this.id,
  });

  factory BookingIncludedItem.fromJson(Map<String, dynamic> json) =>
      BookingIncludedItem(
        title: _string(json['title']),
        icon: _string(json['icon']),
        id: _string(json['_id']),
      );

  Map<String, dynamic> toJson() => {'title': title, 'icon': icon, '_id': id};
}

class BookingAddon {
  final String name;
  final String description;
  final num price;
  final String image;
  final bool isActive;
  final String id;

  const BookingAddon({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isActive,
    required this.id,
  });

  factory BookingAddon.fromJson(Map<String, dynamic> json) => BookingAddon(
    name: _string(json['name']),
    description: _string(json['description']),
    price: _number(json['price']),
    image: _string(json['image']),
    isActive: json['isActive'] == true,
    id: _string(json['_id']),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'image': image,
    'isActive': isActive,
    '_id': id,
  };
}

class BookingTechnician {
  final String name;
  final String phone;

  const BookingTechnician({required this.name, required this.phone});

  factory BookingTechnician.fromJson(Map<String, dynamic> json) =>
      BookingTechnician(
        name: _string(json['name']),
        phone: _string(json['phone']),
      );

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone};
}

class BookingPayment {
  final String provider;
  final String orderId;
  final String paymentId;
  final String transactionId;

  const BookingPayment({
    required this.provider,
    required this.orderId,
    required this.paymentId,
    required this.transactionId,
  });

  factory BookingPayment.fromJson(Map<String, dynamic> json) => BookingPayment(
    provider: _string(json['provider']),
    orderId: _string(json['orderId']),
    paymentId: _string(json['paymentId']),
    transactionId: _string(json['transactionId']),
  );

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'orderId': orderId,
    'paymentId': paymentId,
    'transactionId': transactionId,
  };
}

class BookingAddress {
  final BookingCoordinates coordinates;
  final String label;
  final String name;
  final String addressLine;
  final String city;
  final String state;
  final String zipcode;

  const BookingAddress({
    required this.coordinates,
    required this.label,
    required this.name,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.zipcode,
  });

  factory BookingAddress.fromJson(Map<String, dynamic> json) => BookingAddress(
    coordinates: BookingCoordinates.fromJson(_map(json['coordinates'])),
    label: _string(json['label']),
    name: _string(json['name']),
    addressLine: _string(json['addressLine']),
    city: _string(json['city']),
    state: _string(json['state']),
    zipcode: _string(json['zipcode']),
  );

  Map<String, dynamic> toJson() => {
    'coordinates': coordinates.toJson(),
    'label': label,
    'name': name,
    'addressLine': addressLine,
    'city': city,
    'state': state,
    'zipcode': zipcode,
  };
}

class BookingCoordinates {
  final double? lat;
  final double? lng;

  const BookingCoordinates({required this.lat, required this.lng});

  factory BookingCoordinates.fromJson(Map<String, dynamic> json) =>
      BookingCoordinates(
        lat: json['lat'] == null ? null : _number(json['lat']).toDouble(),
        lng: json['lng'] == null ? null : _number(json['lng']).toDouble(),
      );

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};
List<dynamic> _list(dynamic value) => value is List ? value : <dynamic>[];
String _string(dynamic value) => value is String ? value : '';
num _number(dynamic value) =>
    value is num ? value : num.tryParse('$value') ?? 0;
DateTime? _date(dynamic value) => DateTime.tryParse(value?.toString() ?? '');
