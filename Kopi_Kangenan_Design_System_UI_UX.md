# Design System & UI/UX Specification
## Kopi Kangenan — Aplikasi Mobile Pemesanan Kopi

- **Versi:** 1.0
- **Tanggal:** 14 Oktober 2026
- **Referensi:** Screenshot aplikasi Kopi Kenangan

---

## 1. Design Principles

### 1.1 Prinsip Utama

- **Familiar** — Pengguna harus merasa seperti menggunakan aplikasi kopi yang sudah dikenal.
- **Cepat** — Alur pemesanan maksimal 5 tap dari beranda ke keranjang.
- **Personal** — Kustomisasi terasa mudah dan menyenangkan.
- **Rewarding** — Poin, voucher, dan level memberi rasa pencapaian.
- **Konsisten** — Warna, tipografi, dan spacing seragam di seluruh halaman.

### 1.2 Tone & Mood

- Hangat, ramah, dan mengundang.
- Dominan merah sebagai identitas brand.
- Putih dan krem sebagai latar untuk keterbacaan.
- Aksen hijau untuk pickup, biru untuk delivery.

## 2. Color System

### 2.1 Primary Colors

| Token | Hex | Penggunaan |
|---|---|---|
| `primary-500` | `#C62828` | Tombol utama, header, brand |
| `primary-600` | `#B71C1C` | Tombol pressed state |
| `primary-100` | `#FFEBEE` | Background tombol sekunder |
| `primary-50` | `#FFF5F5` | Background subtle |

### 2.2 Secondary Colors

| Token | Hex | Penggunaan |
|---|---|---|
| `secondary-500` | `#4CAF50` | Aksen pickup, sukses |
| `secondary-100` | `#E8F5E9` | Background badge pickup |
| `info-500` | `#2196F3` | Aksen delivery, tautan |
| `info-100` | `#E3F2FD` | Background badge delivery |
| `warning-500` | `#FF9800` | Badge promo, diskon |
| `warning-100` | `#FFF3E0` | Background badge promo |

### 2.3 Neutral Colors

| Token | Hex | Penggunaan |
|---|---|---|
| `neutral-900` | `#1A1A1A` | Teks utama |
| `neutral-700` | `#4A4A4A` | Teks sekunder |
| `neutral-500` | `#8A8A8A` | Teks placeholder, disabled |
| `neutral-300` | `#D1D1D1` | Border, divider |
| `neutral-100` | `#F5F5F5` | Background card |
| `neutral-50` | `#FAFAFA` | Background halaman |
| `white` | `#FFFFFF` | Background utama |

### 2.4 Membership Colors

| Level | Background | Text | Border |
|---|---|---|---|
| Silver | `#F5F5F5` | `#4A4A4A` | `#D1D1D1` |
| Gold | `#FFF8E1` | `#8B6914` | `#FFD54F` |
| Black | `#1A1A1A` | `#FFFFFF` | `#333333` |

### 2.5 Semantic Colors

| Token | Hex | Penggunaan |
|---|---|---|
| `success` | `#4CAF50` | Sukses, terverifikasi |
| `error` | `#E53935` | Error, gagal |
| `warning` | `#FF9800` | Peringatan |
| `info` | `#2196F3` | Informasi |

## 3. Typography

### 3.1 Font Family

- **Primary:** Poppins (fallback: Inter, Roboto, sans-serif)
- **Monospace:** Roboto Mono (untuk angka harga)

### 3.2 Type Scale

| Token | Size | Weight | Line Height | Penggunaan |
|---|---:|---:|---:|---|
| `display-lg` | 32px | 700 | 40px | Judul halaman utama |
| `display-md` | 28px | 700 | 36px | Judul seksi besar |
| `heading-lg` | 24px | 700 | 32px | Judul halaman |
| `heading-md` | 20px | 600 | 28px | Judul seksi |
| `heading-sm` | 18px | 600 | 24px | Subjudul |
| `body-lg` | 16px | 400 | 24px | Body text utama |
| `body-md` | 14px | 400 | 20px | Body text sekunder |
| `body-sm` | 12px | 400 | 16px | Caption, label |
| `label-lg` | 14px | 600 | 20px | Label tombol |
| `label-md` | 12px | 600 | 16px | Label kecil |
| `price-lg` | 18px | 700 | 24px | Harga produk |
| `price-md` | 14px | 700 | 20px | Harga item |
| `price-sm` | 12px | 600 | 16px | Harga kecil |

