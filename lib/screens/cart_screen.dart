import 'package:flutter/material.dart';
import '../data/outlet_data.dart';
import '../models/outlet_model.dart';
import '../theme/app_colors.dart';
import 'cart_checkout_screen.dart';
import 'menu_screen.dart';
import 'outlet_list_screen.dart';

/// Standalone Cart Item Model for Cart Screen
class CartProductItem {
  final String id;
  final String name;
  final String category;
  final int unitPrice;
  int quantity;
  final String variantDetails;
  final String iceLevel;
  String notes;
  final String imageUrl;

  CartProductItem({
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

  String get formattedUnitPrice => 'Rp${unitPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';

  String get formattedTotalPrice => 'Rp${totalPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
}

/// Keranjang Belanja Screen (Cart Screen)
/// Provides item list management, modifier view, promo vouchers, outlet selection,
/// and smooth transition to final checkout.
class CartScreen extends StatefulWidget {
  final List<CartProductItem>? initialItems;
  final OutletModel? selectedOutlet;

  const CartScreen({
    super.key,
    this.initialItems,
    this.selectedOutlet,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  String _orderType = 'Pickup'; // 'Pickup' | 'Delivery'
  late OutletModel _activeOutlet;
  late List<CartProductItem> _items;

  // Modifiers & Discounts
  bool _usePoints = false;
  static const int _userAvailablePoints = 5000;
  bool _useEcoBag = false;
  static const int _ecoBagPrice = 4000;

  // Voucher
  final TextEditingController _voucherController = TextEditingController();
  int _voucherDiscount = 0;
  String _activeVoucherCode = '';

  @override
  void initState() {
    super.initState();
    _activeOutlet = widget.selectedOutlet ?? OutletData.defaultOutlet;
    _items = widget.initialItems ??
        [
          CartProductItem(
            id: 'cart_1',
            name: 'OG Aren Spesial Latte',
            category: 'Coffee',
            unitPrice: 24000,
            quantity: 1,
            variantDetails: 'Ice • Regular • Kangenan Blend • Normal Sugar',
            iceLevel: 'Normal Ice',
            notes: 'Sedotan dipisah',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBeIt14XqQpNbDIWKDH3pVE95QAxRdYOueOgzynMsn67KPwj41FcsiKtoKPUc-rvcLjQ1s45aXYc5NLCmWUviL-qviWyH2TWkqbEqNdEhnjJa2KbuxSH9jyBdrYr9dZJr1Lja8uFUdeBM45jTlAPb4g9Nnf0QRSJ7-81rW1WR_EYkvUT7bP164LvS0-PlW2E-cvyZZXyr26dBD6BktGQCLoKwb91NXsLV495WNcjpAaWozxwYTRGeZhpg',
          ),
          CartProductItem(
            id: 'cart_2',
            name: 'Triple Cheese Bagel',
            category: 'Food',
            unitPrice: 22000,
            quantity: 1,
            variantDetails: 'Hangatkan 1 Menit • Extra Melted Cheese',
            iceLevel: '-',
            notes: 'Minta dipotong jadi 2 bagian',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBKU0oUvXPPx3OrXyJpQJtyEa5BbppfI-0ZBzj8k6_NXIuUpyb71VWdybNUSTWXwhKpIzm4HBb4YxDrqH7dtcverITR8puYLaEkahJBYbqmQsoZdwizpbV_ETk-L6va6Y0EBoaOFj2-QzJvR6R0p1mjHojm4VWOCR4twoTwci_tKC8MRZP3FNgxSQWqXPo4wS2tonjMATKxZG9mhtSuwBvXJzdDsiY4sD_ByWPQ5sGNX0FM8nOLZ782rQ',
          ),
        ];
  }

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  int get _subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  int get _deliveryFee => _orderType == 'Delivery' ? 10000 : 0;
  int get _bagFee => _useEcoBag ? _ecoBagPrice : 0;
  int get _pointsDeduction => _usePoints ? _userAvailablePoints.clamp(0, _subtotal) : 0;
  int get _finalTotal => (_subtotal + _deliveryFee + _bagFee - _voucherDiscount - _pointsDeduction).clamp(0, 99999999);

  String _formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  void _applyVoucher() {
    final code = _voucherController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'KANGENKOPI' || code == 'DISKON20') {
      setState(() {
        _activeVoucherCode = code;
        _voucherDiscount = 10000;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voucher $code berhasil dipasang! Hemat Rp10.000'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode voucher tidak valid atau sudah kedaluwarsa.'),
          backgroundColor: Color(0xFFC62828),
        ),
      );
    }
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      final newQty = _items[index].quantity + delta;
      if (newQty <= 0) {
        _confirmRemoveItem(index);
      } else {
        _items[index].quantity = newQty;
      }
    });
  }

