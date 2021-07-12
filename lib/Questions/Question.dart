part of '../stripes_builder.dart';

class Digester {
  static const String sep = '|';

  static const String sevPrefix = 'S';

  static const String multPrefix = 'M';

  const Digester();

  Question digest(QuestionEntity entity) {
    final String digest = entity.digestible;
    if (digest.startsWith(sevPrefix)) {
      final List<String> values = digest.replaceFirst(sevPrefix, '').split(sep);
      return SeverityQuestion(
          id: entity.id,
          text: entity.text,
          type: entity.type,
          bottomRange: double.parse(values.first),
          topRange: double.parse(values.last));
    } else if (digest.startsWith(multPrefix)) {
      final List<String> values =
          digest.replaceFirst(multPrefix, '').split(sep);
      return MultipleChoiceQuestion(
          id: entity.id, text: entity.text, type: entity.type, choices: values);
    }
    return CheckQuestion(id: entity.id, text: entity.text, type: entity.type);
  }
}

abstract class Question extends Equatable {
  final String id;

  final String text;

  final String? type;

  Question({required this.id, required this.text, this.type});

  QuestionEntity toEntity();
}

class CheckQuestion extends Question {
  CheckQuestion({required String id, required String text, String? type})
      : super(id: id, text: text, type: type);

  @override
  List<Object?> get props => [id, text, type];

  @override
  QuestionEntity toEntity() {
    return QuestionEntity(id: id, text: text, type: type, digestible: "");
  }
}

class SeverityQuestion extends Question {
  final double bottomRange;

  final double topRange;

  SeverityQuestion(
      {required String id,
      required String text,
      String? type,
      required this.bottomRange,
      required this.topRange})
      : super(id: id, text: text, type: type);

  @override
  List<Object?> get props => [id, text, type, bottomRange, topRange];

  @override
  QuestionEntity toEntity() {
    return QuestionEntity(
        id: id,
        text: text,
        type: type,
        digestible:
            "${Digester.sevPrefix}$bottomRange${Digester.sep}$topRange");
  }
}

class MultipleChoiceQuestion extends Question {
  final List<String> choices;

  MultipleChoiceQuestion(
      {required String id,
      required String text,
      required this.choices,
      String? type})
      : super(id: id, text: text, type: type);

  @override
  List<Object?> get props => [id, text, type, choices];

  @override
  QuestionEntity toEntity() {
    return QuestionEntity(
        id: id,
        text: text,
        type: type,
        digestible: "${Digester.multPrefix}${choices.join(Digester.sep)}");
  }
}