### 3.3 Contoh Penerapan

- Judul produk: `heading-md` (20px, 600)
- Harga produk: `price-lg` (18px, 700)
- Deskripsi: `body-md` (14px, 400)
- Nama kategori: `label-lg` (14px, 600)
- Caption promo: `body-sm` (12px, 400)

## 4. Spacing System

### 4.1 Base Unit

Semua spacing menggunakan kelipatan 4px.

| Token | Value | Penggunaan |
|---|---:|---|
| `space-1` | 4px | Spacing internal kecil |
| `space-2` | 8px | Spacing antar elemen kecil |
| `space-3` | 12px | Spacing antar elemen |
| `space-4` | 16px | Padding standar |
| `space-5` | 20px | Padding card |
| `space-6` | 24px | Padding halaman |
| `space-8` | 32px | Spacing antar seksi |
| `space-10` | 40px | Spacing antar seksi besar |
| `space-12` | 48px | Spacing atas/bawah halaman |

### 4.2 Padding Standar

- Padding halaman horizontal: 16px
- Padding card: 16px
- Padding tombol: 12px 24px
- Padding input: 12px 16px

## 5. Border Radius

| Token | Value | Penggunaan |
|---|---:|---|
| `radius-sm` | 4px | Badge, chip kecil |
| `radius-md` | 8px | Tombol, input |
| `radius-lg` | 12px | Card |
| `radius-xl` | 16px | Card besar, modal |
| `radius-2xl` | 24px | Bottom sheet |
| `radius-full` | 999px | Avatar, pill, toggle |

## 6. Elevation & Shadow

