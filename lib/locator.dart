import 'package:get_it/get_it.dart';
import 'package:interceptor_layer/interceptor_layer.dart';
import 'package:network_layer/api_service.dart';
import 'package:network_layer/network_layer.dart';
import 'package:storage_layer/init_local_storage.dart';
import 'package:storage_layer/storage_layer.dart';
import 'package:worldofbooks/core/repository/books_repository/books_repository.dart';

GetIt locator = GetIt.instance;
Future<void> setupLocator() async {
  /// Local Storage
  final sembastService = SembastStorageService.instance;
  final localStorageService = LocalStorageService(sembastService);

  /// Interceptor & Network
  final apiInterceptor =
      ApiInterceptor(localStorageService, StorageTitles.authTokenFolder);

  locator.registerLazySingleton<BaseNetworkService>(
    () => BaseNetworkService(interceptors: [apiInterceptor]),
  );

  locator.registerLazySingleton<ApiService>(
      () => ApiService(locator.get<BaseNetworkService>()));

  /// Repository
  locator.registerLazySingleton<BooksRepository>(
    () => BooksRepository(locator.get<ApiService>()),
  );
}
