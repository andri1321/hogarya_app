import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController searchController =
      TextEditingController();

  final List<Map<String, dynamic>> chats = [
    {
      "name": "Pedro Almonte",
      "message": "¿Aún está disponible?",
      "time": "2:40 PM",
      "image": "https://i.pravatar.cc/150?img=3",
      "online": true,
      "unread": 2,
    },
    {
      "name": "Maria Lopez",
      "message": "Me interesa la propiedad",
      "time": "1:10 PM",
      "image": "https://i.pravatar.cc/150?img=5",
      "online": true,
      "unread": 0,
    },
    {
      "name": "Carlos Diaz",
      "message": "¿Dónde está ubicada?",
      "time": "Ayer",
      "image": "https://i.pravatar.cc/150?img=8",
      "online": false,
      "unread": 1,
    },
    {
      "name": "Sofia Ramirez",
      "message": "Perfecto, gracias 🙌",
      "time": "Ayer",
      "image": "https://i.pravatar.cc/150?img=9",
      "online": false,
      "unread": 0,
    },
    {
      "name": "Luis Martinez",
      "message": "¿Acepta financiamiento?",
      "time": "Lun",
      "image": "https://i.pravatar.cc/150?img=11",
      "online": true,
      "unread": 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredChats = chats.where((chat) {
      return chat["name"]
          .toLowerCase()
          .contains(
            searchController.text.toLowerCase(),
          );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔝 HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                14,
                18,
                10,
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

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Text(
                      "Chats",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 22,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔍 SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: Row(
                  children: [

                    const Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: searchController,

                        onChanged: (_) {
                          setState(() {});
                        },

                        decoration:
                            const InputDecoration(
                          hintText:
                              "Buscar conversaciones",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// 👥 ACTIVOS
            SizedBox(
              height: 95,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),

                itemCount: chats.length,

                itemBuilder: (_, index) {

                  final user = chats[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),

                    child: Column(
                      children: [

                        Stack(
                          children: [

                            CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  NetworkImage(
                                user["image"],
                              ),
                            ),

                            if (user["online"])
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 15,
                                  height: 15,

                                  decoration:
                                      BoxDecoration(
                                    color: Colors.green,
                                    shape:
                                        BoxShape.circle,

                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        SizedBox(
                          width: 60,

                          child: Text(
                            user["name"],

                            maxLines: 1,

                            overflow:
                                TextOverflow.ellipsis,

                            textAlign:
                                TextAlign.center,

                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 6),

            /// 💬 LISTA CHATS
            Expanded(
              child: ListView.builder(
                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 20,
                ),

                itemCount: filteredChats.length,

                itemBuilder: (_, index) {

                  final chat = filteredChats[index];

                  return _chatTile(
                    chat,
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 💬 CHAT TILE
  Widget _chatTile(
    Map<String, dynamic> chat,
    int index,
  ) {

    return InkWell(
      onTap: () {
        /// abrir conversación
        context.push(
          '/chatConversation',
          extra: chat,
        );
      },

      borderRadius:
          BorderRadius.circular(18),

      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),

        child: Row(
          children: [

            /// 👤 AVATAR
            Stack(
              children: [

                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(
                    chat["image"],
                  ),
                ),

                if (chat["online"])
                  Positioned(
                    bottom: 0,
                    right: 0,

                    child: Container(
                      width: 15,
                      height: 15,

                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            /// 📝 INFO
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          chat["name"],

                          maxLines: 1,

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Text(
                        chat["time"],

                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          chat["message"],

                          maxLines: 1,

                          overflow:
                              TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Colors.grey.shade600,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),

                      if (chat["unread"] > 0)
                        Container(
                          margin:
                              const EdgeInsets.only(
                            left: 10,
                          ),

                          width: 22,
                          height: 22,

                          decoration:
                              const BoxDecoration(
                            color: Color(0xFFFF4D5A),
                            shape: BoxShape.circle,
                          ),

                          child: Center(
                            child: Text(
                              "${chat["unread"]}",

                              style:
                                  const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            /// 🔥 MENU
            InkWell(
              borderRadius:
                  BorderRadius.circular(20),

              onTapDown: (details) {
                _showCustomMenu(
                  context,
                  details.globalPosition,
                  index,
                );
              },

              child: Padding(
                padding: const EdgeInsets.all(6),

                child: Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 MENU
  Future<void> _showCustomMenu(
    BuildContext context,
    Offset offset,
    int index,
  ) async {

    final selected = await showMenu<int>(
      context: context,

      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        20,
        0,
      ),

      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      items: const [

        PopupMenuItem(
          value: 1,
          child: Text("Ver perfil"),
        ),

        PopupMenuItem(
          value: 2,
          child: Text("Marcar leído"),
        ),

        PopupMenuDivider(),

        PopupMenuItem(
          value: 3,
          child: Text("Archivar"),
        ),

        PopupMenuItem(
          value: 4,
          child: Text("Bloquear"),
        ),

        PopupMenuItem(
          value: 5,
          child: Text(
            "Eliminar chat",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );

    switch (selected) {
      case 1:
        debugPrint("Ver perfil");
        break;

      case 2:
        debugPrint("Marcar leído");
        break;

      case 3:
        debugPrint("Archivar");
        break;

      case 4:
        debugPrint("Bloquear");
        break;

      case 5:
        debugPrint("Eliminar");
        break;
    }
  }
}
