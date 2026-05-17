import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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

  /// MARCADORES
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('home_1'),
      position: const LatLng(19.4550, -70.6990),
      infoWindow: const InfoWindow(
        title: 'Casa Moderna',
        snippet: 'DOP 35K',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure,
      ),
    ),

    Marker(
      markerId: const MarkerId('home_2'),
      position: const LatLng(19.4490, -70.6940),
      infoWindow: const InfoWindow(
        title: 'Apartamento Premium',
        snippet: 'DOP 45K',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRose,
      ),
    ),

    Marker(
      markerId: const MarkerId('home_3'),
      position: const LatLng(19.4470, -70.7010),
      infoWindow: const InfoWindow(
        title: 'Villa Exclusiva',
        snippet: 'DOP 85K',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
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

  Future<void> _searchLocation(
    String query,
  ) async {
    if (query.trim().isEmpty) return;

    try {
      final locations = await locationFromAddress(
        query.trim(),
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
        _markers.removeWhere(
          (marker) =>
              marker.markerId.value ==
              'search_location',
        );

        _markers.add(
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
      _markers.removeWhere(
        (marker) =>
            marker.markerId.value ==
            'current_location',
      );

      _markers.add(
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
          GoogleMap(
            initialCameraPosition:
                CameraPosition(
              target: _center,
              zoom: 14,
            ),

            markers: _markers,

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

          /// OVERLAY
          Container(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
          ),

          /// GRADIENTE
          Container(
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

          /// MARKERS
          Positioned(
            left: 60,
            top: 280,

            child: _priceMarker(
              "DOP 35K",
              true,
            ),
          ),

          Positioned(
            right: 80,
            top: 340,

            child: _priceMarker(
              "DOP 45K",
              false,
            ),
          ),

          Positioned(
            left: 130,
            top: 420,

            child: _priceMarker(
              "DOP 85K",
              false,
            ),
          ),

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
                          const Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
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

                              SizedBox(
                                height: 3,
                              ),

                              Text(
                                "12 resultados cerca",

                                style:
                                    TextStyle(
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

                        itemCount: 10,

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          return GestureDetector(
                            onTap:
                                () async {
                              final controller =
                                  mapController;

                              if (controller ==
                                  null) {
                                return;
                              }

                              await controller
                                  .animateCamera(
                                CameraUpdate.newLatLngZoom(
                                  LatLng(
                                    19.4517 +
                                        (index *
                                            0.001),

                                    -70.6970,
                                  ),

                                  16,
                                ),
                              );
                            },

                            child:
                                AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds:
                                    250,
                              ),

                              margin:
                                  const EdgeInsets.only(
                                bottom:
                                    20,
                              ),

                              height:
                                  145,

                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.white,

                                borderRadius:
                                    BorderRadius.circular(
                                  28,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha:
                                          0.05,
                                    ),

                                    blurRadius:
                                        18,
                                  ),
                                ],
                              ),

                              child:
                                  Row(
                                children: [
                                  Hero(
                                    tag:
                                        'house$index',

                                    child:
                                        ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left:
                                            Radius.circular(
                                          28,
                                        ),
                                      ),

                                      child:
                                          Image.network(
                                        'https://images.unsplash.com/photo-1568605114967-8130f3a36994',

                                        width:
                                            130,

                                        height:
                                            double.infinity,

                                        fit: BoxFit.cover,
                                      ),
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
                                                  "Apartamento Moderno",

                                                  style:
                                                      TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,

                                                    fontSize:
                                                        17,
                                                  ),
                                                ),
                                              ),

                                              Icon(
                                                Icons.favorite_border,

                                                color:
                                                    Colors.grey.shade700,
                                              ),
                                            ],
                                          ),

                                          const SizedBox(
                                            height:
                                                5,
                                          ),

                                          Text(
                                            "Santiago, República Dominicana",

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
                                                "3",
                                              ),

                                              const SizedBox(
                                                width:
                                                    12,
                                              ),

                                              _miniInfo(
                                                Icons.bathtub,
                                                "2",
                                              ),

                                              const SizedBox(
                                                width:
                                                    12,
                                              ),

                                              _miniInfo(
                                                Icons.square_foot,
                                                "145m",
                                              ),
                                            ],
                                          ),

                                          const Spacer(),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text(
                                                "DOP 45,000",

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
                                                      Colors.black,

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

  /// MARKER PRECIO
  Widget _priceMarker(
    String price,
    bool selected,
  ) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color:
            selected
                ? Colors.white
                : Colors.black,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.25,
            ),

            blurRadius: 15,
          ),
        ],
      ),

      child: Text(
        price,

        style: TextStyle(
          color:
              selected
                  ? Colors.black
                  : Colors.white,

          fontWeight:
              FontWeight.bold,
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