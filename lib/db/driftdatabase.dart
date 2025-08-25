import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// Define a table for favorites
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get value => text()();
}

// Create the database class manually
@DriftDatabase(tables: [Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Insert a favorite
  Future<int> addFavorite(String value) =>
      into(favorites).insert(FavoritesCompanion(value: Value(value)));

  // Get all favorites
  Future<List<Favorite>> getAllFavorites() => select(favorites).get();

  // Remove a favorite by value
  Future<int> removeFavorite(String value) =>
      (delete(favorites)..where((tbl) => tbl.value.equals(value))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
