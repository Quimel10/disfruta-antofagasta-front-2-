class PlaceEntity {
  final int id;
  final String titulo;
  final String? publicado; // opcional
  final String descCorta;
  final String descLarga; // contenido largo en texto plano / fallback
  final String?
  descLargaHtml; // 👈 NUEVO: contenido con HTML (párrafos, negritas, etc.)
  final String latitud;
  final String longitud;
  final String tipo;
  final int tipoId;
  final String tipoIcono;
  final String? tipoPin; // opcional
  final String? tipoColor; // opcional
  final String imagen;
  final String imagenHigh;
  final List<String> imgThumb; // miniaturas
  final List<String> imgMedium; // fotos en tamaño medio
  final String audio;

  PlaceEntity({
    required this.id,
    required this.titulo,
    this.publicado,
    required this.descCorta,
    required this.descLarga,
    this.descLargaHtml, // 👈 NUEVO
    required this.latitud,
    required this.longitud,
    required this.tipo,
    required this.tipoId,
    required this.tipoIcono,
    this.tipoPin,
    this.tipoColor,
    required this.imagen,
    required this.imagenHigh,
    this.imgThumb = const [],
    this.imgMedium = const [],
    this.audio = "",
  });
}
