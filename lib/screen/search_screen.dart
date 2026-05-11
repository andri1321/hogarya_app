import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String searchText = "";

  final List<Map<String, String>> properties = [
    {
      "image":
          "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
      "type": "Apartamento moderno",
      "price": "\$120,000",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1512917774080-9991f1c4c750",
      "type": "Casa familiar",
      "price": "\$250,000",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
      "type": "Solar grande",
      "price": "\$80,000",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1497366754035-f200968a6e72",
      "type": "Local",
      "price": "\$80,000",
    },
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark,
      ),
    );

    searchController.addListener(() {
      setState(() {
        searchText =
            searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProperties =
        properties.where((property) {
      return property["type"]!
          .toLowerCase()
          .contains(searchText);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3EEF2),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 MISMO BOTÓN DEL FEED
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Container(
                      height: 58,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                                30),
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.04),
                            blurRadius: 10,
                            offset:
                                const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.black54,
                            size: 28,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: TextField(
                              controller:
                                  searchController,
                              decoration:
                                  InputDecoration(
                                hintText:
                                    "Buscar propiedades...",
                                hintStyle:
                                    TextStyle(
                                  color: Colors
                                      .grey
                                      .shade500,
                                  fontSize: 17,
                                ),
                                border:
                                    InputBorder.none,
                              ),
                              style:
                                  const TextStyle(
                                fontSize: 17,
                                color:
                                    Colors.black87,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              _showFilters();
                            },
                            icon: const Icon(
                              Icons.tune,
                              color: Color(
                                  0xFFFF4D5A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// 🏠 GRID
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: GridView.builder(
                  physics:
                      const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.only(
                    bottom: 20,
                  ),
                  itemCount:
                      filteredProperties.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.74,
                  ),
                  itemBuilder:
                      (context, index) {
                    final property =
                        filteredProperties[
                            index];

                    return _propertyCard(
                      image:
                          property["image"]!,
                      title:
                          property["type"]!,
                      price:
                          property["price"]!,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _propertyCard({
    required String image,
    required String title,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin:
                        Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black
                          .withOpacity(0.85),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.white
                          .withOpacity(0.9),
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              "Filtros",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}