abstract class ModelBase {
  String get getId;
  Map<String, dynamic> get map;
}

abstract class ModelFrom<T extends ModelBase> {
  T modelFrom(Map<String, dynamic> _map);
}
