// lib/features/home/presentation/provider/home_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disfruta_antofagasta/features/home/domain/repositories/home_repository.dart';
import 'package:disfruta_antofagasta/features/home/infrastructure/datasources/home_datasource_impl.dart';
import 'package:disfruta_antofagasta/features/home/infrastructure/repositories/home_repository_impl.dart';

/// Proveedor del HomeRepository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  // Por ahora los endpoints de Home NO usan el token (lo estás borrando del header),
  // así que podemos pasar un string vacío sin problemas.
  final dataSource = HomeDatasourceImpl(
    accessToken: '', // si algún día lo necesitas, lo lees del authProvider aquí
  );

  return HomeRepositoryImpl(dataSource: dataSource);
});
