class Contact {
  int? id; // id di-set nullable karena akan di-generate oleh database
  String name;
  String phone;
  String? email;
  String label;

  // Menjadikan id nullable sehingga tidak wajib diisi
  Contact({
    this.id, // id bersifat nullable
    required this.name,
    required this.phone,
    this.email,
    required this.label,
  });

  // Fungsi untuk mengonversi Contact menjadi Map (untuk disimpan ke DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,  // id biarkan null jika belum ada
      'name': name,
      'phone': phone,
      'email': email,
      'label': label,
    };
  }

  // Fungsi untuk mengonversi Map menjadi Contact (ketika membaca data dari DB)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'], // Mengambil id dari database
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      label: map['label'],
    );
  }
}
