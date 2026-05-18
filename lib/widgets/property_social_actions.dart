import 'package:app_hogar_ya/data/user_data.dart';
import 'package:app_hogar_ya/models/property.dart';
import 'package:app_hogar_ya/widgets/profile_touchable.dart';
import 'package:flutter/material.dart';

class PropertySocialActions {
  static void toggleLike(Property property) {
    UserData.toggleLike(property);
  }

  static void sharePost(
    BuildContext context,
    Property property,
  ) {
    UserData.incrementShares(property);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Publicación compartida",
        ),
      ),
    );
  }

  static void showCommentsModal(
    BuildContext context,
    Property property,
  ) {
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
          {
            "name": "usuario1",
            "comment": "Amén!",
            "time": "10 h",
            "liked": false,
          },
          {
            "name": "usuario2",
            "comment": "Bendiciones",
            "time": "5 h",
            "liked": true,
          },
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
      ...UserData.commentsFor(property.id).map(
        (comment) => {
          "name": comment["name"],
          "comment": comment["comment"],
          "liked": false,
          "likes": 0,
          "time": comment["time"] ?? "Ahora",
          "showReplies": false,
          "replies": [],
        },
      ),
    ];

    final TextEditingController commentController =
        TextEditingController();
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Comentarios",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 30),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          itemCount: comments.length,
                          itemBuilder: (_, index) {
                            final comment = comments[index];
                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _buildCommentItem(
                                  context,
                                  comment,
                                  onLike: () {
                                    setModalState(() {
                                      comment["liked"] =
                                          !comment["liked"];
                                      comment["liked"]
                                          ? comment["likes"]++
                                          : comment["likes"]--;
                                    });
                                  },
                                  onReply: () {
                                    setModalState(() {
                                      replyingToName =
                                          comment["name"];
                                      replyingIndex = index;
                                      commentFocusNode
                                          .requestFocus();
                                    });
                                  },
                                ),
                                if (comment["replies"]
                                    .isNotEmpty) ...[
                                  if (!comment["showReplies"])
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(
                                        left: 58,
                                        bottom: 16,
                                      ),
                                      child: GestureDetector(
                                        onTap: () =>
                                            setModalState(
                                          () => comment[
                                                  "showReplies"] =
                                              true,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 1,
                                              color: Colors.grey
                                                  .shade400,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Ver ${comment["replies"].length} respuestas más",
                                              style:
                                                  const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    ...comment["replies"]
                                        .map<Widget>((reply) {
                                      return _buildCommentItem(
                                        context,
                                        reply,
                                        isReply: true,
                                        onLike: () =>
                                            setModalState(
                                          () => reply["liked"] =
                                              !reply["liked"],
                                        ),
                                      );
                                    }).toList(),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                      _buildInputSection(
                        context: context,
                        controller: commentController,
                        focusNode: commentFocusNode,
                        replyingTo: replyingToName,
                        onCancelReply: () => setModalState(
                          () => replyingToName = null,
                        ),
                        onSend: () {
                          if (commentController.text
                              .trim()
                              .isEmpty) {
                            return;
                          }

                          setModalState(() {
                            if (replyingIndex != null &&
                                replyingToName != null) {
                              comments[replyingIndex!]
                                      ["replies"]
                                  .add({
                                "name": "TuUsuario",
                                "comment": commentController.text
                                    .trim(),
                                "time": "1 m",
                                "liked": false,
                              });
                              comments[replyingIndex!]
                                  ["showReplies"] = true;
                            } else {
                              UserData.addComment(
                                property,
                                commentController.text,
                              );

                              comments.insert(0, {
                                "name": "TuUsuario",
                                "comment": commentController.text
                                    .trim(),
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
    ).whenComplete(() {
      commentController.dispose();
      commentFocusNode.dispose();
    });
  }

  static Widget _buildCommentItem(
    BuildContext context,
    Map<String, dynamic> data, {
    bool isReply = false,
    VoidCallback? onLike,
    VoidCallback? onReply,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: isReply ? 58 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileTouchable(
            owner: Owner(
              name: data["name"],
              avatar: "https://via.placeholder.com/150",
              verified: false,
              id: data["name"],
            ),
            child: CircleAvatar(
              radius: isReply ? 14 : 18,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                data["name"][0],
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: "${data["name"]} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: data["time"] ?? "1 sem",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      if (data["isPinned"] == true)
                        const WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.push_pin,
                              size: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      if (data["isPinned"] == true)
                        const TextSpan(
                          text: " • ❤️ del autor",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data["comment"],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onReply,
                  child: const Text(
                    "Responder",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Icon(
                  data["liked"] == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 15,
                  color: data["liked"] == true
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
              if (!isReply && data["likes"] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "${data["likes"]}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildInputSection({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? replyingTo,
    VoidCallback? onCancelReply,
    VoidCallback? onSend,
  }) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        left: 16,
        right: 16,
        top: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Text(
                    "Respondiendo a $replyingTo",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onCancelReply,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("❤️", style: TextStyle(fontSize: 22)),
              Text("🙌", style: TextStyle(fontSize: 22)),
              Text("🔥", style: TextStyle(fontSize: 22)),
              Text("👏", style: TextStyle(fontSize: 22)),
              Text("😢", style: TextStyle(fontSize: 22)),
              Text("😍", style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: "Agrega un comentario...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSend,
                child: const Text(
                  "Publicar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
