part of '../stripes_builder.dart';

class QuestionKeys {
  static const String id = '__id__';
  static const String text = '__text__';
  static const String type = '__type__';
  static const String digest = '__digestible__';
}

class QuestionEntity extends Equatable {
  final String id;

  final String text;

  final String? type;

  final String digestible;

  QuestionEntity(
      {required this.id,
      required this.text,
      this.type,
      required this.digestible});

  QuestionEntity.fromMap(Map<String, dynamic> map)
      : this.id = map[QuestionKeys.id]!,
        this.text = map[QuestionKeys.id],
        this.type =
            map.containsKey(QuestionKeys.type) ? map[QuestionKeys.type] : null,
        this.digestible = map.containsKey(QuestionKeys.digest)
            ? map[QuestionKeys.digest]
            : '';

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      QuestionKeys.id: id,
      QuestionKeys.text: text,
      QuestionKeys.digest: digestible,
    };
    if (type != null) map[QuestionKeys.type] = type;
    return map;
  }

  @override
  List<Object?> get props => [id, text, type, digestible];
}
