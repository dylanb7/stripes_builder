part of '../stripes_builder.dart';

abstract class QuestionRepository {
  Stream<List<Question>> get questions;

  Future<void> addQuestion(Question question);

  Future<void> removeQuestion(Question question);

  Future<void> updateQuestion(Question question);
}

class LocalQuestionRepo extends QuestionRepository {
  final List<QuestionEntity> allQuestions;

  final Digester _digester = Digester();

  LocalQuestionRepo(this.allQuestions);

  @override
  Future<void> addQuestion(Question question) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Question>> get questions => Stream.fromFuture(Future.value(
      allQuestions.map((entity) => _digester.digest(entity)).toList()));

  @override
  Future<void> removeQuestion(Question question) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateQuestion(Question question) {
    throw UnimplementedError();
  }
}

class FirebaseQuestionRepo extends QuestionRepository {
  final CollectionReference ref;

  final Digester _digester = Digester();

  FirebaseQuestionRepo({FirebaseFirestore? store, String? path})
      : this.ref = (store ?? FirebaseFirestore.instance)
            .collection(path ?? "Questions");

  @override
  Future<void> addQuestion(Question question) {
    return this.ref.doc(question.id).set(question.toEntity().toMap());
  }

  @override
  Stream<List<Question>> get questions =>
      ref.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => _digester.digest(
              QuestionEntity.fromMap(doc.data()! as Map<String, dynamic>)))
          .toList());

  @override
  Future<void> removeQuestion(Question question) {
    return this.ref.doc(question.id).delete();
  }

  @override
  Future<void> updateQuestion(Question question) {
    return this.ref.doc(question.id).update(question.toEntity().toMap());
  }
}
