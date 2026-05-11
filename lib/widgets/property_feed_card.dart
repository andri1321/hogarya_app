import 'package:app_hogar_ya/models/property.dart';
import 'package:app_hogar_ya/screen/owner_profile_screen.dart';
// 1. Nueva importación añadida
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyFeedCard extends StatefulWidget {
  final Property property;

  const PropertyFeedCard({
    super.key,
    required this.property,
  });

  @override
  State<PropertyFeedCard> createState() => _PropertyFeedCardState();
}

class _PropertyFeedCardState extends State<PropertyFeedCard> {
  late bool isLiked;
  late bool isFavorite;
  late int likesCount;

  final List<Map<String, dynamic>> commentsList = [
    {"name": "Carlos", "comment": "Muy bonita propiedad 🔥"},
    {"name": "Maria", "comment": "¿Está disponible todavía?"},
  ];

  @override
  void initState() {
    super.initState();
    likesCount = widget.property.likes;
    isLiked = false;
    isFavorite = widget.property.isFavorite;
  }

  // 2. Nueva función para abrir el perfil del dueño añadida
  void _openOwnerProfile() {
    final ownerProperties = [
      widget.property,
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OwnerProfileScreen(
          owner: widget.property.owner,
          properties: ownerProperties,
        ),
      ),
    );
  }

  void _openCommentsModal() {
    final List<Map<String, dynamic>> comments = [
      {
        "id": "1",
        "name": "marcosyaroide",
        "comment": "🙏 🙌 🙌",
        "liked": false,
        "likes": 4358,
        "time": "15 h",
        "isPinned": true,
        "showReplies": false,
        "replies": [
          {"name": "usuario1", "comment": "Amén!", "time": "10 h", "liked": false},
          {"name": "usuario2", "comment": "Bendiciones", "time": "5 h", "liked": true},
        ],
      },
      {
        "id": "2",
        "name": "raqueestevez_",
        "comment": "Y cuando fue que pasó eso 😫?",
        "liked": false,
        "likes": 609,
        "time": "2 sem",
        "showReplies": false,
        "replies": [],
      },
    ];

    final TextEditingController commentController = TextEditingController();
    final FocusNode commentFocusNode = FocusNode();
    String? replyingToName;
    int? replyingIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Comentarios",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 30),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: comments.length,
                          itemBuilder: (_, index) {
                            final comment = comments[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCommentItem(
                                  comment,
                                  onLike: () {
                                    setModalState(() {
                                      comment["liked"] = !comment["liked"];
                                      comment["liked"] ? comment["likes"]++ : comment["likes"]--;
                                    });
                                  },
                                  onReply: () {
                                    setModalState(() {
                                      replyingToName = comment["name"];
                                      replyingIndex = index;
                                      commentFocusNode.requestFocus();
                                    });
                                  },
                                ),
                                if (comment["replies"].isNotEmpty) ...[
                                  if (!comment["showReplies"])
                                    Padding(
                                      padding: const EdgeInsets.only(left: 58, bottom: 16),
                                      child: GestureDetector(
                                        onTap: () => setModalState(() => comment["showReplies"] = true),
                                        child: Row(
                                          children: [
                                            Container(width: 24, height: 1, color: Colors.grey.shade400),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Ver ${comment["replies"].length} respuestas más",
                                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    ...comment["replies"].map<Widget>((reply) {
                                      return _buildCommentItem(
                                        reply,
                                        isReply: true,
                                        onLike: () => setModalState(() => reply["liked"] = !reply["liked"]),
                                      );
                                    }).toList(),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                      _buildInputSection(
                        controller: commentController,
                        focusNode: commentFocusNode,
                        replyingTo: replyingToName,
                        onCancelReply: () => setModalState(() => replyingToName = null),
                        onSend: () {
                          if (commentController.text.trim().isEmpty) return;
                          setModalState(() {
                            if (replyingIndex != null && replyingToName != null) {
                              comments[replyingIndex!]["replies"].add({
                                "name": "TuUsuario",
                                "comment": commentController.text.trim(),
                                "time": "1 m",
                                "liked": false,
                              });
                              comments[replyingIndex!]["showReplies"] = true;
                            } else {
                              comments.insert(0, {
                                "name": "TuUsuario",
                                "comment": commentController.text.trim(),
                                "liked": false,
                                "likes": 0,
                                "time": "Ahora",
                                "replies": [],
                                "showReplies": false,
                              });
                            }
                            commentController.clear();
                            replyingToName = null;
                            replyingIndex = null;
                          });
                        },
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

  Widget _buildCommentItem(Map<String, dynamic> data, {bool isReply = false, VoidCallback? onLike, VoidCallback? onReply}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: isReply ? 58 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isReply ? 14 : 18,
            backgroundColor: Colors.grey.shade200,
            child: Text(data["name"][0], style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(text: "${data["name"]} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: data["time"] ?? "1 sem", style: const TextStyle(color: Colors.grey)),
                      if (data["isPinned"] == true) const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.push_pin, size: 12, color: Colors.grey))),
                      if (data["isPinned"] == true) const TextSpan(text: " • ❤️ del autor", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(data["comment"], style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onReply,
                  child: const Text("Responder", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Icon(
                  data["liked"] == true ? Icons.favorite : Icons.favorite_border,
                  size: 15,
                  color: data["liked"] == true ? Colors.red : Colors.grey,
                ),
              ),
              if (!isReply && data["likes"] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text("${data["likes"]}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection({
    required TextEditingController controller,
    required FocusNode focusNode,
    String? replyingTo,
    VoidCallback? onCancelReply,
    VoidCallback? onSend,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10, left: 16, right: 16, top: 10),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Text("Respondiendo a $replyingTo", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const Spacer(),
                  GestureDetector(onTap: onCancelReply, child: const Icon(Icons.close, size: 16, color: Colors.grey)),
                ],
              ),
            ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("❤️", style: TextStyle(fontSize: 22)), Text("🙌", style: TextStyle(fontSize: 22)),
              Text("🔥", style: TextStyle(fontSize: 22)), Text("👏", style: TextStyle(fontSize: 22)),
              Text("😢", style: TextStyle(fontSize: 22)), Text("😍", style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: "Agrega un comentario...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSend,
                child: const Text("Publicar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // 3. Se aplicó GestureDetector al Avatar y Nombre para abrir el perfil
          child: Row(
            children: [
              GestureDetector(
                onTap: _openOwnerProfile,
                child: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.property.owner.avatar)),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _openOwnerProfile,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.property.owner.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.property.city, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/property-details', extra: widget.property),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(widget.property.images.first, height: 320, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() { isLiked = !isLiked; isLiked ? likesCount++ : likesCount--; }),
                child: Row(children: [Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.black), const SizedBox(width: 4), Text("$likesCount")]),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: _openCommentsModal,
                child: Row(children: [const Icon(Icons.chat_bubble_outline), const SizedBox(width: 4), Text("${commentsList.length}")]),
              ),
              const SizedBox(width: 18),
              const Icon(Icons.send_outlined),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => isFavorite = !isFavorite),
                child: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border, color: isFavorite ? const Color(0xFFFF4D5A) : Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}