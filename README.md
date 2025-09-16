# brave_search
 Flutter Tarayıcı Uygulaması
Modern Flutter ile geliştirilmiş, Clean Architecture ve Cubit tabanlı state management kullanan bir mobil tarayıcı uygulaması. Web, görsel, video ve haber aramalarını destekler. Ayrıca geçmiş yönetimi, offline cache ve dahili WebView entegrasyonu sunar.

📱 Özellikler

Arama Modülleri

🌐 Web Arama – Sonsuz kaydırma (pagination) ile sonuç listesi

🖼️ Görseller – Grid layout ile görsel arama

🎥 Videolar – Video içerikleri listesi

📰 Haberler – Haber aramaları için özel görünüm

🕑 Geçmiş – Önceki sorguların kaydı ve anında geri çağırma

🔍 WebView – Sonuçları uygulama içinde görüntüleme

Kullanıcı Deneyimi

✅ Sonsuz kaydırma (pagination)

✅ Özel mixin'ler ile akıcı animasyonlar

✅ Scroll kontrolü için mixin implementasyonu

✅ Pull-to-refresh

✅ Cache üzerinden offline çalışma

✅ History üzerinden hızlı geri dönüş

✅ İnternet bağlantı kontrolü (online/offline state)

✅ Animasyonlu arama ekranları (Lottie)

🎨 UI/UX

Minimal, modern arayüz

Dark&Light Tema

Özel animasyon mixin'leri ile akıcı kullanıcı deneyimi

Scroll mixin'leri ile optimize edilmiş kaydırma deneyimi

flutter_staggered_grid_view ile görsel grid düzeni

Lottie animasyonları ile zenginleştirilmiş arayüz

Responsive tasarım (iOS ve Android uyumlu)


🌐 Teknik Implementasyon

Network

Dio ile HTTP istekleri

flutter_dotenv ile API key yönetimi

Hata yönetimi & retry mekanizmaları

Pagination ile sayfalı veri yükleme

Local Storage

Hive & hive_flutter ile cache

Arama geçmişi için Hive model + generator

Offline-first deneyim

🧪 Test

Unit testler → UseCase & Repository

Widget testleri → UI bileşenleri

Integration testleri → Arama akışı

Mixin testleri → Özel mixin implementasyonları

🎯 Teknik Başarılar

Cubit tabanlı Clean Architecture

Hive cache + history yönetimi

Offline-first yaklaşımı

Dependency Injection (get_it & injectable)

Responsive & modern UI/UX

Özel mixin'ler ile kod modülerliği ve yeniden kullanımı

Ayrı pagination implementasyonu ile veri yükleme optimizasyonu

AnimationMixin ve ScrollMixin ile geliştirilmiş kullanıcı deneyimi

| Light Theme | Dark Theme |
|-------------|------------|
| <img width="300" alt="light" src="https://github.com/user-attachments/assets/41c06a73-99cd-4a1e-b19d-e4a7b85237c8" /> | <img width="300" alt="dark" src="https://github.com/user-attachments/assets/92f39771-27e4-4905-bb39-3e7954e0ffad" /> |
| <![light](https://github.com/user-attachments/assets/eb38ee34-c8bc-441b-b31a-eb3faa2cf870) /> |  ![darkmode](https://github.com/user-attachments/assets/c6a99234-8d03-40e1-8b42-42c0fa8df624) /> |








