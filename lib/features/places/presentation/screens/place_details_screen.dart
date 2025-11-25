import 'package:disfruta_antofagasta/features/places/presentation/widgets/audio_player_widget.dart';
import 'package:disfruta_antofagasta/config/theme/theme_config.dart';
import 'package:disfruta_antofagasta/features/home/domain/entities/place.dart';
import 'package:disfruta_antofagasta/features/places/presentation/state/place_provider.dart';
import 'package:disfruta_antofagasta/features/places/presentation/widgets/custom_sliver_app_bar.dart';
import 'package:disfruta_antofagasta/features/places/presentation/widgets/image_gallery_viewer.dart';
import 'package:disfruta_antofagasta/features/places/presentation/widgets/place_details_skeleton.dart';
import 'package:disfruta_antofagasta/features/places/presentation/widgets/place_map_card.dart';
import 'package:disfruta_antofagasta/shared/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🔹 Para renderizar HTML
import 'package:flutter_html/flutter_html.dart';

class PlaceDetailsScreen extends ConsumerStatefulWidget {
  final String placeId;

  const PlaceDetailsScreen({super.key, required this.placeId});

  @override
  PlaceDetailsScreenState createState() => PlaceDetailsScreenState();
}

class PlaceDetailsScreenState extends ConsumerState<PlaceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(placeProvider.notifier).placeDetails(widget.placeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placeProvider);
    final PlaceEntity? place = state.placeDetails;

    if (state.isLoadingPlaceDetails) {
      return const PlaceDetailsSkeleton();
    }

    if (place == null) {
      return const Scaffold(
        body: Center(child: Text("No se encontró información del lugar")),
      );
    }

    final lat = double.tryParse(place.latitud) ?? 0.0;
    final lng = double.tryParse(place.longitud) ?? 0.0;
    final urls = buildGalleryUrls(place);

    return Scaffold(
      backgroundColor: AppColors.bluePrimaryDark,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            isFavorite: ref.watch(favoritesProvider).contains(place.id),
            imageUrl: place.imagenHigh,
            title: place.titulo,
            heroTag: 'place_${place.id}',
            onFavoriteToggle: () {
              ref.read(favoritesProvider.notifier).toggle(place.id);
            },
            onShare: () {},
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título + categoría
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          place.titulo,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.sandLight,
                              ),
                        ),
                      ),
                      Chip(
                        backgroundColor: AppColors.sandLight,
                        avatar: Image.network(
                          place.tipoIcono,
                          width: 20,
                          height: 20,
                        ),
                        label: Text(
                          place.tipo,
                          style: const TextStyle(
                            color: AppColors.bluePrimaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Mapa
                  if (lat != 0 && lng != 0) ...[
                    const SizedBox(height: 16),
                    PlaceMapCard(lat: lat, lng: lng, title: place.titulo),
                  ],

                  const SizedBox(height: 8),

                  // Audio descriptivo
                  if (place.audio.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    AudioPlayerWidget(url: place.audio),
                    const SizedBox(height: 16),
                  ],

                  // 🔹 DESCRIPCIÓN RENDERIZANDO HTML
                  Html(
                    data: place.descLarga,
                    style: {
                      "*": Style(
                        color: AppColors.sandLight,
                        fontSize: FontSize(14),
                      ),
                      "p": Style(margin: Margins.only(bottom: 8)),
                      "strong": Style(fontWeight: FontWeight.bold),
                      "b": Style(fontWeight: FontWeight.bold),
                    },
                  ),

                  const SizedBox(height: 16),

                  // Galería
                  if (place.imgThumb.isNotEmpty) ...[
                    Text(
                      "Galería",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.sandLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: place.imgThumb.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final thumb = place.imgThumb[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => ImageGalleryViewer(
                                    imageUrls: urls,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Hero(
                                tag: 'place-${place.id}-img-$index',
                                child: Image.network(
                                  thumb,
                                  width: 100,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Construye las URLs para el visor de galería.
/// - Si existe `imgMedium[i]`, usa esa.
/// - Si no, usa el `imgThumb[i]` correspondiente.
/// Ya no reutilizamos `imagenHigh` para todas las posiciones.
List<String> buildGalleryUrls(PlaceEntity place) {
  return List<String>.generate(place.imgThumb.length, (i) {
    if (i < place.imgMedium.length && place.imgMedium[i].isNotEmpty) {
      return place.imgMedium[i];
    }

    // Fallback: usar el thumb de ese índice
    return place.imgThumb[i];
  });
}
