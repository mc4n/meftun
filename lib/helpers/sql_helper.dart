import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbaseContext {
  final String dbName;
  final List<TableEntity> tableEntities;
  DbaseContext(this.dbName, this.tableEntities);

  String get cmdsOnCreate => tableEntities.map((m) => m.createString).join(';');

  Future<String> get dbPath async => join(await getDatabasesPath(), dbName);

  Future<Database> open() async {
    return openDatabase(await dbPath,
        version: 1, onCreate: (_, __) async => await _.execute(cmdsOnCreate));
  }

  T tableEntityOf<T extends TableEntity>() {
    for (final _ in tableEntities) {
      if (_ is T) return _;
    }
    return null;
  }
}

abstract class TableEntity<T extends ModelBase> {
  final String scheme;
  final String name;
  TableEntity(this.scheme, this.name);
  String get createString => 'create table $name ($scheme)';
  T from(Map<String, dynamic> _map);

  Future<List<T>> select(DbaseContext context) async {
    final db = await context.open();
    final maps = await db.query(name);
    await db.close();
    return List.generate(maps.length, (i) => from(maps[i]));
  }

  Future<void> insert(DbaseContext context, T item) async {
    final db = await context.open();
    await db.insert(
      name,
      item.map,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await db.close();
  }

  Future<void> delete(DbaseContext context, String id) async {
    final db = await context.open();
    await db.delete(name, where: "id = ?", whereArgs: [id]);
    await db.close();
  }
}

class MessageTable extends TableEntity<MessageModel> {
  MessageTable()
      : super(
            'tb_messages',
            'id nvarchar(200) primary key not null,'
                'body nvarchar(900) not null,'
                'from_id nvarchar(200) not null,'
                'chat_group_id nvarchar(200) not null,'
                'epoch integer not null');

  @override
  MessageModel from(Map<String, dynamic> _map) {
    return MessageModel(
      _map['id'],
      _map['body'],
      _map['from_id'],
      _map['chat_group_id'],
      _map['epoch'],
    );
  }
}

mixin ModelBase {
  Map<String, dynamic> get map;
}

class MessageModel with ModelBase {
  final String id;
  final String body;
  final String fromId;
  final String chatGroupId;
  final int epoch;
  const MessageModel(
      this.id, this.body, this.fromId, this.chatGroupId, this.epoch);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'body': body,
        'from_id': fromId,
        'chat_group_id': chatGroupId,
        'epoch': epoch,
      };
}

/*void main() {
  final dbP = DbaseContext('demo', [MessageTable()]);

  final messageStore = dbP.tableEntityOf<MessageTable>();

  messageStore.insert(
      dbP, MessageModel('0423423-42-342-', 'hello, world!', '_', '_', -1));
}*/
