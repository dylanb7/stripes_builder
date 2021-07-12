part of '../stripes_builder.dart';

abstract class StampRepository<T extends Stamp> {
  Stream<List<T>> get stamps;

  Future<void> addStamp(T stamp);

  Future<void> removeStamp(T stamp);

  Future<void> updateStamp(T stamp);
}

class FirebaseStampRepo<T extends Stamp> extends StampRepository<T> {
  final CollectionReference ref;

  final StampEntitySerializer serializer;

  FirebaseStampRepo(this.ref, this.serializer);

  FirebaseStampRepo.fromID(this.serializer,
      {required String uid,
      required CollectionReference userCol,
      String stampId = "__stamps__"})
      : this.ref = userCol.doc(uid).collection(stampId);

  @override
  Future<void> addStamp(T stamp) {
    return ref.doc(stamp.key).set(stamp.toEntity().toMap());
  }

  @override
  Future<void> removeStamp(T stamp) {
    return ref.doc(stamp.key).delete();
  }

  @override
  Stream<List<T>> get stamps => ref.snapshots().map((snapshot) => snapshot.docs
      .map((doc) =>
          serializer.from(serializer.fromMap(doc as Map<String, dynamic>)) as T)
      .toList());

  @override
  Future<void> updateStamp(Stamp stamp) {
    return ref.doc(stamp.key).update(stamp.toEntity().toMap());
  }
  
}
