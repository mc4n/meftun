import 'package:me_flutting/models/basemodel.dart' show ModelBase;
import 'package:me_flutting/helpers/table_helpers.dart';

abstract class BaseTable<T extends ModelBase> {
  final TableBaseHelper<T> store;
  BaseTable(this.store);
}
