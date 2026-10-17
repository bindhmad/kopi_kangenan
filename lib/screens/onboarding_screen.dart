import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

/// Onboarding Screen strictly matching Stitch Screen:
/// projects/12118509048000968690/screens/11d2493699eb4974b79db6a0ab3ad442
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  static const String _fontFamily = 'Plus Jakarta Sans';

  static const String _onboardingImg1 =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAvyBCcCfv9ENJn-42ApV03Ba44_d1lqhN8qQeoVrmLRsMGY-gXaonW-cgkMdVQcRawBrCwS0ySCQcgbxmiY8bi5WtcdTg3S5Au-LLXLNJVisccudt1xc0JNZNEsDYVCwUyZ_bSEeJxssrVUjDC8YuVie-aXUTm05GjSetYQxT5wXvCeJO4buCDdU6J4W6EFY0KoRrUSDwwsU6WLv6P92ghjpF-vS8v7jcufx8anUxVw3sYpnRv162NgA';

  static const String _onboardingImg2 =
      'https://lh3.googleusercontent.com/aida/AEtjO1Welu50kchS0juGHN4gmW8lUMfern9STITSDHUqZAckCGleZIv8X1o59JdcHhr1HHrj_oi7T3gE3T7S8DySc83cRgCsVtVJR3JUG7uhsPp5968y9MiB80gB4koInz0OT99zdo-CbpQMvtOMbGhczagolP7pCKFfEv4KUJJxKiNqiR9AryXN6zH76mDcrMoRMkXiXHkH6w0FNylpr6-YTRc9B94lZYcrJAsr4xVCONwoHkKueISkfRg-OUAf';

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goToLogin();
    }
  }

  void _onSkipPressed() {
    _goToLogin();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Logo Icon + Brand Title & "Lewati" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo + Brand Name
                  const Row(
                    children: [
                      Icon(
                        Icons.local_cafe_rounded,
                        color: AppColors.primaryContainer,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Kopi Kangenan',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),

                  // Skip Action
                  TextButton(
                    onPressed: _currentPage == 2 ? null : _onSkipPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _currentPage == 2
                            ? Colors.transparent
                            : AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Middle Carousel: PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // Slide 1: Primary Onboarding from Stitch
                  _buildSlide(
                    imageUrl: _onboardingImg1,
                    title: 'Pesan Kopi Favoritmu',
                    description:
                        'Pilih dari puluhan menu kopi, sesuaikan sesuai selera, dan pesan tanpa antri.',
                    badges: const [
                      _BadgeData(icon: Icons.bolt_rounded, label: 'Cepat Saji'),
                      _BadgeData(icon: Icons.tune_rounded, label: 'Bisa Kustom'),
                      _BadgeData(icon: Icons.loyalty_rounded, label: 'Poin Hadiah'),
                    ],
                  ),

                  // Slide 2: Kustomisasi & Pilihan Rasa
                  _buildSlide(
                    imageUrl: _onboardingImg2,
                    title: 'Kustom Sesuai Selera',
                    description:
                        'Atur tingkat manis, takaran es, hingga pilihan susu plant-based favoritmu dengan mudah.',
                    badges: const [
                      _BadgeData(icon: Icons.water_drop_rounded, label: 'Less Sugar'),
                      _BadgeData(icon: Icons.ac_unit_rounded, label: 'Ice Level'),
                      _BadgeData(icon: Icons.eco_rounded, label: 'Oat Milk'),
                    ],
                  ),

                  // Slide 3: Ambil Cepat & Promo
                  _buildSlide(
                    iconFallback: Icons.storefront_rounded,
                    title: 'Ambil di Outlet Terdekat',
                    description:
                        'Pesan lebih awal lewat aplikasi, ambil saat tiba di outlet tanpa perlu menunggu antrian.',
                    badges: const [
                      _BadgeData(icon: Icons.near_me_rounded, label: 'GPS Outlet'),
                      _BadgeData(icon: Icons.qr_code_scanner_rounded, label: 'Pickup QR'),
                      _BadgeData(icon: Icons.confirmation_number_rounded, label: 'Cashback 70%'),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Navigation & CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Carousel Step Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final bool isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 24 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryContainer
                              : AppColors.secondaryFixed,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryContainer
                                        .withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Primary Action CTA
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == 2 ? 'Mulai Sekarang' : 'Lanjut',
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: AppColors.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide({
    String? imageUrl,
    IconData? iconFallback,
    required String title,
    required String description,
    required List<_BadgeData> badges,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),

                  // Illustration Container with Ambient Glow & Floating Heart
                  SizedBox(
                    width: 256,
                    height: 256,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Ambient warm radiance
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryFixed.withValues(alpha: 0.35),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryFixed.withValues(alpha: 0.45),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),

                        // Card surface with illustration
                        Container(
                          width: 236,
                          height: 236,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: imageUrl != null
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(
                                          child: SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryContainer,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            iconFallback ?? Icons.coffee_rounded,
                                            size: 96,
                                            color: AppColors.primaryContainer,
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Icon(
                                        iconFallback ?? Icons.coffee_rounded,
                                        size: 96,
                                        color: AppColors.primaryContainer,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        // Floating Aroma Heart Particle Accent
                        Positioned(
                          top: 4,
                          right: 18,
                          child: AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatAnimation.value),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryContainer
                                            .withValues(alpha: 0.18),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.favorite_rounded,
                                    size: 20,
                                    color: AppColors.primaryContainer,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Feature Mini Badges
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: badges.map((badge) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              badge.icon,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              badge.label,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BadgeData {
  final IconData icon;
  final String label;

  const _BadgeData({required this.icon, required this.label});
}
