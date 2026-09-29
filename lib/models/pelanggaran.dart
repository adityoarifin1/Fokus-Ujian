class Pelanggaran {
  final int? idPelanggaran;
  final int idPeserta;
  final String waktu;
  final double posisiX;
  final double posisiY;
  final String jenisPelanggaran;

  Pelanggaran({
    this.idPelanggaran,
    required this.idPeserta,
    required this.waktu,
    required this.posisiX,
    required this.posisiY,
    required this.jenisPelanggaran,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_pelanggaran': idPelanggaran,
      'id_peserta': idPeserta,
      'waktu': waktu,
      'posisi_x': posisiX,
      'posisi_y': posisiY,
      'jenis_pelanggaran': jenisPelanggaran,
    };
  }

  factory Pelanggaran.fromMap(Map<String, dynamic> map) {
    return Pelanggaran(
      idPelanggaran: map['id_pelanggaran'],
      idPeserta: map['id_peserta'],
      waktu: map['waktu'],
      posisiX: map['posisi_x'],
      posisiY: map['posisi_y'],
      jenisPelanggaran: map['jenis_pelanggaran'],
    );
  }
}