| Token | Value | Penggunaan |
|---|---|---|
| `shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Card ringan |
| `shadow-md` | `0 2px 8px rgba(0,0,0,0.08)` | Card standar |
| `shadow-lg` | `0 4px 16px rgba(0,0,0,0.12)` | Card elevated, modal |
| `shadow-xl` | `0 8px 24px rgba(0,0,0,0.16)` | Bottom sheet, dialog |

## 7. Iconography

### 7.1 Icon Library

- Material Icons (bawaan Flutter)
- Custom icon: Logo hati dengan garis (brand Kopi Kangenan)

### 7.2 Ukuran Icon

| Token | Size | Penggunaan |
|---|---:|---|
| `icon-sm` | 16px | Icon inline |
| `icon-md` | 20px | Icon di tombol |
| `icon-lg` | 24px | Icon navigasi |
| `icon-xl` | 32px | Icon header |
| `icon-2xl` | 48px | Icon ilustrasi |

### 7.3 Warna Icon

- Default: `neutral-700`
- Aktif: `primary-500`
- Disabled: `neutral-300`
- Sukses: `success`

## 8. Komponen UI

### 8.1 Tombol

#### Primary Button

```text
Background: primary-500
Text: white, label-lg, 600
Padding: 12px 24px
Radius: radius-md
Height: 48px
State pressed: primary-600
State disabled: neutral-300
```

#### Secondary Button

```text
Background: transparent
Border: 1px primary-500
Text: primary-500, label-lg, 600
Padding: 12px 24px
Radius: radius-md
Height: 48px
```

#### Text Button

```text
Background: transparent
Text: primary-500, label-lg, 600
Padding: 8px 16px
```

#### Icon Button

```text
Size: 40x40
Radius: radius-full
Background: transparent
Icon: 24px, neutral-700
```

### 8.2 Input Field

```text
Background: neutral-100
Border: 1px neutral-300 (default), 1px primary-500 (focus)
Radius: radius-md
Padding: 12px 16px
Text: body-lg, neutral-900
Placeholder: body-lg, neutral-500
Height: 48px
```

### 8.3 Card

#### Product Card

```text
Background: white
Radius: radius-lg
Shadow: shadow-sm
Padding: 0
Image: aspect ratio 1:1, radius atas
Content padding: 12px
Nama: heading-sm, 600, 2 lines max
Harga: price-lg, 700, primary-500
```

#### Outlet Card

```text
Background: white
Radius: radius-lg
Shadow: shadow-sm
Padding: 16px
Layout: logo + info + detail button
```

#### Voucher Card

```text
Background: white
Radius: radius-lg
Border: 1px dashed neutral-300
Padding: 16px
Layout: header (badge + icon) + body + footer (expiry + button)
```

#### Membership Card

```text
Background: gradient sesuai level
Radius: radius-xl
Padding: 20px
Layout: level + nama + progress bar + icon
Height: 180px
```

### 8.4 Badge

#### New Badge

```text
Background: secondary-100
Text: secondary-500, label-md, 600
Padding: 4px 8px
Radius: radius-sm
```

#### Promo Badge

```text
Background: warning-500
Text: white, label-md, 600
Padding: 4px 8px
Radius: radius-sm
```

#### Out of Stock Badge

```text
Background: neutral-300
Text: neutral-500, label-md, 600
Padding: 4px 8px
Radius: radius-sm
```

### 8.5 Chip / Filter

```text
Background: white
Border: 1px neutral-300 (default), 1px primary-500 (aktif)
Text: body-md, neutral-700 (default), primary-500 (aktif)
Padding: 8px 16px
Radius: radius-full
Height: 36px
```

### 8.6 Tab

#### Category Tab

```text
Text: label-lg, neutral-500 (default), primary-500 (aktif)
Indicator: 2px primary-500, full width
Padding: 12px 16px
Spacing: 24px antar tab
```

#### Segment Tab (Pickup/Dine-In/Delivery)

```text
Background: neutral-100
Radius: radius-full
Padding: 4px
Tinggi: 40px
Aktif: background white, text primary-500, shadow-sm
```

### 8.7 Bottom Navigation

```text
Background: white
Height: 64px + safe area
Shadow: shadow-lg
5 tab: Beranda, Menu, VIP, Merch, Saya
Icon: icon-lg (24px)
Label: label-md (12px)
Aktif: primary-500
Tidak aktif: neutral-500
```

### 8.8 Bottom Sheet

```text
Background: white
Radius atas: radius-2xl
Padding: 20px
Drag handle: 4x32px, radius-full, neutral-300
Shadow: shadow-xl
```

### 8.9 Modal Dialog

```text
Background: white
Radius: radius-xl
Padding: 24px
Max width: 320px
Shadow: shadow-xl
Backdrop: rgba(0,0,0,0.5)
```

### 8.10 Quantity Selector

```text
Layout: horizontal, border neutral-300, radius-md
Tombol: 40x40, icon minus/plus
Value: 40x40, text center, label-lg, 600
```

### 8.11 Progress Bar

```text
Background: neutral-200
Fill: primary-500 (atau warna sesuai level)
Height: 8px
Radius: radius-full
```

### 8.12 Avatar

```text
Size: 48x48 (medium), 64x64 (large)
Radius: radius-full
Border: 2px white
Background: neutral-100
```

## 9. Layout Halaman

### 9.1 Splash Screen

```text
Background: white
Logo: center, 120x120
Brand name: di bawah logo, heading-lg
Loading indicator: di bawah brand
Durasi: 2 detik
```

### 9.2 Login Screen

```text
Header: back button
Title: "Masuk / Daftar", heading-lg
Subtitle: "Masukkan nomor handphone kamu", body-md
Input: nomor HP dengan prefix +62
Button: "Lanjut Konfirmasi", primary, full width
Divider: "ATAU"
Button: "Lanjutkan dengan Google", secondary
```

### 9.3 OTP Screen

```text
Header: back button
Title: "Verifikasi Kode", heading-lg
Subtitle: "Masukkan kode yang dikirim ke +62xxx", body-md
Input: 6 kotak OTP
Button: "Verifikasi", primary, full width
Resend: "Kirim ulang kode", text button
```

### 9.4 Beranda

**Struktur Vertikal:**

```text
1. Header (sticky)
   - Sapaan "Hai, Guest" / "Hai, [Nama]"
   - Tombol "Masuk" (jika guest)
   - Avatar + level + poin (jika login)

