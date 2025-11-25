import 'package:disfruta_antofagasta/features/home/domain/entities/banner.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/category.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/place.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/weather.dart';

abstract class HomeDataSource {
  Future<List<BannerEntity>> getBanners(String lang);

  Future<List<CategoryEntity>> getFeaturedCategory(String lang);

  Future<List<PlaceEntity>> getFeatured({
    int? categoryId,
    required String lang,
  });

  Future<WeatherEntity> getWeather(String lang);
}
