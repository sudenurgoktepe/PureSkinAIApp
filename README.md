# PureSkin AI

PureSkin AI, kullanıcıların cilt bakım rutinlerini yönetmesini, cilt analizlerini takip etmesini ve kişisel bakım ürünlerini organize etmesini sağlayan modern bir iOS uygulamasıdır. Uygulama, tamamen kullanıcı dostu bir arayüzle, yapay zekâ destekli cilt değerlendirme sistemi sunar.

---

## 🚀 Özellikler

### 🧪 Cilt Analizi
- Kullanıcı selfie yükleyerek yapay zekâ destekli analiz alır.
- “Genel Cilt Skoru” (0–100) oluşturulur.
- Uzun ve detaylı yorumlama metni sunulur (kırışıklıklar, göz çevresi, T bölgesi, donukluk vb.).
- Cilt problemleri alt başlıklar halinde puanlanır:
  - Göz Altı Morlukları  
  - Donukluk  
  - Kızarıklık  
  - Parlaklık Eksikliği  
  - Nem Dengesi vb.
- Analiz geçmişi takip edilebilir.

---

### 🧴 Ürün Yönetimi
- Kullanıcı kendi cilt bakım ürünlerini uygulamaya ekleyebilir.
- Ürün adı, kategori ve isteğe bağlı açıklama alanları bulunur.
- “Rutinime ekle” seçeneği ile ürün doğrudan sabah/akşam rutinine bağlanabilir.
- Ana sayfada tüm ürünler kart yapısıyla listelenir.

---

### 📅 Sabah & Akşam Rutinleri
- Haftalık takvim görünümü ile gün bazlı rutin planlama.
- Sabah ve akşam rutinleri ayrı sekmelerde tutulur.
- Her rutin adımında:
  - Başlık  
  - Kategori etiketi  
  - Ürün bağlantısı  
  - “Tamamlandı” işaretleme sistemi  
- Adım tamamlanınca:
  - İşaretlenir
  - Yazı rengi solar
  - Üst bilgi çubuğunda 0/5 gibi tamamlanma oranı güncellenir.

---

### ➕ Rutin Adımı Ekleme
- Alt kısımdan açılan modern bottom sheet yapısı.
- Kategorilere göre ayrılmış ürün/adım listesi:
  - Nemlendirici  
  - Serum  
  - Temizleme  
  - Tedavi  
  - Koruma  
  - Toner/Spray  
  - Diğer  
- Ürün/adım seçildikten sonra hangi günlerde uygulanacağı belirlenir:
  - Tek tek gün seçme
  - “Tümünü seç” özelliği
- Seçilen günlerde adım haftalık olarak tekrar eder.

---

### 👤 Profil Yönetimi
- Temel bilgiler:
  - Yaş aralığı  
  - Cinsiyet  
- Cilt tipi (Kuru, Yağlı, Karma vb.)
- Cilt sorunları (multi-select):
  - Hassas Cilt  
  - Düzensiz Doku  
  - Esneklik Kaybı  
  - Kızarıklık  
- Profil sayfasından analiz geçmişine erişim.

---

## 🛠 Kullanılan Teknolojiler

- **Swift**
- **UIKit**
- **SnapKit** (Auto Layout için)
- **UserDefaults** (veri saklama)
- **Custom Bottom Sheet Controller**
- **AI/ML analiz servisi entegrasyonu**  

---
