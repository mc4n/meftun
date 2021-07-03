abstract class ModelBase {
  final String id;
  Map<String, dynamic> get map;
  ModelBase({this.id});
}

abstract class ModelFrom<T extends ModelBase> {
  T modelFrom(Map<String, dynamic> _map);
}
