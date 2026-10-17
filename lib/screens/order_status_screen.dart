import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

/// Status Pesanan Screen (Screen 10)
/// Displays real-time live order progress (Menunggu -> Sedang Dibuat -> Siap Diambil -> Selesai),
/// pickup verification PIN/barcode, outlet location, item summary, and direct outlet contact.
class OrderStatusScreen extends StatefulWidget {
  final String orderId;
  final String outletName;
  final int totalAmount;
  final String orderType;

  const OrderStatusScreen({
    super.key,
    this.orderId = 'KGN-20261016-0042',
    this.outletName = 'Diponegoro Surabaya',
    this.totalAmount = 56000,
    this.orderType = 'Pickup di Counter',
  });

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  // Order status progression steps: 0: Diterima, 1: Sedang Disiapkan, 2: Siap Diambil, 3: Selesai
  int _currentStepIndex = 1;

  final List<Map<String, dynamic>> _statusSteps = [
    {
      'title': 'Pesanan Diterima',
      'subtitle': '07:15 • Kasir telah memverifikasi pesananmu',
      'icon': Icons.receipt_long_rounded,
    },
    {
      'title': 'Sedang Disiapkan Barista',
      'subtitle': '07:17 • Espresso sedang di-extract dengan fresh milk',
      'icon': Icons.coffee_maker_rounded,
    },
    {
      'title': 'Siap Diambil di Counter',
      'subtitle': 'Tunjukkan PIN atau Barcode ini ke kasir',
      'icon': Icons.storefront_rounded,
    },
    {
      'title': 'Pesanan Selesai',
      'subtitle': 'Terima kasih telah memesan Kopi Kangenan!',
      'icon': Icons.check_circle_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.onSurface),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen(isLoggedIn: true)),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Status Pesanan',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryContainer),
            onPressed: () {
              setState(() {
                _currentStepIndex = (_currentStepIndex + 1) % _statusSteps.length;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Status simulasi diperbarui ke: ${_statusSteps[_currentStepIndex]['title']}'),
                  duration: const Duration(milliseconds: 1200),
                ),
              );
            },
            tooltip: 'Simulasi Update Status',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Verification Code & Live ETA Hero Card
            _buildOrderHeroCard(),

            const SizedBox(height: 12),

            // Live Stepper Tracker
            _buildTimelineTracker(),

            const SizedBox(height: 12),

            // Store Info & Quick Contact
            _buildOutletContactCard(),

            const SizedBox(height: 12),

            // Order Items & Payment Receipt
            _buildOrderReceiptCard(),

            const SizedBox(height: 24),

            // Home CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeScreen(isLoggedIn: true)),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home_rounded, color: Colors.white),
                  label: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeroCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No. Pesanan',
                    style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
                  ),
                  Text(
                    widget.orderId,
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.orderType,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pickup PIN Code
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Column(
              children: [
                const Text(
                  'PIN AMBIL PESANAN',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '8 2 9 4',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: AppColors.primaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Estimasi Siap: 7 - 10 Menit',
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTracker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lacak Pesanan Real-Time',
            style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          ..._statusSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isCompleted = index <= _currentStepIndex;
            final isCurrent = index == _currentStepIndex;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isCurrent
                          ? AppColors.primaryContainer
                          : (isCompleted ? const Color(0xFF2E7D32) : AppColors.surfaceContainerHigh),
                      child: Icon(
                        isCompleted ? Icons.check_rounded : step['icon'] as IconData,
                        size: 15,
                        color: isCompleted ? Colors.white : AppColors.secondary,
                      ),
                    ),
                    if (index < _statusSteps.length - 1)
                      Container(
                        width: 2,
                        height: 32,
                        color: index < _currentStepIndex ? const Color(0xFF2E7D32) : AppColors.surfaceContainerHigh,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 13,
                            fontWeight: isCurrent ? FontWeight.w800 : (isCompleted ? FontWeight.w700 : FontWeight.w500),
                            color: isCurrent ? AppColors.primaryContainer : (isCompleted ? AppColors.onSurface : AppColors.secondary),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step['subtitle'] as String,
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 11,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOutletContactCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.outletName,
                  style: const TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Jl. Diponegoro No.129A, Wonokromo, Surabaya',
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menghubungi kasir outlet Kopi Kangenan...')),
              );
            },
            icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primaryContainer),
            tooltip: 'Hubungi Outlet',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderReceiptCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _buildItemRow('1x OG Aren Spesial Latte', 'Rp24.000', 'Ice • Regular • Normal Sugar'),
          const SizedBox(height: 6),
          _buildItemRow('1x Triple Cheese Bagel', 'Rp22.000', 'Hangatkan 1 Menit • Extra Melted'),
          const SizedBox(height: 6),
          _buildItemRow('1x Kantung Belanja Ramah Lingkungan', 'Rp4.000', 'Spunbond Bag'),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Metode Pembayaran', style: TextStyle(fontFamily: _fontFamily, fontSize: 12, color: AppColors.secondary)),
              const Text('QRIS (BCA Digital)', style: TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pembayaran', style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w800)),
              Text(
                'Rp${widget.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 15,
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

  Widget _buildItemRow(String name, String price, String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w600)),
            Text(price, style: const TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
        Text(notes, style: const TextStyle(fontFamily: _fontFamily, fontSize: 10, color: AppColors.secondary)),
      ],
    );
  }
}