2. Pilih Outlet (card)
   - Nama outlet + alamat
   - Toggle Pickup/Delivery
   - Tombol chevron untuk buka daftar outlet

3. Banner Promo (carousel)
   - Height: 160px
   - Radius: radius-lg
   - Indikator dots di bawah

4. Spesial Hari Ini
   - Judul + "Lihat Semua"
   - Horizontal scroll produk
   - Card width: 140px

5. Diskon & Cashback
   - Judul
   - Card horizontal dengan tombol Klaim

6. Baru!
   - Judul + "Lihat Semua"
   - Grid 2 kolom

7. Makanan
   - Judul + "Lihat Semua"
   - Grid 2 kolom

8. Voucher Package
   - Banner full width
   - Tombol "Langganan Sekarang"

9. Chat CS
   - Card dengan icon WhatsApp
   - Nomor CS

10. Bottom padding: 80px (untuk bottom nav)
```

### 9.5 Daftar Outlet

```text
1. Header: back + title "Pilih Outlet"
2. Toggle: Pickup / Delivery (segment)
3. Search bar
4. Filter chips:
   - Order: Semua, Pickup, Drive Thru
   - Brand: Semua, Kangenan, dll.
5. List outlet (card)
   - Logo brand
   - Status "OPENING AT 07:00"
   - Nama outlet
   - Alamat
   - Layanan: Delivery, Pickup, Dine-In
   - Tombol "Detail >"
```

### 9.6 Menu

```text
1. Header: pilih outlet (sticky)
2. Tab kategori (horizontal scroll, sticky)
3. Konten per kategori:
   - Grid 2 kolom
   - Card produk
4. Bottom nav
```

### 9.7 Detail Produk

**Struktur Vertikal:**

```text
1. Gambar produk (full width, 300px)
2. Nama produk + harga
3. Deskripsi
4. Divider
5. Kustomisasi Single Select:
   - Temperature
   - Size
   - Beans
   - Milk Option
   - Sugar Level
   - Ice Level
6. Divider
7. Kustomisasi Multiple Select:
   - Syrup
   - Topping
8. Catatan Tambahan (text field)
9. Detail Produk (banner)
10. Bottom Bar (sticky):
    - Quantity selector
    - Tombol "+ Keranjang Rp[total]"
```

### 9.8 Konfirmasi Pesanan

```text
1. Header: back + "Konfirmasi Pesanan"
2. Segment tab: Pickup, Dine-In, Delivery
3. Info outlet (card)
4. Info alamat delivery (jika Delivery)
5. Judul "Pesan" + tombol "Tambah Pesanan +"
6. List item pesanan:
   - Nama produk + kustomisasi
   - Harga
   - Tombol Ganti
   - Quantity selector
7. Voucher section:
   - "Tambah pesanan untuk pakai voucher" (disabled)
   - "Pakai Kode Voucher"
8. Bottom Bar:
   - Total
   - Tombol "Pilih Pembayaran"
```

### 9.9 Checkout

```text
1. Header: back + "Checkout"
2. Info outlet + opsi pickup
3. Kangenan Points:
   - Checkbox "Redeem 25 pts"
   - Keterangan 1 point = 1 Rupiah
4. Pembayaran Langsung:
   - Tab metode: blu, QRIS, GoPay
   - Keterangan cashback
   - Tombol "Hubungkan" (GoPay)
   - Link "Lihat Semua"
