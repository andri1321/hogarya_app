import 'package:flutter/material.dart';

class RegistroPropiedadScreen extends StatefulWidget {
  final String propertyType;

  const RegistroPropiedadScreen({
    super.key,
    required this.propertyType,
  });

  @override
  State<RegistroPropiedadScreen> createState() =>
      _RegistroPropiedadScreenState();
}

class _RegistroPropiedadScreenState
    extends State<RegistroPropiedadScreen> {

  /// =========================================================
  /// CONTADORES
  /// =========================================================

  int habitaciones = 3;
  int banos = 2;
  int parqueos = 1;
  int niveles = 1;
  int habitacionesServicio = 1;

  /// =========================================================
  /// CHECKBOX / SWITCH
  /// =========================================================

  bool cocinaEquipada = false;
  bool balcon = false;
  bool patio = false;
  bool terraza = false;
  bool amueblado = false;
  bool wifi = false;
  bool deslindado = false;
  bool calleAsfaltada = false;
  bool frenteVidrio = false;

  bool salaSeparada = true;
  bool comedorSeparado = false;

  /// SOLAR
  bool titulo = false;
  bool actoVenta = false;

  /// VILLA
  bool piscina = false;
  bool jacuzzi = false;
  bool bbq = false;
  bool vistaMar = false;
  bool vistaMontana = false;

  bool mesaBillar = false;
  bool cine = false;
  bool bar = false;
  bool areaJuegos = false;

  bool seguridadPrivada = false;
  bool residencialCerrado = false;
  bool camaras = false;

  /// =========================================================
  /// DROPDOWNS
  /// =========================================================

  String? tipoUsoSolar;
  String? idealParaLocal;

  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),

      child: Column(
        key: ValueKey(widget.propertyType),

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// ======================================================
          /// 🚫 SIN CATEGORÍA
          /// ======================================================

          if (widget.propertyType ==
              "Selecciona una categoría") ...[

            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: Text(
                  "Selecciona una categoría para mostrar los detalles",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],

          /// ======================================================
          /// 🏢 APARTAMENTO
          /// ======================================================

          if (widget.propertyType == "Apto") ...[

            _buildSectionHeader(
              "1",
              "Detalles del Apartamento",
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _buildCounter(
                    "Habitaciones",
                    habitaciones,
                    (val) {
                      setState(() {
                        habitaciones = val;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCounter(
                    "Baños",
                    banos,
                    (val) {
                      setState(() {
                        banos = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _buildCounter(
                    "Parqueos",
                    parqueos,
                    (val) {
                      setState(() {
                        parqueos = val;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCounter(
                    "Niveles",
                    niveles,
                    (val) {
                      setState(() {
                        niveles = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _buildCheckbox(
              "Cocina Equipada",
              cocinaEquipada,
              (val) {
                setState(() {
                  cocinaEquipada = val!;
                });
              },
            ),

            _buildCheckbox(
              "Balcón",
              balcon,
              (val) {
                setState(() {
                  balcon = val!;
                });
              },
            ),

            _buildSwitch(
              "Sala Separada",
              salaSeparada,
              (val) {
                setState(() {
                  salaSeparada = val;
                });
              },
            ),

            _buildSwitch(
              "Comedor Separado",
              comedorSeparado,
              (val) {
                setState(() {
                  comedorSeparado = val;
                });
              },
            ),

            _buildTextField(
              "Metros Cuadrados",
              "Ej: 120",
            ),

            _buildTextField(
              "Piso del Apartamento",
              "Ej: 5",
            ),

            const SizedBox(height: 35),
          ],

          /// ======================================================
          /// 🏠 CASA
          /// ======================================================

          if (widget.propertyType == "Casa") ...[

            _buildSectionHeader(
              "1",
              "Detalles de la Casa",
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _buildCounter(
                    "Habitaciones",
                    habitaciones,
                    (val) {
                      setState(() {
                        habitaciones = val;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCounter(
                    "Baños",
                    banos,
                    (val) {
                      setState(() {
                        banos = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _buildCounter(
                    "Parqueos",
                    parqueos,
                    (val) {
                      setState(() {
                        parqueos = val;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCounter(
                    "Niveles",
                    niveles,
                    (val) {
                      setState(() {
                        niveles = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _buildCheckbox(
              "Patio",
              patio,
              (val) {
                setState(() {
                  patio = val!;
                });
              },
            ),

            _buildCheckbox(
              "Terraza",
              terraza,
              (val) {
                setState(() {
                  terraza = val!;
                });
              },
            ),

            _buildCheckbox(
              "Balcón",
              balcon,
              (val) {
                setState(() {
                  balcon = val!;
                });
              },
            ),

            _buildTextField(
              "Metros de Construcción",
              "Ej: 250",
            ),

            _buildTextField(
              "Metros de Terreno",
              "Ej: 400",
            ),

            const SizedBox(height: 35),
          ],

          /// ======================================================
          /// 🌳 SOLAR
          /// ======================================================

          if (widget.propertyType == "Solar") ...[

            _buildSectionHeader(
              "1",
              "Detalles del Solar",
            ),

            const SizedBox(height: 14),

            _buildTextField(
              "Tamaño Total",
              "Ej: 500 m²",
            ),

            _buildTextField(
              "Frente",
              "Ej: 20 metros",
            ),

            _buildTextField(
              "Fondo",
              "Ej: 25 metros",
            ),

            _buildDropdown(
              label: "Tipo de Uso",
              value: tipoUsoSolar,
              options: const [
                "Residencial",
                "Comercial",
                "Agrícola",
              ],
              onChanged: (value) {
                setState(() {
                  tipoUsoSolar = value;
                });
              },
            ),

            const SizedBox(height: 24),

            /// 📄 DOCUMENTACIÓN
            const Text(
              "Documentación",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 12),

            _buildCheckbox(
              "Deslindado",
              deslindado,
              (val) {
                setState(() {
                  deslindado = val!;
                });
              },
            ),

            _buildCheckbox(
              "Título",
              titulo,
              (val) {
                setState(() {
                  titulo = val!;
                });
              },
            ),

            _buildCheckbox(
              "Acto de venta",
              actoVenta,
              (val) {
                setState(() {
                  actoVenta = val!;
                });
              },
            ),

            _buildCheckbox(
              "Calle Asfaltada",
              calleAsfaltada,
              (val) {
                setState(() {
                  calleAsfaltada = val!;
                });
              },
            ),

            const SizedBox(height: 35),
          ],

          /// ======================================================
          /// 🏡 VILLA
          /// ======================================================

          if (widget.propertyType == "Villa") ...[

            _buildSectionHeader(
              "1",
              "Detalles de la Villa",
            ),

            const SizedBox(height: 18),

            /// HABITACIONES
            Row(
              children: [

                Expanded(
                  child: _buildCounter(
                    "Habitaciones",
                    habitaciones,
                    (val) {
                      setState(() {
                        habitaciones = val;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCounter(
                    "Baños",
                    banos,
                    (val) {
                      setState(() {
                        banos = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _buildCounter(
                    "Niveles",
                    niveles,
                    (val) {
                      setState(() {
                        niveles = val;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCounter(
                    "Hab. Servicio",
                    habitacionesServicio,
                    (val) {
                      setState(() {
                        habitacionesServicio = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// AMENIDADES
            const Text(
              "Amenidades Premium",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 10),

            _buildCheckbox(
              "Piscina",
              piscina,
              (val) {
                setState(() {
                  piscina = val!;
                });
              },
            ),

            _buildCheckbox(
              "Jacuzzi",
              jacuzzi,
              (val) {
                setState(() {
                  jacuzzi = val!;
                });
              },
            ),

            _buildCheckbox(
              "BBQ",
              bbq,
              (val) {
                setState(() {
                  bbq = val!;
                });
              },
            ),

            _buildCheckbox(
              "Terraza",
              terraza,
              (val) {
                setState(() {
                  terraza = val!;
                });
              },
            ),

            _buildCheckbox(
              "Vista al mar",
              vistaMar,
              (val) {
                setState(() {
                  vistaMar = val!;
                });
              },
            ),

            _buildCheckbox(
              "Vista a montaña",
              vistaMontana,
              (val) {
                setState(() {
                  vistaMontana = val!;
                });
              },
            ),

            const SizedBox(height: 28),

            /// ENTRETENIMIENTO
            const Text(
              "Entretenimiento",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 10),

            _buildCheckbox(
              "Mesa de billar",
              mesaBillar,
              (val) {
                setState(() {
                  mesaBillar = val!;
                });
              },
            ),

            _buildCheckbox(
              "Cine",
              cine,
              (val) {
                setState(() {
                  cine = val!;
                });
              },
            ),

            _buildCheckbox(
              "Bar",
              bar,
              (val) {
                setState(() {
                  bar = val!;
                });
              },
            ),

            _buildCheckbox(
              "Área de juegos",
              areaJuegos,
              (val) {
                setState(() {
                  areaJuegos = val!;
                });
              },
            ),

            const SizedBox(height: 28),

            /// SEGURIDAD
            const Text(
              "Seguridad",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 10),

            _buildCheckbox(
              "Seguridad privada",
              seguridadPrivada,
              (val) {
                setState(() {
                  seguridadPrivada = val!;
                });
              },
            ),

            _buildCheckbox(
              "Residencial cerrado",
              residencialCerrado,
              (val) {
                setState(() {
                  residencialCerrado = val!;
                });
              },
            ),

            _buildCheckbox(
              "Cámaras",
              camaras,
              (val) {
                setState(() {
                  camaras = val!;
                });
              },
            ),

            const SizedBox(height: 35),
          ],

          /// ======================================================
          /// 🛏 HABITACIÓN
          /// ======================================================

          if (widget.propertyType == "Habitación") ...[

            _buildSectionHeader(
              "1",
              "Detalles de la Habitación",
            ),

            const SizedBox(height: 18),

            _buildTextField(
              "Tamaño",
              "Ej: 25 m²",
            ),

            _buildCheckbox(
              "Baño Privado",
              cocinaEquipada,
              (val) {
                setState(() {
                  cocinaEquipada = val!;
                });
              },
            ),

            _buildCheckbox(
              "Amueblada",
              amueblado,
              (val) {
                setState(() {
                  amueblado = val!;
                });
              },
            ),

            _buildCheckbox(
              "Incluye Wifi",
              wifi,
              (val) {
                setState(() {
                  wifi = val!;
                });
              },
            ),

            _buildTextField(
              "Cantidad de Personas",
              "Ej: 2",
            ),

            const SizedBox(height: 35),
          ],

          /// ======================================================
          /// 🏬 LOCAL
          /// ======================================================

          if (widget.propertyType == "Local") ...[

            _buildSectionHeader(
              "1",
              "Detalles del Local",
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _buildCounter(
                    "Baños",
                    banos,
                    (val) {
                      setState(() {
                        banos = val;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCounter(
                    "Parqueos",
                    parqueos,
                    (val) {
                      setState(() {
                        parqueos = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _buildTextField(
              "Metros Cuadrados",
              "Ej: 80",
            ),

            _buildTextField(
              "Depósito",
              "Ej: Sí",
            ),

            _buildDropdown(
              label: "Ideal para",
              value: idealParaLocal,
              options: const [
                "Oficina",
                "Restaurante",
                "Tienda",
                "Barbería",
                "Farmacia",
              ],
              onChanged: (value) {
                setState(() {
                  idealParaLocal = value;
                });
              },
            ),

            _buildCheckbox(
              "Frente de Vidrio",
              frenteVidrio,
              (val) {
                setState(() {
                  frenteVidrio = val!;
                });
              },
            ),

            const SizedBox(height: 35),
          ],
        ],
      ),
    );
  }

  /// =========================================================
  /// HEADER
  /// =========================================================

  Widget _buildSectionHeader(
    String index,
    String title,
  ) {

    return Row(
      children: [

        CircleAvatar(
          radius: 12,
          backgroundColor: const Color(0xFF1976D2),
          child: Text(
            index,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
      ],
    );
  }

  /// =========================================================
  /// INPUT
  /// =========================================================

  Widget _buildTextField(
    String label,
    String hint, {
    int maxLines = 1,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          TextField(
            maxLines: maxLines,

            decoration: InputDecoration(
              hintText: hint,

              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =========================================================
  /// COUNTER
  /// =========================================================

  Widget _buildCounter(
    String label,
    int value,
    Function(int) onChanged,
  ) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),

          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
            ),

            borderRadius:
                BorderRadius.circular(10),
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              IconButton(
                onPressed: () {

                  if (value > 0) {
                    onChanged(value - 1);
                  }
                },

                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
              ),

              Text(
                "$value",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                onPressed: () {
                  onChanged(value + 1);
                },

                icon: const Icon(
                  Icons.add_circle_outline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// =========================================================
  /// DROPDOWN
  /// =========================================================

  Widget _buildDropdown({
    required String label,
    required List<String> options,
    required String? value,
    required Function(String?) onChanged,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          DropdownButtonFormField<String>(
            value: value,

            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            items: options.map((e) {

              return DropdownMenuItem(
                value: e,
                child: Text(e),
              );
            }).toList(),

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// =========================================================
  /// CHECKBOX
  /// =========================================================

  Widget _buildCheckbox(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {

    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity:
          ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  /// =========================================================
  /// SWITCH
  /// =========================================================

  Widget _buildSwitch(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {

    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}