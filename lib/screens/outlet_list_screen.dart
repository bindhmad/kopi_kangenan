import 'package:flutter/material.dart';
import '../data/outlet_data.dart';
import '../models/outlet_model.dart';
import '../theme/app_colors.dart';
import 'menu_screen.dart';
import 'outlet_detail_screen.dart';

/// Daftar Outlet Screen (Screen 5)
/// Allows user to browse outlets, filter by distance/city/service, view map mode,
/// and select an active store or view detailed information.
class OutletListScreen extends StatefulWidget {
  final OutletModel? currentSelectedOutlet;

  const OutletListScreen({
    super.key,
    this.currentSelectedOutlet,
  });

  @override
  State<OutletListScreen> createState() => _OutletListScreenState();
}

class _OutletListScreenState extends State<OutletListScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  bool _isMapView = false;
  late OutletModel _activeSelectedOutlet;

  final List<String> _filterCategories = [
    'Semua',
    'Terdekat',
    'Buka Sekarang',
    'Dine-In',
    'Surabaya',
    'Jakarta',
  ];

  @override
  void initState() {
    super.initState();
    _activeSelectedOutlet = widget.currentSelectedOutlet ?? OutletData.defaultOutlet;
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<OutletModel> get _filteredOutlets {
    return OutletData.outlets.where((outlet) {
      // Search matching
      final matchesQuery = _searchQuery.isEmpty ||
          outlet.name.toLowerCase().contains(_searchQuery) ||
          outlet.address.toLowerCase().contains(_searchQuery) ||
          outlet.city.toLowerCase().contains(_searchQuery);

      if (!matchesQuery) return false;

      // Filter category matching
      switch (_selectedFilter) {
        case 'Terdekat':
          return outlet.distanceKm <= 3.0;
        case 'Buka Sekarang':
          return outlet.isOpen;
        case 'Dine-In':
          return outlet.supportsDineIn;
        case 'Surabaya':
          return outlet.city.toLowerCase().contains('surabaya');
        case 'Jakarta':
          return outlet.city.toLowerCase().contains('jakarta');
        case 'Semua':
        default:
          return true;
      }
    }).toList();
  }

  void _onSelectOutlet(OutletModel outlet) {
    setState(() {
      _activeSelectedOutlet = outlet;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Outlet aktif diubah ke: ${outlet.name}'),
        backgroundColor: AppColors.primaryContainer,
        duration: const Duration(milliseconds: 1400),
      ),
    );

    // If popped back, return the outlet
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(outlet);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlets = _filteredOutlets;

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
          'Pilih Outlet',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
        actions: [
          // View Switcher (List vs Map)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _isMapView = !_isMapView;
                });
              },
              icon: Icon(
                _isMapView ? Icons.format_list_bulleted_rounded : Icons.map_outlined,
                size: 18,
                color: AppColors.primaryContainer,
              ),
              label: Text(
                _isMapView ? 'Daftar' : 'Peta',
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryContainer,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryFixed.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: AppColors.surfaceContainerLowest,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                // Search Input Field
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.surfaceContainerHigh),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontFamily: _fontFamily, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Cari outlet, jalan, atau kota...',
                      hintStyle: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        color: AppColors.secondary,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondary, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.secondary),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Horizontal Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterCategories.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            }
                          },
                          labelStyle: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.secondary,
                          ),
                          selectedColor: AppColors.primaryContainer,
                          backgroundColor: AppColors.surfaceContainerLow,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main View: List or Simulated Interactive Map
          Expanded(
            child: _isMapView ? _buildSimulatedMapView(outlets) : _buildListView(outlets),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<OutletModel> outlets) {
    if (outlets.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: outlets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final outlet = outlets[index];
        final isCurrentActive = outlet.id == _activeSelectedOutlet.id;
        return _buildOutletCard(outlet, isCurrentActive);
      },
    );
  }

  Widget _buildOutletCard(OutletModel outlet, bool isCurrentActive) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentActive ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
          width: isCurrentActive ? 1.5 : 1,
        ),
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
          // Outlet Info Row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Outlet Thumbnail Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    outlet.imageUrl,
                    width: 74,
                    height: 74,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 74,
                      height: 74,
                      color: AppColors.primaryFixed,
                      child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              outlet.name,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              outlet.distance,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        outlet.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 11,
                          color: AppColors.secondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: outlet.isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            outlet.isOpen ? 'Buka • ${outlet.operationalHoursText}' : 'Tutup Sementara',
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: outlet.isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB300)),
                          const SizedBox(width: 2),
                          Text(
                            '${outlet.rating}',
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
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

          // Services & Action Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Service tags
                Row(
                  children: [
                    if (outlet.supportsPickup) _buildSmallTag('Pickup'),
                    if (outlet.supportsDelivery) ...[
                      const SizedBox(width: 4),
                      _buildSmallTag('Delivery'),
                    ],
                    if (outlet.supportsDineIn) ...[
                      const SizedBox(width: 4),
                      _buildSmallTag('Dine-In'),
                    ],
                  ],
                ),

                // Action Buttons
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OutletDetailScreen(outlet: outlet),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Text(
                          'Detail',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: () => _onSelectOutlet(outlet),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCurrentActive ? const Color(0xFF2E7D32) : AppColors.primaryContainer,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Text(
                        isCurrentActive ? 'Dipilih ✓' : 'Pilih Outlet',
                        style: const TextStyle(
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
      ),
    );
  }

  Widget _buildSmallTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        ),
      ),
    );
  }

  Widget _buildSimulatedMapView(List<OutletModel> outlets) {
    return Stack(
      children: [
        // Simulated Interactive Stylized Map Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFE5E3DF),
          child: Stack(
            children: [
              // Stylized Road lines
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapGridPainter(),
                ),
              ),

              // Outlet Map Pins
              ...outlets.asMap().entries.map((entry) {
                final index = entry.key;
                final outlet = entry.value;
                final isSelected = outlet.id == _activeSelectedOutlet.id;

                // Position pins across the map area
                final topPos = 60.0 + (index % 4) * 85.0;
                final leftPos = 40.0 + (index * 70.0) % 240.0;

                return Positioned(
                  top: topPos,
                  left: leftPos,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeSelectedOutlet = outlet;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryContainer : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Text(
                            outlet.name.split(' ').first,
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.location_on_rounded,
                          size: isSelected ? 36 : 28,
                          color: isSelected ? AppColors.primaryContainer : const Color(0xFFD32F2F),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        // Floating Active Outlet Card at Bottom
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: _buildOutletCard(_activeSelectedOutlet, true),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.storefront_rounded, size: 48, color: AppColors.primaryContainer),
            ),
            const SizedBox(height: 16),
            const Text(
              'Outlet Tidak Ditemukan',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba gunakan kata kunci lain atau ubah filter pencarianmu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 12,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedFilter = 'Semua';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Reset Filter'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simulated Map Painter for Map View
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFFAF7F2)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final secondaryRoadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final waterPaint = Paint()
      ..color = const Color(0xFFC7DCF0)
      ..style = PaintingStyle.fill;

    // Stylized river/lake
    final waterPath = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.3, size.width * 0.3, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.9, 0, size.height * 0.85)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Diagonal Main Arterial Road
    canvas.drawLine(
      const Offset(-20, 100),
      Offset(size.width + 20, size.height - 80),
      roadPaint,
    );

    // Secondary Cross Roads
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.8, size.height),
      secondaryRoadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.45),
      secondaryRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
