import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  /// 🔥 EXPANSION STATES
  bool accountExpanded = true;
  bool privacyExpanded = false;
  bool notificationExpanded = false;
  bool appExpanded = false;
  bool historyExpanded = false;
  bool contactExpanded = false;
  bool supportExpanded = false;
  bool legalExpanded = false;
  bool sessionExpanded = false;
  bool extrasExpanded = false;

  /// 🔐 PRIVACIDAD
  bool publicProfile = true;
  bool sharePersonalData = false;
  bool twoFactorAuth = true;

  /// 🔔 NOTIFICACIONES
  bool newPropertiesNotif = true;
  bool messagesNotif = true;
  bool promotionsNotif = false;

  /// 🎨 APP
  bool darkMode = false;

  String selectedLanguage = "Español";
  String selectedMeasure = "Metros cuadrados";

  /// 📞 CONTACTO
  String contactMethod = "Chat interno";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 14,
            bottom: 30,
          ),
          child: Column(
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

                  const Expanded(
                    child: Text(
                      "Configuración",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// 👤 CUENTA
              _buildExpandableSection(
                title: "Cuenta & Perfil",
                expanded: accountExpanded,
                onTap: () {
                  setState(() {
                    accountExpanded = !accountExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildTile("Editar Perfil"),
                    _buildDivider(),
                    _buildTile("Verificación de Cuenta"),
                    _buildDivider(),
                    _buildTile("Cambiar Contraseña"),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🔐 PRIVACIDAD
              _buildExpandableSection(
                title: "Privacidad y Seguridad",
                expanded: privacyExpanded,
                onTap: () {
                  setState(() {
                    privacyExpanded = !privacyExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildSwitchTile(
                      title: "Perfil Público",
                      subtitle:
                          "Permitir que otros usuarios vean tu perfil",
                      value: publicProfile,
                      onChanged: (v) {
                        setState(() {
                          publicProfile = v;
                        });
                      },
                    ),

                    _buildDivider(),

                    _buildSwitchTile(
                      title: "Compartir Datos Personales",
                      subtitle:
                          "Elegir qué información mostrar",
                      value: sharePersonalData,
                      onChanged: (v) {
                        setState(() {
                          sharePersonalData = v;
                        });
                      },
                    ),

                    _buildDivider(),

                    _buildSwitchTile(
                      title: "Autenticación en Dos Pasos",
                      subtitle:
                          "Mayor seguridad para tu cuenta",
                      value: twoFactorAuth,
                      onChanged: (v) {
                        setState(() {
                          twoFactorAuth = v;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🔔 NOTIFICACIONES
              _buildExpandableSection(
                title: "Preferencias de Notificaciones",
                expanded: notificationExpanded,
                onTap: () {
                  setState(() {
                    notificationExpanded =
                        !notificationExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildSwitchTile(
                      title: "Nuevas Propiedades",
                      subtitle:
                          "Alertas de propiedades en tu zona",
                      value: newPropertiesNotif,
                      onChanged: (v) {
                        setState(() {
                          newPropertiesNotif = v;
                        });
                      },
                    ),

                    _buildDivider(),

                    _buildSwitchTile(
                      title: "Mensajes y Chat",
                      subtitle:
                          "Notificaciones de mensajes nuevos",
                      value: messagesNotif,
                      onChanged: (v) {
                        setState(() {
                          messagesNotif = v;
                        });
                      },
                    ),

                    _buildDivider(),

                    _buildSwitchTile(
                      title: "Promociones y Ofertas",
                      subtitle:
                          "Ofertas especiales y destacadas",
                      value: promotionsNotif,
                      onChanged: (v) {
                        setState(() {
                          promotionsNotif = v;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🎨 APP
              _buildExpandableSection(
                title: "Preferencias de la Aplicación",
                expanded: appExpanded,
                onTap: () {
                  setState(() {
                    appExpanded = !appExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildDropdownTile(
                      title: "Idioma",
                      value: selectedLanguage,
                      items: const [
                        "Español",
                        "English",
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            selectedLanguage = v;
                          });
                        }
                      },
                    ),

                    _buildDivider(),

                    _buildSwitchTile(
                      title: "Tema Oscuro",
                      subtitle:
                          "Cambiar entre modo oscuro y claro",
                      value: darkMode,
                      onChanged: (v) {
                        setState(() {
                          darkMode = v;
                        });
                      },
                    ),

                    _buildDivider(),

                    _buildDropdownTile(
                      title: "Unidades de Medida",
                      value: selectedMeasure,
                      items: const [
                        "Metros cuadrados",
                        "Pies cuadrados",
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            selectedMeasure = v;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 📜 HISTORIAL
              _buildExpandableSection(
                title: "Historial de Actividades",
                expanded: historyExpanded,
                onTap: () {
                  setState(() {
                    historyExpanded = !historyExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildTile("Registro de Actividad"),

                    _buildDivider(),

                    _buildTile("Búsquedas Recientes"),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 📞 CONTACTO
              _buildExpandableSection(
                title: "Preferencias de Contacto",
                expanded: contactExpanded,
                onTap: () {
                  setState(() {
                    contactExpanded = !contactExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildDropdownTile(
                      title: "Método de Contacto",
                      value: contactMethod,
                      items: const [
                        "Chat interno",
                        "Teléfono",
                        "Correo electrónico",
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            contactMethod = v;
                          });
                        }
                      },
                    ),

                    _buildDivider(),

                    _buildTile("Bloquear Usuarios"),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🆘 AYUDA
              _buildExpandableSection(
                title: "Centro de Ayuda y Soporte",
                expanded: supportExpanded,
                onTap: () {
                  setState(() {
                    supportExpanded = !supportExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildTile("Preguntas Frecuentes"),

                    _buildDivider(),

                    _buildTile("Contacto con Soporte"),

                    _buildDivider(),

                    _buildTile("Guía de Uso de la App"),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// ⚖️ LEGAL
              _buildExpandableSection(
                title: "Acerca de y Legal",
                expanded: legalExpanded,
                onTap: () {
                  setState(() {
                    legalExpanded = !legalExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildTile("Términos y Condiciones"),

                    _buildDivider(),

                    _buildTile("Política de Privacidad"),

                    _buildDivider(),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Versión de la app: 1.0.0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🚪 SESIÓN
              _buildExpandableSection(
                title: "Cerrar Sesión y Eliminar Cuenta",
                expanded: sessionExpanded,
                onTap: () {
                  setState(() {
                    sessionExpanded = !sessionExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildTile(
                      "Cerrar Sesión",
                      color: Colors.orange,
                    ),

                    _buildDivider(),

                    _buildTile(
                      "Eliminar Cuenta",
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// ✨ EXTRAS
              _buildExpandableSection(
                title: "Extras",
                expanded: extrasExpanded,
                onTap: () {
                  setState(() {
                    extrasExpanded = !extrasExpanded;
                  });
                },
                child: Column(
                  children: [

                    _buildTile("Invitar a Amigos"),

                    _buildDivider(),

                    _buildTile("Suscripciones y Planes"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 EXPANDABLE SECTION
  Widget _buildExpandableSection({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [

          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              child: Row(
                children: [

                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: child,
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  /// 🔥 NORMAL TILE
  Widget _buildTile(
    String title, {
    Color color = Colors.black,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }

  /// 🔥 SWITCH TILE
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// 🔥 DROPDOWN TILE
  Widget _buildDropdownTile({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      child: Row(
        children: [

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 DIVIDER
  Widget _buildDivider() {

    return Container(
      height: 1,
      color: Colors.black12,
    );
  }
}