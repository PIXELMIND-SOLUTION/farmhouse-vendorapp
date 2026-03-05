// ─── Location Model ───────────────────────────────────────────────────────────

class LocationModel {
  final String type;
  final List<double> coordinates;

  LocationModel({
    required this.type,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'] ?? '',
      coordinates: List<double>.from(
        (json['coordinates'] as List).map((e) => (e as num).toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
}

// ─── Time Price Model ─────────────────────────────────────────────────────────

class TimePriceModel {
  final String id;
  final String label;
  final String timing;
  final double price;
  final List<String> inactiveDates;
  final bool isActive;

  TimePriceModel({
    required this.id,
    required this.label,
    required this.timing,
    required this.price,
    required this.inactiveDates,
    required this.isActive,
  });

  factory TimePriceModel.fromJson(Map<String, dynamic> json) {
    return TimePriceModel(
      id: json['_id'] ?? '',
      label: json['label'] ?? '',
      timing: json['timing'] ?? '',
      price: (json['price'] as num).toDouble(),
      inactiveDates: List<String>.from(json['inactiveDates'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'label': label,
        'timing': timing,
        'price': price,
        'inactiveDates': inactiveDates,
        'isActive': isActive,
      };
}

// ─── Booked Slot Model ────────────────────────────────────────────────────────

class BookedSlotModel {
  final String id;
  final String userId;
  final String bookingId;
  final DateTime checkIn;
  final DateTime checkOut;
  final DateTime date;
  final String label;
  final String timing;
  final DateTime bookedAt;

  BookedSlotModel({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.checkIn,
    required this.checkOut,
    required this.date,
    required this.label,
    required this.timing,
    required this.bookedAt,
  });

  factory BookedSlotModel.fromJson(Map<String, dynamic> json) {
    return BookedSlotModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      bookingId: json['bookingId'] ?? '',
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      date: DateTime.parse(json['date']),
      label: json['label'] ?? '',
      timing: json['timing'] ?? '',
      bookedAt: DateTime.parse(json['bookedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'bookingId': bookingId,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'date': date.toIso8601String(),
        'label': label,
        'timing': timing,
        'bookedAt': bookedAt.toIso8601String(),
      };
}

// ─── Farmhouse Model ──────────────────────────────────────────────────────────

class FarmhouseModel {
  final String id;
  final String name;
  final LocationModel location;
  final List<String> images;
  final String address;
  final String description;
  final List<String> amenities;
  final double price;
  final List<TimePriceModel> timePrices;
  final List<String> wishlist;
  final double rating;
  final bool active;
  final List<BookedSlotModel> bookedSlots;
  final List<dynamic> reviews;
  final List<String> inactiveDates;
  final DateTime createdAt;

  FarmhouseModel({
    required this.id,
    required this.name,
    required this.location,
    required this.images,
    required this.address,
    required this.description,
    required this.amenities,
    required this.price,
    required this.timePrices,
    required this.wishlist,
    required this.rating,
    required this.active,
    required this.bookedSlots,
    required this.reviews,
    required this.inactiveDates,
    required this.createdAt,
  });

  factory FarmhouseModel.fromJson(Map<String, dynamic> json) {
    return FarmhouseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      location: LocationModel.fromJson(json['location']),
      images: List<String>.from(json['images'] ?? []),
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      price: (json['price'] as num).toDouble(),
      timePrices: (json['timePrices'] as List?)
              ?.map((e) => TimePriceModel.fromJson(e))
              .toList() ??
          [],
      wishlist: List<String>.from(json['wishlist'] ?? []),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      active: json['active'] ?? true,
      bookedSlots: (json['bookedSlots'] as List?)
              ?.map((e) => BookedSlotModel.fromJson(e))
              .toList() ??
          [],
      reviews: json['reviews'] ?? [],
      inactiveDates: List<String>.from(json['inactiveDates'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'location': location.toJson(),
        'images': images,
        'address': address,
        'description': description,
        'amenities': amenities,
        'price': price,
        'timePrices': timePrices.map((e) => e.toJson()).toList(),
        'wishlist': wishlist,
        'rating': rating,
        'active': active,
        'bookedSlots': bookedSlots.map((e) => e.toJson()).toList(),
        'reviews': reviews,
        'inactiveDates': inactiveDates,
        'createdAt': createdAt.toIso8601String(),
      };
}

// ─── Vendor Model ─────────────────────────────────────────────────────────────

class VendorModel {
  final String id;
  final String name;
  final String farmhouseId;
  final DateTime createdAt;

  VendorModel({
    required this.id,
    required this.name,
    required this.farmhouseId,
    required this.createdAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      farmhouseId: json['farmhouseId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'farmhouseId': farmhouseId,
        'createdAt': createdAt.toIso8601String(),
      };
}

// ─── Login Response Model ─────────────────────────────────────────────────────

class VendorLoginResponse {
  final bool success;
  final String message;
  final VendorModel vendor;
  final FarmhouseModel farmhouse;

  VendorLoginResponse({
    required this.success,
    required this.message,
    required this.vendor,
    required this.farmhouse,
  });

  factory VendorLoginResponse.fromJson(Map<String, dynamic> json) {
    return VendorLoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      vendor: VendorModel.fromJson(json['vendor']),
      farmhouse: FarmhouseModel.fromJson(json['farmhouse']),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'vendor': vendor.toJson(),
        'farmhouse': farmhouse.toJson(),
      };
}

// ─── Login Request Model ──────────────────────────────────────────────────────

class VendorLoginRequest {
  final String name;
  final String password;

  VendorLoginRequest({
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
      };
}