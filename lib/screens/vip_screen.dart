import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'menu_screen.dart';

/// Screen: Kangenan VIP
/// Implements 4 Stitch screens:
/// 1. VIP Silver - Voucher Tab (ID: 1427583a6c1f4f38baa8262e9895f0e9)
/// 2. Modal Beli Paket Voucher (ID: 3a50f8845d60495d9d65e07df4cf6bfd)
/// 3. VIP Gold - Benefits Tab (ID: 913d09ed514f47b891fc8c76664e3198)
/// 4. VIP Black - Voucher Pack Tab (ID: a026fa24816343e082c6e08febf9e322)
class VipScreen extends StatefulWidget {
  final int initialTab; // 0: Voucher, 1: Voucher Pack, 2: Benefits
  final int initialTier; // 0: Silver, 1: Gold, 2: Black
  final String userName;

  const VipScreen({
    super.key,
    this.initialTab = 0,
    this.initialTier = 0,
    this.userName = 'Davit Hengky',
  });

  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  late int _selectedTab;
  late int _currentTierIndex;
  late final PageController _cardPageController;

  final TextEditingController _voucherCodeController = TextEditingController();
  String _selectedVoucherFilter = 'Semua';

  // Sample dynamic state for purchased packs & applied vouchers
  final Set<String> _usedVouchers = {};
  final List<Map<String, dynamic>> _myVouchers = [
    {
      'id': 'v1',
      'tag': 'Pakai di App',
      'tagColor': Color(0xFF1976D2),
      'tagBg': Color(0xFFE3F2FD),
      'title': 'Cashback 30% s/d 30RB',
      'subtitle': 'Min. pembelian 60RB untuk semua menu kopi...',
      'expiry': 'Hingga 14 Okt 2026, 23:59',
      'category': 'Cashback',
      'icon': Icons.percent_rounded,
    },
    {
      'id': 'v2',
      'tag': 'Gratis Ongkir',
      'tagColor': Color(0xFF2E7D32),
      'tagBg': Color(0xFFE8F5E9),
      'title': 'Potongan Ongkir Rp10.000',
      'subtitle': 'Min. pembelian 35RB khusus delivery...',
      'expiry': 'Hingga 20 Okt 2026, 23:59',
      'category': 'Delivery',
      'icon': Icons.two_wheeler_rounded,
    },
    {
      'id': 'v3',
      'tag': 'Diskon Spesial',
      'tagColor': Color(0xFFC62828),
      'tagBg': Color(0xFFFFEBEE),
      'title': 'Diskon 20% Espresso Blend',
      'subtitle': 'Tanpa minimum pembelian untuk member VIP...',
      'expiry': 'Hingga 31 Okt 2026, 23:59',
      'category': 'Diskon',
      'icon': Icons.local_cafe_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _currentTierIndex = widget.initialTier;
    _cardPageController = PageController(initialPage: widget.initialTier);
  }

  @override
  void dispose() {
    _voucherCodeController.dispose();
    _cardPageController.dispose();
    super.dispose();
  }

  void _applyVoucherCode() {
    final code = _voucherCodeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'KANGENANVIP' || code == 'NGOPIHEMAT' || code == 'HEMAT98') {
      setState(() {
        _myVouchers.insert(0, {
          'id': 'v_${DateTime.now().millisecondsSinceEpoch}',
          'tag': 'Kode Promo VIP',
          'tagColor': const Color(0xFFC62828),
          'tagBg': const Color(0xFFFFEBEE),
          'title': 'Voucher Diskon Rp15.000 ($code)',
          'subtitle': 'Khusus semua produk Signature Coffee...',
          'expiry': 'Hingga 30 Nov 2026, 23:59',
          'category': 'Diskon',
          'icon': Icons.confirmation_number_rounded,
        });
      });
      _voucherCodeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voucher "$code" berhasil diaktifkan! 🎉'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode voucher "$code" tidak valid atau telah kedaluwarsa.'),
          backgroundColor: const Color(0xFFC62828),
        ),
      );
    }
  }

  void _showHelpInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.workspace_premium_rounded, color: Color(0xFFC62828)),
            SizedBox(width: 8),
            Text(
              'Tingkat Member Kangenan',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tingkatkan akumulasi belanjamu untuk membuka berbagai keistimewaan eksklusif:',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 12, color: AppColors.secondary),
            ),
            SizedBox(height: 12),
            _TierInfoItem(
              tier: 'SILVER',
              threshold: 'Rp0 - Rp699.999',
              perks: 'Akses voucher harian & promo aplikasi reguler',
              color: Color(0xFF757575),
            ),
            SizedBox(height: 8),
            _TierInfoItem(
              tier: 'GOLD',
              threshold: 'Rp700.000 - Rp1.999.999',
              perks: 'Cashback 5%, Voucher bulanan, dan Birthday Treats',
              color: Color(0xFFC59B27),
            ),
            SizedBox(height: 8),
            _TierInfoItem(
              tier: 'BLACK',
              threshold: 'Rp2.000.000+',
              perks: 'Cashback 10%, Akses menu rahasia, dan Gratis Ongkir prioritas',
              color: Color(0xFF1A1A1A),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Mengerti', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _openPurchaseModal(Map<String, dynamic> pack) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModalBeliVoucherSheet(
        pack: pack,
        onSuccess: (purchasedPack) {
          setState(() {
            _myVouchers.insert(0, {
              'id': 'pack_${DateTime.now().millisecondsSinceEpoch}',
              'tag': 'Paket Aktif',
              'tagColor': const Color(0xFFC62828),
              'tagBg': const Color(0xFFFFEBEE),
              'title': 'Voucher B1G1 dari ${purchasedPack['title']}',
              'subtitle': 'Berlaku untuk minuman Signature & Artisan...',
              'expiry': 'Hingga 31 Des 2026, 23:59',
              'category': 'Diskon',
              'icon': Icons.card_giftcard_rounded,
            });
            _selectedTab = 0; // switch to voucher tab
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selamat! ${purchasedPack['title']} telah aktif di akunmu! 🎉'),
              backgroundColor: const Color(0xFF2E7D32),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed App Header
            _buildAppHeader(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub Header Navigation
                      _buildSubHeader(),

                      const SizedBox(height: 12),

                      // Swipable VIP Membership Tier Card Carousel
                      _buildTierCarousel(),

                      const SizedBox(height: 8),

                      // Carousel Indicator Dots
                      _buildCarouselDots(),

                      const SizedBox(height: 16),

                      // Segmented 3 Tabs (Voucher, Voucher Pack, Benefits)
                      _buildSegmentedTabs(),

                      const SizedBox(height: 16),

                      // Tab View Body
                      if (_selectedTab == 0)
                        _buildVoucherTabContent()
                      else if (_selectedTab == 1)
                        _buildVoucherPackTabContent()
                      else
                        _buildBenefitsTabContent(),

                      const SizedBox(height: 32),
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

  // Header matching Stitch: Title "Vip", Help & Profile Icon
  Widget _buildAppHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_cafe_rounded,
                  size: 20,
                  color: AppColors.primaryContainer,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Vip',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _showHelpInfoDialog,
                icon: const Icon(
                  Icons.help_outline_rounded,
                  size: 22,
                  color: AppColors.secondary,
                ),
                tooltip: 'Bantuan dan Informasi',
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sub Header: Back Button, "Kangenan VIP", Subtitle, Help Button
  Widget _buildSubHeader() {
    String subtitleText = 'Tingkat Silver Member';
    if (_currentTierIndex == 1) {
      subtitleText = 'Tingkat & Keistimewaan Gold';
    } else if (_currentTierIndex == 2) {
      subtitleText = 'Tingkat & Keistimewaan Black';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                'Kangenan VIP',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                subtitleText,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: _showHelpInfoDialog,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                size: 18,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Swipable Carousel of Silver, Gold, and Black Cards
  Widget _buildTierCarousel() {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _cardPageController,
        onPageChanged: (index) {
          setState(() {
            _currentTierIndex = index;
          });
        },
        physics: const BouncingScrollPhysics(),
        children: [
          _buildSilverCard(),
          _buildGoldCard(),
          _buildBlackCard(),
        ],
      ),
    );
  }

  // Silver Card (Screen 1 ID: 1427583a)
  Widget _buildSilverCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF0EDED),
            Color(0xFFE4E1E1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'SILVER',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4A4A4A),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCD8D8),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '0%',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF424242),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hai, ${widget.userName}',
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                ],
              ),
              // Heart badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primaryContainer,
                  size: 24,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        ' / 699.999',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Target Gold',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: const LinearProgressIndicator(
                  value: 0.05,
                  minHeight: 8,
                  backgroundColor: Color(0xFFD6D3D3),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5F5E5E)),
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 14, color: AppColors.secondary),
                  SizedBox(width: 6),
                  Text(
                    'Belanja Rp700.000 lagi untuk naik ke Level Gold',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Gold Card (Screen 3 ID: 913d09ed)
  Widget _buildGoldCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF9E6),
            Color(0xFFFFEBB0),
            Color(0xFFF7C948),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC59B27).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'GOLD',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF7A5806),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A5806),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_rounded, size: 11, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Locked',
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hai, ${widget.userName}',
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7A5806),
                    ),
                  ),
                ],
              ),
              // Luxury Lock Badge Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE0A812), Color(0xFFFFF3CA)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7A5806).withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF8E7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Color(0xFF7A5806),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Target Belanja: Rp700.000',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A3200),
                    ),
                  ),
                  Text(
                    'Rp320.000 / Rp700.000',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7A5806),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: const LinearProgressIndicator(
                  value: 0.45,
                  minHeight: 8,
                  backgroundColor: Color(0x337A5806),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7A5806)),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kumpulkan Rp380.000 lagi untuk membuka kenikmatan status VIP Gold!',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5C4105),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Black Card (Screen 4 ID: a026fa24)
  Widget _buildBlackCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF262626),
            Color(0xFF141414),
            Color(0xFF0A0A0A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle Watermark
          Positioned(
            right: -10,
            bottom: -8,
            child: Text(
              'KANGENAN',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white.withValues(alpha: 0.04),
                letterSpacing: 4,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'BLACK',
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.6)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.lock_rounded, size: 11, color: Color(0xFFFFD54F)),
                                SizedBox(width: 4),
                                Text(
                                  'Locked',
                                  style: TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFFD54F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Hai, ${widget.userName}',
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFD54F)),
                        ],
                      ),
                    ],
                  ),
                  // Luxury Gold Shield Badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2618),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Color(0xFFFFD54F),
                      size: 24,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Target Belanja: Rp2.000.000',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '42%',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFFD54F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: const LinearProgressIndicator(
                      value: 0.42,
                      minHeight: 8,
                      backgroundColor: Color(0xFF333333),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD54F)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kumpulkan total belanja Rp2.000.000 untuk menikmati status Kangenan Black VIP',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dots below the carousel
  Widget _buildCarouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentTierIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryContainer : const Color(0xFFD1D1D1),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }

  // 3 Segmented Tabs: Voucher | Voucher Pack | Benefits
  Widget _buildSegmentedTabs() {
    final tabs = ['Voucher', 'Voucher Pack', 'Benefits'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryContainer : AppColors.secondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // TAB 1: Voucher Content (Screen 1 ID: 1427583a)
  Widget _buildVoucherTabContent() {
    final filterOptions = ['Semua', 'Diskon', 'Cashback', 'Delivery'];

    final filteredVouchers = _myVouchers.where((v) {
      if (_selectedVoucherFilter == 'Semua') return true;
      return v['category'] == _selectedVoucherFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Promo Code Input Box
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.confirmation_number_rounded,
                  color: Color(0xFFE65100),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _voucherCodeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan kode voucher di sini...',
                    hintStyle: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                  onSubmitted: (_) => _applyVoucherCode(),
                ),
              ),
              ElevatedButton(
                onPressed: _applyVoucherCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text(
                  'Terapkan',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: filterOptions.map((filter) {
              final isSelected = _selectedVoucherFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      _selectedVoucherFilter = filter;
                    });
                  },
                  selectedColor: AppColors.primaryFixed,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryContainer : AppColors.secondary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryContainer : const Color(0xFFE0E0E0),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        // Voucher List Stack
        if (filteredVouchers.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: const Text(
              'Tidak ada voucher dalam kategori ini.',
              style: TextStyle(fontFamily: _fontFamily, color: AppColors.secondary),
            ),
          )
        else
          ...filteredVouchers.map((v) => _buildVoucherTicketCard(v)),

        const SizedBox(height: 12),

        // Stamp Promo Banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(Icons.loyalty_rounded, color: AppColors.primaryContainer, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Makin sering ngopi, makin untung!',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Kumpulkan Stamp tiap pesan Espresso Blend favoritmu.',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Voucher Ticket Card with Notches
  Widget _buildVoucherTicketCard(Map<String, dynamic> v) {
    final isUsed = _usedVouchers.contains(v['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: v['tagBg'] as Color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              v['tag'] as String,
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: v['tagColor'] as Color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            v['title'] as String,
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            v['subtitle'] as String,
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 11,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        v['icon'] as IconData,
                        color: AppColors.primaryContainer,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          v['expiry'] as String,
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 11,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: isUsed
                          ? null
                          : () {
                              setState(() {
                                _usedVouchers.add(v['id'] as String);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Voucher "${v['title']}" siap dipakai saat checkout!'),
                                  backgroundColor: const Color(0xFF2E7D32),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isUsed ? const Color(0xFF9E9E9E) : AppColors.primaryContainer,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text(
                        isUsed ? 'Tersimpan ✓' : 'Pakai Voucher',
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Left Notch Cutout
          Positioned(
            left: -6,
            top: 72,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Right Notch Cutout
          Positioned(
            right: -6,
            top: 72,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Voucher Pack Content (Screen 4 ID: a026fa24)
  Widget _buildVoucherPackTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Informative Header Banner
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 18,
                color: AppColors.primaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beli Paket Voucher, Langsung Hemat Berkali-kali',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Nikmati diskon eksklusif untuk member setia',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Voucher Pack Card 1: Rp9.000
        _buildVoucherPackCard(
          title: 'Langganan Voucher Rp9.000',
          subtitle: '1x Voucher B1G1, 2x Voucher B2G1, 30x Voucher Diskon 10%, 30x Voucher Diskon Ongkir Rp5.000',
          badgeText: '65x',
          originalPrice: 'Rp630.000',
          saveTag: 'Save 98%',
          price: 'Rp9.000',
          priceValue: 9000,
          accentColor: AppColors.primaryContainer,
          hasFireIcon: false,
        ),

        const SizedBox(height: 14),

        // Voucher Pack Card 2: Rp24.000
        _buildVoucherPackCard(
          title: 'Langganan Voucher Rp24.000',
          subtitle: '1x Voucher Gratis 1 Minuman, 1x Voucher B1G1, 32x Diskon 15%, 32x Diskon Ongkir Rp10.000',
          badgeText: '66x',
          originalPrice: 'Rp680.000',
          saveTag: 'Save 96%',
          price: 'Rp24.000',
          priceValue: 24000,
          accentColor: const Color(0xFFFF9800),
          hasFireIcon: true,
        ),

        const SizedBox(height: 14),

        // Automatic Loyalty Perk
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(Icons.card_giftcard_rounded, color: AppColors.primaryContainer, size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Poin Loyalitas Otomatis',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Dapatkan 50 KangenPoints tiap pembelian pack',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.secondary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherPackCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required String originalPrice,
    required String saveTag,
    required String price,
    required int priceValue,
    required Color accentColor,
    required bool hasFireIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Accent Stripe
              Container(width: 5, color: accentColor),

              // Content Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              if (hasFireIcon) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.local_fire_department_rounded, size: 16, color: Color(0xFFE65100)),
                              ],
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE65100),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 11,
                          color: AppColors.secondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            originalPrice,
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 12,
                              color: AppColors.secondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              saveTag,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HARGA PAKET',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                price,
                                style: const TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _openPurchaseModal({
                                'title': title,
                                'subtitle': subtitle,
                                'price': price,
                                'priceValue': priceValue,
                                'originalPrice': originalPrice,
                                'saveTag': saveTag,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryContainer,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            icon: const Text(
                              'Buy Pack',
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            label: const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 3: Benefits Content (Screen 3 ID: 913d09ed)
  Widget _buildBenefitsTabContent() {
    String tierName = 'Gold';
    if (_currentTierIndex == 0) tierName = 'Silver';
    if (_currentTierIndex == 2) tierName = 'Black';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Keuntungan Eksklusif Member $tierName',
              style: const TextStyle(
                fontFamily: _fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const Row(
              children: [
                Icon(Icons.stars_rounded, size: 16, color: Color(0xFFD4AF37)),
                SizedBox(width: 4),
                Text(
                  '3 Hak Spesial',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Benefit 1: Cashback
        _buildBenefitCard(
          icon: Icons.paid_rounded,
          title: _currentTierIndex == 2 ? 'Cashback (10%)' : (_currentTierIndex == 1 ? 'Cashback (5%)' : 'Cashback (2%)'),
          subtitle: 'Dapatkan cashback Kangenan Points untuk setiap transaksi kopimu tanpa batas minimum.',
          lockTag: _currentTierIndex == 0 ? 'Aktif di Level Silver' : 'Terkunci di Level $tierName',
          frequencyTag: 'Setiap Pesanan',
          isLocked: _currentTierIndex > 0,
        ),

        const SizedBox(height: 10),

        // Benefit 2: Membership Voucher
        _buildBenefitCard(
          icon: Icons.confirmation_number_rounded,
          title: 'Membership Voucher',
          subtitle: 'Dapatkan voucher diskon produk dan gratis ongkos kirim setiap awal bulan otomatis.',
          lockTag: _currentTierIndex == 0 ? 'Aktif di Level Silver' : 'Terkunci di Level $tierName',
          frequencyTag: 'Rilis Bulanan',
          isLocked: _currentTierIndex > 0,
        ),

        const SizedBox(height: 10),

        // Benefit 3: Birthday Treats
        _buildBenefitCard(
          icon: Icons.cake_rounded,
          title: 'Birthday Treats',
          subtitle: 'Dapatkan E-Voucher Birthday spesial segelas Signature Latte di bulan kelahiranmu.',
          lockTag: _currentTierIndex == 0 ? 'Aktif di Level Silver' : 'Terkunci di Level $tierName',
          frequencyTag: '1x Tiap Tahun',
          isLocked: _currentTierIndex > 0,
        ),

        const SizedBox(height: 14),

        // Bottom CTA Card: Order Coffee
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF0EF), Color(0xFFFFFFFF)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_cafe_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pesan Kopi Hari Ini?',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tingkatkan terus transaksimu untuk naik ke level $tierName!',
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text(
                  'Pesan',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String lockTag,
    required String frequencyTag,
    required bool isLocked,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7A5806),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7A5806),
                      ),
                    ),
                    Icon(
                      isLocked ? Icons.lock_outline_rounded : Icons.check_circle_rounded,
                      size: 16,
                      color: isLocked ? AppColors.secondary : const Color(0xFF2E7D32),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    color: Color(0xFF5A5A5A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLocked ? Icons.lock_clock_rounded : Icons.verified_rounded,
                            size: 12,
                            color: const Color(0xFF7A5806),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            lockTag,
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7A5806),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      frequencyTag,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 10,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal Bottom Sheet: Konfirmasi Pembayaran (Screen 2 ID: 3a50f884)
class _ModalBeliVoucherSheet extends StatefulWidget {
  final Map<String, dynamic> pack;
  final ValueChanged<Map<String, dynamic>> onSuccess;

  const _ModalBeliVoucherSheet({
    required this.pack,
    required this.onSuccess,
  });

  @override
  State<_ModalBeliVoucherSheet> createState() => _ModalBeliVoucherSheetState();
}

class _ModalBeliVoucherSheetState extends State<_ModalBeliVoucherSheet> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  String _selectedPaymentMethod = 'blu';
  bool _isProcessing = false;
  bool _isSuccess = false;

  late Timer _countdownTimer;
  int _remainingSeconds = 3585; // 00:59:45

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  String _formatTimer() {
    final h = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _triggerPayment() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        Navigator.of(context).pop();
        widget.onSuccess(widget.pack);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final packTitle = widget.pack['title'] as String;
    final packPrice = widget.pack['price'] as String;
    final originalPrice = widget.pack['originalPrice'] as String;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Konfirmasi Pembayaran',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: AppColors.secondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Limited Time Offer Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.loyalty_rounded, color: AppColors.primaryContainer, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Penawaran Terbatas VIP',
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule_rounded, size: 12, color: AppColors.primaryContainer),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimer(),
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Selected Voucher Pack Summary Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F8F8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEBE8E8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star_rounded, size: 12, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        'Paling Populer',
                                        style: TextStyle(
                                          fontFamily: _fontFamily,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  packTitle,
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '65x Voucher Eksklusif Kangenan',
                                  style: TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 11,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_cafe_rounded, color: AppColors.primaryContainer, size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              packPrice,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              originalPrice,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 12,
                                color: AppColors.secondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'HEMAT 98%',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Breakdown Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Harga Asli', style: TextStyle(fontFamily: _fontFamily, fontSize: 12, color: AppColors.secondary)),
                          Text(originalPrice, style: const TextStyle(fontFamily: _fontFamily, fontSize: 12, color: AppColors.secondary, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Harga Paket', style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                          Text(packPrice, style: const TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryContainer)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.savings_rounded, color: AppColors.primaryContainer, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Kamu Hemat',
                                  style: TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                ),
                              ],
                            ),
                            Text(
                              'Rp621.000 (98%)',
                              style: TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryContainer),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Payment Method Selector
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metode Pembayaran',
                      style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    Text(
                      'Tersedia 3 Pilihan',
                      style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                _buildPaymentOption(
                  id: 'blu',
                  name: 'blu by BCA Digital',
                  desc: 'Saldo mencukupi (Rp142.500)',
                  badgeText: 'blu',
                  badgeBg: const Color(0xFF0047FF),
                ),
                const SizedBox(height: 8),

                _buildPaymentOption(
                  id: 'gopay',
                  name: 'GoPay',
                  desc: 'Saldo: Rp25.000',
                  badgeText: 'GoPay',
                  badgeBg: const Color(0xFF00AED6),
                ),

                const SizedBox(height: 14),

                // Security Guarantee
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_rounded, size: 14, color: AppColors.secondary),
                    SizedBox(width: 6),
                    Text(
                      'Garansi 100% aman & langsung aktif di akunmu',
                      style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _triggerPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSuccess ? const Color(0xFF2E7D32) : AppColors.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: _isProcessing
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Memproses...',
                                style: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ],
                          )
                        : (_isSuccess
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Pembayaran Berhasil!',
                                    style: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lock_rounded, size: 18, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Bayar · $packPrice',
                                    style: const TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                ],
                              )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String name,
    required String desc,
    required String badgeText,
    required Color badgeBg,
  }) {
    final isSelected = _selectedPaymentMethod == id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFEBEE) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : const Color(0xFFE0E0E0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 11,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryContainer : const Color(0xFFBDBDBD),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(2),
              child: isSelected
                  ? Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TierInfoItem extends StatelessWidget {
  final String tier;
  final String threshold;
  final String perks;
  final Color color;

  const _TierInfoItem({
    required this.tier,
    required this.threshold,
    required this.perks,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tier,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                threshold,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            perks,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
