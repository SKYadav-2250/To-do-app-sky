import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Auth use cases imports
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Task use cases imports
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/data/datasources/task_remote_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'features/tasks/domain/usecases/add_task_usecase.dart';
import 'features/tasks/domain/usecases/update_task_usecase.dart';
import 'features/tasks/domain/usecases/delete_task_usecase.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';

import 'core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        signUpUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      sharedPreferences: sl(),
    ),
  );
  
  // Features - Tasks
  // Bloc
  sl.registerFactory(() => TaskBloc(
        getTasksUseCase: sl(),
        addTaskUseCase: sl(),
        updateTaskUseCase: sl(),
        deleteTaskUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(apiClient: sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
