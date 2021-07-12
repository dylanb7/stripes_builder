part of '../stripes_builder.dart';

class StampKeys {
  static const String stampKey = "__stamp__";

  static const String typeKey = "__type__";
}

abstract class StampEntitySerializer {
  StampEntity fromMap(Map<String, dynamic> map);

  Stamp from(StampEntity entity);
}

abstract class StampEntity {

  Map<String, dynamic> toMap();

  int get stamp;

}