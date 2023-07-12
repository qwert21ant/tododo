import 'package:path_provider/path_provider.dart';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:tododo/model/app_config.dart';

import 'config_storage.dart';

class ConfigStorageImpl implements ConfigStorage {
  static const cfgName = 'config.db';

  ConfigStorageImpl();

  late final Database _db;
  final _store = StoreRef<String, Object>.main();

  late AppConfig _config;

  @override
  AppConfig get config => _config;

  @override
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);

    _db = await databaseFactoryIo.openDatabase('${appDir.path}/$cfgName');

    _config = AppConfig();

    final revision = await _store.record('localRevision').get(_db) as int?;
    if (revision == null) {
      await _store.record('localRevision').add(_db, 0);
    } else {
      _config.localRevision = revision;
    }

    final wasOnline = await _store.record('wasOnline').get(_db) as bool?;
    if (wasOnline == null) {
      await _store.record('wasOnline').add(_db, false);
      _config.wasOnline = true;
    } else {
      _config.wasOnline = wasOnline;
    }
  }

  @override
  Future<void> updateConfig(AppConfig newConfig) async {
    _config = newConfig;

    await _store.record('localRevision').update(_db, _config.localRevision);
    await _store.record('wasOnline').update(_db, _config.wasOnline);
  }
}
