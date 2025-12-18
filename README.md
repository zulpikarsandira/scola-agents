# Scola Agents - Guru Virtual AI 🚀

Scola Agents adalah aplikasi asisten pendidikan berbasis AI yang memungkinkan siswa berinteraksi dengan berbagai persona guru virtual melalui teks dan suara. Proyek ini dibangun menggunakan Flutter dan mengintegrasikan model bahasa canggih dari **OpenRouter (Gemma)** serta teknologi Text-to-Speech premium dari **ElevenLabs**.

---

## ✨ Fitur Utama
- **Interaksi Multi-Modal**: Pilih antara mode chatting (teks) atau ngobrol langsung (suara).
- **Guru Virtual Beragam**: Berdiskusi dengan berbagai persona guru (Buk Rini, Pak Aris, Pak Budi) yang memiliki karakteristik unik.
- **Teknologi Suara Realistis**: Output suara natural menggunakan ElevenLabs API.
- **Smart UI/UX**:
  - Animasi karakter yang responsif terhadap input.
  - Navbar cerdas yang menyesuaikan dengan posisi scroll.
  - UI Full Dark Mode yang modern dan premium (Gemini-inspired).
- **Keamanan API**: Pengelolaan API Key yang aman dan terisolasi.

---

## 🛠️ Tech Stack
- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **AI Model**: OpenRouter (Google: Gemma 2 9B)
- **Voice Synthesis**: [ElevenLabs](https://elevenlabs.io)
- **Animations**: `flutter_animate`, Lottie, & Custom GIF Transitions.
- **Icons**: Lucide Icons & Material Icons.

---

## 📋 Persyaratan Sistem
Sebelum memulai, pastikan Anda telah menginstal:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versi >= 3.10.1)
- [Dart SDK](https://dart.dev/get-started/sdk/install)
- Android Studio / VS Code dengan plugin Flutter & Dart
- Koneksi Internet untuk akses API

---

## 🚀 Cara Mulai & Remix Project

Ikuti langkah-langkah berikut untuk menjalankan project di lokal Anda:

### 1. Clone Repositori
```bash
git clone https://github.com/zulpikarsandira/scola-agents.git
cd ai_voice_app
```

### 2. Instal Dependensi
```bash
flutter pub get
```

### 3. Konfigurasi API Key (PENTING)
Aplikasi ini membutuhkan API Key dari OpenRouter dan ElevenLabs. Untuk keamanan, buat file baru di `lib/config/api_keys.dart`:

```dart
// lib/config/api_keys.dart
class ApiConfig {
  static const String openRouterKey = "MASUKKAN_OPENROUTER_KEY_ANDA";
  static const String elevenLabsKey = "MASUKKAN_ELEVENLABS_KEY_ANDA";
}
```
> [!IMPORTANT]
> Jangan pernah membagikan atau mem-push file `api_keys.dart` ke repositori publik. File ini sudah otomatis diabaikan oleh `.gitignore`.

### 4. Jalankan Aplikasi
Hubungkan perangkat fisik atau emulator, lalu jalankan:
```bash
flutter run
```

---

## 🔄 Flow Aplikasi
1. **Home Screen**: Pintu masuk utama untuk memulai diskusi.
2. **Topic Selection**: Pilih dari daftar guru virtual yang tersedia.
3. **Chat/Voice Session**: 
   - Mode **Chatting**: Interaksi teks dengan UI yang bersih.
   - Mode **Ngobrol**: Interaksi suara real-time (STT -> OpenRouter -> TTS).
4. **Summary**: (Opsional/Pengembangan) Ringkasan sesi belajar.

---

## 🏗️ Struktur Proyek
- `lib/screens/`: Berisi semua halaman utama (Chat, Home, Profile, dll).
- `lib/services/`: Logika integrasi API (OpenRouter, ElevenLabs).
- `lib/widgets/`: Komponen UI yang dapat digunakan kembali (GlassCard, Drawer, dll).
- `lib/theme/`: Definisi desain sistem dan skema warna aplikasi.

---

## 👤 Credits & Pembuat
Project ini dibuat dan dikembangkan dengan ❤️ oleh:
**Zulpikar Sandira**

Jika Anda menyukai project ini, jangan lupa untuk memberikan ⭐️ di repositori ini!

---

## 📄 Lisensi
[Pilih lisensi Anda, misal: MIT] - Lihat file LICENSE untuk detail lebih lanjut.
