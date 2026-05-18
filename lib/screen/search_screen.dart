import 'dart:ui' as ui;
import 'dart:ui';

import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/map_property.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  GoogleMapController? mapController;

  final TextEditingController _searchController =
      TextEditingController();

  /// PRECIO
  final TextEditingController _minPriceController =
      TextEditingController();

  final TextEditingController _maxPriceController =
      TextEditingController();

  /// CENTRO DEL MAPA
  final LatLng _center =
      const LatLng(19.4517, -70.6970);

  /// ESTILO MAPA OSCURO
  String? darkMapStyle;

  /// ANIMACIÓN MAPA ENTRADA
  bool _mapEntered = false;

  String? _selectedPropertyId;

  /// FILTROS
  String selectedOperation = "Venta";
  String selectedType = "Apartamento";

  final List<String> operationFilters = [
    "Venta",
    "Alquiler",
  ];

  final List<String> typeFilters = [
    "Apartamento",
    "Habitación",
    "Casa",
    "Villa",
    "Penthouse",
  ];

  final Set<Marker> _locationMarkers = {};
  Set<Marker> _markersState = {};
  List<MapProperty> _visibleProperties = [];
  LatLngBounds? _currentBounds;

  final List<Property> _fallbackProperties = [
    Property(
      id: "map_1",
      title: "Apartamento moderno",
      description: "Apartamento moderno cerca del centro de Santiago.",
      city: "Santiago",
      type: "Apartamento",
      price: 4500000,
      images: const [
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
      ],
      likes: 120,
      comments: 45,
      shares: 10,
      views: 500,
      owner: Owner(
        name: "Pedro Almonte",
        avatar: "https://i.pravatar.cc/150?img=3",
        verified: true,
      ),
      isFavorite: false,
      latitude: 19.4550,
      longitude: -70.6990,
      bedrooms: 3,
      bathrooms: 2,
      size: 145,
    ),
    Property(
      id: "map_2",
      title: "Casa familiar acogedora",
      description: "Casa familiar con patio y buena ubicación.",
      city: "Santiago",
      type: "Casa",
      price: 6500000,
      images: const [
        "https://images.unsplash.com/photo-1572120360610-d971b9d7767c",
      ],
      likes: 230,
      comments: 60,
      shares: 25,
      views: 980,
      owner: Owner(
        name: "Ana Garcia",
        avatar: "https://i.pravatar.cc/150?img=9",
        verified: true,
      ),
      isFavorite: false,
      latitude: 19.4490,
      longitude: -70.6940,
      bedrooms: 3,
      bathrooms: 2,
      parking: 1,
      size: 200,
    ),
    Property(
      id: "map_3",
      title: "Villa exclusiva",
      description: "Villa con espacios amplios y terminaciones premium.",
      city: "Santiago",
      type: "Villa",
      price: 12000000,
      images: const [
        "https://images.unsplash.com/photo-1613977257363-707ba9348227",
      ],
      likes: 560,
      comments: 120,
      shares: 80,
      views: 2400,
      owner: Owner(
        name: "Maria Lopez",
        avatar: "https://i.pravatar.cc/150?img=5",
        verified: true,
      ),
      isFavorite: true,
      latitude: 19.4470,
      longitude: -70.7010,
      bedrooms: 4,
      bathrooms: 3,
      parking: 2,
      size: 450,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _mapEntered = true;
      });
      _updateVisibleProperties().then((_) {
        if (mounted && _visibleProperties.isNotEmpty) {
          setState(() {
            _selectedPropertyId = _visibleProperties.first.property.id;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();

    super.dispose();
  }

  Future<void> _goToPosition(
    LatLng position,
  ) async {
    final controller = mapController;

    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        position,
        16,
      ),
    );
  }

  Future<void> _onCameraIdle() async {
    if (mapController == null) return;
    final bounds = await mapController!.getVisibleRegion();
    setState(() {
      _currentBounds = bounds;
    });
    _updateVisibleProperties();
  }

  Future<void> _updateVisibleProperties() async {
    final source = UserData.allPublications.isNotEmpty
        ? UserData.allPublications
        : _fallbackProperties;

    final filtered = source.where((property) {
      final operationMatch = selectedOperation == "Venta"
          ? property.isForSale
          : !property.isForSale;
      final typeMatch = selectedType.isEmpty || property.type == selectedType;
      final minPrice = double.tryParse(_minPriceController.text.trim()) ?? 0;
      final maxPrice = double.tryParse(_maxPriceController.text.trim()) ??
          double.infinity;
      final priceMatch = property.price >= minPrice && property.price <= maxPrice;

      return operationMatch && typeMatch && priceMatch;
    }).toList();

    List<MapProperty> mapped = List.generate(filtered.length, (index) {
      return MapProperty.fromProperty(
        filtered[index],
        fallbackPosition: LatLng(
          _center.latitude + (index * 0.003),
          _center.longitude + (index * 0.003),
        ),
      );
    });

    if (_currentBounds != null) {
      mapped = mapped.where((item) {
        return _currentBounds!.contains(item.position);
      }).toList();
    }

    setState(() {
      _visibleProperties = mapped;
    });

    await _updateMarkers();
  }

  String _formatPriceShort(double price) {
    if (price >= 1000000) {
      return "DOP ${(price / 1000000).toStringAsFixed(1)}M";
    } else if (price >= 1000) {
      return "DOP ${(price / 1000).toStringAsFixed(0)}K";
    }
    return "DOP ${price.toStringAsFixed(0)}";
  }

  Future<BitmapDescriptor> _createCustomMarker(String text, bool isSelected) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint = Paint()
      ..color = isSelected ? Colors.black : Colors.white;

    final Paint borderPaint = Paint()
      ..color = isSelected ? Colors.transparent : Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double width = 100.0;
    final double height = 45.0;
    final Radius radius = const Radius.circular(20.0);

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.0, 0.0, width, height),
      radius,
    );

    final Path path = Path()..addRRect(rRect);
    canvas.drawShadow(path, Colors.black, 4.0, true);

    canvas.drawRRect(rRect, paint);
    canvas.drawRRect(rRect, borderPaint);

    final TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 15.0,
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );

    painter.layout();
    painter.paint(
      canvas,
      Offset(
        (width * 0.5) - painter.width * 0.5,
        (height * 0.5) - painter.height * 0.5,
      ),
    );

    final img = await pictureRecorder.endRecording().toImage(
          width.toInt(),
          height.toInt(),
        );
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> _updateMarkers() async {
    final Set<Marker> newMarkers = {};

    for (final item in _visibleProperties) {
      final selected = item.property.id == _selectedPropertyId;
      final icon = await _createCustomMarker(
          _formatPriceShort(item.property.price), selected);

      newMarkers.add(Marker(
        markerId: MarkerId(item.property.id),
        position: item.position,
        icon: icon,
        onTap: () => _selectProperty(item),
      ));
    }

    newMarkers.addAll(_locationMarkers);

    if (mounted) {
      setState(() {
        _markersState = newMarkers;
      });
    }
  }

  Future<void> _selectProperty(
    MapProperty item,
  ) async {
    setState(() {
      _selectedPropertyId = item.property.id;
    });

    await _goToPosition(item.position);
    await _updateMarkers();
  }

  Widget _cachedPropertyImage(String? imageUrl) {
    return imageUrl == null
        ? Container(
            width: 130,
            height: double.infinity,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.home_outlined,
              size: 44,
              color: Colors.grey,
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: 130,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 130,
              height: double.infinity,
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 130,
              height: double.infinity,
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.broken_image,
                size: 44,
                color: Colors.grey,
              ),
            ),
          );
  }

  String _formatPrice(double price) {
    final formatted = price
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"),
            (match) => ",");

    return "DOP $formatted";
  }

  Future<void> _searchLocation(
    String query,
  ) async {
    if (query.trim().isEmpty) return;

    final queryWithCountry = query.trim().toLowerCase().contains("republica dominicana") || 
                             query.trim().toLowerCase().contains("república dominicana")
        ? query.trim()
        : "${query.trim()}, República Dominicana";

    try {
      final locations = await locationFromAddress(
        queryWithCountry,
      );

      if (locations.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se encontró la ubicación.',
            ),
          ),
        );

        return;
      }

      final location = locations.first;

      final position = LatLng(
        location.latitude,
        location.longitude,
      );

      setState(() {
        _locationMarkers.removeWhere(
          (marker) =>
              marker.markerId.value ==
              'search_location',
        );

        _locationMarkers.add(
          Marker(
            markerId: const MarkerId(
              'search_location',
            ),

            position: position,

            infoWindow: InfoWindow(
              title: query.trim(),
            ),

            icon:
                BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueYellow,
            ),
          ),
        );
      });

      await _updateMarkers();

      await _goToPosition(position);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error buscando la ubicación.',
          ),
        ),
      );
    }
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor activa el servicio de ubicación.',
          ),
        ),
      );

      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
            LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permiso de ubicación denegado.',
          ),
        ),
      );

      return;
    }

    final position =
        await Geolocator.getCurrentPosition();

    final target = LatLng(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _locationMarkers.removeWhere(
        (marker) =>
            marker.markerId.value ==
            'current_location',
      );

      _locationMarkers.add(
        Marker(
          markerId: const MarkerId(
            'current_location',
          ),

          position: target,

          infoWindow: const InfoWindow(
            title: 'Ubicación actual',
          ),

          icon:
              BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan,
          ),
        ),
      );
    });

    await _updateMarkers();

    await _goToPosition(target);
  }

  /// MODAL FILTROS
  void _openFilters() {
    showModalBottomSheet(
      context: context,

      backgroundColor: const Color(
        0xFFF8F8F8,
      ),

      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      builder: (context) {
        return StatefulBuilder(
          builder: (
            context,
            modalSetState,
          ) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                24,
                22,
                40,
              ),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    /// HANDLE
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Filtros",

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// OPERACIÓN
                    const Text(
                      "Operación",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children: operationFilters.map(
                        (filter) {
                          final selected =
                              selectedOperation ==
                                  filter;

                          return GestureDetector(
                            onTap: () {
                              modalSetState(() {
                                selectedOperation =
                                    filter;
                              });

                              setState(() {});
                            },

                            child:
                                AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds: 250,
                              ),

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: selected
                                    ? Colors.black
                                    : Colors.white,

                                borderRadius:
                                    BorderRadius.circular(
                                  30,
                                ),

                                border: Border.all(
                                  color: Colors.black
                                      .withValues(
                                    alpha: 0.08,
                                  ),
                                ),
                              ),

                              child: Text(
                                filter,

                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.black,

                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 28),

                    /// TIPO
                    const Text(
                      "Tipo de propiedad",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children: typeFilters.map(
                        (filter) {
                          final selected =
                              selectedType ==
                                  filter;

                          return GestureDetector(
                            onTap: () {
                              modalSetState(() {
                                selectedType =
                                    filter;
                              });

                              setState(() {});
                            },

                            child:
                                AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds: 250,
                              ),

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: selected
                                    ? Colors.black
                                    : Colors.white,

                                borderRadius:
                                    BorderRadius.circular(
                                  30,
                                ),

                                border: Border.all(
                                  color: Colors.black
                                      .withValues(
                                    alpha: 0.08,
                                  ),
                                ),
                              ),

                              child: Text(
                                filter,

                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.black,

                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 28),

                    /// PRECIO
                    const Text(
                      "Precio",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 58,

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),

                              border: Border.all(
                                color: Colors.black
                                    .withValues(
                                  alpha: 0.08,
                                ),
                              ),
                            ),

                            child: TextField(
                              controller:
                                  _minPriceController,

                              keyboardType:
                                  TextInputType
                                      .number,

                              decoration:
                                  const InputDecoration(
                                hintText:
                                    "Mínimo",

                                border:
                                    InputBorder.none,

                                contentPadding:
                                    EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Container(
                            height: 58,

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),

                              border: Border.all(
                                color: Colors.black
                                    .withValues(
                                  alpha: 0.08,
                                ),
                              ),
                            ),

                            child: TextField(
                              controller:
                                  _maxPriceController,

                              keyboardType:
                                  TextInputType
                                      .number,

                              decoration:
                                  const InputDecoration(
                                hintText:
                                    "Máximo",

                                border:
                                    InputBorder.none,

                                contentPadding:
                                    EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black,

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Aplicar filtros",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// CARGAR ESTILO MAPA
  Future<void> _loadMapStyle() async {
    try {
      final style =
          await rootBundle.loadString(
        'assets/map/map_style_dark.json',
      );

      if (!mounted) return;

      setState(() {
        darkMapStyle = style;
      });
    } catch (_) {
      darkMapStyle = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          /// MAPA
          AnimatedOpacity(
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            opacity: _mapEntered ? 1 : 0,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              scale: _mapEntered ? 1 : 1.04,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(
                  target: _center,
                  zoom: 14,
                ),

                markers: _markersState,
                onCameraIdle: _onCameraIdle,

                zoomControlsEnabled: false,
                myLocationButtonEnabled:
                    false,

                compassEnabled: false,

                buildingsEnabled: true,

                mapToolbarEnabled: false,

                style: darkMapStyle,

                onMapCreated: (controller) {
                  mapController = controller;
                },
              ),
            ),
          ),

          /// OVERLAY
          IgnorePointer(
            child: Container(
              color: Colors.black.withValues(
                alpha: 0.08,
              ),
            ),
          ),

          /// GRADIENTE
          IgnorePointer(
            child: Container(
              height: 220,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:
                      Alignment.topCenter,

                  end:
                      Alignment.bottomCenter,

                  colors: [
                    Colors.black.withValues(
                      alpha: 0.45,
                    ),

                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// SEARCH
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),

              child: Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 18,
                        sigmaY: 18,
                      ),

                      child: Container(
                        height: 64,

                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.15,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            24,
                          ),

                          border: Border.all(
                            color: Colors.white
                                .withValues(
                              alpha: 0.18,
                            ),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.15,
                              ),

                              blurRadius: 25,
                            ),
                          ],
                        ),

                        child: TextField(
                          controller:
                              _searchController,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                          ),

                          textInputAction:
                              TextInputAction
                                  .search,

                          onSubmitted:
                              _searchLocation,

                          decoration:
                              InputDecoration(
                            hintText:
                                'Buscar provincia, ciudad o zona...',

                            hintStyle:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withValues(
                                alpha: 0.65,
                              ),
                            ),

                            prefixIcon:
                                Icon(
                              Icons.search,

                              color: Colors
                                  .white
                                  .withValues(
                                alpha: 0.85,
                              ),
                            ),

                            suffixIcon:
                                Padding(
                              padding:
                                  const EdgeInsets
                                      .all(
                                10,
                              ),

                              child:
                                  GestureDetector(
                                onTap:
                                    _openFilters,

                                child:
                                    Container(
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        Colors
                                            .white,

                                    borderRadius:
                                        BorderRadius.circular(
                                      14,
                                    ),
                                  ),

                                  child:
                                      const Icon(
                                    Icons
                                        .tune,

                                    color: Colors
                                        .black,

                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            border:
                                InputBorder
                                    .none,

                            contentPadding:
                                const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// BOTÓN UBICACIÓN
          Positioned(
            right: 18,
            bottom: 170,

            child: _floatingButton(
              icon: Icons.my_location,
              onTap:
                  _goToCurrentLocation,
            ),
          ),

          /// BOTÓN FAVORITOS
          Positioned(
            right: 18,
            bottom: 240,

            child: _floatingButton(
              icon:
                  Icons.favorite_border,

              onTap: () {},
            ),
          ),

          /// MARKERS RENUEVOS

          /// BOTTOM SHEET
          DraggableScrollableSheet(
            initialChildSize: 0.18,
            minChildSize: 0.15,
            maxChildSize: 0.82,

            snap: true,

            snapSizes: const [
              0.18,
              0.45,
              0.82,
            ],

            builder: (
              context,
              scrollController,
            ) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF8F8F8,
                  ),

                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(
                      34,
                    ),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.20,
                      ),

                      blurRadius: 35,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 12,
                      ),

                      child: Container(
                        width: 60,
                        height: 5,

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.grey
                                  .shade400,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 22,
                      ),

                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              const Text(
                                "Propiedades",

                                style:
                                    TextStyle(
                                  fontSize:
                                      24,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 3,
                              ),

                              Text(
                                "${_visibleProperties.length} resultados cerca",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors
                                          .grey,
                                ),
                              ),
                            ],
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.black,

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),

                            child:
                                const Row(
                              children: [
                                Icon(
                                  Icons.map,

                                  color:
                                      Colors
                                          .white,

                                  size:
                                      18,
                                ),

                                SizedBox(
                                  width: 8,
                                ),

                                Text(
                                  "Mapa",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Expanded(
                      child:
                          ListView.builder(
                        controller:
                            scrollController,

                        physics:
                            const BouncingScrollPhysics(),

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),

                        itemCount: _visibleProperties.length,

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          final item = _visibleProperties[index];
                          final selected =
                              item.property.id == _selectedPropertyId;
                          final property = item.property;
                          final imageUrl = property.images.isNotEmpty
                              ? property.images.first
                              : null;

                          return GestureDetector(
                            onTap:
                                () async {
                              await _selectProperty(item);
                            },
                            child:
                                AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds:
                                    300,
                              ),
                              curve: Curves.easeOutCubic,
                              margin:
                                  EdgeInsets.only(
                                bottom:
                                    20,
                                left: selected ? 0 : 4,
                                right: selected ? 0 : 4,
                              ),
                              height:
                                  selected ? 156 : 145,
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  selected ? 28 : 24,
                                ),
                                border: Border.all(
                                  color: selected
                                      ? Colors.black.withValues(
                                          alpha:
                                              0.12,
                                        )
                                      : Colors.transparent,
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: selected ? 0.12 : 0.05,
                                    ),
                                    blurRadius:
                                        selected ? 26 : 18,
                                    offset:
                                        const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child:
                                  Row(
                                children: [
                                  Hero(
                                    tag:
                                        'map-house-${property.id}-$index',
                                    child:
                                        ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left:
                                            Radius.circular(
                                          24,
                                        ),
                                      ),
                                      child:
                                          _cachedPropertyImage(imageUrl),
                                    ),
                                  ),
                                  Expanded(
                                    child:
                                        Padding(
                                      padding:
                                          const EdgeInsets.all(
                                        15,
                                      ),
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    Text(
                                                  property.title,
                                                  maxLines:
                                                      1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize:
                                                        17,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap:
                                                    () =>
                                                        UserData.toggleFavorite(
                                                          property,
                                                        ),
                                                child:
                                                    Icon(
                                                  property.isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: property.isFavorite
                                                      ? Colors.redAccent
                                                      : Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height:
                                                5,
                                          ),
                                          Text(
                                            "${property.city}, República Dominicana",
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style:
                                                TextStyle(
                                              color:
                                                  Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height:
                                                12,
                                          ),
                                          Row(
                                            children: [
                                              _miniInfo(
                                                Icons.bed,
                                                "${property.bedrooms}",
                                              ),
                                              const SizedBox(
                                                width:
                                                    12,
                                              ),
                                              _miniInfo(
                                                Icons.bathtub,
                                                "${property.bathrooms}",
                                              ),
                                              const SizedBox(
                                                width:
                                                    12,
                                              ),
                                              _miniInfo(
                                                Icons.square_foot,
                                                "${property.size.toInt()}m",
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child:
                                                    Text(
                                                  _formatPrice(
                                                      property.price),
                                                  maxLines:
                                                      1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(
                                                    color:
                                                        Colors.blue.shade900,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize:
                                                        20,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap:
                                                    () =>
                                                        context.push(
                                                          '/property-details',
                                                          extra:
                                                              property,
                                                        ),
                                                child:
                                                    Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal:
                                                        15,
                                                    vertical:
                                                        10,
                                                  ),
                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        selected
                                                            ? Colors.black
                                                            : Colors.grey.shade900,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      16,
                                                    ),
                                                  ),
                                                  child:
                                                      const Text(
                                                    "Detalles",
                                                    style:
                                                        TextStyle(
                                                      color:
                                                          Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// BOTÓN FLOTANTE
  Widget _floatingButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(22),

        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),

          child: Container(
            height: 58,
            width: 58,

            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.15,
              ),

              borderRadius:
                  BorderRadius.circular(
                22,
              ),

              border: Border.all(
                color:
                    Colors.white.withValues(
                  alpha: 0.15,
                ),
              ),
            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// MINI INFO
  Widget _miniInfo(
    IconData icon,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade700,
        ),

        const SizedBox(width: 4),

        Text(
          value,

          style: TextStyle(
            color: Colors.grey.shade700,

            fontWeight:
                FontWeight.w500,
          ),
        ),
      ],
    );
  }
}