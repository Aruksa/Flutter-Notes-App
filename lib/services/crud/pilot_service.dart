import 'package:flutter/foundation.dart';
import 'package:pilot/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';     //importing dependencies
import 'package:path/path.dart' show join;

class PilotService{
  Database? _db;

  Future<DatabasePilot> updatePilot({required DatabasePilot pilot, required String text,}) async {
    final db = _getDatabaseOrThrow();
    await getPilot(id: pilot.id);
    final updatesCount = await db.update(pilotTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdatePilot();
    } else {
      return await getPilot(id: pilot.id);
    }
  }


  Future<Iterable<DatabasePilot>> getAllPilots () async {
    final db = _getDatabaseOrThrow();
    final pilots = await db.query(pilotTable);
    return pilots.map((pilotRow) => DatabasePilot.fromRow(pilotRow));
  }

  Future<DatabasePilot> getPilot({required int id}) async {
    final db = _getDatabaseOrThrow();
    final pilots = await db.query(
      pilotTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (pilots.isEmpty) {
      throw CouldNotFindPilot();
    } else {
      return DatabasePilot.fromRow(pilots.first);
    }
  }

  Future<int> deleteAllPilots() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(pilotTable);
  }

  Future<void> deletePilot({required String id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeletePilot();
    }
  }

  Future<DatabasePilot> createPilot({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    //make sure the email and its corresponding id are correct
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner){
      throw CouldNotFindUser();
    }
    const text = '';
    //create the note
    final pilotId = await db.insert(pilotTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabasePilot(id: pilotId, userId: owner.id, text: text, isSyncedWithCloud: true);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    }
    else
    {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException;
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createPilotTable);

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}


@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser ({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String,Object?> map) : id = map[idColumn] as int, email = map[emailColumn] as String;

  @override
  String toString () => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode; //use create hashCode from == operator

 }

 class DatabasePilot{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabasePilot({
    required this.id, required this.userId, required this.text, required this.isSyncedWithCloud,
  });

  DatabasePilot.fromRow(Map<String,Object?> map) : id = map[idColumn] as int, userId = map[userIdColumn] as int,
  text = map[textColumn] as String, isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true: false;

  @override
  String toString () => 'Pilot, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override
  bool operator ==(covariant DatabasePilot other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
 }

const dbName = 'pilot.db';
const userTable = 'user';
const pilotTable = 'pilot';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = "userId";
const textColumn = "text";
const isSyncedWithCloudColumn = "isSyncedWithCloud";

const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user" (
	      "id"	INTEGER NOT NULL,
	      "email"	TEXT NOT NULL UNIQUE,
	      PRIMARY KEY("id" AUTOINCREMENT)
        ); ''';

const createPilotTable = ''' CREATE TABLE IF NOT EXISTS "pilot" (
	      "id"	INTEGER NOT NULL,
	      "user_id"	INTEGER NOT NULL,
	      "text"	TEXT,
	      "is_synced_with_cloud"	INTEGER DEFAULT 0,
	      FOREIGN KEY("user_id") REFERENCES "user"("id"),
	      PRIMARY KEY("id" AUTOINCREMENT)
        ); ''';
