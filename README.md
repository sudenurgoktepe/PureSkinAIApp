# PureSkin AI

Kişisel cilt bakımını veri odaklı ve sürdürülebilir hale getiren, yapay zekâ destekli bir iOS uygulaması.  
Kullanıcılar cilt analizlerini takip edebilir, ürünlerini kaydedebilir ve sabah/akşam rutinlerini haftalık plana göre yönetebilir.

> **Platform:** iOS (Swift + UIKit)  
> **Amaç:** Cilt sağlığını sadece “o anlık” değil, uzun vadede takip edilebilir ve ölçülebilir kılmak.

---

## 🧴 Özellikler

### 🧪 1. Cilt Analizi ve Geçmişi

- Kullanıcılar düzenli aralıklarla selfie ekleyerek cilt ilerlemesini takip edebilir.
- Her analiz, **Genel Cilt Skoru (0–100)** ile birlikte kaydedilir.
- Detaylı metinsel değerlendirme:
  - Cildin genel durumu
  - Problemli bölgeler (göz altı, T bölgesi, burun çevresi vb.)
  - İyileştirme önerileri
- Skora ek olarak, alt parametreler üzerinden detaylı analiz:
  - Göz Altı Morlukları
  - Donukluk
  - Kızarıklık
  - vb. (ölçeklendirilmiş bar grafikleri ile)

Ekran görüntüleri:

- Ana sayfada “Cilt Analizi Geçmişi” bloğu  
  ![Cilt Analizi Geçmişi](/mnt/data/Ekran Resmi 2025-11-21 17.36.40.png)

- Örnek AI analiz sonucu – genel skor & uzun açıklama  
  ![Genel Cilt Skoru ve Değerlendirme](/mnt/data/WhatsApp Image 2025-11-21 at 17.44.03.jpeg)

- Detaylı analiz ve önemli notlar  
  ![Detaylı Analiz ve Notlar](/mnt/data/WhatsApp Image 2025-11-21 at 17.44.12.jpeg)

---

### 🧴 2. Ürün Yönetimi (My Products)

- Kullanıcı, kullandığı tüm cilt bakım ürünlerini uygulamaya kaydedebilir.
- Her ürün için:
  - **Fotoğraf** (örnek görsel veya gerçek ürün fotoğrafı)
  - **Ürün Adı**
  - **Kategori** (örn: Göz Kremi, Serum, Nemlendirici…)
  - **Açıklama** (isteğe bağlı not)
  - “Rutinime ekle” seçeneği ile direkt rutine bağlama

Ekran görüntüleri:

- Ürün ekleme formu  
  ![Ürün Ekle Ekranı](/mnt/data/Ekran Resmi 2025-11-21 17.38.06.png)

- Ana sayfada “Ürünlerim” alanı ve ürün kartları  
  ![Ürünlerim Listesi](/mnt/data/Ekran Resmi 2025-11-21 17.38.54.png)

---

### 📆 3. Sabah / Akşam Rutin Yönetimi

- Haftalık takvim görünümü ile **hangi gün, hangi rutin** görünecek şekilde yapılandırma
- **Sabah / Akşam** sekmeli yapı
- Her rutin adımı için:
  - Başlık (örn. “Uyku Maskesi”, “Retinol”, “Yoğun Nemlendirici Krem”)
  - “Bu rutin için ürün seçildi” etiketi
- Kullanıcı, adımı tamamladığında:
  - Adım griye düşer ve üzeri çizilir (tamamlandı hissi)
  - Sağda **checkmark** görünür
- Üst kısımda, o rutin için ilerleme göstergesi:
  - Örn. `0/5 Tamamlandı`, `1/3 Tamamlandı`

Ekran görüntüleri:

- Sabah rutini listesi  
  ![Sabah Rutini](/mnt/data/Ekran Resmi 2025-11-21 17.39.10.png)

- Akşam rutini ve tamamlanmış adım örneği  
  ![Akşam Rutini](/mnt/data/Ekran Resmi 2025-11-21 17.39.27.png)

---

### ➕ 4. Rutin Oluşturma ve Kategori Bazlı Seçim

- Alt taraftan açılan **bottom sheet** ile rutine adım ekleme deneyimi
- Kategori bazlı yapı:
  - Nemlendirici, Serum, Toner/Spray, Koruma, Tedavi, Temizleme, Diğer…
- Kategori açıldığında, kategoriye ait ürünler **kart görünümünde** seçilebilir (çok şık yeşil kartlar 😌)

Ekran görüntüleri:

- Rutin için kategori seçilen bottom sheet  
  ![Rutin Kategorileri](/mnt/data/Ekran Resmi 2025-11-21 17.41.22.png)

- Seçilen ürün için haftalık gün seçimi:
  - “Bu günler için ekle”
  - Tümünü seç / tek tek seçim
  - Seçilen günlerde adım haftalık olarak tekrar eder  
  ![Rutin Gün Seçimi](/mnt/data/Ekran Resmi 2025-11-21 17.41.31.png)

---

### 👤 5. Profil ve Kişiselleştirme

- Kullanıcı profili üzerinden temel bilgiler:
  - Yaş aralığı (örn. 18–24)
  - Cinsiyet
- Cilt tipi:
  - Örn. **Kuru**, **Karma**, **Yağlı**…
- Cilt sorunları (multi-select liste):
  - Hassas Cilt
  - Düzensiz Doku
  - Esneklik Kaybı
  - vb.
- Profil ekranındaki her kart **kalem ikonu** ile düzenlenebilir.
- Cilt analizi geçmişine profil üzerinden de erişim sağlanır.

Ekran görüntüsü:

- Profil ekranı  
  ![Profil Ekranı](/mnt/data/Ekran Resmi 2025-11-21 17.39.39.png)

---

## 🛠 Teknolojiler

- **Swift 5**
- **UIKit** tabanlı çok sekmeli (TabBar) yapı
- **SnapKit** ile Auto Layout yönetimi (tüm ekranlarda modern, esnek layout)
- **Custom Bottom Sheet** bileşenleri (yarım ekran, drag-to-dismiss, arka plan blur/gri)
- **UserDefaults** / hafif veri saklama (rutinler, ürünler, kullanıcı tercihleri vb.)
- (Opsiyonel / Proje altyapısına göre) **AI servis entegrasyonu**:
  - Cilt analizi için sunucu tarafında çalışan bir yapay zeka servisine istek atma
  - Dönen JSON verilerini parçalayarak:
    - Genel skor  
    - Uzun açıklama  
    - Detaylı parametre skorlarını ekranda gösterme

---
