import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'onboarding_screen.dart';

/// Splash Screen designed strictly to match Stitch Screen:
/// projects/12118509048000968690/screens/4e62d6239a374db29037b44129f08ef4
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  Timer? _navigationTimer;

  static const String _logoUrl =
      'https://lh3.googleusercontent.com/aida/AEtjO1UG2rPiAh9o0lsbzoUvgaGrnbvK1ZXbyURSCdhkp3M-B2FkPc5GOomfPL426ZLBk788zl4Xnt7rv9zFbcpxUWzk4KKi3uLz7x9zeKNMA6tRoNSL-7JJSjOoRvpCeeUNgpZ6aAMWT7pMqJVvB5f54r2V0HPm1G08_srPrrTz9e4V3-TjHA7CSU4V2fLBsnCd8jo-B09lyvEhGrDNnwxFAq_UedcHFTxn1abbxk1dyMlU2E6ViW2iF-skX2B4';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _navigationTimer = Timer(const Duration(milliseconds: 2800), _goToOnboarding);
  }

  void _goToOnboarding() {
    if (!mounted) return;
    _navigationTimer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: GestureDetector(
        onTap: _goToOnboarding,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top placeholder to balance the layout
                const SizedBox(height: 32),

                // Center: Logo with glowing ambient aura, title & tagline
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ambient warm radiance halo
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryFixed.withValues(
                                    alpha: _opacityAnimation.value,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryFixed.withValues(
                                        alpha: _opacityAnimation.value * 0.8,
                                      ),
                                      blurRadius: 36,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Logo Container
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              _logoUrl,
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryContainer,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.local_cafe_rounded,
                                    size: 56,
                                    color: AppColors.primaryContainer,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // App Title
                    const Text(
                      'Kopi Kangenan',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    const Text(
                      'Kopi Great. Tanpa Antri.',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                        letterSpacing: 0,
                        height: 1.42,
                      ),
                    ),
                  ],
                ),

                // Bottom: 3 Bouncing Dots Loading Indicator
                const Padding(
                  padding: EdgeInsets.only(bottom: 24, top: 16),
                  child: BouncingDotsLoading(
                    color: AppColors.primaryContainer,
                    size: 8.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 3 Bouncing dots loading indicator matching Stitch's CSS bounce
class BouncingDotsLoading extends StatefulWidget {
  final Color color;
  final double size;

  const BouncingDotsLoading({
    super.key,
    required this.color,
    this.size = 8.0,
  });

  @override
  State<BouncingDotsLoading> createState() => _BouncingDotsLoadingState();
}

class _BouncingDotsLoadingState extends State<BouncingDotsLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Stagger phase offset: 0.0, 0.22, 0.44
        final double delay = index * 0.22;
        double progress = (_controller.value - delay);
        if (progress < 0.0) progress += 1.0;

        // Bounce curve simulation
        final double translationY = (progress < 0.5)
            ? -6.0 * (1.0 - (progress * 2 - 0.5).abs() * 2)
            : 0.0;

        return Transform.translate(
          offset: Offset(0, translationY),
          child: Container(
            width: widget.size,
            height: widget.size,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        _buildDot(1),
        _buildDot(2),
      ],
    );
  }
}
