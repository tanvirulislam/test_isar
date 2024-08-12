import 'package:isar/isar.dart';

part 'bank.info.g.dart';

@collection
class BankInfo {
  Id id = Isar.autoIncrement;
  String? name;
  String? imagePath;
  bool? isFavorite;
  bool? isSelected;

  BankInfo({
    this.name,
    this.imagePath,
    this.isFavorite,
    this.isSelected,
  });
}
