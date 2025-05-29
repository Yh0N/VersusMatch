import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/controllers/post_controller.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:versus_match/presentation/pages/edit_post_page.dart';

class BeautifulPostCard extends ConsumerStatefulWidget {
  final PostModel post;
  final UserModel? user;

  const BeautifulPostCard({super.key, required this.post, required this.user});

  @override
  ConsumerState<BeautifulPostCard> createState() => _BeautifulPostCardState();
}

class _BeautifulPostCardState extends ConsumerState<BeautifulPostCard> {
  late int likeCount;
  late bool liked;
  late List<Map<String, dynamic>> comments;
  String? acceptedBy;
  late String content;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes.length;
    liked = widget.user != null && widget.post.likes.contains(widget.user!.id);
    comments = List<Map<String, dynamic>>.from(widget.post.comments);
    acceptedBy = widget.post.acceptedBy;
    content = widget.post.content;
  }

  Future<void> toggleLike() async {
    final userId = widget.user?.id;
    if (userId == null) return;
    await ref.read(postControllerProvider).toggleLike(widget.post, userId);
    setState(() {
      liked = !liked;
      likeCount += liked ? 1 : -1;
    });
  }

  Future<void> addComment(String text, String username, String avatarUrl) async {
    await ref.read(postControllerProvider).addComment(widget.post, text, username, avatarUrl);
    setState(() {
      comments.add({
        'username': username,
        'avatarUrl': avatarUrl,
        'text': text,
      });
    });
  }

  Future<void> acceptChallenge() async {
    final userId = widget.user?.id;
    if (userId == null) return;
    await ref.read(postControllerProvider).acceptChallenge(widget.post, userId);
    setState(() {
      acceptedBy = userId;
    });
  }

  void showCommentsModal(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                "Comentarios",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              if (comments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    "No hay comentarios aún.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              if (comments.isNotEmpty)
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final c = comments[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: c['avatarUrl'] != null && c['avatarUrl'].toString().isNotEmpty
                              ? NetworkImage(c['avatarUrl'])
                              : const AssetImage('assets/default_avatar.png') as ImageProvider,
                        ),
                        title: Text(c['username'] ?? 'Usuario'),
                        subtitle: Text(c['text'] ?? ''),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Escribe un comentario...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.deepPurple, size: 28),
                      onPressed: () async {
                        if (controller.text.trim().isNotEmpty) {
                          final username = widget.user?.username ?? 'Usuario';
                          final avatarUrl = widget.user?.avatarUrl ?? '';
                          await addComment(controller.text.trim(), username, avatarUrl);
                          controller.clear();
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = widget.user?.avatarUrl;
    final username = widget.user?.username ?? 'Usuario';
    final post = widget.post;
    final isOwner = widget.user?.id != null && widget.user!.id == post.authorId;

    // Debug: imprime los IDs para verificar
    print('user.id: ${widget.user?.id} | post.authorId: ${post.authorId} | isOwner: $isOwner');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.deepPurple.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(width: 14),
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
                ),
                const Spacer(),
                if (isOwner) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.deepPurple),
                    tooltip: 'Editar',
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPostPage(post: post),
                        ),
                      );
                      if (result == true && mounted) {
                        final updated = await ref.read(postControllerProvider).getPostById(post.id);
                        setState(() {
                          content = updated.content;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Publicación editada')),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Eliminar',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('¿Eliminar publicación?'),
                          content: const Text('Esta acción no se puede deshacer.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await ref.read(postControllerProvider).deletePost(post.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Publicación eliminada')),
                          );
                        }
                      }
                    },
                  ),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post.type.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(post.imageUrl!),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // Botón "Aceptar Reto" bonito si es challenge y no ha sido aceptado
            if (post.type == 'challenge')
              acceptedBy == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: acceptChallenge,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7F53AC), Color(0xFF647DEE)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.18),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.flash_on, color: Colors.white, size: 26),
                              const SizedBox(width: 10),
                              const Text(
                                'ACEPTAR RETO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Reto aceptado',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Likes y comentarios interactivos
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : Colors.grey,
                  ),
                  onPressed: toggleLike,
                ),
                Text('$likeCount'),
                const SizedBox(width: 18),
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.deepPurple),
                  onPressed: () => showCommentsModal(context),
                ),
                Text('${comments.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}