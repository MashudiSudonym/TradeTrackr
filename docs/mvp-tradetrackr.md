# TradeTrackr - MVP Feature Specification

## Deskripsi Aplikasi
TradeTrackr adalah aplikasi jurnal trading offline yang membantu trader mencatat, mengelola, dan menganalisis aktivitas trading mereka. Aplikasi ini dirancang untuk bekerja sepenuhnya offline dengan fitur backup data otomatis dan manual.

---

## Fitur Utama MVP

### 1. User Onboarding & Setup Awal
Pengalaman pertama user saat membuka aplikasi untuk kali pertama.

**Detail Fitur:**
- Form pengisian data user:
  - First Name (wajib)
  - Last Name (wajib)
  - Email (wajib)
- Preferensi format tanggal dan waktu
- Timezone mengikuti pengaturan perangkat secara otomatis
- Data user disimpan di database lokal (SQLite/Hive)
- Halaman selamat datang dengan pengenalan singkat fitur utama aplikasi

**Tujuan:**
Personalisasi aplikasi tanpa memerlukan sistem autentikasi atau koneksi internet.

---

### 2. Input Trade Baru
Form untuk mencatat setiap transaksi trading yang dilakukan.

**Detail Fitur:**
- Field input:
  - Tanggal & Waktu transaksi
  - Instrumen/Aset (contoh: BTC/USDT, NDX100, EURUSD)
  - Jenis Transaksi (Buy/Sell, Long/Short)
  - Ukuran Posisi (lot/kontrak)
  - Harga Masuk (Entry Price)
  - Harga Keluar (Exit Price)
  - Stop Loss
  - Take Profit
  - Alasan Entry (Strategi yang digunakan)
  - Catatan Tambahan (Emosi, kondisi pasar, dll)
- Validasi input untuk memastikan data lengkap dan benar
- Auto-calculate hasil profit/loss berdasarkan entry dan exit price
- Tombol simpan untuk menyimpan data ke database lokal

**Tujuan:**
Memudahkan user mencatat semua detail trading dengan cepat dan akurat.

---

### 3. Daftar Jurnal Trading
Tampilan tabel riwayat semua transaksi trading yang telah dicatat.

**Detail Fitur:**
- Tabel interaktif dengan kolom:
  - Tanggal/Waktu
  - Instrumen
  - Jenis Transaksi
  - Hasil (Profit/Loss)
  - Status
- Fitur pencarian berdasarkan instrumen atau tanggal
- Filter data:
  - Berdasarkan rentang tanggal
  - Berdasarkan instrumen
  - Berdasarkan hasil (profit/loss/breakeven)
- Sorting data (ascending/descending)
- Tap untuk melihat detail trade

**Tujuan:**
Memberikan overview cepat terhadap semua aktivitas trading dan memudahkan analisis.

---

### 4. Detail Trade
Halaman detail lengkap dari sebuah transaksi trading.

**Detail Fitur:**
- Menampilkan semua informasi trade secara lengkap
- Informasi performa:
  - Profit/Loss (nominal dan persentase)
  - Risk/Reward Ratio
  - Durasi holding
- Catatan psikologi dan kondisi pasar
- Tombol edit untuk mengubah data trade
- Tombol delete untuk menghapus trade

**Tujuan:**
Memberikan analisis mendalam terhadap setiap transaksi untuk evaluasi dan pembelajaran.

---

### 5. Export Data Manual ke CSV
Fitur untuk mengekspor seluruh data trading ke format CSV.

**Detail Fitur:**
- Tombol "Export to CSV" di halaman jurnal atau pengaturan
- Export semua data trading dalam satu file CSV
- File tersimpan di penyimpanan perangkat (folder Downloads atau pilihan user)
- Notifikasi konfirmasi setelah export berhasil
- Naming file otomatis dengan format: `TradeTrackr_Export_[YYYY-MM-DD].csv`

**Tujuan:**
Memberikan kontrol penuh kepada user untuk backup dan analisis data di luar aplikasi.

---

### 6. Backup Otomatis Terjadwal
Mekanisme backup data secara otomatis dan berkala.

**Detail Fitur:**
- Background scheduler untuk export data CSV secara otomatis
- Pengaturan jadwal backup:
  - Harian (setiap 24 jam)
  - Mingguan (setiap 7 hari)
  - Manual (non-aktif)