5. Detail Pesanan
6. Kantung Belanja (checkbox)
7. Pakai Kode Voucher
8. Beli Paket Voucher
9. Ringkasan (Subtotal, Total)
10. Info loyalty cashback
11. Bottom Bar:
    - Tombol "Jadwalkan"
    - Tombol "Bayar - Rp[total]"
```

### 9.10 Status Pesanan

```text
1. Header: back + "Status Pesanan"
2. Status card:
   - Icon status (pending/processing/ready/completed)
   - Teks status
   - Estimasi waktu
3. Detail pesanan
4. Tombol "Ambil di Outlet" / "Hubungi Outlet"
```

### 9.11 Profil / Saya

```text
1. Header card:
   - Avatar + nama
   - Level + poin
   - Tombol edit profil
2. Promo Spesial:
   - Banner "Ikuti Sekarang" (WhatsApp)
3. Daily Check-In:
   - Judul + "Detail"
   - 6 kotak hari
   - Tombol "Check-In"
4. Akun:
   - Kotak Masuk
   - Alamat Pengiriman
   - Scan Merchandise
   - Ubah Bahasa Aplikasi
```

### 9.12 VIP

```text
1. Header: back + "Kangenan VIP" + icon help
2. Kartu membership (carousel):
   - Level (Silver/Gold/Black)
   - Nama
   - Progress bar
   - Teks "Belanja Rp[X] lagi untuk naik ke Level [Y]"
   - Icon level
