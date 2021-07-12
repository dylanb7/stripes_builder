part of '../stripes_builder.dart';

int stampFrom({required DateTime dateTime}) => dateTime.millisecondsSinceEpoch;

abstract class Stamp {

  final int _stamp;

  Stamp(this._stamp);

  StampEntity toEntity();

  int get stamp => _stamp;

  String get key => "$_stamp";

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(_stamp);

}