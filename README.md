# SIMPLE-SURVEI — MySQL Local Build

Versi rebuild yang mempertahankan React frontend dan FastAPI backend, dengan persistence MySQL dan tanpa Docker. Lapisan kompatibilitas menyimpan dokumen aplikasi sebagai JSON di MySQL agar bentuk data dan alur bisnis lama tetap kompatibel selama migrasi. Untuk aplikasi skala besar, tabel relasional ternormalisasi dapat menjadi tahap berikutnya.

## Persyaratan
- Windows 10/11 (untuk `start.bat`), Python 3.10+, Node.js LTS/npm, MySQL 8.x, dan VS Code.
- Koneksi internet diperlukan untuk memasang dependensi pertama kali. Setelah dependensi dan aset terpasang, fitur inti survei dapat berjalan lokal tanpa internet.

## Langkah pertama
1. Ekstrak ZIP dan buka folder `SIMPLE-SURVEI-main` di VS Code.
2. Jalankan MySQL Server.
3. Buka MySQL Workbench, jalankan file `database_schema.sql` di root folder. Ini membuat database `simple_survei` dan tabel dokumen.
4. Salin `backend/.env.example` menjadi `backend/.env`. Sesuaikan `MYSQL_URL` dengan username/password MySQL lokal, buat `JWT_SECRET` yang panjang/acak, dan ganti `ADMIN_EMAIL` serta `ADMIN_PASSWORD` dengan kredensial admin Anda. Kredensial contoh wajib diganti sebelum digunakan.
5. Salin `frontend/.env.example` menjadi `frontend/.env` (opsional; URL default sudah disediakan).
6. Jalankan `start.bat`. Pada eksekusi pertama, dependensi Python dan npm dipasang; dua terminal akan terbuka.
7. Buka `http://localhost:3000`. API tersedia di `http://localhost:8000`, dokumentasi API di `http://localhost:8000/docs`, dan health check di `http://localhost:8000/api/health`.

Format `MYSQL_URL`: `mysql://USERNAME:PASSWORD@127.0.0.1:3306/simple_survei`. Jika password memiliki karakter khusus URL, lakukan URL-encoding.

## NIK
Di formulir, NIK ditampilkan seperti `3201-1508-1234-5678`, dengan tanda hubung otomatis setiap 4 digit. Validasi tetap 16 digit numerik dan backend menyimpan NIK tanpa tanda hubung. Pencegahan NIK duplikat tetap dilakukan pada backend.

## Online deployment
- Buat database MySQL di server dan jalankan `database_schema.sql`.
- Atur `MYSQL_URL`, `JWT_SECRET`, `FRONTEND_URL`, `CORS_ORIGINS`, serta `COOKIE_SECURE=true` di environment produksi.
- Host frontend dan backend di layanan yang sesuai, gunakan HTTPS, batasi CORS ke domain frontend, dan jangan mengunggah file `.env`.
- Google OAuth, AI berbasis API, dan email eksternal memerlukan kredensial dan koneksi internet.

## Catatan teknis
- MongoDB/Motor tidak lagi dipakai untuk persistence. `pymongo` masih menjadi dependensi ringan untuk tipe `ObjectId` dan kompatibilitas exception.
- MySQL menyimpan koleksi aplikasi pada tabel `survey_documents` dengan kolom JSON. Ini menjaga perilaku lama dengan perubahan minimal, tetapi bukan skema relasional ternormalisasi.
- Indeks email admin, NIK responden, dan kode referensi dibuat sebagai unique indexes persisten di MySQL. Jika migrasi mendeteksi duplikasi data lama, server berhenti dengan pesan agar duplikasi dibereskan terlebih dahulu.
- `test.bat` menjalankan test offline. Test integrasi nyata tersedia di `tests/test_mysql_integration.py`, tetapi perlu `MYSQL_TEST_URL` yang menunjuk ke database khusus pengujian. Jangan arahkan test ke database produksi.
- Lihat `test_reports/validation-report.md` untuk daftar test yang sudah lulus dan batasan verifikasi. MySQL server nyata dan frontend production build tidak dapat dijalankan pada lingkungan tempat ZIP ini disiapkan.
