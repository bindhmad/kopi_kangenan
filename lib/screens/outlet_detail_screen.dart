import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/outlet_model.dart';
import '../theme/app_colors.dart';
import 'menu_screen.dart';

/// Detail Outlet Screen
/// Displays full information, facilities, operational hours, and direct order CTA.
class OutletDetailScreen extends StatefulWidget {
  final OutletModel outlet;

  const OutletDetailScreen({
    super.key,
    this.outlet = const OutletModel(
      id: 'out_1',
      name: 'Diponegoro Surabaya',
      address: 'Jl. Diponegoro No.129A, Darmo, Kec. Wonokromo, Surabaya, Jawa Timur 60241',
      city: 'Surabaya',
      distance: '0.8 km',
      distanceKm: 0.8,
      openTime: '07:00',
      closeTime: '22:00',
      isOpen: true,
      rating: 4.9,
      reviewCount: 384,
      phone: '+62 31 567 8901',
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&w=800&q=80',
      supportsPickup: true,
      supportsDelivery: true,
      supportsDineIn: true,
      facilities: [
        'Wi-Fi 100 Mbps',
        'Area Merokok Outdoor',
        'Ruang AC Nyaman',
        'Colokan Tiap Meja',
        'Parkir Mobil & Motor',
        'Musholla',
      ],
      latitude: -7.289166,
      longitude: 112.734444,
    ),
  });

  @override
  State<OutletDetailScreen> createState() => _OutletDetailScreenState();
}

