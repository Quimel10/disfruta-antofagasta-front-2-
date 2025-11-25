import 'package:disfruta_antofagasta/features/home/domain/datasources/home_datasource.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/banner.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/category.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/place.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/weather.dart';
import 'package:disfruta_antofagasta/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  // -------- BANNERS --------
  @override
  Future<List<BannerEntity>> getBanners(String lang) {
    return dataSource.getBanners(lang);
  }

  // --- CATEGORÍAS DESTACADAS ---
  @override
  Future<List<CategoryEntity>> getFeaturedCategory(String lang) {
    return dataSource.getFeaturedCategory(lang);
  }

  // --- LUGARES DESTACADOS ---
  @override
  Future<List<PlaceEntity>> getFeatured({
    int? categoryId,
    required String lang,
  }) {
    return dataSource.getFeatured(categoryId: categoryId, lang: lang);
  }

  // -------- CLIMA --------
  @override
  Future<WeatherEntity> getWeather(String lang) {
    return dataSource.getWeather(lang);
  }
}
