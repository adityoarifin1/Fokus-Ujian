# 🤖 AI Usage Declaration

**Proyek:** FokusUjian — Aplikasi CBT Secure Exam Berbasis Flutter
**Mata Kuliah:** Mobile Programming
**Dosen Pengampu:** Ghea Chandra Surawan, S.Pd., M.Pd.
**Mahasiswa:** Adityo Arifin
**NPM:** 2453025006
**Kelas:** PTI 24 B
**Universitas:** Universitas Lampung
**Tanggal Deklarasi:** 24 November 2026

---

## 📌 Pernyataan

Saya, **Adityo Arifin**, menyatakan dengan jujur bahwa dalam pengerjaan proyek akhir mata kuliah Mobile Programming ini, saya **menggunakan bantuan kecerdasan buatan (AI)** sebagai alat bantu pembelajaran dan pengembangan. Deklarasi ini dibuat secara transparan agar dosen dapat mengetahui peran AI dalam proses pengerjaan proyek.

> Seluruh keputusan desain, logika bisnis, dan arah pengembangan tetap menjadi tanggung jawab dan keputusan saya sebagai mahasiswa. AI digunakan sebagai **asisten belajar**, bukan sebagai pengganti pemikiran saya.

---

## 🛠️ Alat AI yang Digunakan

| Alat AI | Jenis | Kegunaan Utama |
|---|---|---|
| **Google Antigravity (Gemini)** | AI Asisten Chat + Agentic | Pengembangan kode, debug, audit laporan, dan perencanaan proyek |

---

## 📋 Rincian Penggunaan AI per Tahap Proyek

### 1. 📐 Tahap Perancangan (Mockup & Instalasi)

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 1.1 | **Perencanaan arsitektur** | AI membantu menjelaskan pola arsitektur berlapis (Model – Repository – Service – UI Screen) yang sesuai untuk aplikasi Flutter |
| 1.2 | **Perancangan skema database** | AI memberikan saran struktur 6 tabel SQLite: `admin`, `ujian`, `soal`, `peserta`, `jawaban`, `pelanggaran` beserta relasi ON DELETE CASCADE |
| 1.3 | **Pemilihan package Flutter** | AI menyarankan dan menjelaskan penggunaan `sqflite`, `sqflite_common_ffi_web`, `excel`, `crypto`, dan `flutter_secure_storage` |
| 1.4 | **Setup lingkungan development** | AI membantu proses instalasi Flutter SDK, konfigurasi Android SDK, dan troubleshooting error awal |

---

### 2. 🏗️ Tahap Project 1 — Fondasi & Database

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 2.1 | **Pembuatan skema SQLite** | AI membantu menulis kode `db_helper.dart` untuk inisialisasi database dan migrasi skema |
| 2.2 | **Implementasi Model class** | AI membimbing pembuatan class Model (`Admin`, `Ujian`, `Soal`, `Peserta`, `Jawaban`, `Pelanggaran`) dengan metode `toMap()` dan `fromMap()` |
| 2.3 | **Implementasi Repository pattern** | AI menjelaskan pola Repository dan membantu menulis operasi CRUD untuk tiap tabel |
| 2.4 | **Debug error database** | AI membantu menyelesaikan error schema mismatch saat migrasi database versi baru |

---

### 3. 📱 Tahap Project 2 — Modul Siswa

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 3.1 | **UI Screen siswa** | AI membantu menyusun layout dan logika untuk `StartScreen`, `IdentitasScreen`, `PaktaIntegritasScreen`, `SoalScreen`, dan `HasilScreen` |
| 3.2 | **Logika timer ujian** | AI membantu implementasi countdown timer dengan auto-submit saat waktu habis |
| 3.3 | **Navigasi dan state management** | AI memberikan panduan penggunaan `setState` dan navigasi antar halaman dengan passing data |
| 3.4 | **Validasi form identitas** | AI membantu menulis logika validasi input (nama, kelas, NIS, kode ujian) sebelum memulai ujian |

---

### 4. 👨‍🏫 Tahap Project 3 — Modul Guru & Administrator

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 4.1 | **Login berbasis peran** | AI membantu implementasi enkripsi password menggunakan SHA-256 dengan package `crypto` |
| 4.2 | **Dashboard guru** | AI membantu membuat logika siklus status ujian: `Draft → Aktif → Selesai` |
| 4.3 | **Import soal dari Excel** | AI menjelaskan cara menggunakan package `excel` dan menulis fungsi `_processExcelBytes()` untuk membaca file `.xlsx` |
| 4.4 | **Monitoring peserta** | AI membantu menulis logika perhitungan nilai otomatis dan penampilan log pelanggaran |
| 4.5 | **Manajemen akun guru** | AI membantu membuat halaman kelola guru dengan fitur tambah, edit, hapus akun |
| 4.6 | **Bug fixing: login guru** | AI membantu menemukan dan memperbaiki bug akun guru bawaan yang menggunakan plaintext password bukan hash SHA-256 |
| 4.7 | **Bug fixing: overflow tombol** | AI menyarankan penggantian `Row` dengan `Wrap` untuk mengatasi overflow tombol di layar kecil (390px) |

