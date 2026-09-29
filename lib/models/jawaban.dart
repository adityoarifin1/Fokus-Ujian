class Jawaban {
  final int? idJawaban;
  final int idPeserta;
  final int idSoal;
  final String jawaban;
  final String waktuJawab;

  Jawaban({
    this.idJawaban,
    required this.idPeserta,
    required this.idSoal,
    required this.jawaban,
    required this.waktuJawab,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_jawaban': idJawaban,
      'id_peserta': idPeserta,
      'id_soal': idSoal,
      'jawaban': jawaban,
      'waktu_jawab': waktuJawab,
    };
  }

  factory Jawaban.fromMap(Map<String, dynamic> map) {
    return Jawaban(
      idJawaban: map['id_jawaban'],
      idPeserta: map['id_peserta'],
      idSoal: map['id_soal'],
      jawaban: map['jawaban'],
      waktuJawab: map['waktu_jawab'],
    );
  }
}
