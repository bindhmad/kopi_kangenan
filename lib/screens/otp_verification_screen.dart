import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';

/// OTP Verification Screen strictly matching Stitch Screen:
/// projects/12118509048000968690/screens/e88541d4e44941368c034a166e9dd4e7
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _otpDigits = [];
  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;

  Timer? _countdownTimer;
  int _secondsRemaining = 59;
  bool _canResend = false;

  static const String _fontFamily = 'Plus Jakarta Sans';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _secondsRemaining = 59;
      _canResend = false;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _countdownTimer?.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _onKeyPressed(String key) {
    if (key == 'backspace') {
      if (_otpDigits.isNotEmpty) {
        setState(() {
          _otpDigits.removeLast();
        });
      }
    } else if (_otpDigits.length < 6) {
      setState(() {
        _otpDigits.add(key);
      });

      if (_otpDigits.length == 6) {
        _verifyOtp();
      }
    }
  }

  void _onResendOtp() {
    if (!_canResend) return;

    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode OTP baru telah dikirim ke ${widget.phoneNumber}'),
        backgroundColor: AppColors.primaryContainer,
      ),
    );
  }

  void _verifyOtp() {
    if (_otpDigits.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 6 digit kode OTP secara lengkap'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    final code = _otpDigits.join();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2E7D32),
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Verifikasi Berhasil!',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kode $code berhasil diverifikasi. Selamat datang kembali di Kopi Kangenan!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: _fontFamily,
                fontSize: 13,
                color: AppColors.secondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(isLoggedIn: true),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Masuk ke Beranda',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerString =
        '00:${_secondsRemaining.toString().padLeft(2, '0')}';

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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 24,
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
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'KOPI KANGENAN',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // Middle Content: Badges, Header & OTP Slots
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Central Delight Badge / Illustration
                    Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ambient Warm Halo with breathing scale
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseScale.value,
                                  child: Container(
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryFixed.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Red Icon Circle Badge
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryContainer,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryContainer
                                        .withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.sms_rounded,
                                size: 28,
                                color: AppColors.onPrimary,
                              ),
                            ),

                            // Floating Lock Badge at bottom-right
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surfaceContainerLowest,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header Text
                    const Text(
                      'Verifikasi Kode',
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
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 14,
                          color: AppColors.secondary,
                          height: 1.45,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Masukkan 6 digit kode yang dikirim ke ',
                          ),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 6-Digit OTP Slots Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final bool hasDigit = index < _otpDigits.length;
                        final bool isCurrent = index == _otpDigits.length;
                        final String digit =
                            hasDigit ? _otpDigits[index] : '';

                        return Container(
                          width: 46,
                          height: 54,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCurrent
                                  ? AppColors.primaryContainer
                                  : (hasDigit
                                      ? AppColors.primaryContainer
                                          .withValues(alpha: 0.4)
                                      : AppColors.borderInactive),
                              width: isCurrent ? 2.0 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isCurrent
                                    ? AppColors.primaryContainer
                                        .withValues(alpha: 0.12)
                                    : Colors.black.withValues(alpha: 0.03),
                                blurRadius: isCurrent ? 6 : 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: hasDigit
                                ? Text(
                                    digit,
                                    style: const TextStyle(
                                      fontFamily: _fontFamily,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurface,
                                    ),
                                  )
                                : (isCurrent
                                    ? Container(
                                        width: 2,
                                        height: 22,
                                        color: AppColors.primary,
                                      )
                                    : const SizedBox.shrink()),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),

                    // Countdown Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 6),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 13,
                              color: AppColors.secondary,
                            ),
                            children: [
                              const TextSpan(text: 'Kirim ulang kode dalam '),
                              TextSpan(
                                text: timerString,
                                style: const TextStyle(
                                  fontFamily: _fontFamily,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons: Verify & Resend
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Verifikasi',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: _canResend ? _onResendOtp : null,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      child: Text(
                        'Kirim Ulang Kode',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _canResend
                              ? AppColors.primary
                              : AppColors.secondary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Virtual Mobile Numeric Keypad matching Stitch design
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle indicator bar
                  Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryFixedDim,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),

                  // Keypad grid
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: Column(
                      children: [
                        _buildKeypadRow(['1', '2', '3'], ['', 'ABC', 'DEF']),
                        const SizedBox(height: 6),
                        _buildKeypadRow(['4', '5', '6'], ['GHI', 'JKL', 'MNO']),
                        const SizedBox(height: 6),
                        _buildKeypadRow(['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ']),
                        const SizedBox(height: 6),
                        _buildBottomKeypadRow(),
                      ],
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

  Widget _buildKeypadRow(List<String> digits, List<String> letters) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _KeypadButton(
              digit: digits[index],
              subtext: letters[index],
              onTap: () => _onKeyPressed(digits[index]),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomKeypadRow() {
    return Row(
      children: [
        const Expanded(child: SizedBox(height: 48)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _KeypadButton(
              digit: '0',
              subtext: '',
              onTap: () => _onKeyPressed('0'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onKeyPressed('backspace'),
                borderRadius: BorderRadius.circular(8),
                child: const SizedBox(
                  height: 48,
                  child: Center(
                    child: Icon(
                      Icons.backspace_outlined,
                      size: 22,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Keypad Button widget with subtle shadow and tactile press
class _KeypadButton extends StatelessWidget {
  final String digit;
  final String subtext;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.digit,
    required this.subtext,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(8),
      elevation: 0.5,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                digit,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  height: 1.1,
                ),
              ),
              if (subtext.isNotEmpty)
                Text(
                  subtext,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: AppColors.secondary,
                    height: 1.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
