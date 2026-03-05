import 'dart:convert';

class FarmhouseModel {
  final bool success;
  final Farmhouse farmhouse;

  FarmhouseModel({required this.success, required this.farmhouse});

  factory FarmhouseModel.fromJson(Map<String, dynamic> json) => FarmhouseModel(
        success: json['success'] ?? false,
        farmhouse: Farmhouse.fromJson(json['farmhouse']),
      );
}

class Farmhouse {
  final Location location;
  final String id;
  final String name;
  final List<String> images;
  final String address;
  final String description;
  final List<String> amenities;
  final double price;
  final List<TimePrice> timePrices;
  final List<dynamic> wishlist;
  final double rating;
  final bool active;
  final List<BookedSlot> bookedSlots;
  final List<dynamic> reviews;
  final List<dynamic> inactiveDates;
  final DateTime createdAt;
  final VendorCredentials vendorCredentials;

  Farmhouse({
    required this.location,
    required this.id,
    required this.name,
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
    required this.vendorCredentials,
  });

  factory Farmhouse.fromJson(Map<String, dynamic> json) => Farmhouse(
        location: Location.fromJson(json['location']),
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        images: List<String>.from(json['images'] ?? []),
        address: json['address'] ?? '',
        description: json['description'] ?? '',
        amenities: List<String>.from(json['amenities'] ?? []),
        price: (json['price'] ?? 0).toDouble(),
        timePrices: (json['timePrices'] as List<dynamic>? ?? [])
            .map((e) => TimePrice.fromJson(e))
            .toList(),
        wishlist: json['wishlist'] ?? [],
        rating: (json['rating'] ?? 0).toDouble(),
        active: json['active'] ?? false,
        bookedSlots: (json['bookedSlots'] as List<dynamic>? ?? [])
            .map((e) => BookedSlot.fromJson(e))
            .toList(),
        reviews: json['reviews'] ?? [],
        inactiveDates: json['inactiveDates'] ?? [],
        createdAt: DateTime.parse(json['createdAt']),
        vendorCredentials: VendorCredentials.fromJson(json['vendorCredentials']),
      );
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json['type'] ?? '',
        coordinates: List<double>.from(
            (json['coordinates'] as List).map((e) => (e as num).toDouble())),
      );
}

class TimePrice {
  final String id;
  final String label;
  final String timing;
  final double price;
  final List<dynamic> inactiveDates;
  final bool isActive;

  TimePrice({
    required this.id,
    required this.label,
    required this.timing,
    required this.price,
    required this.inactiveDates,
    required this.isActive,
  });

  factory TimePrice.fromJson(Map<String, dynamic> json) => TimePrice(
        id: json['_id'] ?? '',
        label: json['label'] ?? '',
        timing: json['timing'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        inactiveDates: json['inactiveDates'] ?? [],
        isActive: json['isActive'] ?? false,
      );
}

class BookedSlot {
  final String id;
  final String userId;
  final String bookingId;
  final DateTime checkIn;
  final DateTime checkOut;
  final DateTime date;
  final String label;
  final String timing;
  final DateTime bookedAt;

  BookedSlot({
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

  factory BookedSlot.fromJson(Map<String, dynamic> json) => BookedSlot(
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

class VendorCredentials {
  final String name;
  final String password;
  final String vendorId;
  final DateTime createdAt;

  VendorCredentials({
    required this.name,
    required this.password,
    required this.vendorId,
    required this.createdAt,
  });

  factory VendorCredentials.fromJson(Map<String, dynamic> json) =>
      VendorCredentials(
        name: json['name'] ?? '',
        password: json['password'] ?? '',
        vendorId: json['vendorId'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
      );
}