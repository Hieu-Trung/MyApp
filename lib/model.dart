import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class Model{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String detail;
  @HiveField(2)
  final bool isCompleted;

  Model({this.title, this.detail, this.isCompleted});
}