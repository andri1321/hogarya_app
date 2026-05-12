import 'dart:io';

import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:app_hogar_ya/screen/registrar_ubicacion_screen.dart';
import 'package:app_hogar_ya/screen/registro_propiedad_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddNewPublicationScreen extends StatefulWidget {
  const AddNewPublicationScreen({super.key});

  @override
  State<AddNewPublicationScreen> createState() =>
      _AddNewPublicationScreenState();
}

class _AddNewPublicationScreenState
    extends State<AddNewPublicationScreen> {

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  /// 🏷️ CATEGORÍA
  String selectedCategory =
      "Selecciona una categoría";

  final List<String> categories = [
    "Apto",
    "Solar",
    "Casa",
    "Habitación",
    "Local",
    "Villa",
  ];

  /// 🔥 OPERACIÓN
  String selectedOperation =
      "Selecciona operación";

  final List<String> operations = [
    "Venta",
    "Alquiler",
  ];

  /// 📸 IMÁGENES
  final List<XFile> images = [];

  final ImagePicker picker = ImagePicker();
  String? provincia;
  String? ciudad;
  String? sector;

  Future<void> pickImages() async {

    final List<XFile> picked =
        await picker.pickMultiImage();

    if (picked.isNotEmpty) {

      setState(() {

        if (images.length + picked.length <= 10) {

          images.addAll(picked);

        } else {

          final remaining = 10 - images.length;

          images.addAll(
            picked.take(remaining),
          );
        }
      });
    }
  }

  @override
  void dispose() {

    titleController.dispose();

    priceController.dispose();

    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.of(context).size.width;

    final ImageProvider userAvatarImage =
        UserData.profileImage != null
            ? FileImage(UserData.profileImage!)
            : NetworkImage(
                UserData.networkImage,
              );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// 🔝 HEADER
              Row(
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
                      size: 34,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Text(
                      "Nueva Publicacion",

                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.08,

                        fontWeight:
                            FontWeight.w900,

                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              /// 👤 USER INFO
              Row(
                children: [

                  CircleAvatar(
                    radius: 22,

                    backgroundImage:
                        userAvatarImage,
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        UserData.userName,

                        style: const TextStyle(
                          fontSize: 22,

                          fontWeight:
                              FontWeight.w800,

                          fontStyle:
                              FontStyle.italic,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        "nueva publicacion",

                        style: const TextStyle(
                          color: Colors.black54,

                          fontSize: 12,

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// 🔥 BUTTONS
              Row(
                children: [

                  /// CANCEL
                  Expanded(
                    child: SizedBox(
                      height: 48,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFFE95B5B,
                          ),

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Cancel",

                          style: TextStyle(
                            fontSize: 16,

                            fontWeight:
                                FontWeight.bold,

                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// PUBLICAR
                  Expanded(
                    child: SizedBox(
                      height: 48,

                      child: ElevatedButton(
                        onPressed: _publishProperty,

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF119BFF,
                          ),

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Publicar",

                          style: TextStyle(
                            fontSize: 16,

                            fontWeight:
                                FontWeight.bold,

                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// 🖼️ IMAGE PICKER
              GestureDetector(
                onTap: pickImages,

                child: Container(
                  width: double.infinity,
                  height: 140,

                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFD9D9D9,
                    ),

                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: images.isEmpty

                      /// 🔥 VACÍO
                      ? Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: const [

                            Icon(
                              Icons
                                  .add_photo_alternate_outlined,

                              size: 42,

                              color: Colors.black45,
                            ),

                            SizedBox(height: 8),

                            Text(
                              "Agregar fotos",

                              style: TextStyle(
                                color: Colors.black54,

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        )

                      /// 🔥 IMÁGENES
                      : ListView.builder(
                          scrollDirection:
                              Axis.horizontal,

                          itemCount: images.length,

                          itemBuilder:
                              (context, index) {

                            return Padding(
                              padding:
                                  const EdgeInsets.all(
                                6,
                              ),

                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),

                                child: GestureDetector(
                                  onTap: () {

                                    showDialog(
                                      context: context,

                                      barrierColor:
                                          Colors.black,

                                      builder: (_) {

                                        return StatefulBuilder(
                                          builder:
                                              (
                                                context,
                                                setDialogState,
                                              ) {

                                            final controller =
                                                PageController(
                                              initialPage:
                                                  index,
                                            );

                                            int currentIndex =
                                                index;

                                            return Dialog(
                                              backgroundColor:
                                                  Colors.black,

                                              insetPadding:
                                                  EdgeInsets.zero,

                                              child: Stack(
                                                children: [

                                                  /// 📸 GALERÍA
                                                  PageView.builder(
                                                    controller:
                                                        controller,

                                                    itemCount:
                                                        images.length,

                                                    onPageChanged:
                                                        (
                                                          value,
                                                        ) {

                                                      setDialogState(
                                                        () {

                                                          currentIndex =
                                                              value;
                                                        },
                                                      );
                                                    },

                                                    itemBuilder:
                                                        (
                                                          context,
                                                          i,
                                                        ) {

                                                      return InteractiveViewer(
                                                        minScale:
                                                            1,

                                                        maxScale:
                                                            4,

                                                        child:
                                                            Center(
                                                          child:
                                                              Image.file(
                                                            File(
                                                              images[i]
                                                                  .path,
                                                            ),

                                                            fit:
                                                                BoxFit.contain,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),

                                                  /// ❌ CLOSE
                                                  Positioned(
                                                    top: 45,
                                                    right: 18,

                                                    child:
                                                        GestureDetector(
                                                      onTap:
                                                          () {

                                                        Navigator.pop(
                                                          context,
                                                        );
                                                      },

                                                      child:
                                                          const CircleAvatar(
                                                        radius:
                                                            20,

                                                        backgroundColor:
                                                            Colors.black54,

                                                        child:
                                                            Icon(
                                                          Icons.close,

                                                          color:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  /// 🔢 CONTADOR
                                                  Positioned(
                                                    bottom: 30,
                                                    left: 0,
                                                    right: 0,

                                                    child:
                                                        Center(
                                                      child:
                                                          Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                          horizontal:
                                                              16,

                                                          vertical:
                                                              8,
                                                        ),

                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.black54,

                                                          borderRadius:
                                                              BorderRadius.circular(
                                                            20,
                                                          ),
                                                        ),

                                                        child:
                                                            Text(
                                                          "${currentIndex + 1}/${images.length}",

                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.white,

                                                            fontSize:
                                                                16,

                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
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

                                  child: Image.file(
                                    File(
                                      images[index].path,
                                    ),

                                    width: 120,
                                    height: 140,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Fotos: ${images.length}/10  Elige primero la foto principal de la publicación",

                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 28),

              /// 📝 TITLE
              _buildInput(
                controller: titleController,
                hint: "Título",
              ),

              const SizedBox(height: 18),

              /// 💰 PRICE
              _buildInput(
                controller: priceController,

                hint: "Precio",

                keyboard:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),

              const SizedBox(height: 18),

              /// 🔥 OPERACIÓN
              GestureDetector(
                onTap: _showOperationModal,

                child: Container(
                  height: 55,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFD9D9D9,
                    ),

                    borderRadius:
                        BorderRadius.circular(8),
                  ),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.sell_outlined,
                        color: Colors.black45,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          selectedOperation,

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// 🏷️ CATEGORY
              GestureDetector(
                onTap: _showCategoryModal,

                child: Container(
                  height: 55,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFD9D9D9,
                    ),

                    borderRadius:
                        BorderRadius.circular(8),
                  ),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.home_work_outlined,
                        color: Colors.black45,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          selectedCategory,

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// 📄 DESCRIPTION
              Container(
                height: 140,

                decoration: BoxDecoration(
                  color: const Color(
                    0xFFD9D9D9,
                  ),

                  borderRadius:
                      BorderRadius.circular(8),
                ),

                child: TextField(
                  controller:
                      descriptionController,

                  maxLines: null,
                  expands: true,

                  decoration: const InputDecoration(
                    hintText: "Descripción",

                    hintStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),

                    border: InputBorder.none,

                    contentPadding:
                        EdgeInsets.all(14),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              /// 📍 DIVIDER
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.black87,
              ),

              const SizedBox(height: 30),

              const Text(
                "Detalle de Propiedad",

                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 30),

              /// 🏠 PROPERTY DETAILS
              RegistroPropiedadScreen(
                propertyType: selectedCategory,
              ),

              Divider(
                height: 40,
                thickness: 1,
                color: Colors.black87,
              ),

              const SizedBox(height: 18),

              const Text(
                "Ubicacion de propiedad",

                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 25),

              /// 📍 UBICACIÓN
              RegistrarUbicacionScreen(
                onLocationChanged: (
                  selectedProvincia,
                  selectedCiudad,
                  selectedSector,
                ) {

                  provincia = selectedProvincia;
                  ciudad = selectedCiudad;
                  sector = selectedSector;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _publishProperty() {

    final title = titleController.text.trim();
    final description =
        descriptionController.text.trim();
    final price = double.tryParse(
      priceController.text
          .replaceAll(',', '')
          .trim(),
    );

    if (images.isEmpty ||
        title.isEmpty ||
        description.isEmpty ||
        price == null ||
        selectedCategory ==
            "Selecciona una categoría") {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Completa título, precio, categoría, descripción y al menos una foto.",
          ),
        ),
      );

      return;
    }

    final property = Property(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),

      title: title,

      description: description,

      city: ciudad ??
          provincia ??
          "Sin ubicación",

      type: _normalizedPropertyType(),

      price: price,

      images: images
          .map((image) => image.path)
          .toList(),

      likes: 0,
      comments: 0,
      shares: 0,
      views: 0,

      owner: Owner(
        id: UserData.userId,
        name: UserData.userName,
        avatar: UserData.ownerAvatar,
        verified: UserData.verified,
      ),

      isFavorite: false,
    );

    UserData.addPublication(property);

    setState(() {
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      selectedCategory =
          "Selecciona una categoría";
      selectedOperation =
          "Selecciona operación";
      images.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Publicación creada correctamente.",
        ),
      ),
    );
  }

  String _normalizedPropertyType() {
    if (selectedCategory == "Apto") {
      return "Apartamento";
    }

    return selectedCategory;
  }

  /// 🔥 MODAL OPERACIÓN
  void _showOperationModal() {

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor:
          const Color(0xFFF1ECF4),

      shape:
          const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      builder: (_) {

        return Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: operations.map(
                (operation) {

                  final isSelected =
                      selectedOperation ==
                          operation;

                  return InkWell(
                    borderRadius:
                        BorderRadius.circular(18),

                    onTap: () {

                      setState(() {
                        selectedOperation =
                            operation;
                      });

                      Navigator.pop(context);
                    },

                    child: Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        color: isSelected
                            ? Colors.black
                                .withOpacity(0.06)
                            : Colors.transparent,
                      ),

                      child: Row(
                        children: [

                          Icon(
                            Icons.sell_outlined,

                            size: 30,

                            color: isSelected
                                ? Colors.black
                                : Colors.black54,
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Text(
                              operation,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style: TextStyle(
                                fontSize: 18,

                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,

                                color:
                                    Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 MODAL CATEGORÍAS
  void _showCategoryModal() {

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor:
          const Color(0xFFF1ECF4),

      shape:
          const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      builder: (_) {

        return Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: categories.map(
                (category) {

                  final isSelected =
                      selectedCategory ==
                          category;

                  return InkWell(
                    borderRadius:
                        BorderRadius.circular(18),

                    onTap: () {

                      setState(() {
                        selectedCategory =
                            category;
                      });

                      Navigator.pop(context);
                    },

                    child: Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        color: isSelected
                            ? Colors.black
                                .withOpacity(0.06)
                            : Colors.transparent,
                      ),

                      child: Row(
                        children: [

                          Icon(
                            Icons.home_work_outlined,

                            size: 30,

                            color: isSelected
                                ? Colors.black
                                : Colors.black54,
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Text(
                              category,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style: TextStyle(
                                fontSize: 18,

                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,

                                color:
                                    Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 INPUT
  Widget _buildInput({
    required TextEditingController controller,
    required String hint,

    TextInputType keyboard =
        TextInputType.text,
  }) {

    return Container(
      height: 55,

      decoration: BoxDecoration(
        color: const Color(
          0xFFD9D9D9,
        ),

        borderRadius:
            BorderRadius.circular(8),
      ),

      child: TextField(
        controller: controller,

        keyboardType: keyboard,

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),

          border: InputBorder.none,

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 14,
          ),
        ),
      ),
    );
  }
}
