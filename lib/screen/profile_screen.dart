import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../data/user_data.dart';
import '../models/property.dart';
import '../widgets/stat_item.dart';
import '../widgets/property_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
 }

 class _ProfileScreenState
    extends State<ProfileScreen> {

  final ImagePicker picker = ImagePicker();

  File? get profileImage => UserData.profileImage;

  String get userName => UserData.userName;

  String get fullName => UserData.fullName;

  String get description => UserData.description;

  bool _showingFavorites = false;

  @override
  void initState() {
    super.initState();

    UserData.notifier.addListener(
      _refreshUserData,
    );
  }

  @override
  void dispose() {
    UserData.notifier.removeListener(
      _refreshUserData,
    );

    super.dispose();
  }

  void _refreshUserData() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final exampleProperty = Property(
      id: 'my-prop-1',

      title: 'Mi Propiedad',

      description:
          'Hermosa vista de la ciudad',

      price: 1500,

      city: 'Santiago',

      images: [
        'https://images.unsplash.com/photo-1568605114967-8130f3a36994?q=80&w=400',
      ],

      likes: 10,

      isFavorite: false,

      owner: Owner(
        name: 'Tu Nombre',

        avatar:
            'https://via.placeholder.com/150',

        verified: true,
      ),

      type: 'Casa',

      comments: 0,
      shares: 0,
      views: 0,

      bedrooms: 3,
      bathrooms: 2,
      parking: 2,
      hasKitchen: true,
      hasPatio: true,
      size: 250,
    );

    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FA),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,

        elevation: 0,

        leading: IconButton(
          onPressed: () {

            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
        ),

        centerTitle: true,

        title: const Text(
          "Perfil",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
            fontSize: 22,
          ),
        ),

        actions: [

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),

            onSelected: (value) {

              if (value == "ver") {

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Ver perfil",
                    ),
                  ),
                );
              }

              if (value == "editar") {

                _showEditProfileDialog();
              }

              if (value == "compartir") {

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Compartir perfil",
                    ),
                  ),
                );
              }

              if (value == "cerrar") {

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Cerrar sesión",
                    ),
                  ),
                );
              }
            },

            itemBuilder: (context) => [

              const PopupMenuItem(
                value: "ver",

                child: Row(
                  children: [

                    Icon(Icons.person),

                    SizedBox(width: 10),

                    Text("Ver perfil"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "editar",

                child: Row(
                  children: [

                    Icon(Icons.edit),

                    SizedBox(width: 10),

                    Text("Editar perfil"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "compartir",

                child: Row(
                  children: [

                    Icon(Icons.share),

                    SizedBox(width: 10),

                    Text("Compartir perfil"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "cerrar",

                child: Row(
                  children: [

                    Icon(Icons.logout),

                    SizedBox(width: 10),

                    Text("Cerrar sesión"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            /// 🔥 HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// FOTO PERFIL
 GestureDetector(
  onTap: _showImagePickerOptions,

  child: Stack(
    alignment: Alignment.center,

    children: [

      Container(
        width: 135,
        height: 135,

        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,

          image: profileImage != null
              ? DecorationImage(
                  image: FileImage(profileImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),

        child: profileImage == null
            ? Icon(
                Icons.person,
                size: 80,
                color: Colors.grey.shade600,
              )
            : null,
      ),

      Container(
        width: 135,
        height: 135,

        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
      ),
    ],
  ),
 ),

                    const SizedBox(width: 22),

                    /// INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const SizedBox(height: 8),

                          Text(
                            userName,

                            style:
                                const TextStyle(
                              fontSize: 34,
                              fontWeight:
                                  FontWeight.w900,
                              fontStyle:
                                  FontStyle.italic,
                            ),
                          ),

                          Text(
                            fullName,

                            style:
                                const TextStyle(
                              color:
                                  Colors.grey,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          Text(
                            description,

                            style:
                                const TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          /// 🔥 STATS
 SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 12,
    ),

    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,

      children: [

        /// 🔥 FOLLOWING CLICK
        GestureDetector(
          onTap: () {

            final following = [

              {
                "name": "Richie House",
                "username": "@richiehouse",
                "avatar":
                    "https://i.pravatar.cc/150?img=21",
              },

              {
                "name": "Laura Martinez",
                "username": "@lauram",
                "avatar":
                    "https://i.pravatar.cc/150?img=22",
              },

              {
                "name": "Andres Lopez",
                "username": "@andresl",
                "avatar":
                    "https://i.pravatar.cc/150?img=23",
              },

              {
                "name": "Camila Reyes",
                "username": "@camireyes",
                "avatar":
                    "https://i.pravatar.cc/150?img=24",
              },
            ];

            showModalBottomSheet(
              context: context,

              isScrollControlled: true,

              backgroundColor:
                  Colors.transparent,

              builder: (_) {

                return DraggableScrollableSheet(
                  initialChildSize: 0.75,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,

                  builder:
                      (_, scrollController) {

                    return Container(
                      decoration:
                          const BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.vertical(
                          top:
                              Radius.circular(
                            25,
                          ),
                        ),
                      ),

                      child: Column(
                        children: [

                          const SizedBox(
                            height: 12,
                          ),

                          Container(
                            width: 45,
                            height: 5,

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.grey
                                      .shade300,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          const Text(
                            "Siguiendo",

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Expanded(
                            child:
                                ListView.builder(
                              controller:
                                  scrollController,

                              itemCount:
                                  following.length,

                              itemBuilder:
                                  (_, index) {

                                final user =
                                    following[
                                        index];

                                return ListTile(

                                  leading:
                                      CircleAvatar(
                                    radius: 24,

                                    backgroundImage:
                                        NetworkImage(
                                      user[
                                          "avatar"]!,
                                    ),
                                  ),

                                  title: Text(
                                    user["name"]!,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  subtitle:
                                      Text(
                                    user[
                                        "username"]!,
                                  ),

                                  trailing:
                                      ElevatedButton(
                                    onPressed:
                                        () {},

                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.grey.shade200,

                                      elevation: 0,

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                    ),

                                    child:
                                        const Text(
                                      "Siguiendo",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.black,
                                      ),
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
                );
              },
            );
          },

          child: const StatItem(
            label: 'Following',
            value: '50.5K',
          ),
        ),

        /// 🔥 FOLLOWERS CLICK
        GestureDetector(
          onTap: () {

            final followers = [

              {
                "name": "Carlos Diaz",
                "username": "@carlosdz",
                "avatar":
                    "https://i.pravatar.cc/150?img=11",
              },

              {
                "name": "Maria Lopez",
                "username": "@marialopez",
                "avatar":
                    "https://i.pravatar.cc/150?img=12",
              },

              {
                "name": "Pedro Almonte",
                "username": "@pedroalmonte",
                "avatar":
                    "https://i.pravatar.cc/150?img=13",
              },

              {
                "name": "Ana Garcia",
                "username": "@anagarcia",
                "avatar":
                    "https://i.pravatar.cc/150?img=14",
              },
            ];

            showModalBottomSheet(
              context: context,

              isScrollControlled: true,

              backgroundColor:
                  Colors.transparent,

              builder: (_) {

                return DraggableScrollableSheet(
                  initialChildSize: 0.75,
                  minChildSize: 0.5,
                  maxChildSize: 0.95,

                  builder:
                      (_, scrollController) {

                    return Container(
                      decoration:
                          const BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.vertical(
                          top:
                              Radius.circular(
                            25,
                          ),
                        ),
                      ),

                      child: Column(
                        children: [

                          const SizedBox(
                            height: 12,
                          ),

                          Container(
                            width: 45,
                            height: 5,

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.grey
                                      .shade300,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          const Text(
                            "Seguidores",

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          Expanded(
                            child:
                                ListView.builder(
                              controller:
                                  scrollController,

                              itemCount:
                                  followers.length,

                              itemBuilder:
                                  (_, index) {

                                final user =
                                    followers[
                                        index];

                                return ListTile(

                                  leading:
                                      CircleAvatar(
                                    radius: 24,

                                    backgroundImage:
                                        NetworkImage(
                                      user[
                                          "avatar"]!,
                                    ),
                                  ),

                                  title: Text(
                                    user["name"]!,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  subtitle:
                                      Text(
                                    user[
                                        "username"]!,
                                  ),

                                  trailing:
                                      ElevatedButton(
                                    onPressed:
                                        () {},

                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.black,

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                    ),

                                    child:
                                        const Text(
                                      "Seguir",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.white,
                                      ),
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
                );
              },
            );
          },

          child: const StatItem(
            label: 'Followers',
            value: '47.3K',
          ),
        ),

        const StatItem(
          label: 'Likes',
          value: '90M',
        ),
      ],
    ),
  ),
 ),

            /// 🔥 BOTONES
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showingFavorites = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _showingFavorites
                    ? Colors.grey.shade400
                    : const Color.fromARGB(255, 84, 147, 198),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Mis publicaciones'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showingFavorites = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _showingFavorites
                    ? const Color.fromARGB(255, 193, 75, 67)
                    : Colors.grey.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Mis favoritos'),
            ),
          ],
        ),
      ),
    ),

            /// 🔥 GRID
            ValueListenableBuilder<int>(
              valueListenable: UserData.notifier,
              builder: (context, value, child) {
                final properties = _showingFavorites
                    ? UserData.favoriteProperties
                    : UserData.userPublications;

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < properties.length) {
                          return PropertyCard(
                            property: properties[index],
                            allowFavoriteToggle: _showingFavorites,
                          );
                        }

                        if (!_showingFavorites) {
                          return PropertyCard(
                            property: exampleProperty,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                      childCount: _showingFavorites
                          ? properties.length
                          : properties.length + 6,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 EDITAR PERFIL
  void _showEditProfileDialog() {

    final nameController =
        TextEditingController(
      text: userName,
    );

    final fullNameController =
        TextEditingController(
      text: fullName,
    );

    final descriptionController =
        TextEditingController(
      text: description,
    );

    showDialog(
      context: context,

      builder: (_) {

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Text(
            "Editar perfil",
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [

                TextField(
                  controller:
                      nameController,

                  decoration:
                      const InputDecoration(
                    labelText: "Usuario",
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller:
                      fullNameController,

                  decoration:
                      const InputDecoration(
                    labelText:
                        "Nombre completo",
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller:
                      descriptionController,

                  maxLines: 4,

                  decoration:
                      const InputDecoration(
                    labelText:
                        "Descripción",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "Cancelar",
              ),
            ),

            ElevatedButton(
              onPressed: () {

                setState(() {

                  UserData.userName =
                      nameController.text;

                  UserData.fullName =
                      fullNameController
                          .text;

                  UserData.description =
                      descriptionController
                          .text;
                });

                Navigator.pop(context);
              },

              child: const Text(
                "Guardar",
              ),
            ),
          ],
        );
      },
    );
  }

  void _openFavorites() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (
            context,
            scrollController,
          ) {
            return ValueListenableBuilder<int>(
              valueListenable: UserData.notifier,
              builder: (context, value, child) {
                final favorites =
                    UserData.favoriteProperties;

                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color:
                              Colors.grey.shade300,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Mis favoritos",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: favorites.isEmpty
                            ? const Center(
                                child: Text(
                                  "No tienes favoritos todavía",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : GridView.builder(
                                controller:
                                    scrollController,
                                physics:
                                    const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.all(
                                  16,
                                ),
                                itemCount:
                                    favorites.length,
                                itemBuilder:
                                    (_, index) {
                                  return PropertyCard(
                                    property:
                                        favorites[
                                            index],
                                    allowFavoriteToggle:
                                        true,
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio:
                                      0.75,
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
 /// 🔥 SELECCIONAR FOTO
void _showImagePickerOptions() {

  showModalBottomSheet(
    context: context,

    builder: (_) {

      return SafeArea(
        child: Wrap(
          children: [

            ListTile(
              leading: const Icon(
                Icons.photo_library,
              ),

              title: const Text(
                "Galería",
              ),

              onTap: () async {

                Navigator.pop(context);

                final XFile? image =
                    await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 70,
                );

                if (image != null) {

                  setState(() {

                    UserData.profileImage =
                        File(image.path);
                  });
                }
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.camera_alt,
              ),

              title: const Text(
                "Cámara",
              ),

              onTap: () async {

                Navigator.pop(context);

                final XFile? image =
                    await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 70,
                );

                if (image != null) {

                  setState(() {

                    UserData.profileImage =
                        File(image.path);
                  });
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
}
