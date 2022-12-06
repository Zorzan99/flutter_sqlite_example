import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSqlLite {
  Future<Database> openConnection() async {
    final databasePath = await getDatabasesPath();
    final databaseFinalPath = join(databasePath, 'SQLITE_EXAMPLE');
    print(databasePath);
    print(databaseFinalPath);
    return await openDatabase(
      databaseFinalPath,
      version: 2,
      onConfigure: (db) async {
        print('onConfigure Chamado');
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // Chamado sommente no momento de criação do banco de dados
      // primeira vez que carrega o app
      onCreate: (Database db, int version) {
        print('onCreateChamado');

        final batch = db.batch();

        batch.execute('''
        create table teste(
          id Integer primary key autoincrement,
          nome varchar(200)
        )

        ''');
        batch.execute('''
        create table produto(
          id Integer primary key autoincrement,
          nome varchar(200)
        )

        ''');
        // batch.execute('''
        // create table categorias(
        //   id Integer primary key autoincrement,
        //   nome varchar(200)
        // )

        // ''');
        batch.commit();
      },
      // Será chamado sempre que ouver uma alteração no version incremental (1 -> 2)

      onUpgrade: (Database db, int oldVersion, int version) {
        print('onUpgradeChamado');
        final batch = db.batch();

        if (oldVersion == 1) {
          batch.execute('''
        create table produto(
          id Integer primary key autoincrement,
          nome varchar(200)
        )

        ''');
          //   batch.execute('''
          // create table categorias(
          //   id Integer primary key autoincrement,
          //   nome varchar(200)
          // )

          // ''');

        }

        // if (oldVersion == 2) {
        //   batch.execute('''
        // create table categorias(
        //   id Integer primary key autoincrement,
        //   nome varchar(200)
        // )

        // ''');
        // }
        batch.commit();
      },
      // Será chamado sempre que ouver uma alteração no version decremental (2 -> 1)
      onDowngrade: (Database db, int oldVersion, int version) {
        print('onDowngradeChamado');
        final batch = db.batch();

        if (oldVersion == 3) {
          batch.execute('''
        drop table categorias(
        ''');
        }
        batch.commit();
      },
    );
  }
}
