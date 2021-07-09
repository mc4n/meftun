abstract class ModelBase<Tkey> {
  final Tkey id;
  ModelBase({this.id});

  List<String> get fields => map.keys.toList();
  List<dynamic> get values => map.values.toList();

  Map<String, dynamic> selectMap(List<int> indexes) {
    if (indexes.length == 0)
      return throw Exception('no fields was selected!');
    else if (indexes.length > fields.length)
      return throw Exception('too much arguments supplied!');
    else
      return Map.fromEntries(
          indexes.map((i) => MapEntry(fields[i], values[i])));
  }

  Map<String, dynamic> get map;

  @override
  bool operator ==(Object other) =>
      id == ((other is ModelBase) ? other.id : null);

  @override
  int get hashCode => id.hashCode;
}

abstract class ModelFrom<T extends ModelBase<Tkey>, Tkey> {
  T modelFrom(Tkey _key, Map<String, dynamic> _map);
}