3. Tab: Voucher, Voucher Pack, Benefits
4. Konten sesuai tab
```

### 9.13 Merch

```text
1. Header: pilih outlet
2. Tab kategori
3. Grid 2 kolom merchandise
4. Setiap item: gambar, nama, harga, badge New
```

## 10. Navigasi

### 10.1 Bottom Navigation

- Tab 1: Beranda (`home` icon)
- Tab 2: Menu (`menu_book` icon)
- Tab 3: VIP (`workspace_premium` icon)
- Tab 4: Merch (`shopping_bag` icon)
- Tab 5: Saya (`person` icon)

### 10.2 Alur Navigasi Utama

```text
Splash → Beranda
Beranda → Daftar Outlet → Beranda
Beranda → Menu → Detail Produk → Keranjang
Keranjang → Konfirmasi Pesanan → Checkout → Status Pesanan
Beranda → Profil → VIP
Profil → Alamat Pengiriman
Profil → Kotak Masuk
Profil → Ubah Bahasa
```

### 10.3 Transisi Halaman

- **Push:** slide dari kanan (default Material)
- **Modal:** slide dari bawah (bottom sheet)
- **Tab switch:** fade + slide horizontal
- **Dialog:** fade + scale

## 11. State & Interaksi

### 11.1 Loading States

- Skeleton loading: untuk daftar produk dan outlet
- Circular progress: untuk aksi tombol
- Shimmer effect: untuk gambar yang sedang dimuat

### 11.2 Empty States

- **Keranjang kosong:** ilustrasi + "Keranjang kamu masih kosong" + tombol "Mulai Pesan"
- **Riwayat kosong:** ilustrasi + "Belum ada pesanan" + tombol "Pesan Sekarang"
- **Voucher kosong:** ilustrasi + "Belum ada voucher"

### 11.3 Error States

- **Network error:** icon wifi off + "Koneksi terputus" + tombol "Coba Lagi"
- **Server error:** icon error + "Terjadi kesalahan" + tombol "Coba Lagi"
- **Validation error:** teks merah di bawah input

### 11.4 Success States

- **Tambah ke keranjang:** snackbar "Berhasil ditambahkan ke keranjang"
- **Checkout berhasil:** modal sukses + tombol "Lihat Pesanan"
- **Check-in berhasil:** modal reward + animasi

### 11.5 Interaksi Mikro

- Tap: ripple effect Material
- Long press: haptic feedback (opsional)
- Swipe: hapus item di keranjang
- Pull to refresh: di beranda dan riwayat
- Scroll: smooth, dengan parallax di banner (opsional)

## 12. Aksesibilitas

### 12.1 Kontras Warna

- Teks utama pada background putih: rasio minimal 4.5:1
- Teks pada tombol primary: putih pada merah, rasio 4.5:1

### 12.2 Ukuran Tap Target

Minimal 44x44px untuk semua elemen interaktif.

### 12.3 Label

- Semua icon button memiliki tooltip/semantic label
- Form input memiliki label yang jelas

### 12.4 Text Scaling

- Mendukung system text scaling hingga 1.3x
- Layout tidak rusak saat text diperbesar

## 13. Responsivitas

### 13.1 Breakpoint

| Token | Width | Perangkat |
|---|---|---|
| `mobile` | `< 600px` | HP |
| `tablet` | `600-900px` | Tablet kecil |
| `desktop` | `> 900px` | Tablet besar |

### 13.2 Adaptasi Layout

- **Mobile:** 1 kolom, bottom nav
- **Tablet:** 2 kolom untuk grid, navigation rail
- **Desktop:** 3 kolom untuk grid, navigation drawer

Fokus utama: mobile (sesuai target tugas).

## 14. Animasi & Transisi

### 14.1 Durasi

| Token | Durasi | Penggunaan |
|---|---:|---|
| `duration-fast` | 150ms | Ripple, hover |
| `duration-normal` | 250ms | Transisi halaman |
| `duration-slow` | 400ms | Modal, bottom sheet |

### 14.2 Easing

- Standard: `easeInOut`
- Enter: `easeOut`
- Exit: `easeIn`

### 14.3 Animasi Khusus

- Banner carousel: auto-scroll 5 detik
- Add to cart: scale + fade tombol
- Check-in: confetti (opsional)
- Loading: shimmer effect

## 15. Design Token Summary (untuk Flutter)

### 15.1 Colors

```dart
class AppColors {
  static const primary = Color(0xFFC62828);
  static const primaryDark = Color(0xFFB71C1C);
  static const primaryLight = Color(0xFFFFEBEE);
  static const secondary = Color(0xFF4CAF50);
  static const info = Color(0xFF2196F3);
  static const warning = Color(0xFFFF9800);
  static const neutral900 = Color(0xFF1A1A1A);
  static const neutral700 = Color(0xFF4A4A4A);
  static const neutral500 = Color(0xFF8A8A8A);
  static const neutral300 = Color(0xFFD1D1D1);
  static const neutral100 = Color(0xFFF5F5F5);
  static const neutral50 = Color(0xFFFAFAFA);
  static const white = Color(0xFFFFFFFF);
}
```

### 15.2 Spacing

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}
```

### 15.3 Radius

```dart
class AppRadius {
  static const sm = 4.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const xl = 16.0;
  static const xxl = 24.0;
  static const full = 999.0;
}
```

### 15.4 Typography

```dart
class AppTypography {
  static const displayLg = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.25);
  static const displayMd = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.28);
  static const headingLg = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.33);
  static const headingMd = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4);
  static const headingSm = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.33);
  static const bodyLg = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const bodyMd = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.43);
  static const bodySm = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.33);
  static const labelLg = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.43);
  static const labelMd = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.33);
}
```

## 16. Wireframe Ringkas per Halaman

### 16.1 Beranda

