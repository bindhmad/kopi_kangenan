import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../data/menu_data.dart';
import '../theme/app_colors.dart';
import 'menu_screen.dart';
import 'order_status_screen.dart';

/// Data class representing an item inside the user's cart
class CartItem {
  final String id;
  final String name;
  final String category;
  final int unitPrice;
  int quantity;
  final String variantDetails;
  final String iceLevel;
  final String notes;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unitPrice,
    this.quantity = 1,
    required this.variantDetails,
    required this.iceLevel,
    this.notes = 'Sedotan dipisah',
    required this.imageUrl,
  });

  int get totalPrice => unitPrice * quantity;
}

/// Cart & Checkout Screen
/// Strictly matching Stitch screens:
/// - projects/12118509048000968690/screens/da9bee4c22f049b2b9888e740ffdee19 (Checkout)
/// - projects/12118509048000968690/screens/3df06904f0244a8193a159a19159efb7 (Konfirmasi Pesanan)
/// - projects/12118509048000968690/screens/f54282f4691f4a0abba09c61883d83e8 (Empty Cart)
class CartCheckoutScreen extends StatefulWidget {
  final List<CartItem>? initialItems;

  const CartCheckoutScreen({
    super.key,
    this.initialItems,
  });

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  // Order Type: 'Pickup' | 'Delivery'
  String _orderType = 'Pickup';

  // Checkboxes
  bool _redeemPoints = false;
  bool _ecoBagSelected = false;

  // Selected Payment Method
  String _selectedPaymentMethod = 'blu'; // 'blu', 'qris', 'gopay', 'ovo', 'shopeepay', 'dana', 'bca_va', 'cash'

  // Voucher state
  bool _voucherApplied = true;
  String _voucherCode = 'KANGENHEMAT';
  static const int _voucherDiscount = 1000;

  // Fixed Fees
  static const int _serviceFee = 1000;
  static const int _ecoBagPrice = 4000;
  static const int _pointsDiscount = 25; // 25 points = Rp25

  // Cart Items List
  late List<CartItem> _items;

  @override
  void initState() {
    super.initState();
    if (widget.initialItems != null) {
      _items = List.from(widget.initialItems!);
    } else {
      // Default items matching Stitch design
      _items = [
        CartItem(
          id: 'kangen-aren-latte',
          name: 'OG Aren Spesial Latte Ice',
          category: 'Coffee',
          unitPrice: 24000,
          quantity: 1,
          variantDetails: 'Regular · Kangenan Blend · Fresh Milk · Normal Sweet',
          iceLevel: 'Normal Ice',
          notes: 'Sedotan dipisah',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAQBAqnoX6IpSI5gqdbd7STUif0XCI2gguzDTZ_hpgKn6NnKNm-Tme2a-1H7FfWC84ESm1lUrxP3yNO5s4Hu7RDehRieMAoxeVjWZVD-3Nj4qjM_66UjQyaLSWzqcOljeEdaLF94uQXsa_F0ahZ_QohK3AB9CyBCqFSq2LU3Rsf95oE_bTMN6I8RJCSziw6G_SvB_k0ZYPzUlgIvNFewN2H5K8F6-YYVuzwSTdFaAnu1sFpaoOSir86Bw',
        ),
      ];
    }
  }

  int get _itemsSubtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  int get _totalItemsCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  int get _totalPayment {
    if (_items.isEmpty) return 0;
    int total = _itemsSubtotal;
    if (_ecoBagSelected) total += _ecoBagPrice;
    total += _serviceFee;
    if (_voucherApplied) total -= _voucherDiscount;
    if (_redeemPoints) total -= _pointsDiscount;
    return total < 0 ? 0 : total;
  }

