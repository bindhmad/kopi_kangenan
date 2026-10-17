class OutletModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String distance;
  final double distanceKm;
  final String openTime;
  final String closeTime;
  final bool isOpen;
  final double rating;
  final int reviewCount;
  final String phone;
  final String imageUrl;
  final bool supportsPickup;
  final bool supportsDelivery;
  final bool supportsDineIn;
  final List<String> facilities;
  final double latitude;
  final double longitude;

  const OutletModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.distance,
    required this.distanceKm,
    required this.openTime,
    required this.closeTime,
    this.isOpen = true,
    required this.rating,
    required this.reviewCount,
    required this.phone,
    required this.imageUrl,
    this.supportsPickup = true,
    this.supportsDelivery = true,
    this.supportsDineIn = true,
    required this.facilities,
    required this.latitude,
    required this.longitude,
  });

  String get operationalHoursText => '$openTime - $closeTime';
}
