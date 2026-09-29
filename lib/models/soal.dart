class Soal {
  final int? idSoal;
  final int idUjian;
  final String teksSoal;
  final String opsiA;
  final String opsiB;
  final String opsiC;
  final String opsiD;
  final String jawabanBenar;

  Soal({
    this.idSoal,
    required this.idUjian,
    required this.teksSoal,
    required this.opsiA,
    required this.opsiB,
    required this.opsiC,
    required this.opsiD,
    required this.jawabanBenar,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id_ujian': idUjian,
      'teks_soal': teksSoal,
      'opsi_a': opsiA,
      'opsi_b': opsiB,
      'opsi_c': opsiC,
      'opsi_d': opsiD,
      'jawaban_benar': jawabanBenar,
    };
    if (idSoal != null) {
      map['id_soal'] = idSoal;
    }
    return map;
  }

  factory Soal.fromMap(Map<String, dynamic> map) {
    return Soal(
      idSoal: map['id_soal'],
      idUjian: map['id_ujian'],
      teksSoal: map['teks_soal'],
      opsiA: map['opsi_a'],
      opsiB: map['opsi_b'],
      opsiC: map['opsi_c'],
      opsiD: map['opsi_d'],
      jawabanBenar: map['jawaban_benar'],
    );
  }
}
