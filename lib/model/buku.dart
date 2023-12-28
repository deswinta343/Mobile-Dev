class Buku {
  int id;
  String judul;
  String deskripsi;
  String photo;

  Buku({required this.id, required this.judul, required this.deskripsi, required this.photo});

  Map<String, dynamic> toList() {
    return {'id': id, 'judul': judul, 'deskripsi': deskripsi, 'photo': photo};
  }
}