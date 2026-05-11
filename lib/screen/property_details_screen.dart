/// 🔥 PROPERTY DETAILS SCREEN COMPLETA

import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/material.dart';

class PropertyDetailsScreen extends StatefulWidget {

  final Property property;

  const PropertyDetailsScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyDetailsScreen> createState() =>
      _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState
    extends State<PropertyDetailsScreen> {

  int currentPage = 0;

  String formatPrice(double price) {
    return "RD\$${price.toInt().toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ",",
        )}";
  }

  @override
  Widget build(BuildContext context) {

    final property = widget.property;

    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [

          /// 🔥 APPBAR IMAGENES
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: Colors.black,

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor:
                    Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            actions: [

              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor:
                      Colors.black.withOpacity(0.4),
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [

                  /// 🔥 PAGEVIEW
                  PageView.builder(
                    itemCount: property.images.length,

                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },

                    itemBuilder: (_, index) {

                      return Hero(
                        tag: property.id,
                        child: Image.network(
                          property.images[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),

                  /// 🔥 INDICADOR
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: List.generate(
                        property.images.length,
                        (index) {

                          final active =
                              currentPage == index;

                          return AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            width: active ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔥 CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  /// 🔥 TITULO
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 PRECIO
                  Text(
                    formatPrice(property.price),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 UBICACION
                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        property.city,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// 🔥 STATS
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [

                      _stat(
                        Icons.favorite,
                        property.likes.toString(),
                      ),

                      _stat(
                        Icons.chat,
                        property.comments.toString(),
                      ),

                      _stat(
                        Icons.send,
                        property.shares.toString(),
                      ),

                      _stat(
                        Icons.remove_red_eye,
                        property.views.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 DESCRIPCION
                  const Text(
                    "Descripción",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    property.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 OWNER
                  const Text(
                    "Propietario",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            property.owner.avatar,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [

                                  Text(
                                    property.owner.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 5),

                                  if (property
                                      .owner.verified)
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              const Text(
                                "Propietario verificado",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {},

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                30,
                              ),
                            ),
                          ),

                          child: const Text(
                            "Chat",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    IconData icon,
    String value,
  ) {
    return Column(
      children: [

        Icon(icon),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}