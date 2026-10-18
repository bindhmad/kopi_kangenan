import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'vip_screen.dart';

/// Profil Screen (Saya)
/// Strictly fulfills PRD requirements:
/// - User profile info & edit
/// - VIP membership status & progress
/// - Daily Check-In 6-day streak with rewards
/// - Quick shortcuts (Riwayat, Voucher, Alamat, Metode Pembayaran)
/// - App preferences & Logout
class ProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String initialEmail;

  const ProfileScreen({
    super.key,
    this.initialName = 'Davit Hengky',
    this.initialPhone = '+62 812-3456-7890',
    this.initialEmail = 'davit.hengky@kangenan.id',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _fontFamily = 'Plus Jakarta Sans';

  late String _userName;
  late String _userPhone;
  late String _userEmail;

  int _kangenanPoints = 1250;
  bool _hasCheckedInToday = false;
  final int _activeDayStreak = 3; // Day 3 is today

  bool _pushNotifications = true;
  String _selectedLanguage = 'Bahasa Indonesia';

  static const String _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCRgVw2TCY502RhhuqjqS-eviu0i83HXgYQKekl4pjh3Urp3gnJOj2nQHUucdzW1KwnBaXlC1L5lKrCWD4CszSS32U4JDWf1U24aM6MhkkQRDk71XxRlDEUFl3efbty9_WAbMx4zetk404nRFZVKgQENElOGziiahMGtunszGAgGoa_GkG7fc8CtU3546tRV-M_bDIGHGRf9V40s5558P5mCWF6Ry7zT1qupcUzQsNTmkXylMVEziEbRQ';

  @override
  void initState() {
    super.initState();
    _userName = widget.initialName;
    _userPhone = widget.initialPhone;
    _userEmail = widget.initialEmail;
  }

  void _claimDailyCheckIn() {
    if (_hasCheckedInToday) return;

    setState(() {
      _hasCheckedInToday = true;
      _kangenanPoints += 100;
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8E1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration_rounded, size: 48, color: Color(0xFFFFB300)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Check-In Berhasil! 🎉',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamu mendapatkan Voucher Diskon 20% + 100 Poin Kangenan!',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: _fontFamily, fontSize: 13, color: AppColors.secondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Klaim & Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfileModal() {
    final nameCtrl = TextEditingController(text: _userName);
    final phoneCtrl = TextEditingController(text: _userPhone);
    final emailCtrl = TextEditingController(text: _userEmail);

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
                  'Ubah Data Profil',
                  style: TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(
                labelText: 'Nomor WhatsApp / HP',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Alamat Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _userName = nameCtrl.text.trim();
                    _userPhone = phoneCtrl.text.trim();
                    _userEmail = emailCtrl.text.trim();
                  });
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui!'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Akun?', style: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w700)),
        content: const Text('Kamu perlu masuk kembali untuk mengakses poin dan promo eksklusifmu.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
            child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
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
          'Profil Saya',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryContainer),
            onPressed: _editProfileModal,
            tooltip: 'Ubah Profil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Card & Tier Overview
            _buildUserHeaderCard(),

            const SizedBox(height: 12),

            // Daily Check-In Widget (F44)
            _buildDailyCheckInCard(),

            const SizedBox(height: 12),

            // Quick Shortcut Cards Grid (Riwayat, Voucher, Alamat, Metode)
            _buildShortcutsGrid(),

            const SizedBox(height: 12),

            // VIP Benefits Card
            _buildVipMembershipBanner(),

            const SizedBox(height: 12),

            // App Settings & Account Actions
            _buildSettingsList(),

            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(),

            const SizedBox(height: 16),

            // Version info
            const Text(
              'Kopi Kangenan App • Versi 1.0.0 (UTS PAB)',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
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
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Image.network(
                      _avatarUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 56,
                        height: 56,
                        color: AppColors.primaryFixed,
                        child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _userPhone,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      _userEmail,
                      style: const TextStyle(
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
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Loyalty Points & Tier Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF8E1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.toll_rounded, size: 18, color: Color(0xFFFFB300)),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Poin Kangenan',
                        style: TextStyle(fontFamily: _fontFamily, fontSize: 10, color: AppColors.secondary),
                      ),
                      Text(
                        '$_kangenanPoints pts',
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD1D1D1)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_rounded, size: 14, color: Color(0xFF616161)),
                    SizedBox(width: 4),
                    Text(
                      'Silver Member',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF424242),
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
  }

  Widget _buildDailyCheckInCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primaryContainer),
                  SizedBox(width: 6),
                  Text(
                    'Daily Check-In',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                'Streak: $_activeDayStreak Hari',
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 6-Day Streak Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final dayNum = index + 1;
              final isPassed = dayNum < _activeDayStreak || (dayNum == _activeDayStreak && _hasCheckedInToday);
              final isToday = dayNum == _activeDayStreak && !_hasCheckedInToday;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 5 ? 6 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isPassed
                        ? const Color(0xFFE8F5E9)
                        : (isToday ? AppColors.primaryFixed.withValues(alpha: 0.5) : AppColors.surfaceContainerLow),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isToday
                          ? AppColors.primaryContainer
                          : (isPassed ? const Color(0xFF81C784) : Colors.transparent),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'H$dayNum',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isPassed ? const Color(0xFF2E7D32) : AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        isPassed
                            ? Icons.check_circle_rounded
                            : (dayNum == 3 || dayNum == 6 ? Icons.confirmation_number_rounded : Icons.toll_rounded),
                        size: 16,
                        color: isPassed
                            ? const Color(0xFF2E7D32)
                            : (dayNum == 3 || dayNum == 6 ? const Color(0xFFFFB300) : AppColors.secondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dayNum == 3 || dayNum == 6 ? 'Voucher' : '+25',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isPassed ? const Color(0xFF2E7D32) : AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Check-in Button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              onPressed: _hasCheckedInToday ? null : _claimDailyCheckIn,
              icon: Icon(
                _hasCheckedInToday ? Icons.check_rounded : Icons.touch_app_rounded,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                _hasCheckedInToday ? 'Sudah Check-In Hari Ini' : 'Check-In Sekarang & Klaim Reward',
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasCheckedInToday ? const Color(0xFF2E7D32) : AppColors.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildShortcutCard(
            icon: Icons.receipt_long_rounded,
            title: 'Riwayat',
            badge: '1 Aktif',
            color: const Color(0xFF1976D2),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Membuka Riwayat Pesanan...'))),
          ),
          const SizedBox(width: 8),
          _buildShortcutCard(
            icon: Icons.confirmation_number_outlined,
            title: 'Voucher',
            badge: '4 Kupon',
            color: const Color(0xFFD32F2F),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VipScreen(initialTab: 0, userName: _userName),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildShortcutCard(
            icon: Icons.place_outlined,
            title: 'Alamat',
            badge: '2 Lokasi',
            color: const Color(0xFF388E3C),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Membuka Alamat Tersimpan...'))),
          ),
          const SizedBox(width: 8),
          _buildShortcutCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Bayar',
            badge: 'QRIS',
            color: const Color(0xFF7B1FA2),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Membuka Metode Pembayaran...'))),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard({
    required IconData icon,
    required String title,
    required String badge,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                badge,
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVipMembershipBanner() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VipScreen(initialTab: 2, userName: _userName),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD54F), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Kopi Kangenan VIP Club',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Lihat Keuntungan >',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFD54F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Belanja Rp125.000 lagi untuk naik ke Gold Member & nikmati cashback 5% + voucher ulang tahun!',
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 11,
                color: Color(0xFFD1D1D1),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(
                value: 0.65,
                backgroundColor: Color(0xFF4A4A4A),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD54F)),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Ubah Data Profil',
            subtitle: 'Nama, Email, dan Nomor Telepon',
            onTap: _editProfileModal,
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.support_agent_rounded,
            title: 'Pusat Bantuan & Layanan Konsumen',
            subtitle: 'Hubungi WhatsApp resmi Kopi Kangenan',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka Customer Service WhatsApp Kangenan...')),
              );
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
            activeThumbColor: AppColors.primaryContainer,
            secondary: const Icon(Icons.notifications_outlined, color: AppColors.primaryContainer),
            title: const Text(
              'Notifikasi Promo & Pesanan',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Dapatkan info diskon kilat dan status kopi',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 11, color: AppColors.secondary),
            ),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.language_rounded,
            title: 'Pilihan Bahasa',
            subtitle: _selectedLanguage,
            onTap: () {
              setState(() {
                _selectedLanguage = _selectedLanguage == 'Bahasa Indonesia' ? 'English' : 'Bahasa Indonesia';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bahasa diubah ke $_selectedLanguage')),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Syarat & Kebijakan Privasi',
            subtitle: 'Pelajari hak dan data keamanan pengguna',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menampilkan Syarat & Ketentuan...')),
              );
            },
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryContainer, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
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
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondary, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton.icon(
          onPressed: _showLogoutDialog,
          icon: const Icon(Icons.logout_rounded, color: Color(0xFFC62828), size: 18),
          label: const Text(
            'Keluar dari Akun',
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC62828),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFC62828)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