- Lokasi penyimpanan backup dapat dipilih user
- Notifikasi status backup (berhasil/gagal)
- Riwayat backup terakhir ditampilkan di pengaturan
- Manajemen file backup (hapus backup lama, lihat daftar backup)

**Tujuan:**
Melindungi data user dari kehilangan dengan backup otomatis yang tidak mengganggu penggunaan aplikasi.

---

### 7. Import Data CSV
Fitur untuk mengimpor data trading dari file CSV.

**Detail Fitur:**
- Tombol "Import from CSV" di pengaturan
- File picker untuk memilih file CSV dari penyimpanan perangkat
- Validasi format file CSV sebelum import
- Opsi untuk:
  - Replace (ganti semua data dengan data dari CSV)
  - Merge (gabung data CSV dengan data yang sudah ada)
- Preview data sebelum import final
- Notifikasi konfirmasi setelah import berhasil

**Tujuan:**
Memudahkan restore data atau migrasi data dari perangkat lain.

---

### 8. Pengaturan Dasar
Halaman pengaturan untuk kustomisasi aplikasi.

**Detail Fitur:**
- **Profil User:**
  - Edit First Name, Last Name, Email
- **Backup Settings:**
  - Aktifkan/nonaktifkan backup otomatis
  - Pilih jadwal backup (harian/mingguan)
  - Pilih lokasi penyimpanan backup
  - Lihat riwayat backup terakhir
- **Preferensi Tampilan:**
  - Format tanggal (DD/MM/YYYY, MM/DD/YYYY, YYYY-MM-DD)
  - Format waktu (12-hour, 24-hour)
  - Tema aplikasi (light/dark mode)
- **Notifikasi:**
  - Notifikasi backup berhasil/gagal
  - Reminder untuk mencatat trade
- **Tentang Aplikasi:**
  - Versi aplikasi
  - Informasi developer
  - Privacy policy

**Tujuan:**
Memberikan kontrol penuh kepada user untuk menyesuaikan aplikasi sesuai preferensi mereka.

---

### 9. UI Responsif & Minimalis
Desain antarmuka yang sederhana dan user-friendly.

**Detail Fitur:**
- Desain clean dengan hierarki visual yang jelas
- Navigasi mudah dengan bottom navigation bar atau drawer
- Responsive design untuk berbagai ukuran layar
- Loading indicator untuk proses yang membutuhkan waktu
- Error handling dengan pesan yang jelas dan helpful
- Konsistensi design pattern di seluruh aplikasi

**Tujuan:**
Memberikan pengalaman pengguna yang nyaman dan intuitif tanpa perlu pembelajaran panjang.

---

## Teknologi & Implementasi

### Database
- **SQLite** atau **Hive** untuk penyimpanan data lokal
- Schema database mencakup:
  - User profile
  - Trade records
  - Settings/preferences
  - Backup history

### File Management
- CSV export/import menggunakan `csv` package
- File system access menggunakan `path_provider` atau `file_picker`

### Background Tasks
- Scheduled backup menggunakan `workmanager` atau `flutter_local_notifications`

### State Management
- Provider, Riverpod, atau Bloc untuk manajemen state aplikasi

---

## Prioritas Pengembangan

1. **Phase 1: Core Functionality**
   - User onboarding & setup
   - Input trade baru
   - Database setup (SQLite/Hive)
   - Daftar jurnal trading (basic)

2. **Phase 2: Data Management**
   - Detail trade
   - Export manual ke CSV
   - Import data CSV

3. **Phase 3: Automation & Polish**
   - Backup otomatis terjadwal
   - Pengaturan lengkap
   - UI polish & optimization

---

## Catatan Tambahan

- Aplikasi bekerja 100% offline tanpa memerlukan koneksi internet
- Tidak ada sistem autentikasi/login di versi MVP
- Data user tersimpan lokal dan aman di perangkat
- Enkripsi file CSV backup dapat dipertimbangkan untuk fase selanjutnya
- Analytics dan visualisasi data dapat ditambahkan setelah MVP stabil

---

## Success Metrics MVP

- User dapat menyelesaikan onboarding dalam < 2 menit
- User dapat menambahkan trade baru dalam < 1 menit
- Export/import data berjalan tanpa error
- Backup otomatis bekerja sesuai jadwal tanpa mengganggu performa aplikasi
- Aplikasi stabil tanpa crash dalam penggunaan normal

---

**Dokumen ini akan diupdate seiring perkembangan aplikasi TradeTrackr.**