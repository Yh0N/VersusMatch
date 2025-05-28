import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/controllers/auth_controller.dart';
import 'package:versus_match/controllers/post_controller.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/presentation/pages/create_post_page.dart';
import 'package:versus_match/presentation/pages/create_team_page.dart';
import 'package:versus_match/presentation/pages/join_team_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postController = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Versus Match'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authControllerProvider).logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 🔹 Botones de acción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Publicar"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/challenge');
                      },
                      icon: const Icon(Icons.sports_kabaddi),
                      label: const Text("Retar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, CreateTeamPage.routeName);
                      },
                      icon: const Icon(Icons.group_add),
                      label: const Text("Crear Equipo"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JoinTeamPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.group),
                      label: const Text("Unirse a un equipo"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Feed de publicaciones
          Expanded(
            child: FutureBuilder<List<PostModel>>(
              future: postController.getAllPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final posts = snapshot.data ?? [];

                if (posts.isEmpty) {
                  return const Center(child: Text('No hay publicaciones aún.'));
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(post: post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.read(userRepositoryProvider);

    return FutureBuilder<UserModel>(
      future: userRepo.getUserById(post.authorId),
      builder: (context, snapshot) {
        final username = snapshot.hasData ? snapshot.data!.username : 'Usuario';
        final avatarUrl = snapshot.hasData && snapshot.data!.avatarUrl != null && snapshot.data!.avatarUrl!.isNotEmpty
            ? snapshot.data!.avatarUrl!
            : null;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Foto de perfil pequeña y redonda
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(post.imageUrl!),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  post.content,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      post.type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(post.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}