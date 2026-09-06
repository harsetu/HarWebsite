import 'package:get_it/get_it.dart';
import '../bloc/contact_cubit.dart';
import '../bloc/language_bloc.dart';
import '../network/base_api.dart';
import '../network/secure_storage_service.dart';
import '../utils/package_info_wrapper.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupService() async {
  // Network services
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  getIt.registerLazySingleton<BaseApi>(() => BaseApi());
  getIt.registerLazySingleton<PackageInfoWrapper>(() => PackageInfoWrapper());

  // Blocs
  getIt.registerLazySingleton<LanguageBloc>(() => LanguageBloc());
  getIt.registerFactory<ContactCubit>(() => ContactCubit());
}
