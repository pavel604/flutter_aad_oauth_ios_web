// ignore: unused_import
import 'platforms/storage_unsupported.dart'
    if (dart.library.io) 'platforms/storage_native.dart'
    if (dart.library.js) 'platforms/storage_web.dart';

abstract class IStorage {
  static IStorage get instance {
    return getPlatformStorage();
  }

  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
}
