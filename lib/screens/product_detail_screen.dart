import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_colors.dart';
import 'cart_checkout_screen.dart';

/// Product Detail & Customization Screen
/// Strictly matching Stitch screen:
/// projects/12118509048000968690/screens/e2e22a0d2c9c40aeb6398419235e0159
class ProductDetailScreen extends StatefulWidget {
  final MenuItem? item;

  const ProductDetailScreen({
    super.key,
    this.item,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  // Default values matching Stitch design
  String _selectedTemperature = 'Ice';
  String _selectedSize = 'Regular (12oz)';
  String _selectedBeans = 'Kangenan Blend';
  String _selectedMilk = 'Fresh Milk';
  String _selectedSugar = 'Normal';
  String _selectedIce = 'Normal Ice';

  final Set<String> _selectedToppings = {};
  int _quantity = 1;
  bool _isFavorite = false;

  final TextEditingController _notesController = TextEditingController();

  static const String _defaultImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCHsmiMu1mzQrmmaB2HI_uf56_7jnoGK88kmc08mQC06uPAm-5fnZPSQ4AwQZdufwMsikZ5dm0WCQxkMwlVLtZsvC1xcA_dtD7oStucuqNoAE4OVL9ziVMFQ-dSq8adexG8VCdopWCUXIrQejQvCOoGsfpYIdJ6l1khw-Uh-Gw-4pIuF9AwtOyVTEKd4khDkmGly3GejlQl7rEwnXU_8rajSapikNADldvHeR5wc5qHe_MvGrSRDDQAWA';

  static const String _storyBannerUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCZz6V-fuMA846DYQ0j6GLSmoOaWsGUEiBPClu8Wp20AqrsBv-51ICb0JOzXkZDznwywb2Mig2Ym7va3r_zMWTWuN9eE2iMbAVPfdn-9Sx4lqnPC8-qPfr4egSrIV6RxxLHuNtUNDYn2RdsqiUtEr4i9cRqG83hb4iiRKV65qXJYLOUGRsVJugxAA8RuNAlE97kEye1ACZnK0jtIqN7dIV6cph8MIvb42top6DsTVSwBGnyXIAn4VTm1Q';

  // Available Add-ons Prices
  final Map<String, int> _toppingPrices = {
    'Espresso Shot Kangenan': 6000,
    'Espresso Shot Juwara': 6000,
    'Oreo Crumble': 6000,
    'Whipped Cream Chocolate': 6000,
    'Vanilla Syrup': 6000,
    'Caramel Syrup': 6000,
  };

  int get _basePrice => widget.item?.price ?? 24000;

  int get _unitPrice {
    int total = _basePrice;
    if (_selectedSize == 'Large (16oz)') total += 4000;
    if (_selectedBeans == 'Juwara Beans') total += 3000;
    if (_selectedMilk == 'Oatside (Oatmilk)') total += 6000;

    for (final topping in _selectedToppings) {
      total += _toppingPrices[topping] ?? 0;
    }
    return total;
  }

  int get _totalPrice => _unitPrice * _quantity;

  String _formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onAddToCart() {
    final title = widget.item?.name ?? 'OG Aren Spesial Latte';
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity x $title berhasil ditambahkan ke keranjang!'),
        backgroundColor: AppColors.primaryContainer,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Keranjang',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CartCheckoutScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.item?.name ?? 'OG Aren Spesial Latte';
    final description = widget.item?.description ??
        'Perpaduan espresso, susu, sirup speculoos, gula aren asli Indonesia dan topping speculoos cookie crumble.';
    final imageUrl = widget.item?.imageUrl ?? _defaultImageUrl;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(),

            // Scrollable Customization Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Hero Image
                    _buildHeroImage(imageUrl),

                    // Product Title, Price & Description
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _formatCurrency(_basePrice),
                                style: const TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryContainer,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 13,
                              color: AppColors.secondary,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(color: AppColors.surfaceContainer, thickness: 1),

                    // Customization Sections
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // 1. Temperature (Suhu)
                          _buildSectionHeader('Suhu', isRequired: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Ice',
                                  subtitle: 'Dingin segar',
                                  icon: Icons.ac_unit_rounded,
                                  isSelected: _selectedTemperature == 'Ice',
                                  onTap: () => setState(() => _selectedTemperature = 'Ice'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Hot',
                                  subtitle: 'Hangat nikmat',
                                  icon: Icons.local_cafe_rounded,
                                  isSelected: _selectedTemperature == 'Hot',
                                  onTap: () => setState(() => _selectedTemperature = 'Hot'),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 2. Size (Ukuran Gelas)
                          _buildSectionHeader('Ukuran Gelas', isRequired: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Regular (12oz)',
                                  subtitle: 'Standar porsi',
                                  isSelected: _selectedSize == 'Regular (12oz)',
                                  onTap: () => setState(() => _selectedSize = 'Regular (12oz)'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Large (16oz)',
                                  subtitle: '+Rp4.000',
                                  isSelected: _selectedSize == 'Large (16oz)',
                                  onTap: () => setState(() => _selectedSize = 'Large (16oz)'),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 3. Beans (Pilihan Biji Kopi)
                          _buildSectionHeader('Pilihan Biji Kopi', isRequired: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Kangenan Blend',
                                  subtitle: 'Seimbang & Bold',
                                  isSelected: _selectedBeans == 'Kangenan Blend',
                                  onTap: () => setState(() => _selectedBeans = 'Kangenan Blend'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Juwara Beans',
                                  subtitle: '100% Arabica (+Rp3.000)',
                                  isSelected: _selectedBeans == 'Juwara Beans',
                                  onTap: () => setState(() => _selectedBeans = 'Juwara Beans'),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 4. Milk (Pilihan Susu)
                          _buildSectionHeader('Pilihan Susu', isRequired: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Fresh Milk',
                                  subtitle: 'Creamy & Gurih',
                                  isSelected: _selectedMilk == 'Fresh Milk',
                                  onTap: () => setState(() => _selectedMilk = 'Fresh Milk'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildOptionCard(
                                  title: 'Oatside (Oatmilk)',
                                  subtitle: '+Rp6.000',
                                  isSelected: _selectedMilk == 'Oatside (Oatmilk)',
                                  onTap: () => setState(() => _selectedMilk = 'Oatside (Oatmilk)'),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 5. Sugar Level (Level Manis)
                          _buildSectionHeader('Level Manis', isRequired: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildPillButton(
                                label: 'Normal',
                                sublabel: '100%',
                                isSelected: _selectedSugar == 'Normal',
                                onTap: () => setState(() => _selectedSugar = 'Normal'),
                              ),
                              const SizedBox(width: 8),
                              _buildPillButton(
                                label: 'Less Sugar',
                                sublabel: '50%',
                                isSelected: _selectedSugar == 'Less Sugar',
                                onTap: () => setState(() => _selectedSugar = 'Less Sugar'),
                              ),
                              const SizedBox(width: 8),
                              _buildPillButton(
                                label: 'No Sugar',
                                sublabel: '0%',
                                isSelected: _selectedSugar == 'No Sugar',
                                onTap: () => setState(() => _selectedSugar = 'No Sugar'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 6. Ice Level (Level Es)
                          _buildSectionHeader('Level Es', isRequired: true),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildPillButton(
                                label: 'Normal Ice',
                                sublabel: 'Paling Pas',
                                isSelected: _selectedIce == 'Normal Ice',
                                onTap: () => setState(() => _selectedIce = 'Normal Ice'),
                              ),
                              const SizedBox(width: 8),
                              _buildPillButton(
                                label: 'Less Ice',
                                sublabel: 'Lebih Pekat',
                                isSelected: _selectedIce == 'Less Ice',
                                onTap: () => setState(() => _selectedIce = 'Less Ice'),
                              ),
                              const SizedBox(width: 8),
                              _buildPillButton(
                                label: 'No Ice',
                                sublabel: 'Tanpa Es',
                                isSelected: _selectedIce == 'No Ice',
                                onTap: () => setState(() => _selectedIce = 'No Ice'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 7. Toppings & Syrups (Multiple Select)
                          _buildSectionHeader('Pilihan Topping & Sirup', isRequired: false),
                          const SizedBox(height: 10),
                          ..._buildToppingCheckboxes(),

                          const SizedBox(height: 24),

                          // 8. Order Notes (Catatan Tambahan)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Catatan Tambahan',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _notesController,
                                builder: (context, value, child) {
                                  return Text(
                                    '${value.text.length}/100',
                                    style: const TextStyle(
                                      fontFamily: _fontFamily,
                                      fontSize: 12,
                                      color: AppColors.secondary,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _notesController,
                              maxLength: 100,
                              maxLines: 3,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 13,
                                color: AppColors.onSurface,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Ga perlu paper bag, sedotan dipisah, dll.',
                                hintStyle: TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 13,
                                  color: AppColors.secondary,
                                ),
                                counterText: '',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // 9. Story Banner Section
                          const Text(
                            'Detail Cerita Produk',
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _storyBannerUrl,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 120,
                                color: AppColors.surfaceContainer,
                                child: const Center(
                                  child: Icon(Icons.coffee, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'The O.G Aren - Original Gula Aren Series',
                                  style: TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Menggunakan 100% gula aren organik murni dari perkebunan lokal di Jawa Barat, diproses tradisional untuk menjaga aroma karamel pekat dan sensasi gurih alami khas nusantara.',
                                  style: TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 12,
                                    color: AppColors.secondary,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 110), // Padding for sticky bottom bar
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 10. Sticky Bottom Dock (Quantity Stepper & Cart CTA)
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Quantity Stepper
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.remove_rounded,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() => _quantity++);
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Primary CTA Button
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+ Keranjang ${_formatCurrency(_totalPrice)}',
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.onSurface,
            ),
          ),
          const Text(
            'Detail Produk',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tautan produk disalin')),
                  );
                },
                icon: const Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: AppColors.secondary,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
                icon: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 20,
                  color: _isFavorite
                      ? AppColors.primaryContainer
                      : AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(String imageUrl) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 220,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: AppColors.surfaceContainer,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryContainer,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.surfaceContainer,
              child: const Icon(
                Icons.local_cafe_rounded,
                size: 64,
                color: AppColors.primaryContainer,
              ),
            ),
          ),
        ),
        // Gradient overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Best Seller Badge
        Positioned(
          left: 16,
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 14,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text(
                  'Best Seller',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required bool isRequired}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isRequired ? AppColors.primaryFixed : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            isRequired ? 'Wajib • 1' : 'Opsional',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isRequired ? const Color(0xFF410003) : AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryFixed.withValues(alpha: 0.3)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.borderInactive,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryFixed
                          : AppColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: isSelected
                          ? AppColors.primaryContainer
                          : AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryContainer
                            : AppColors.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryContainer
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : AppColors.borderInactive,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillButton({
    required String label,
    required String sublabel,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryFixed.withValues(alpha: 0.3)
                : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.borderInactive,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primaryContainer
                      : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 10,
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildToppingCheckboxes() {
    final toppings = [
      {'name': 'Espresso Shot Kangenan', 'price': '+Rp6.000', 'available': true},
      {'name': 'Espresso Shot Juwara', 'price': '+Rp6.000', 'available': true},
      {'name': 'Oreo Crumble', 'price': '+Rp6.000', 'available': true},
      {'name': 'Whipped Cream Chocolate', 'price': '+Rp6.000', 'available': true},
      {'name': 'Vanilla Syrup', 'price': '+Rp6.000', 'available': true},
      {'name': 'Caramel Syrup', 'price': '+Rp6.000', 'available': true},
      {'name': 'Golden Boba', 'price': '+Rp6.000', 'available': false},
      {'name': 'Grass Jelly', 'price': '+Rp6.000', 'available': false},
    ];

    return toppings.map((topping) {
      final name = topping['name'] as String;
      final price = topping['price'] as String;
      final available = topping['available'] as bool;
      final isSelected = _selectedToppings.contains(name);

      if (!available) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Habis',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                price,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.borderInactive,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontFamily: _fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                Checkbox(
                  value: isSelected,
                  activeColor: AppColors.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedToppings.add(name);
                      } else {
                        _selectedToppings.remove(name);
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}
