class Ujian {
  final int? idUjian;
  final String namaUjian;
  final String mataPelajaran;
  final int durasi;
  final String tanggal;
  final String status;
  final String kodeUjian;

  Ujian({
    this.idUjian,
    required this.namaUjian,
    required this.mataPelajaran,
    required this.durasi,
    required this.tanggal,
    required this.status,
    required this.kodeUjian,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nama_ujian': namaUjian,
      'mata_pelajaran': mataPelajaran,
      'durasi': durasi,
      'tanggal': tanggal,
      'status': status,
      'kode_ujian': kodeUjian,
    };
    if (idUjian != null) {
      map['id_ujian'] = idUjian;
    }
    return map;
  }

  factory Ujian.fromMap(Map<String, dynamic> map) {
    return Ujian(
      idUjian: map['id_ujian'],
      namaUjian: map['nama_ujian'],
      mataPelajaran: map['mata_pelajaran'],
      durasi: map['durasi'],
      tanggal: map['tanggal'],
      status: map['status'],
      kodeUjian: map['kode_ujian'],
    );
  }
}
