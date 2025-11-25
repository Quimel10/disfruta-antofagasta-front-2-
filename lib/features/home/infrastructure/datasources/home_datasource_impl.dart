import 'package:dio/dio.dart';
import 'package:disfruta_antofagasta/config/constants/enviroment.dart';
import 'package:disfruta_antofagasta/features/home/domain/datasources/home_datasource.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/banner.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/category.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/place.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/weather.dart';
import 'package:disfruta_antofagasta/features/home/infrastructure/mappers/banner_mapper.dart';
import 'package:disfruta_antofagasta/features/home/infrastructure/mappers/category_mapper.dart';
import 'package:disfruta_antofagasta/features/home/infrastructure/mappers/place_mapper.dart';
import 'package:disfruta_antofagasta/features/home/infrastructure/mappers/weather_mapper.dart';

class HomeDatasourceImpl extends HomeDataSource {
  final Dio dio;
  final String accessToken;

  HomeDatasourceImpl({required this.accessToken, Dio? dio})
    : dio = dio ?? Dio(BaseOptions(baseUrl: Environment.apiUrl)) {
    print('🌐 DIO baseUrl: ${Environment.apiUrl}');

    // sacamos siempre Authorization
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.remove('Authorization');
          return handler.next(options);
        },
      ),
    );

    // logs
    this.dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  // -------- BANNERS --------
  @override
  Future<List<BannerEntity>> getBanners(String lang) async {
    try {
      print('🌐 GET BANNERS: ${dio.options.baseUrl}/get_banners?lang=$lang');

      final response = await dio.get(
        '/get_banners',
        queryParameters: {'lang': lang},
      );

      print('📡 BANNERS statusCode: ${response.statusCode}');
      print('📡 BANNERS raw: ${response.data}');

      final banners = BannerMapper.jsonToList(response.data);

      for (final b in banners) {
        print('🎯 BANNER => id:${b.id}, titulo:${b.titulo}, img:${b.img}');
      }

      return banners;
    } on DioException catch (e) {
      final serverMsg =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response!.data['message'].toString()
          : e.message ?? 'Network error';

      print('❌ getBanners DioException: $serverMsg');
      throw Exception('getBanners failed: $serverMsg');
    } catch (e, st) {
      print('❌ getBanners Exception: $e\n$st');
      throw Exception('getBanners failed: $e');
    }
  }

  // ---- CATEGORÍAS DESTACADAS ----
  @override
  Future<List<CategoryEntity>> getFeaturedCategory(String lang) async {
    try {
      final response = await dio.get(
        '/get_categorias_destacadas',
        queryParameters: {'lang': lang},
      );

      print('📡 FEATURED CATEGORIES status: ${response.statusCode}');
      print('📡 FEATURED CATEGORIES length: ${(response.data as List).length}');

      final categories = CategoryMapper.jsonToList(response.data);
      return categories;
    } on DioException catch (e) {
      final serverMsg =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response!.data['message'].toString()
          : e.message ?? 'Network error';

      print('❌ getFeaturedCategory DioException: $serverMsg');
      throw Exception('getFeaturedCategory failed: $serverMsg');
    } catch (e, st) {
      print('❌ getFeaturedCategory Exception: $e\n$st');
      throw Exception('getFeaturedCategory failed: $e');
    }
  }

  // -------- DESTACADOS HOME --------
  @override
  Future<List<PlaceEntity>> getFeatured({
    int? categoryId,
    required String lang,
  }) async {
    try {
      final response = await dio.get(
        '/get_new_destacados',
        queryParameters: {
          'lang': lang,
          if (categoryId != null) 'cat': categoryId,
        },
      );

      print('📡 FEATURED PLACES status: ${response.statusCode}');
      print('📡 FEATURED PLACES length: ${(response.data as List).length}');

      final featured = PlaceMapper.jsonToList(response.data);
      return featured;
    } on DioException catch (e) {
      final serverMsg =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response!.data['message'].toString()
          : e.message ?? 'Network error';

      print('❌ getFeatured DioException: $serverMsg');
      throw Exception('getFeatured failed: $serverMsg');
    } catch (e, st) {
      print('❌ getFeatured Exception: $e\n$st');
      throw Exception('getFeatured failed: $e');
    }
  }

  // ------------- CLIMA -------------
  @override
  Future<WeatherEntity> getWeather(String lang) async {
    try {
      final response = await dio.get(
        '/get_weather',
        queryParameters: {'lang': lang},
      );

      print('📡 WEATHER status: ${response.statusCode}');
      print('📡 WEATHER payload: ${response.data}');

      final weather = WeatherMapper.jsonToEntity(response.data);
      return weather;
    } on DioException catch (e) {
      final serverMsg =
          (e.response?.data is Map && e.response?.data['message'] != null)
          ? e.response!.data['message'].toString()
          : e.message ?? 'Network error';

      print('❌ getWeather DioException: $serverMsg');
      throw Exception('getWeather failed: $serverMsg');
    } catch (e, st) {
      print('❌ getWeather Exception: $e\n$st');
      throw Exception('getWeather failed: $e');
    }
  }
}
