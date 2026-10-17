import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'otp_verification_screen.dart';

/// Login Screen strictly matching Stitch Screen:
/// projects/12118509048000968690/screens/f04e8624da4d4604985578d9594c1256
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isValidPhone = false;
  late final AnimationController _heartAnimController;
  late final Animation<double> _heartScaleAnimation;

  static const String _fontFamily = 'Plus Jakarta Sans';

  @override
  void initState() {
    super.initState();

    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _heartScaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _heartAnimController, curve: Curves.easeOutBack),
    );

    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    String text = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (text.startsWith('0')) {
      text = text.substring(1);
      _phoneController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    final isValid = text.length >= 9;
    if (isValid != _isValidPhone) {
      setState(() {
        _isValidPhone = isValid;
      });
    }
  }

  void _onHeartTapped() {
    _heartAnimController.forward().then((_) {
      _heartAnimController.reverse();
    });
  }

  void _onSubmit() {
    final rawNumber = _phoneController.text.trim();
    if (rawNumber.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal 9 digit nomor handphone yang valid'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      _phoneFocusNode.requestFocus();
      return;
    }

    final formattedPhone = '+62 $rawNumber';
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            OtpVerificationScreen(phoneNumber: formattedPhone),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    _heartAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back Button & Brand Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 28,
                      color: AppColors.onSurface,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_cafe_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'KOPI KANGENAN',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 28), // Balance spacing
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Centered Brand Icon Delight
                    GestureDetector(
                      onTap: _onHeartTapped,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Warm Radiance Blur Glow
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryFixed.withValues(alpha: 0.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryFixed.withValues(
                                    alpha: 0.6,
                                  ),
                                  blurRadius: 28,
                                  spreadRadius: 6,
                                ),
                              ],
                            ),
                          ),

                          // Brand Icon Badge
                          AnimatedBuilder(
                            animation: _heartScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _heartScaleAnimation.value,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomPaint(
                                      size: const Size(32, 32),
                                      painter: _KopiHeartPainter(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Little Floating Sparkle Toast
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Rasa yang Bikin Kangen',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF410003),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title & Subtitle
                    const Text(
                      'Masuk / Daftar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masukkan nomor handphone kamu untuk pesan kopi favoritmu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Phone Input Component
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nomor Handphone',
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              'Verifikasi via WhatsApp/SMS',
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 11,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Input Box Group
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isValidPhone
                                  ? AppColors.primaryContainer
                                  : AppColors.borderInactive,
                              width: _isValidPhone ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Country Prefix Box
                              Container(
                                height: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    bottomLeft: Radius.circular(7),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Text('🇮🇩', style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 6),
                                    Text(
                                      '+62',
                                      style: TextStyle(
                                        fontFamily: _fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 18,
                                      color: AppColors.secondary,
                                    ),
                                  ],
                                ),
                              ),

                              // Text Input
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(13),
                                  ],
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '812-3456-7890',
                                    hintStyle: TextStyle(
                                      fontFamily: _fontFamily,
                                      fontSize: 14,
                                      color: AppColors.secondary.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                  onSubmitted: (_) => _onSubmit(),
                                ),
                              ),

                              // Clear Button
                              if (_phoneController.text.isNotEmpty)
                                IconButton(
                                  onPressed: () {
                                    _phoneController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.cancel_rounded,
                                    size: 18,
                                    color: AppColors.secondary,
                                  ),
                                  splashRadius: 18,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Helper Row Feedback
                        Row(
                          children: [
                            Icon(
                              _isValidPhone
                                  ? Icons.check_circle_rounded
                                  : Icons.lock_rounded,
                              size: 13,
                              color: _isValidPhone
                                  ? AppColors.primaryContainer
                                  : AppColors.secondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _isValidPhone
                                  ? 'Nomor siap diverifikasi via WhatsApp/SMS'
                                  : 'Kode OTP rahasia akan dikirimkan otomatis',
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 11,
                                fontWeight: _isValidPhone
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: _isValidPhone
                                    ? AppColors.primaryContainer
                                    : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lanjut Konfirmasi',
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onPrimary,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: AppColors.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Visual Separator Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: AppColors.surfaceContainerHigh,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'ATAU',
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: AppColors.surfaceContainerHigh,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Secondary Social Button: Google
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menghubungkan akun Google...'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.surfaceContainerLowest,
                          side: const BorderSide(
                            color: AppColors.borderInactive,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(20, 20),
                              painter: _GoogleLogoPainter(),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Lanjutkan dengan Google',
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Warm Coffee Perk Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.redeem_rounded,
                              size: 20,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gratis Kopi Susu Kangenan',
                                  style: TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF410003),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Klaim voucher khusus setelah pendaftaran pertamamu',
                                  style: TextStyle(
                                    fontFamily: _fontFamily,
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Footer Agreements
                    const Text(
                      'Dengan masuk, kamu menyetujui Syarat & Ketentuan serta Kebijakan Privasi Kopi Kangenan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        color: AppColors.secondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Painter for Kopi Heart with steam curves
class _KopiHeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final heartPaint = Paint()
      ..color = AppColors.primaryContainer
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.88);
    path.cubicTo(
      size.width * 0.1,
      size.height * 0.58,
      0,
      size.height * 0.35,
      size.width * 0.28,
      size.height * 0.14,
    );
    path.cubicTo(
      size.width * 0.45,
      size.height * 0.14,
      size.width * 0.5,
      size.height * 0.28,
      size.width * 0.5,
      size.height * 0.28,
    );
    path.cubicTo(
      size.width * 0.5,
      size.height * 0.28,
      size.width * 0.55,
      size.height * 0.14,
      size.width * 0.72,
      size.height * 0.14,
    );
    path.cubicTo(
      size.width * 1.0,
      size.height * 0.35,
      size.width * 0.9,
      size.height * 0.58,
      size.width * 0.5,
      size.height * 0.88,
    );
    path.close();
    canvas.drawPath(path, heartPaint);

    // Steam aroma slash strokes
    final steamPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final steam1 = Path();
    steam1.moveTo(size.width * 0.42, size.height * 0.32);
    steam1.quadraticBezierTo(
      size.width * 0.48,
      size.height * 0.44,
      size.width * 0.56,
      size.height * 0.56,
    );
    canvas.drawPath(steam1, steamPaint);

    final steam2 = Path();
    steam2.moveTo(size.width * 0.32, size.height * 0.38);
    steam2.quadraticBezierTo(
      size.width * 0.38,
      size.height * 0.46,
      size.width * 0.42,
      size.height * 0.52,
    );
    canvas.drawPath(steam2, steamPaint..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Google Logo Multi-Color Painter
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale);

    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final redPaint = Paint()..color = const Color(0xFFEA4335);

    // Blue section
    final bluePath = Path()
      ..moveTo(22.56, 12.25)
      ..cubicTo(22.56, 11.47, 22.49, 10.72, 22.36, 10.0)
      ..lineTo(12.0, 10.0)
      ..lineTo(12.0, 14.26)
      ..lineTo(17.92, 14.26)
      ..cubicTo(17.66, 15.63, 16.88, 16.79, 15.71, 17.57)
      ..lineTo(19.28, 20.34)
      ..cubicTo(21.36, 18.42, 22.56, 15.6, 22.56, 12.25)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // Green section
    final greenPath = Path()
      ..moveTo(12.0, 23.0)
      ..cubicTo(14.97, 23.0, 17.46, 22.02, 19.28, 20.34)
      ..lineTo(15.71, 17.57)
      ..cubicTo(14.73, 18.23, 13.48, 18.63, 12.0, 18.63)
      ..cubicTo(9.14, 18.63, 6.71, 16.7, 5.84, 14.1)
      ..lineTo(2.18, 16.94)
      ..cubicTo(3.99, 20.53, 7.7, 23.0, 12.0, 23.0)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Yellow section
    final yellowPath = Path()
      ..moveTo(5.84, 14.09)
      ..cubicTo(5.62, 13.43, 5.49, 12.73, 5.49, 12.0)
      ..cubicTo(5.49, 11.27, 5.62, 10.57, 5.84, 9.91)
      ..lineTo(2.18, 7.07)
      ..cubicTo(1.43, 8.56, 1.0, 10.23, 1.0, 12.0)
      ..cubicTo(1.0, 13.77, 1.43, 15.44, 2.18, 16.93)
      ..lineTo(5.84, 14.09)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Red section
    final redPath = Path()
      ..moveTo(12.0, 5.38)
      ..cubicTo(13.62, 5.38, 15.06, 5.94, 16.21, 7.02)
      ..lineTo(19.36, 3.87)
      ..cubicTo(17.45, 2.09, 14.97, 1.0, 12.0, 1.0)
      ..cubicTo(7.7, 1.0, 3.99, 3.47, 2.18, 7.06)
      ..lineTo(5.84, 9.9)
      ..cubicTo(6.71, 7.3, 9.14, 5.38, 12.0, 5.38)
      ..close();
    canvas.drawPath(redPath, redPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
