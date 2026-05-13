import 'dart:io';

import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:app_hogar_ya/widgets/property_feed_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() =>
      _FeedScreenState();
}

class _FeedScreenState
    extends State<FeedScreen> {

  final TextEditingController searchController =
      TextEditingController();

  String selectedType = "Todos";
  String selectedCity = "Todos";

  double minPrice = 10000;
  double maxPrice = 2000000;

  /// 🔥 PROPIEDADES
  final List<Property> allProperties = [

    Property(
      id: "1",

      title: "Apartamento moderno",

      description:
          "Hermoso apartamento moderno ubicado en Santiago. Cuenta con 3 habitaciones, 2 baños, cocina moderna y balcón.",

      city: "Santiago",

      type: "Apartamento",

      price: 4500000,

      images: [
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
        "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688",
        "https://images.unsplash.com/photo-1494526585095-c41746248156",
      ],

      likes: 120,
      comments: 45,
      shares: 10,
      views: 500,

      owner: Owner(
        name: "Pedro Almonte",
        avatar:
            "https://i.pravatar.cc/150?img=3",
        verified: true,
      ),

      isFavorite: false,
      bedrooms: 3,
      bathrooms: 2,
      hasKitchen: true,
      hasBalcony: true,
    ),

    Property(
      id: "2",

      title: "Villa de lujo con piscina",

      description:
          "Villa exclusiva con piscina, patio enorme y acabados premium ubicada en Punta Cana.",

      city: "Punta Cana",

      type: "Casa",

      price: 12000000,

      images: [
        "https://images.unsplash.com/photo-1613977257363-707ba9348227",
        "https://images.unsplash.com/photo-1564013799919-ab600027ffc6",
        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c",
      ],

      likes: 560,
      comments: 120,
      shares: 80,
      views: 2400,

      owner: Owner(
        name: "Maria Lopez",
        avatar:
            "https://i.pravatar.cc/150?img=5",
        verified: true,
      ),

      isFavorite: true,
      bedrooms: 4,
      bathrooms: 3,
      hasPatio: true,
      parking: 2,
      size: 450,
    ),

    Property(
      id: "3",

      title: "Estudio económico",

      description:
          "Perfecto para estudiantes o parejas jóvenes. Económico y cómodo.",

      city: "La Vega",

      type: "Apartamento",

      price: 1800000,

      images: [
        "https://images.unsplash.com/photo-1507089947367-19c1da9775ae",
        "https://images.unsplash.com/photo-1484154218962-a197022b5858",
      ],

      likes: 80,
      comments: 20,
      shares: 5,
      views: 320,

      owner: Owner(
        name: "Carlos Diaz",
        avatar:
            "https://i.pravatar.cc/150?img=8",
        verified: false,
      ),

      isFavorite: false,
      bedrooms: 1,
      bathrooms: 1,
      hasKitchen: true,
      size: 45,
    ),

    Property(
      id: "4",

      title: "Casa familiar acogedora",

      description:
          "Casa ideal para familias, con patio y excelente ubicación en Santo Domingo.",

      city: "Santo Domingo",

      type: "Casa",

      price: 6500000,

      images: [
        "https://images.unsplash.com/photo-1572120360610-d971b9d7767c",
        "https://images.unsplash.com/photo-1448630360428-65456885c650",
      ],

      likes: 230,
      comments: 60,
      shares: 25,
      views: 980,

      owner: Owner(
        name: "Ana Garcia",
        avatar:
            "https://i.pravatar.cc/150?img=9",
        verified: true,
      ),

      isFavorite: false,
      bedrooms: 3,
      bathrooms: 2,
      hasPatio: true,
      parking: 1,
      size: 200,
    ),
  ];

  List<Property> filtered = [];

  @override
  void initState() {
    super.initState();

    UserData.setInitialPublications(
      allProperties,
    );

    filtered = UserData.allPublications;

    UserData.notifier.addListener(
      applyFilters,
    );
  }

  @override
  void dispose() {
    UserData.notifier.removeListener(
      applyFilters,
    );

    searchController.dispose();
    super.dispose();
  }

  /// 🔥 FILTROS
  void applyFilters() {

    setState(() {

      filtered = UserData.allPublications.where((p) {

        final searchMatch = p.title
            .toLowerCase()
            .contains(
              searchController.text.toLowerCase(),
            );

        final typeMatch =
            selectedType == "Todos" ||
                p.type == selectedType;

        final cityMatch =
            selectedCity == "Todos" ||
                p.city == selectedCity;

        final priceMatch =
            p.price >= minPrice &&
                p.price <= maxPrice;

        return searchMatch &&
            typeMatch &&
            cityMatch &&
            priceMatch;

      }).toList();
    });
  }

  /// 🔥 FILTROS MODAL
  void _openFilters() {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (_) {

        String tempType = selectedType;
        String tempCity = selectedCity;

        double tempMin = minPrice;
        double tempMax = maxPrice;

        return StatefulBuilder(
          builder: (
            context,
            setModalState,
          ) {

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom:
                    MediaQuery.of(context)
                            .viewInsets
                            .bottom +
                        20,
              ),

              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const Text(
                      "Filtros",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButton<String>(
                      value: tempType,
                      isExpanded: true,

                      items: [
                        "Todos",
                        "Casa",
                        "Apartamento",
                        "Solar",
                        "Local",
                        "Habitación",
                      ]
                          .map(
                            (e) =>
                                DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),

                      onChanged: (v) {

                        setModalState(() {
                          tempType = v!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    DropdownButton<String>(
                      value: tempCity,
                      isExpanded: true,

                      items: [
                        "Todos",
                        "Santiago",
                        "Santo Domingo",
                        "Punta Cana",
                        "La Vega",
                      ]
                          .map(
                            (e) =>
                                DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),

                      onChanged: (v) {

                        setModalState(() {
                          tempCity = v!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Precio mínimo: RD\$${tempMin.toInt()}",
                    ),

                    Slider(
                      min: 0,
                      max: 15000000,
                      value: tempMin,

                      onChanged: (v) {

                        setModalState(() {

                          tempMin = v;

                          if (tempMin > tempMax) {
                            tempMax = tempMin;
                          }
                        });
                      },
                    ),

                    Text(
                      "Precio máximo: RD\$${tempMax.toInt()}",
                    ),

                    Slider(
                      min: 0,
                      max: 15000000,
                      value: tempMax,

                      onChanged: (v) {

                        setModalState(() {

                          tempMax = v;

                          if (tempMax < tempMin) {
                            tempMin = tempMax;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {

                        setState(() {

                          selectedType = tempType;
                          selectedCity = tempCity;

                          minPrice = tempMin;
                          maxPrice = tempMax;
                        });

                        applyFilters();

                        Navigator.pop(context);
                      },

                      child: const Text(
                        "Aplicar",
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF3EEF2),

      body: SafeArea(
        child: Column(
          children: [

            _buildHeader(context),

            /// 🔍 SEARCH
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.03),
                      blurRadius: 10,
                      offset:
                          const Offset(0, 4),
                    ),
                  ],
                ),

                child: TextField(
                  controller: searchController,

                  onChanged: (_) =>
                      applyFilters(),

                  decoration: InputDecoration(
                    hintText:
                        "Buscar propiedades...",

                    hintStyle: TextStyle(
                      color:
                          Colors.grey.shade400,
                    ),

                    prefixIcon: const Icon(
                      Icons.search,
                      color:
                          Color(0xFFFF4D5A),
                    ),

                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color:
                            Color(0xFFFF4D5A),
                      ),

                      onPressed:
                          _openFilters,
                    ),

                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            /// 🔥 CHIPS
            SizedBox(
              height: 50,

              child: ListView(
                scrollDirection:
                    Axis.horizontal,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                children: [

                  _chip("Todos"),
                  _chip("Casa"),
                  _chip("Habitación"),
                  _chip("Villa"),
                  _chip("Apartamento"),
                  _chip("Solar"),
                  _chip("Local"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🔥 FEED
            Expanded(
              child: filtered.isEmpty

                  ? const Center(
                      child:
                          Text("Sin resultados"),
                    )

                  : ListView.builder(
                      physics:
                          const BouncingScrollPhysics(),

                      itemCount:
                          filtered.length,

                      itemBuilder:
                          (_, index) {

                        final property =
                            filtered[index];

                        return PropertyFeedCard(
                          property: property,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 CHIP
  Widget _chip(String text) {

    final selected =
        selectedType == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedType = text;
        });

        applyFilters();
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          right: 8,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(
                  0xFFFF4D5A,
                )
              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),

        child: Center(
          child: Text(
            text,

            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.black87,

              fontWeight: selected
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 HEADER
  Widget _buildHeader(
    BuildContext context,
  ) {

    return Padding(
      padding: const EdgeInsets.all(16),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          const Text(
            "HogarYa",

            style: TextStyle(
              fontSize: 30,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          AnimatedBuilder(
            animation: UserData.notifier,
            builder: (context, _) {

              final File? profileImage =
                  UserData.profileImage;

              return GestureDetector(
                onTap: () {
                  context.go('/profile');
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage)
                      : null,
                  child: profileImage == null
                      ? Icon(
                          Icons.person,
                          color: Colors.grey.shade600,
                          size: 24,
                        )
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