```text
┌─────────────────────────────┐
│ Hai, Guest          Masuk > │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │ Diponegoro Surabaya   v │ │
│ │ Delivery  Pickup        │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │    BANNER CAROUSEL      │ │
│ │         ● ○ ○           │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│ Spesial Hari Ini    Lihat > │
│ ┌────┐ ┌────┐ ┌────┐        │
│ │    │ │    │ │    │        │
│ └────┘ └────┘ └────┘        │
├─────────────────────────────┤
│ Diskon & Cashback           │
│ ┌──────────┐ ┌──────────┐   │
│ │ 5.000    │ │ 5.000    │   │
│ │ OVO Klaim│ │ GEx Klaim│   │
│ └──────────┘ └──────────┘   │
├─────────────────────────────┤
│ Baru!               Lihat > │
│ ┌──────┐ ┌──────┐           │
│ │      │ │      │           │
│ └──────┘ └──────┘           │
├─────────────────────────────┤
│ Makanan             Lihat > │
│ ┌──────┐ ┌──────┐           │
│ │      │ │      │           │
│ └──────┘ └──────┘           │
├─────────────────────────────┤
│ [    Daftar atau Masuk    ] │
├─────────────────────────────┤
│ 🏠   📋   💎   🛍️   👤      │
│Beranda Menu VIP Merch Saya  │
└─────────────────────────────┘
```

### 16.2 Detail Produk + Kustomisasi

```text
┌─────────────────────────────┐
│ <  OG Aren Spesial Latte    │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │    GAMBAR PRODUK        │ │
│ └─────────────────────────┘ │
│ OG Aren Spesial   Rp24.000  │
│ Deskripsi produk...         │
├─────────────────────────────┤
│ Temperature  Select 1       │
│ ┌────────┐ ┌────────┐       │
│ │  Ice   │ │  Hot   │       │
│ └────────┘ └────────┘       │
├─────────────────────────────┤
│ Size  Select 1              │
│ ┌────────┐ ┌────────┐       │
│ │Regular │ │ Large  │       │
│ └────────┘ └────────┘       │
├─────────────────────────────┤
│ ... (Beans, Milk, Sugar, Ice)│
├─────────────────────────────┤
│ Syrup  Optional             │
│ ☐ Vanilla Syrup    +Rp6.000 │
│ ☐ Hazelnut Syrup   +Rp6.000 │
├─────────────────────────────┤
│ Topping  Optional           │
│ ☐ Espresso Shot    +Rp6.000 │
│ ☐ Oreo             +Rp6.000 │
├─────────────────────────────┤
│ Catatan Tambahan    0/100   │
│ ┌─────────────────────────┐ │
│ │ Ga perlu paper          │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│ [-] 1 [+]  [ + Keranjang ] │
└─────────────────────────────┘
```

### 16.3 Checkout

```text
┌─────────────────────────────┐
│ <  Checkout                 │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │ ○ Outlet                │ │
│ │   Diponegoro Surabaya   │ │
│ │ 🏪 Opsi Pickup          │ │
│ │   Pickup di Counter     │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│ Kangenan Points             │
│ ☐ Redeem 25 pts            │
│   1 Kangenan Point = 1 Rp   │
├─────────────────────────────┤
│ Pembayaran Langsung  Lihat> │
│ ┌──────┐ ┌──────┐ ┌──────┐ │
│ │ blu  │ │QRIS  │ │GoPay │ │
│ └──────┘ └──────┘ └──────┘ │
├─────────────────────────────┤
│ Pesan          Total 1 Item │
│ 1x OG Aren ...    Rp24.000  │
├─────────────────────────────┤
│ ☐ Kantung Belanja  Rp4.000  │
├─────────────────────────────┤
│ 🎫 Pakai Kode Voucher    >  │
├─────────────────────────────┤
│ Beli Paket Voucher          │
│ ┌─────────────────────────┐ │
│ │ Langganan Voucher       │ │
│ │ Rp9.000  Save 98%       │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│ Subtotal          Rp24.000  │
│ Total Pembayaran  Rp24.000  │
├─────────────────────────────┤
│ ⏰ Jadwalkan  [Bayar-Rp24.000]│
└─────────────────────────────┘
```

## 17. Referensi Visual per Screenshot

