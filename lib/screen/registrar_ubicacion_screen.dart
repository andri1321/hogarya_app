import 'package:flutter/material.dart';

class RegistrarUbicacionScreen
    extends StatefulWidget {
  const RegistrarUbicacionScreen({
    super.key,
  });

  @override
  State<RegistrarUbicacionScreen>
  createState() =>
      _RegistrarUbicacionScreenState();
}

class _RegistrarUbicacionScreenState
    extends State<RegistrarUbicacionScreen> {

  final TextEditingController
  calleController =
      TextEditingController();

  final TextEditingController
  referenciaController =
      TextEditingController();

  String? provincia;
  String? ciudad;
  String? sector;

  /// =========================================================
  /// DATA
  /// =========================================================

  final Map<String, List<String>>
  ciudadesPorProvincia = {

    'Santo Domingo': [
      'Distrito Nacional',
      'Santo Domingo Este',
      'Santo Domingo Norte',
      'Santo Domingo Oeste',
    ],

    'Santiago': [
      'Santiago de los Caballeros',
      'Tamboril',
      'Licey',
      'Villa González',
    ],

    'La Vega': [
      'La Vega',
      'Jarabacoa',
      'Constanza',
    ],
  };

  final Map<String, List<String>>
  sectoresPorCiudad = {

    'Santiago de los Caballeros': [
      'Cienfuegos',
      'Gurabo',
      'Bella Vista',
      'Pekín',
      'Los Jardines',
    ],

    'Distrito Nacional': [
      'Naco',
      'Piantini',
      'Gazcue',
    ],
  };

  @override
  void dispose() {

    calleController.dispose();

    referenciaController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final ciudades =
        provincia == null
            ? <String>[]
            : ciudadesPorProvincia[provincia] ?? [];

    final sectores =
        ciudad == null
            ? <String>[]
            : sectoresPorCiudad[ciudad] ?? [];

    /// ✅ REGLA DE ORO
    /// SOLO CONTENIDO
    /// NO SCAFFOLD
    /// NO APPBAR
    /// NO FONDO

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        /// =====================================================
        /// PROVINCIA
        /// =====================================================

        _dropdown(
          value: provincia,

          items:
              ciudadesPorProvincia.keys
                  .toList(),

          hint: "Provincia",

          onChanged: (
            v,
          ) {

            setState(() {

              provincia = v;

              ciudad = null;

              sector = null;
            });
          },
        ),

        const SizedBox(
          height: 16,
        ),

        /// =====================================================
        /// CIUDAD
        /// =====================================================

        _dropdown(
          value: ciudad,

          items: ciudades,

          hint: "Ciudad",

          onChanged: (
            v,
          ) {

            setState(() {

              ciudad = v;

              sector = null;
            });
          },
        ),

        const SizedBox(
          height: 16,
        ),

        /// =====================================================
        /// SECTOR
        /// =====================================================

        _dropdown(
          value: sector,

          items: sectores,

          hint: "Sector",

          onChanged: (
            v,
          ) {

            setState(() {

              sector = v;
            });
          },
        ),

        const SizedBox(
          height: 16,
        ),

        /// =====================================================
        /// CALLE
        /// =====================================================

        _input(
          controller: calleController,

          hint: "Calle",
        ),

        const SizedBox(
          height: 16,
        ),

        /// =====================================================
        /// REFERENCIA
        /// =====================================================

        _input(
          controller:
              referenciaController,

          hint: "Referencia",
        ),

        const SizedBox(
          height: 16,
        ),

        /// =====================================================
        /// ELEGIR EN MAPA
        /// =====================================================

        GestureDetector(
  onTap: () {

    /// 🔥 AQUÍ LUEGO ABRIRÁS GOOGLE MAPS
  },

  child: Container(
    width: double.infinity,
    height: 120,

    decoration: BoxDecoration(
      color: const Color(
        0xFFD9D9D9,
      ),

      borderRadius:
          BorderRadius.circular(
            12,
          ),
    ),

    child: Column(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: const [

        Icon(
          Icons.location_on_outlined,
          size: 36,
          color: Colors.black54,
        ),

        SizedBox(
          height: 10,
        ),

        Text(
          "Seleccionar ubicación en mapa",
          style: TextStyle(
            fontWeight:
                FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  ),
),
      ],
    );
  }

  /// =========================================================
  /// INPUT
  /// =========================================================

  Widget _input({

    required TextEditingController
    controller,

    required String hint,

  }) {

    return TextField(
      controller: controller,

      decoration: InputDecoration(
        hintText: hint,

        filled: true,

        fillColor: const Color(
          0xFFD9D9D9,
        ),

        contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                12,
              ),

          borderSide:
              BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                    12,
                  ),

              borderSide:
                  BorderSide.none,
            ),

        focusedBorder:
            OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                    12,
                  ),

              borderSide:
                  const BorderSide(
                    color: Color(
                      0xFF1565C0,
                    ),

                    width: 1.4,
                  ),
            ),
      ),
    );
  }

  /// =========================================================
  /// DROPDOWN
  /// =========================================================

  Widget _dropdown({

    required String? value,

    required List<String> items,

    required ValueChanged<String?>
    onChanged,

    required String hint,

  }) {

    return DropdownButtonFormField<
      String
    >(
      value: value,

      decoration: InputDecoration(
        hintText: hint,

        filled: true,

        fillColor: const Color(
          0xFFD9D9D9,
        ),

        contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                12,
              ),

          borderSide:
              BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                    12,
                  ),

              borderSide:
                  BorderSide.none,
            ),

        focusedBorder:
            OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                    12,
                  ),

              borderSide:
                  const BorderSide(
                    color: Color(
                      0xFF1565C0,
                    ),

                    width: 1.4,
                  ),
            ),
      ),

      hint: Text(
        hint,
      ),

      items: items.map(
        (
          e,
        ) {

          return DropdownMenuItem<
            String
          >(
            value: e,

            child: Text(
              e,
            ),
          );
        },
      ).toList(),

      onChanged: onChanged,
    );
  }
}