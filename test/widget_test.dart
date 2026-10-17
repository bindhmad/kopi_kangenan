import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopi_kangenan/screens/login_screen.dart';
import 'package:kopi_kangenan/screens/otp_verification_screen.dart';
import 'package:kopi_kangenan/screens/home_screen.dart';
import 'package:kopi_kangenan/screens/menu_screen.dart';
import 'package:kopi_kangenan/screens/product_detail_screen.dart';
import 'package:kopi_kangenan/screens/cart_checkout_screen.dart';
import 'package:kopi_kangenan/screens/cart_screen.dart';
import 'package:kopi_kangenan/screens/outlet_list_screen.dart';
import 'package:kopi_kangenan/screens/outlet_detail_screen.dart';
import 'package:kopi_kangenan/screens/profile_screen.dart';
import 'package:kopi_kangenan/screens/order_status_screen.dart';
import 'package:kopi_kangenan/main.dart';

void main() {
  testWidgets('App loads Splash Screen and displays brand title', (WidgetTester tester) async {
    await tester.pumpWidget(const KopiKangenanApp());
    expect(find.text('Kopi Kangenan'), findsWidgets);
    expect(find.text('Kopi Great. Tanpa Antri.'), findsOneWidget);
  });

  testWidgets('LoginScreen renders phone input and action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('Masuk / Daftar'), findsOneWidget);
    expect(find.text('+62'), findsOneWidget);
    expect(find.text('Lanjut Konfirmasi'), findsOneWidget);
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
  });

  testWidgets('OtpVerificationScreen renders 6-digit slots and keypad', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OtpVerificationScreen(phoneNumber: '+62 812-3456-7890'),
      ),
    );

    expect(find.text('Verifikasi Kode'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('+62 812-3456-7890'),
      ),
      findsOneWidget,
    );
    expect(find.text('Verifikasi'), findsOneWidget);
    expect(find.text('Kirim Ulang Kode'), findsOneWidget);
  });

  testWidgets('HomeScreen renders greeting, outlet, and promo sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(isLoggedIn: true, userName: 'Davit Hengky'),
      ),
    );

    expect(find.text('Hai, Davit Hengky'), findsOneWidget);
    expect(find.text('Diponegoro Surabaya'), findsOneWidget);
    expect(find.text('Double Cashback 70%'), findsOneWidget);
    expect(find.text('Spesial Hari Ini'), findsOneWidget);
    expect(find.text('Diskon & Cashback'), findsOneWidget);
  });

  testWidgets('MenuScreen renders category tabs and product items', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MenuScreen(initialCategory: 'Coffee'),
      ),
    );

    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('OG Aren Spesial Latte'), findsOneWidget);
  });

  testWidgets('ProductDetailScreen renders customization options and updates total price', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailScreen(),
      ),
    );

    expect(find.text('Detail Produk'), findsOneWidget);
    expect(find.text('OG Aren Spesial Latte'), findsOneWidget);
    expect(find.text('Suhu'), findsOneWidget);
    expect(find.text('Ukuran Gelas'), findsOneWidget);
    expect(find.text('Pilihan Biji Kopi'), findsOneWidget);
    expect(find.text('Pilihan Susu'), findsOneWidget);
    expect(find.text('Level Manis'), findsOneWidget);
    expect(find.text('Level Es'), findsOneWidget);
    expect(find.text('Pilihan Topping & Sirup'), findsOneWidget);
    expect(find.text('Catatan Tambahan'), findsOneWidget);
    expect(find.text('+ Keranjang Rp24.000'), findsOneWidget);

    // Tap '+' on quantity stepper
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    // Price should now be 24.000 * 2 = 48.000
    expect(find.text('+ Keranjang Rp48.000'), findsOneWidget);
  });

  testWidgets('CartCheckoutScreen renders checkout order summary and payment methods', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CartCheckoutScreen(),
      ),
    );

    expect(find.text('Checkout Pesanan'), findsOneWidget);
    expect(find.text('Diponegoro Surabaya'), findsOneWidget);
    expect(find.text('Siap 15 Menit'), findsOneWidget);
    expect(find.text('Kangenan Points'), findsOneWidget);
    expect(find.text('Pembayaran Langsung'), findsOneWidget);
    expect(find.text('Rincian Pembayaran'), findsOneWidget);
    expect(find.text('Konfirmasi Pesanan'), findsOneWidget);
  });

  testWidgets('CartCheckoutScreen renders empty cart state when no items', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CartCheckoutScreen(initialItems: []),
      ),
    );

    expect(find.text('Keranjang Belanja'), findsOneWidget);
    expect(find.text('Keranjang kamu masih kosong'), findsOneWidget);
    expect(find.text('Mulai Pesan'), findsOneWidget);
    expect(find.text('Atau coba menu terlaris kami'), findsOneWidget);
  });

  testWidgets('CartScreen renders item list, modifiers, and summary', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );

    expect(find.text('Keranjang Belanja'), findsOneWidget);
    expect(find.text('OG Aren Spesial Latte'), findsOneWidget);
    expect(find.text('Triple Cheese Bagel'), findsOneWidget);
    expect(find.text('Tukar Kangenan Points'), findsOneWidget);
    expect(find.text('Ringkasan Pembayaran'), findsOneWidget);
    expect(find.text('Lanjut ke Pembayaran'), findsOneWidget);
  });

  testWidgets('OutletListScreen renders outlets and search filter', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OutletListScreen(),
      ),
    );

    expect(find.text('Pilih Outlet'), findsWidgets);
    expect(find.text('Diponegoro Surabaya'), findsOneWidget);
    expect(find.text('Lippo Mall Puri'), findsOneWidget);
    expect(find.text('Menara Standard Chartered'), findsOneWidget);
  });

  testWidgets('OutletDetailScreen renders outlet details and facilities', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OutletDetailScreen(),
      ),
    );

    expect(find.text('Diponegoro Surabaya'), findsOneWidget);
    expect(find.text('Alamat Lengkap Outlet'), findsOneWidget);
    expect(find.text('Layanan yang Tersedia'), findsOneWidget);
    expect(find.text('Fasilitas Outlet'), findsOneWidget);
    expect(find.text('Pesan dari Outlet Ini'), findsOneWidget);
  });

  testWidgets('ProfileScreen renders user profile and daily check-in', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Davit Hengky'), findsOneWidget);
    expect(find.text('Daily Check-In'), findsOneWidget);
    expect(find.text('Kopi Kangenan VIP Club'), findsOneWidget);
    expect(find.text('Keluar dari Akun'), findsOneWidget);
  });

  testWidgets('OrderStatusScreen renders real-time tracking steps and PIN', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OrderStatusScreen(),
      ),
    );

    expect(find.text('Status Pesanan'), findsOneWidget);
    expect(find.text('PIN AMBIL PESANAN'), findsOneWidget);
    expect(find.text('8 2 9 4'), findsOneWidget);
    expect(find.text('Lacak Pesanan Real-Time'), findsOneWidget);
    expect(find.text('Kembali ke Beranda'), findsOneWidget);
  });
}