class _OutletDetailScreenState extends State<OutletDetailScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';
  bool _isFavorite = false;

  final List<Map<String, String>> _scheduleDays = [
    {'day': 'Senin', 'hours': '07:00 - 22:00', 'isToday': 'false'},
    {'day': 'Selasa', 'hours': '07:00 - 22:00', 'isToday': 'false'},
    {'day': 'Rabu', 'hours': '07:00 - 22:00', 'isToday': 'false'},
    {'day': 'Kamis', 'hours': '07:00 - 22:00', 'isToday': 'false'},
    {'day': 'Jumat', 'hours': '07:00 - 23:00', 'isToday': 'true'},
    {'day': 'Sabtu', 'hours': '07:00 - 23:00', 'isToday': 'false'},
    {'day': 'Minggu', 'hours': '07:00 - 22:00', 'isToday': 'false'},
  ];

  @override
  Widget build(BuildContext context) {
    final outlet = widget.outlet;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // Collapsible Image App Bar with Back & Favorite Actions
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primaryContainer,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.45),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.45),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isFavorite ? const Color(0xFFFF5252) : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? '${outlet.name} disimpan ke Favorit'
                                : '${outlet.name} dihapus dari Favorit',
                          ),
                          duration: const Duration(milliseconds: 1400),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.45),
                  child: IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tautan outlet ${outlet.name} disalin ke clipboard!'),
                          duration: const Duration(milliseconds: 1500),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    outlet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primaryFixed,
                      child: const Center(
                        child: Icon(Icons.storefront_rounded, size: 64, color: AppColors.primary),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: outlet.isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            outlet.isOpen ? 'Buka Sekarang • ${outlet.operationalHoursText}' : 'Tutup Sementara',
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          outlet.name,
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${outlet.rating} (${outlet.reviewCount} ulasan)',
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.near_me_rounded, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${outlet.distance} dari lokasimu',
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Outlet Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address & Quick Map Actions Card
                  _buildAddressCard(outlet),

                  const SizedBox(height: 16),

                  // Supported Services Card
                  _buildServicesCard(outlet),

                  const SizedBox(height: 16),

                  // Facilities & Amenities Card
                  _buildFacilitiesCard(outlet),

                  const SizedBox(height: 16),

                  // Weekly Operational Hours Card
                  _buildHoursCard(),

                  const SizedBox(height: 16),

                  // Direct Contact Section
                  _buildContactCard(outlet),

                  const SizedBox(height: 90), // Bottom padding for sticky button
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Order CTA
      bottomSheet: Container(
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
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MenuScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Memesan dari outlet: ${outlet.name}'),
                    backgroundColor: AppColors.primaryContainer,
                  ),
                );
              },
              icon: const Icon(Icons.coffee_rounded, color: Colors.white),
              label: const Text(
                'Pesan dari Outlet Ini',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(OutletModel outlet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Alamat Lengkap Outlet',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            outlet.address,
            style: const TextStyle(
              fontFamily: _fontFamily,
              fontSize: 13,
              color: AppColors.secondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: outlet.address));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alamat berhasil disalin ke clipboard!'),
                        duration: Duration(milliseconds: 1500),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primaryContainer),
                  label: const Text(
                    'Salin Alamat',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryContainer),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membuka rute ke ${outlet.name} di Google Maps...'),
                        duration: const Duration(milliseconds: 1500),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions_rounded, size: 16, color: Colors.white),
                  label: const Text(
                    'Petunjuk Arah',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCard(OutletModel outlet) {
    return Container(
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
            'Layanan yang Tersedia',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildServicePill(
                icon: Icons.storefront_rounded,
                title: 'Pickup',
                subtitle: 'Ambil di Bar',
                isAvailable: outlet.supportsPickup,
              ),
              const SizedBox(width: 8),
              _buildServicePill(
                icon: Icons.delivery_dining_rounded,
                title: 'Delivery',
                subtitle: 'Antar Cepat',
                isAvailable: outlet.supportsDelivery,
              ),
              const SizedBox(width: 8),
              _buildServicePill(
                icon: Icons.table_bar_rounded,
                title: 'Dine-In',
                subtitle: 'Makan di Tempat',
                isAvailable: outlet.supportsDineIn,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicePill({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isAvailable,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isAvailable ? AppColors.surfaceContainerLow : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isAvailable ? AppColors.outlineVariant.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isAvailable ? AppColors.primaryContainer : AppColors.secondary,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isAvailable ? AppColors.onSurface : AppColors.secondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isAvailable ? subtitle : 'Tidak Tersedia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 9,
                color: isAvailable ? AppColors.secondary : AppColors.secondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesCard(OutletModel outlet) {
    return Container(
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
            'Fasilitas Outlet',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: outlet.facilities.map((facility) {
              IconData icon = Icons.check_circle_outline_rounded;
              if (facility.toLowerCase().contains('wi-fi')) icon = Icons.wifi_rounded;
              if (facility.toLowerCase().contains('merokok')) icon = Icons.outdoor_grill_rounded;
              if (facility.toLowerCase().contains('ac')) icon = Icons.ac_unit_rounded;
              if (facility.toLowerCase().contains('colokan')) icon = Icons.power_rounded;
              if (facility.toLowerCase().contains('parkir')) icon = Icons.local_parking_rounded;
              if (facility.toLowerCase().contains('musholla')) icon = Icons.mosque_rounded;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: AppColors.primaryContainer),
                    const SizedBox(width: 6),
                    Text(
                      facility,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jam Operasional',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Hari Ini Buka',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: _scheduleDays.map((item) {
              final isToday = item['isToday'] == 'true';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['day']!,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? AppColors.primaryContainer : AppColors.secondary,
                      ),
                    ),
                    Text(
                      item['hours']!,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? AppColors.primaryContainer : AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(OutletModel outlet) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Text(
            'Kontak & Bantuan Outlet',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryFixed,
              child: const Icon(Icons.phone_rounded, color: AppColors.primary, size: 18),
            ),
            title: const Text(
              'Telepon Outlet',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            subtitle: Text(
              outlet.phone,
              style: const TextStyle(
                fontFamily: _fontFamily,
                fontSize: 12,
                color: AppColors.secondary,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.call_outlined, color: AppColors.primaryContainer),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Menghubungi ${outlet.phone}...')),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE8F5E9),
              child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF2E7D32), size: 18),
            ),
            title: const Text(
              'Customer Service WhatsApp',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            subtitle: const Text(
              '+62 811-2345-6789 (Respon Cepat)',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 12,
                color: AppColors.secondary,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new_rounded, color: Color(0xFF2E7D32)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp Customer Care...')),
                );
              },
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}