---

### 5. 🔒 Tahap Project 4 — Fitur Keamanan Ujian

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 5.1 | **Deteksi sentuhan tepi layar** | AI membantu implementasi `EdgeTouchDetector` menggunakan `GestureDetector` dengan kalkulasi area sentuhan tepi |
| 5.2 | **Alarm service** | AI membantu menulis `alarm_service.dart` untuk memicu peringatan audio dan visual saat pelanggaran terdeteksi |
| 5.3 | **Kiosk Mode service** | AI menjelaskan konsep Kiosk Mode dan membantu membuat `kiosk_mode_service.dart` sebagai abstraksi lintas platform |
| 5.4 | **Log pelanggaran real-time** | AI membantu mengintegrasikan pencatatan pelanggaran ke SQLite secara asinkron tanpa menghentikan jalannya ujian |
| 5.5 | **Bug fixing: jawaban tidak tersimpan** | AI membantu menemukan bug di mana penggantian jawaban tidak diperbarui dengan benar di database |

---

### 6. 📄 Tahap Penulisan Laporan

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 6.1 | **Audit kelengkapan laporan** | AI menganalisis seluruh 7 laporan PDF (Mockup, Instalasi, Project 1–4, Laporan Akhir) dan memberikan umpan balik kelengkapannya |
| 6.2 | **Penyusunan struktur laporan** | AI memberikan saran struktur BAB I–VI yang sesuai standar laporan akademik |
| 6.3 | **Review konten laporan** | AI memeriksa kesesuaian antara isi laporan dengan implementasi nyata di kode program |
| 6.4 | **Identifikasi kekurangan** | AI mendeteksi bagian yang belum lengkap seperti Daftar Pustaka dan Daftar Gambar pada beberapa laporan |

---

### 7. 🎬 Tahap Presentasi & Video

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 7.1 | **Penyusunan rundown video** | AI membantu merancang struktur presentasi video 12 menit dengan urutan yang logis dan sesuai arahan dosen |
| 7.2 | **Penulisan naskah/script** | AI membantu menulis naskah pembuka, transisi antar bagian, dan penutupan video presentasi |
| 7.3 | **Judul dan deskripsi YouTube** | AI membantu menyusun judul SEO-friendly dan deskripsi lengkap untuk unggahan video di YouTube |

---

### 8. 📊 Pembuatan Aset Pendukung

| No | Penggunaan AI | Deskripsi |
|---|---|---|
| 8.1 | **Generate soal PKn Excel** | AI membuatkan 10 soal Pendidikan Kewarganegaraan dalam format `.xlsx` siap import ke aplikasi FokusUjian |
| 8.2 | **Script audit laporan** | AI menulis script Python (`inspect_reports.py`) untuk mengaudit semua laporan PDF secara otomatis |

---

## 🎓 Refleksi Penggunaan AI

### Yang AI Lakukan:
- ✅ Menjelaskan konsep dan teori (arsitektur, enkripsi, database)
- ✅ Menyarankan solusi untuk error dan bug
- ✅ Menulis kode boilerplate awal yang kemudian saya sesuaikan
- ✅ Mereview dan memberikan umpan balik atas kode dan laporan saya
- ✅ Membantu dokumentasi dan aset pendukung non-kode

### Yang Tetap Saya Kerjakan Sendiri:
- ✍️ Menentukan fitur dan konsep utama aplikasi (Secure Exam, deteksi tepi)
- ✍️ Memahami dan memodifikasi semua kode yang dihasilkan
- ✍️ Melakukan pengujian manual dan mencatat hasilnya
- ✍️ Menulis narasi dan analisis laporan dengan bahasa sendiri
- ✍️ Mengambil keputusan desain UI dan pengalaman pengguna
- ✍️ Merekam dan mengedit video presentasi

---

## 🔗 Referensi

- **Source Code Proyek:** [github.com/adityoarifin1/Fokus-Ujian](https://github.com/adityoarifin1/Fokus-Ujian)
- **Alat AI:** Google Antigravity (powered by Gemini) — [antigravity.google](https://antigravity.google)
- **Framework:** Flutter — [flutter.dev](https://flutter.dev)

---

*Deklarasi ini dibuat secara jujur dan bertanggung jawab sebagai bentuk transparansi akademik.*

**Bandar Lampung, 24 November 2026**

**Adityo Arifin**
NPM. 2453025006

