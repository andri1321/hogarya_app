import 'dart:io';

import 'package:app_hogar_ya/models/property.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatConversationScreen extends StatefulWidget {
  final Property? property;
  final Map<String, dynamic>? chat;

  const ChatConversationScreen({
    super.key,
    this.property,
    this.chat,
  });

  @override
  State<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends State<ChatConversationScreen> {

  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  final List<Map<String, dynamic>> messages = [

    {
      "isMe": false,
      "message":
          "Hola 👋 ¿La propiedad sigue disponible?",
      "time": "2:10 PM",
    },

    {
      "isMe": true,
      "message":
          "Sí, todavía está disponible.",
      "time": "2:11 PM",
    },

    {
      "isMe": false,
      "message":
          "Perfecto, me interesa bastante.",
      "time": "2:12 PM",
    },

    {
      "isMe": true,
      "message":
          "Claro 🙌 ¿Deseas más fotos o información?",
      "time": "2:13 PM",
    },

    {
      "isMe": false,
      "message":
          "Sí por favor, también ubicación exacta.",
      "time": "2:14 PM",
    },
  ];

  void sendMessage() {

    if (messageController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      messages.add({
        "isMe": true,
        "message": messageController.text.trim(),
        "time": "Ahora",
      });
    });

    messageController.clear();

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration:
              const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final owner = widget.property?.owner;

    final chatName =
        owner?.name ??
            widget.chat?["name"] ??
            "Pedro Almonte";

    final chatAvatar =
        owner?.avatar ??
            widget.chat?["image"] ??
            "https://i.pravatar.cc/150?img=3";

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔝 HEADER
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              child: Row(
                children: [

                  /// 🔙 BACK
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
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// 👤 USER
                  Stack(
                    children: [

                      CircleAvatar(
                        radius: 23,
                        backgroundImage:
                            _imageProvider(
                          chatAvatar,
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,

                        child: Container(
                          width: 13,
                          height: 13,

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

                  const SizedBox(width: 12),

                  /// 📝 INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          chatName,

                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 2),

                        const Text(
                          "Activo ahora",

                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 📞 ACTIONS
                  _topAction(Icons.call_outlined),

                  const SizedBox(width: 10),

                  _topAction(Icons.more_vert),
                ],
              ),
            ),

            /// 💬 MENSAJES
            Expanded(
              child: ListView.builder(
                controller: scrollController,

                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 18,
                ),

                itemCount: messages.length,

                itemBuilder: (_, index) {

                  final message = messages[index];

                  final bool isMe =
                      message["isMe"];

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,

                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),

                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,

                        children: [

                          Container(
                            constraints:
                                const BoxConstraints(
                              maxWidth: 290,
                            ),

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),

                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(
                                      0xFFFF4D5A,
                                    )
                                  : const Color(
                                      0xFFF1F1F1,
                                    ),

                              borderRadius:
                                  BorderRadius.only(
                                topLeft:
                                    const Radius.circular(
                                  22,
                                ),
                                topRight:
                                    const Radius.circular(
                                  22,
                                ),
                                bottomLeft:
                                    Radius.circular(
                                  isMe ? 22 : 6,
                                ),
                                bottomRight:
                                    Radius.circular(
                                  isMe ? 6 : 22,
                                ),
                              ),
                            ),

                            child: Text(
                              message["message"],

                              style: TextStyle(
                                fontSize: 15,
                                color: isMe
                                    ? Colors.white
                                    : Colors.black87,

                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            message["time"],

                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// ✍️ INPUT
            Container(
              padding: const EdgeInsets.fromLTRB(
                14,
                10,
                14,
                14,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),

              child: Row(
                children: [

                  /// ➕
                  Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.add,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// INPUT
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFF2F2F2),

                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),

                      child: TextField(
                        controller:
                            messageController,

                        minLines: 1,
                        maxLines: 5,

                        decoration:
                            const InputDecoration(
                          hintText:
                              "Escribe un mensaje...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// SEND
                  GestureDetector(
                    onTap: sendMessage,

                    child: Container(
                      width: 45,
                      height: 45,

                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D5A),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
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

  /// 🔥 ACTION BUTTON
  Widget _topAction(IconData icon) {

    return Container(
      width: 40,
      height: 40,

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),

      child: Icon(
        icon,
        size: 20,
        color: Colors.black87,
      ),
    );
  }

  ImageProvider _imageProvider(String image) {
    if (image.startsWith('http')) {
      return NetworkImage(image);
    }

    return FileImage(
      File(image),
    );
  }
}