  String _formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  void _increaseQuantity(int index) {
    setState(() {
      _items[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    });
  }

  void _addRecommendedItem(MenuItem menuItem) {
    setState(() {
      final existingIndex =
          _items.indexWhere((element) => element.id == menuItem.id);
      if (existingIndex >= 0) {
        _items[existingIndex].quantity++;
      } else {
        _items.add(
          CartItem(
            id: menuItem.id,
            name: menuItem.name,
            category: menuItem.category,
            unitPrice: menuItem.price,
            quantity: 1,
            variantDetails: 'Regular · Standar',
            iceLevel: 'Normal Ice',
            notes: 'Standar porsi',
            imageUrl: menuItem.imageUrl,
          ),
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menuItem.name} ditambahkan ke keranjang!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: _items.isEmpty ? _buildEmptyCartView() : _buildFilledCheckoutView(),
      bottomNavigationBar: _items.isEmpty ? null : _buildStickyBottomDock(),
    );
  }

  // ==========================================
  // TOP APP BAR
  // ==========================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.onSurface,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        _items.isEmpty ? 'Keranjang Belanja' : 'Checkout Pesanan',
        style: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // EMPTY CART VIEW
  // ==========================================
  Widget _buildEmptyCartView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      child: Column(
        children: [
          // Illustration & Microcopy
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                // Glowing Circle Illustration
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: AppColors.secondary,
                    ),
                    Positioned(
                      top: 4,
                      right: 8,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_cafe,
                          size: 16,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Keranjang kamu masih kosong',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Aroma biji kopi pilihan hari ini menunggu kamu. Yuk, pesan minuman favoritmu sekarang!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      color: AppColors.secondary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MenuScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mulai Pesan',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Atau coba menu terlaris kami',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 20),

          // Recommendations Grid (2 Columns)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.76,
            ),
            itemCount: 2,
            itemBuilder: (context, index) {
              final menuItem = index == 0
                  ? MenuData.coffeeItems.first
                  : MenuData.foodItems.first;
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.25,
                        child: Image.network(
                          menuItem.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: AppColors.surfaceContainer,
                            child: const Icon(Icons.coffee),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menuItem.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  menuItem.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 11,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  menuItem.formattedPrice,
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryContainer,
                                  ),
                                ),
                                SizedBox(
                                  height: 28,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _addRecommendedItem(menuItem),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryContainer,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      minimumSize: Size.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text(
                                      '+ Tambah',
                                      style: TextStyle(
                                        fontFamily: _fontFamily,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FILLED CHECKOUT VIEW
  // ==========================================
  Widget _buildFilledCheckoutView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Order Type Switcher (Pickup / Delivery / Dine-in)
          _buildOrderTypeSegment(),
          const SizedBox(height: 12),

          // 2. Info Outlet Card
          _buildOutletInfoCard(),
          const SizedBox(height: 16),

          // 3. Cart Items Header & List
          _buildItemsSection(),
          const SizedBox(height: 16),

          // 4. Kangenan Points Section
          _buildKangenanPointsSection(),
          const SizedBox(height: 16),

          // 5. Pembayaran Langsung (Payment Method Selector)
          _buildPaymentMethodsSection(),
          const SizedBox(height: 16),

          // 6. Kantung Belanja Ramah Lingkungan
          _buildEcoBagSection(),
          const SizedBox(height: 16),

          // 7. Pakai Kode Voucher & Beli Paket Banner
          _buildVoucherSection(),
          const SizedBox(height: 16),

          // 8. Ringkasan Pembayaran (Price Summary)
          _buildPriceSummarySection(),
          const SizedBox(height: 14),

          // 9. Info Card (Cashback terms)
          _buildInfoDisclaimerCard(),
        ],
      ),
    );
  }

  // ------------------------------------------
  // 1. Order Type Segment
  // ------------------------------------------
  Widget _buildOrderTypeSegment() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          // Pickup Option (Active by default)
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _orderType = 'Pickup'),
              child: Container(
                decoration: BoxDecoration(
                  color: _orderType == 'Pickup'
                      ? AppColors.surfaceContainerLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: _orderType == 'Pickup'
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 16,
                      color: _orderType == 'Pickup'
                          ? const Color(0xFF2E7D32)
                          : AppColors.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pickup',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: _orderType == 'Pickup'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _orderType == 'Pickup'
                            ? const Color(0xFF2E7D32)
                            : AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Dine-In (Disabled as in Stitch)
          Expanded(
            child: Opacity(
              opacity: 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Dine-In',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    'Tidak tersedia',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 8,
                      color: Color(0xFFBA1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Delivery Option
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _orderType = 'Delivery'),
              child: Container(
                decoration: BoxDecoration(
                  color: _orderType == 'Delivery'
                      ? AppColors.surfaceContainerLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: _orderType == 'Delivery'
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Delivery',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      fontWeight: _orderType == 'Delivery'
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: _orderType == 'Delivery'
                          ? AppColors.primaryContainer
                          : AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // 2. Info Outlet Card
  // ------------------------------------------
  Widget _buildOutletInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 18,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Outlet Kopi Kangenan',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Diponegoro Surabaya',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Jl. Diponegoro No.129A, RT.011/RW.02, Kec. Wonokromo, Surabaya',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilihan outlet dibuka')),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Ubah',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 18,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Opsi Pickup',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 11,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        _orderType == 'Pickup'
                            ? 'Pickup di Counter'
                            : 'Diantar ke Alamat',
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Siap 15 Menit',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // 3. Cart Items List & Header
  // ------------------------------------------
  Widget _buildItemsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 18,
                  color: AppColors.primaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  'Pesanan ($_totalItemsCount item)',
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 14,
                      color: AppColors.primaryContainer,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Tambah Menu',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // List of Cart Item Cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cartItem = _items[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cartItem.imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 56,
                            height: 56,
                            color: AppColors.surfaceContainer,
                            child: const Icon(Icons.coffee, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cartItem.quantity}x ${cartItem.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cartItem.variantDetails,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 11,
                                color: AppColors.secondary,
                              ),
                            ),
                            Text(
                              cartItem.iceLevel,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 11,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatCurrency(cartItem.totalPrice),
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 16),

                  // Bottom Item Row (Notes & Stepper)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.edit_note_rounded,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Catatan: ${cartItem.notes}',
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),

                      // Stepper (- qty +)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => _decreaseQuantity(index),
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  size: 14,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${cartItem.quantity}',
                                style: const TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _increaseQuantity(index),
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ------------------------------------------
  // 4. Kangenan Points Section
  // ------------------------------------------
  Widget _buildKangenanPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kangenan Points',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _redeemPoints,
                          activeColor: AppColors.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _redeemPoints = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Redeem 25 pts',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '-Rp25',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 32, top: 4),
                child: Text(
                  '1 Kangenan Point = 1 Rupiah',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // 5. Pembayaran Langsung (Horizontal Cards & Modal)
  // ------------------------------------------
  Widget _buildPaymentMethodsSection() {
    final paymentOptions = [
      {
        'id': 'blu',
        'title': 'blu by BCA',
        'badge': 'Cashback 40%*',
        'color': const Color(0xFF003B73),
        'textColor': const Color(0xFF70D6FF),
        'iconText': 'blu',
      },
      {
        'id': 'qris',
        'title': 'QRIS',
        'badge': 'Simpan & bayar',
        'color': const Color(0xFFF0F0F0),
        'textColor': AppColors.primaryContainer,
        'iconText': 'QRIS',
      },
      {
        'id': 'gopay',
        'title': 'GoPay',
        'badge': 'Hubungkan',
        'color': const Color(0xFF00AED6),
        'textColor': Colors.white,
        'icon': Icons.account_balance_wallet,
      },
      {
        'id': 'ovo',
        'title': 'OVO',
        'badge': 'Points 20%',
        'color': const Color(0xFF4C3494),
        'textColor': Colors.white,
        'iconText': 'OVO',
      },
      {
        'id': 'shopeepay',
        'title': 'ShopeePay',
        'badge': 'Koin 30%',
        'color': const Color(0xFFEE4D2D),
        'textColor': Colors.white,
        'icon': Icons.local_mall_rounded,
      },
      {
        'id': 'bca_va',
        'title': 'BCA Virtual Account',
        'badge': 'Otomatis',
        'color': const Color(0xFF005BAC),
        'textColor': Colors.white,
        'icon': Icons.account_balance_rounded,
      },
      {
        'id': 'cash',
        'title': 'Tunai di Kasir',
        'badge': 'Bayar saat ambil',
        'color': const Color(0xFF2E7D32),
        'textColor': Colors.white,
        'icon': Icons.payments_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pembayaran Langsung',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            InkWell(
              onTap: () => _showAllPaymentMethodsModal(),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text(
          'blu by BCA Digital - Cashback 40% max. 25RB*',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 11,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal scrolling payment method cards
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: paymentOptions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final option = paymentOptions[index];
              final isSelected = _selectedPaymentMethod == option['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = option['id'] as String;
                  });
                },
                child: Container(
                  width: 124,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryContainer
                          : AppColors.borderInactive.withValues(alpha: 0.6),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Brand Icon/Badge
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: option['color'] as Color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: option['icon'] != null
                                  ? Icon(
                                      option['icon'] as IconData,
                                      size: 18,
                                      color: option['textColor'] as Color,
                                    )
                                  : Text(
                                      option['iconText'] as String,
                                      style: TextStyle(
                                        fontFamily: _fontFamily,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: option['textColor'] as Color,
                                      ),
                                    ),
                            ),
                          ),

                          // Text Label & Subtitle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['title'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                option['badge'] as String,
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primaryContainer
                                      : AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Checkmark on Top Right
                      if (isSelected)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // 6. Kantung Belanja Ramah Lingkungan
  // ------------------------------------------
  Widget _buildEcoBagSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _ecoBagSelected,
                  activeColor: AppColors.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _ecoBagSelected = val ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Kantung Belanja Ramah Lingkungan',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const Text(
            'Rp4.000',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 12,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // 7. Voucher & Subscription Upsell Section
  // ------------------------------------------
  Widget _buildVoucherSection() {
    return Column(
      children: [
        // Promo Voucher Banner (Clickable)
        GestureDetector(
          onTap: () => _showVoucherModal(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), // Soft Amber
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFECB3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.confirmation_number_rounded,
                        size: 18,
                        color: Color(0xFFE65100),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _voucherApplied
                              ? 'Kode Voucher: $_voucherCode'
                              : 'Pakai Kode Voucher',
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                        Text(
                          _voucherApplied
                              ? 'Hemat Rp1.000 berhasil digunakan'
                              : 'Hemat s.d. Rp10.000 dengan promo kopi',
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 11,
                            color: Color(0xFF795548),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF795548),
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Voucher Pack Upsell Card ("Beli Paket Voucher, Langsung Hemat")
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFF8E1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFECB3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Langganan Voucher Rp24.000',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '66x',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                '1x Voucher Gratis 1 Minuman, 1x Voucher B1G1...',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 11,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Rp680.000',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Save 96%',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Rp24.000',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Paket Voucher ditambahkan'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Beli Paket',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // 8. Ringkasan Pembayaran (Price Breakdown)
  // ------------------------------------------
  Widget _buildPriceSummarySection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 10),

          // Subtotal
          _buildSummaryRow('Subtotal Produk', _formatCurrency(_itemsSubtotal)),

          // Kantung Belanja jika aktif
          if (_ecoBagSelected) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'Kantung Belanja Ramah Lingkungan',
              _formatCurrency(_ecoBagPrice),
            ),
          ],

          // Biaya Layanan
          const SizedBox(height: 6),
          _buildSummaryRow('Biaya Layanan', _formatCurrency(_serviceFee)),

          // Diskon Promo Voucher
          if (_voucherApplied) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'Diskon Promo Voucher',
              '-${_formatCurrency(_voucherDiscount)}',
              valueColor: const Color(0xFF2E7D32),
            ),
          ],

          // Kangenan Points jika di-redeem
          if (_redeemPoints) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'Kangenan Points',
              '-${_formatCurrency(_pointsDiscount)}',
              valueColor: const Color(0xFF2E7D32),
            ),
          ],

          const Divider(height: 18),

          // Total Belanja
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                _formatCurrency(_totalPayment),
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            color: AppColors.secondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // 9. Info Disclaimer Card
  // ------------------------------------------
  Widget _buildInfoDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.secondary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Loyalty Cashback tidak berlaku dengan penggunaan Kangenan Point / promo lainnya.',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 11,
                color: AppColors.secondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 10. STICKY BOTTOM DOCK
  // ==========================================
  Widget _buildStickyBottomDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
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
            // Jadwalkan Button
            OutlinedButton(
              onPressed: () => _showScheduleModal(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryContainer,
                side: const BorderSide(color: AppColors.primaryFixed),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(0, 44),
              ),
              child: const Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Jadwal',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Confirm Order Primary Button
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => _confirmOrder(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Konfirmasi Pesanan',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '· ${_formatCurrency(_totalPayment)}',
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
    );
  }

  // ==========================================
  // MODALS & ACTIONS
  // ==========================================

  // Schedule Modal
  void _showScheduleModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jadwalkan Waktu Ambil',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.bolt_rounded, color: Color(0xFF2E7D32)),
                title: const Text('Sekarang (Siap 15 Menit)'),
                subtitle: const Text('Pesanan langsung diproses barista'),
                trailing: const Icon(Icons.check_circle, color: AppColors.primaryContainer),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.alarm_rounded, color: AppColors.secondary),
                title: const Text('30 Menit Lagi'),
                subtitle: const Text('Ambil pada jam sibuk tanpa antri'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today_rounded, color: AppColors.secondary),
                title: const Text('Pilih Jam Tertentu'),
                subtitle: const Text('Sesuaikan dengan jadwal kedatanganmu'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Voucher Input Modal
  void _showVoucherModal() {
    final controller = TextEditingController(text: _voucherCode);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan Kode Voucher',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Contoh: KANGENHEMAT',
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _voucherCode = controller.text.trim();
                      _voucherApplied = _voucherCode.isNotEmpty;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Voucher $_voucherCode berhasil dipasang!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Terapkan Voucher'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // All Payment Methods Bottom Sheet
  void _showAllPaymentMethodsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Instant Debit & E-Wallet',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                _buildPaymentTile('blu', 'blu by BCA Digital', 'Cashback 40%'),
                _buildPaymentTile('qris', 'QRIS (Gopay/OVO/Dana/BCA/dll)', 'Instan bayar'),
                _buildPaymentTile('gopay', 'GoPay', 'Saldo & PayLater'),
                _buildPaymentTile('ovo', 'OVO', 'Cashback 20%'),
                _buildPaymentTile('shopeepay', 'ShopeePay', 'Koin Shopee'),
                const Divider(height: 20),
                const Text(
                  'Virtual Account & Tunai',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                _buildPaymentTile('bca_va', 'BCA Virtual Account', 'Verifikasi otomatis'),
                _buildPaymentTile('cash', 'Tunai / Kasir', 'Bayar langsung di kasir'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentTile(String id, String title, String subtitle) {
    final isSelected = _selectedPaymentMethod == id;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.payment,
          size: 16,
          color: isSelected ? Colors.white : AppColors.secondary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primaryContainer : AppColors.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 11,
          color: AppColors.secondary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primaryContainer)
          : null,
      onTap: () {
        setState(() => _selectedPaymentMethod = id);
        Navigator.of(context).pop();
      },
    );
  }

  // Confirm Order Action & Success Dialog
  void _confirmOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 44,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pesanan Diterima!',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Barista Kopi Kangenan sedang menyiapkan minumanmu dengan sepenuh hati.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Nomor Pesanan:', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                          Text('#KGN-88291', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Pembayaran:', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                          Text(
                            _formatCurrency(_totalPayment),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Estimasi Pengambilan:', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
                          Text('15 Menit di Counter', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const OrderStatusScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Lacak Status Pesanan', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to Home / Previous
                    },
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