| Screenshot | Halaman | Komponen Kunci |
|---:|---|---|
| 1 | Profil / Saya | Header card, Daily Check-In, Akun list |
| 2 | Konfirmasi Pesanan | Segment tab, item list, voucher |
| 3 | Beranda | Banner, Spesial Hari Ini, Diskon |
| 4 | Splash | Logo hati |
| 5 | Menu (Makanan) | Grid produk |
| 6 | Menu (Baru!) | Grid dengan badge New |
| 7 | Banner Promo | Double Cashback |
| 8 | Beranda | Voucher Package, Chat CS |
| 9 | Daftar Outlet | Search, filter, outlet card |
| 10 | Menu | Grid produk, tab kategori |
| 11 | VIP (Black) | Membership card, benefits |
| 12 | Menu (Coffee) | Grid produk kopi |
| 13 | VIP (Silver) | Voucher tab |
| 14 | VIP (Silver) | Voucher Pack tab |
| 15 | VIP (Gold) | Benefits tab |
| 16 | VIP (Black) | Benefits tab |
| 17 | Login | WhatsApp login |
| 18 | VIP (Silver) | Benefits tab |
| 19 | VIP (Gold) | Voucher tab |
| 20 | VIP (Black) | Voucher Pack tab |
| 21 | Detail Produk | Kustomisasi single select |
| 22 | Detail Produk | Kustomisasi multiple select |
| 23 | Detail Produk | Catatan + Detail Produk |
| 24 | Detail Produk | Topping list |
| 25 | Checkout | Metode pembayaran |
| 26 | Checkout | Ringkasan |

## 18. Catatan Implementasi

### 18.1 Prioritas Komponen

1. **Fondasi:** colors, typography, spacing, radius
2. **Atom:** button, input, badge, chip
3. **Molekul:** card produk, card outlet, card voucher
4. **Organisme:** header, bottom nav, bottom sheet
5. **Template:** layout halaman

### 18.2 Konsistensi

- Semua halaman menggunakan padding horizontal 16px
- Semua card menggunakan `radius-lg` (12px)
- Semua tombol primary menggunakan warna `primary-500`
- Semua heading menggunakan Poppins 600/700

### 18.3 Asset yang Dibutuhkan

- Logo Kopi Kangenan (hati dengan garis)
- Icon set (Material Icons)
- Gambar produk (placeholder atau dari sumber bebas)
- Gambar banner promo (desain sendiri)
- Gambar outlet (placeholder)

### 18.4 Placeholder Gambar

- Produk: gunakan gambar kopi generik
- Banner: gunakan warna solid + teks
- Outlet: gunakan icon hati

## 19. Checklist Implementasi UI

### Fondasi

- [ ] Setup color palette
- [ ] Setup typography
- [ ] Setup spacing & radius
- [ ] Setup theme (light mode)

### Komponen Atom

- [ ] Primary button
- [ ] Secondary button
- [ ] Text button
- [ ] Input field
- [ ] Badge (New, Promo, Out of Stock)
- [ ] Chip / filter
- [ ] Quantity selector
- [ ] Progress bar
- [ ] Avatar

### Komponen Molekul

- [ ] Product card
- [ ] Outlet card
- [ ] Voucher card
- [ ] Membership card
- [ ] Customization group
- [ ] Customization option

### Komponen Organisme

- [ ] Header (beranda)
- [ ] Header (halaman)
- [ ] Bottom navigation
- [ ] Bottom sheet
- [ ] Modal dialog
- [ ] Segment tab
- [ ] Category tab

### Template Halaman

- [ ] Splash
- [ ] Login
- [ ] OTP
- [ ] Beranda
- [ ] Daftar Outlet
- [ ] Menu
- [ ] Detail Produk
- [ ] Konfirmasi Pesanan
- [ ] Checkout
- [ ] Status Pesanan
- [ ] Profil
- [ ] VIP
- [ ] Merch
- [ ] Riwayat
- [ ] Daily Check-In
- [ ] Alamat
- [ ] Kotak Masuk
- [ ] Ubah Bahasa

---

Dokumen ini menjadi acuan tunggal untuk implementasi UI/UX Kopi Kangenan. Seluruh keputusan desain merujuk pada spesifikasi ini.
