class Peserta {
  final int? idPeserta;
  final int idUjian;
  final String nama;
  final String kelas;
  final String identitas;

  Peserta({
    this.idPeserta,
    required this.idUjian,
    required this.nama,
    required this.kelas,
    required this.identitas,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id_ujian': idUjian,
      'nama': nama,
      'kelas': kelas,
      'identitas': identitas,
    };
    if (idPeserta != null) {
      map['id_peserta'] = idPeserta;
    }
    return map;
  }

  factory Peserta.fromMap(Map<String, dynamic> map) {
    return Peserta(
      idPeserta: map['id_peserta'],
      idUjian: map['id_ujian'],
      nama: map['nama'],
      kelas: map['kelas'],
      identitas: map['identitas'],
    );
  }
}
