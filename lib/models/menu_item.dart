class MenuItem {
  final String id;
  final String name;
  final String category; // 'coffee', 'food', 'promo', 'toast'
  final int price;
  final int? originalPrice;
  final String? badge;
  final String description;
  final String imageUrl;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    this.badge,
    required this.description,
    required this.imageUrl,
  });

  String get formattedPrice => 'Rp${price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

  String? get formattedOriginalPrice => originalPrice != null
      ? 'Rp${originalPrice.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}'
      : null;
}
