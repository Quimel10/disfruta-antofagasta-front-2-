import 'package:disfruta_antofagasta/features/home/domain/repositories/home_repository.dart';
import 'package:disfruta_antofagasta/features/home/presentation/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository repository;

  /// Idioma actual (es, en, pt, fr)
  String _currentLang = 'es';

  HomeNotifier({required this.repository}) : super(HomeState.initial());

  /// --- CARGA INICIAL / CAMBIO DE IDIOMA ---
  Future<void> init(String lang) async {
    _currentLang = lang;

    // reseteamos estado
    state = state.copyWith(
      isLoadingBanners: true,
      isLoadingCategories: true,
      isLoadingPlaces: true,
      isLoadingWeather: true,
      errorMessage: null,
      errorMessageBanner: null,
      selectedCategoryId: 0,
      banners: null,
      categories: null,
      places: null,
      weather: null,
    );

    await Future.wait([
      loadBanners(),
      loadCategories(),
      loadFeaturedPlaces(),
      loadWeather(),
    ], eagerError: false);
  }

  /// Pull-to-refresh desde Home
  Future<void> refresh(String lang) => init(lang);

  // ---------------- BANNERS ----------------
  Future<void> loadBanners() async {
    state = state.copyWith(isLoadingBanners: true, errorMessageBanner: null);

    try {
      final banners = await repository.getBanners(_currentLang);
      state = state.copyWith(
        isLoadingBanners: false,
        banners: banners,
        errorMessageBanner: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingBanners: false,
        errorMessageBanner: 'Error loading banners: $e',
      );
    }
  }

  // -------------- CATEGORÍAS ---------------
  Future<void> loadCategories() async {
    state = state.copyWith(isLoadingCategories: true, errorMessage: null);

    try {
      final categories = await repository.getFeaturedCategory(_currentLang);
      state = state.copyWith(
        isLoadingCategories: false,
        categories: categories,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingCategories: false,
        errorMessage: 'Error loading categories: $e',
      );
    }
  }

  // ---------- LUGARES DESTACADOS ----------
  Future<void> loadFeaturedPlaces({int? categoryId}) async {
    state = state.copyWith(isLoadingPlaces: true, errorMessage: null);

    final catId = categoryId ?? state.selectedCategoryId;

    try {
      final places = await repository.getFeatured(
        categoryId: catId,
        lang: _currentLang,
      );

      state = state.copyWith(isLoadingPlaces: false, places: places);
    } catch (e) {
      state = state.copyWith(
        isLoadingPlaces: false,
        errorMessage: 'Error loading places: $e',
      );
    }
  }

  // ----------------- CLIMA -----------------
  Future<void> loadWeather() async {
    state = state.copyWith(isLoadingWeather: true, errorMessage: null);

    try {
      final weather = await repository.getWeather(_currentLang);
      state = state.copyWith(isLoadingWeather: false, weather: weather);
    } catch (e) {
      state = state.copyWith(
        isLoadingWeather: false,
        errorMessage: 'Error loading weather: $e',
      );
    }
  }

  /// --- CAMBIAR CATEGORÍA ---
  Future<void> selectCategory(int? categoryId) async {
    if (state.selectedCategoryId == categoryId) {
      categoryId = 0;
    }

    state = state.copyWith(selectedCategoryId: categoryId);
    await loadFeaturedPlaces(categoryId: categoryId);
  }
}