  void _confirmRemoveItem(int index) {
    final item = _items[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Item?', style: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700)),
        content: Text('Apakah kamu yakin ingin menghapus ${item.name} dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal', style: TextStyle(color: AppColors.secondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} dihapus dari keranjang')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editItemNotes(int index) {
    final item = _items[index];
    final controller = TextEditingController(text: item.notes);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Catatan Pesanan',
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: const TextStyle(fontFamily: _fontFamily, fontSize: 13, color: AppColors.secondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Contoh: Jangan terlalu manis, sedotan dipisah...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    item.notes = controller.text.trim();
                  });
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer),
                child: const Text('Simpan Catatan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          if (_items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Kosongkan Keranjang?', style: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700)),
                    content: const Text('Semua menu yang telah kamu pilih akan dihapus.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _items.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer),
                        child: const Text('Kosongkan', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Hapus Semua',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryContainer,
                ),
              ),
            ),
        ],
      ),
      body: _items.isEmpty ? _buildEmptyCart() : _buildCartBody(),
      bottomNavigationBar: _items.isEmpty ? null : _buildStickyBottomBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.primaryContainer),
            ),
            const SizedBox(height: 20),
            const Text(
              'Keranjangmu Masih Kosong',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk, temukan kopi favorit, toast lezat, atau camilan manis untuk temani harimu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 13,
                color: AppColors.secondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MenuScreen()),
                );
              },
              icon: const Icon(Icons.coffee_rounded, color: Colors.white),
              label: const Text(
                'Mulai Pesan Kopi',
                style: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Pickup vs Delivery Toggle Strip
          _buildOrderTypeToggle(),

          // Selected Outlet Bar with Change Action
          _buildOutletCard(),

          const SizedBox(height: 12),

          // Cart Items List
          ..._items.asMap().entries.map((entry) => _buildCartItemCard(entry.key, entry.value)),

          // Add More Items Button
          _buildAddMoreItemsButton(),

          const SizedBox(height: 12),

          // Promo & Voucher Section
          _buildVoucherCard(),

          const SizedBox(height: 12),

          // Kangenan Points & Eco Bag Modifiers
          _buildModifiersCard(),

          const SizedBox(height: 12),

          // Payment Summary Card
          _buildSummaryCard(),

          const SizedBox(height: 100), // Spacing for bottom bar
        ],
      ),
    );
  }

  Widget _buildOrderTypeToggle() {
    return Container(
      color: AppColors.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _orderType = 'Pickup'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _orderType == 'Pickup' ? AppColors.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storefront_rounded, size: 16, color: _orderType == 'Pickup' ? Colors.white : AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        'Pickup di Outlet',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _orderType == 'Pickup' ? Colors.white : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _orderType = 'Delivery'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _orderType == 'Delivery' ? AppColors.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delivery_dining_rounded, size: 16, color: _orderType == 'Delivery' ? Colors.white : AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        'Delivery (Antar)',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _orderType == 'Delivery' ? Colors.white : AppColors.secondary,
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

  Widget _buildOutletCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _orderType == 'Pickup' ? Icons.storefront_rounded : Icons.location_on_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _orderType == 'Pickup' ? 'Ambil di Outlet' : 'Alamat Pengiriman',
                  style: const TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
                ),
                const SizedBox(height: 2),
                Text(
                  _orderType == 'Pickup' ? _activeOutlet.name : 'Jl. Basuki Rahmat No.45, Surabaya',
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              final selected = await Navigator.of(context).push<OutletModel>(
                MaterialPageRoute(
                  builder: (context) => OutletListScreen(currentSelectedOutlet: _activeOutlet),
                ),
              );
              if (selected != null) {
                setState(() {
                  _activeOutlet = selected;
                });
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              side: const BorderSide(color: AppColors.primaryContainer),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text(
              'Ubah',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(int index, CartProductItem item) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.primaryFixed,
                    child: const Icon(Icons.local_cafe_rounded, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.variantDetails,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: AppColors.secondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.formattedUnitPrice,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Notes preview & Edit Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.edit_note_rounded, size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.notes.isEmpty ? 'Tanpa catatan' : 'Catatan: ${item.notes}',
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      color: AppColors.secondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () => _editItemNotes(index),
                  child: const Text(
                    'Ubah',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Subtotal & Quantity Stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${item.formattedTotalPrice}',
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Row(
                children: [
                  _buildStepperButton(
                    icon: item.quantity > 1 ? Icons.remove : Icons.delete_outline_rounded,
                    color: item.quantity > 1 ? AppColors.secondary : const Color(0xFFC62828),
                    onTap: () => _changeQuantity(index, -1),
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildStepperButton(
                    icon: Icons.add,
                    color: AppColors.primaryContainer,
                    onTap: () => _changeQuantity(index, 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.surfaceContainerHigh),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildAddMoreItemsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MenuScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primaryContainer),
        label: const Text(
          'Tambah Pesanan Lain',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryContainer,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryContainer, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: const Size.fromHeight(40),
        ),
      ),
    );
  }

  Widget _buildVoucherCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, size: 18, color: AppColors.primaryContainer),
              const SizedBox(width: 8),
              const Text(
                'Voucher & Promo Diskon',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              if (_voucherDiscount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Aktif: $_activeVoucherCode',
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.surfaceContainerHigh),
                  ),
                  child: TextField(
                    controller: _voucherController,
                    style: const TextStyle(fontFamily: _fontFamily, fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Masukkan kode promo (misal: KANGENKOPI)',
                      hintStyle: TextStyle(fontSize: 11, color: AppColors.secondary),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyVoucher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: const Text('Gunakan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModifiersCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
        children: [
          // Kangenan Points Toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _usePoints,
            onChanged: (val) => setState(() => _usePoints = val),
            activeThumbColor: AppColors.primaryContainer,
            title: const Row(
              children: [
                Icon(Icons.toll_rounded, size: 16, color: Color(0xFFFFB300)),
                SizedBox(width: 6),
                Text(
                  'Tukar Kangenan Points',
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            subtitle: const Text(
              'Tersedia 5.000 Poin (Hemat Rp5.000)',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
            ),
          ),
          const Divider(height: 1),
          // Eco Bag
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _useEcoBag,
            onChanged: (val) => setState(() => _useEcoBag = val),
            activeThumbColor: AppColors.primaryContainer,
            title: const Row(
              children: [
                Icon(Icons.eco_rounded, size: 16, color: Color(0xFF2E7D32)),
                SizedBox(width: 6),
                Text(
                  'Kantung Belanja Ramah Lingkungan',
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            subtitle: const Text(
              '+Rp4.000 (Spunbond dapat dipakai berulang kali)',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _buildSummaryRow('Subtotal Pesanan', _formatCurrency(_subtotal)),
          if (_orderType == 'Delivery')
            _buildSummaryRow('Biaya Pengiriman', _formatCurrency(_deliveryFee)),
          if (_useEcoBag)
            _buildSummaryRow('Kantung Belanja Ramah Lingkungan', _formatCurrency(_bagFee)),
          if (_voucherDiscount > 0)
            _buildSummaryRow('Diskon Voucher', '-${_formatCurrency(_voucherDiscount)}', isHighlightGreen: true),
          if (_usePoints)
            _buildSummaryRow('Potongan Poin Kangenan', '-${_formatCurrency(_pointsDeduction)}', isHighlightGreen: true),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w800),
              ),
              Text(
                _formatCurrency(_finalTotal),
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

  Widget _buildSummaryRow(String label, String value, {bool isHighlightGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: _fontFamily, fontSize: 12, color: AppColors.secondary)),
          Text(
            value,
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isHighlightGreen ? const Color(0xFF2E7D32) : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Tagihan',
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
                ),
                Text(
                  _formatCurrency(_finalTotal),
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to CartCheckoutScreen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CartCheckoutScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lanjut ke Pembayaran',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
