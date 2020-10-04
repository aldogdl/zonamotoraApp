import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBApp {

  final nombreBD = 'zonamotora.db';

  static Database _database;
  static final DBApp db = DBApp._();
  DBApp._();

  /* */
  Future<Database> get abrir async {

    if(_database != null){
      if(_database.isOpen) {
        return _database;
      }
    }

    _database = await initDB();
    return _database;
  }

  /* */
  Future<void> borrarBd() async {

    Directory directorioDocument = await getApplicationDocumentsDirectory();
    final pathAlArchivoDb = join(directorioDocument.path, nombreBD);
    await deleteDatabase(pathAlArchivoDb);
  }

  /* */
  Future<Database> initDB() async {

    Directory directorioDocument = await getApplicationDocumentsDirectory();
    final pathAlArchivoDb = join(directorioDocument.path, nombreBD);
    
    return await openDatabase(
      pathAlArchivoDb,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {

        await db.execute(
          'CREATE TABLE user ('
          ' u_id INTEGER,'
          ' u_usname TEXT,'
          ' u_uspass TEXT,'
          ' u_roles TEXT,'
          ' u_nombre TEXT,'
          ' u_tokenServer TEXT,'
          ' u_tokenDevices TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE autos ('
          ' md_id INTEGER,'
          ' mk_id INTEGER,'
          ' md_nombre TEXT,'
          ' mk_nombre TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE categos ('
          ' cat_id INTEGER,'
          ' cat_catego TEXT,'
          ' cat_despeq TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE misAutos ('
          ' idReg INTEGER,'
          ' mdid INTEGER,'
          ' mkid INTEGER,'
          ' mdNombre TEXT,'
          ' mkNombre TEXT,'
          ' anio INTEGER,'
          ' version TEXT,'
          ' createdAt TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE notifics ('
          ' id INTEGER,'
          ' idServer INTEGER,'
          ' cant INTEGER,'
          ' tema TEXT,'
          ' titulo TEXT,'
          ' page TEXT,'
          ' createdAt TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE proccRoto ('
          ' nombre TEXT,'
          ' path TEXT,'
          ' metadata TEXT,'
          ' contents TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE cotizaciones ('
          ' filename TEXT,'
          ' createdAt TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE carshop ('
          ' idInv INTEGER,'
          ' createdAt TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE favs ('
          ' pbl_id INTEGER,'
          ' u_id INTEGER, '
          ' cat_id INTEGER,'
          ' sa_id INTEGER,'
          ' pbl_queVendes TEXT,'
          ' pbl_descripcion TEXT,'
          ' pbl_precio TEXT,'
          ' pbl_fotos TEXT,'
          ' createdAt TEXT'
          ');'
        );
      },
      singleInstance: true,
      readOnly: false,
    );
  }

}