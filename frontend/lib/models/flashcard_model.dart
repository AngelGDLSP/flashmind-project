class FlashcardModel {
  final int id;
  final String pregunta;
  final String respuesta;
  final String dificultad;
  final String? ejemplo;
  final int vecesRepasada;
  final int idTema;
  
  // SRS Fields
  final int interval;
  final double easeFactor;
  final int repetitions;
  final DateTime nextReview;

  FlashcardModel({
    required this.id,
    required this.pregunta,
    required this.respuesta,
    required this.dificultad,
    this.ejemplo,
    required this.vecesRepasada,
    required this.idTema,
    required this.interval,
    required this.easeFactor,
    required this.repetitions,
    required this.nextReview,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id_ficha'],
      pregunta: json['pregunta'],
      respuesta: json['respuesta'],
      dificultad: json['dificultad'] ?? 'media',
      ejemplo: json['ejemplo'],
      vecesRepasada: json['veces_repasada'] ?? 0,
      idTema: json['id_tema'],
      interval: json['interval'] ?? 0,
      easeFactor: (json['ease_factor'] ?? 2.5).toDouble(),
      repetitions: json['repetitions'] ?? 0,
      nextReview: DateTime.parse(json['next_review'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ficha': id,
      'pregunta': pregunta,
      'respuesta': respuesta,
      'dificultad': dificultad,
      'ejemplo': ejemplo,
      'id_tema': idTema,
      'interval': interval,
      'ease_factor': easeFactor,
      'repetitions': repetitions,
      'next_review': nextReview.toIso8601String(),
    };
  }
}
