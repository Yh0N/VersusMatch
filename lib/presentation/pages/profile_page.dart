import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/controllers/post_controller.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/presentation/pages/edit_profile_page.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:versus_match/presentation/widgets/beautiful_post_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final postController = ref.watch(postControllerProvider);

    return FutureBuilder(
      future: account.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final userId = snapshot.data!.$id;
        return FutureBuilder<UserModel>(
          future: userRepo.getUserById(userId),
          builder: (context, userSnap) {
            if (!userSnap.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final user = userSnap.data!;
            return Scaffold(
              appBar: AppBar(title: const Text('Perfil')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Foto de perfil centrada y redonda
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                            ? NetworkImage(user.avatarUrl!)
                            : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Información centrada
                    Center(
                      child: Column(
                        children: [
                          Text(
                            user.username,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(user.email, style: const TextStyle(fontSize: 16)),
                          if (user.position != null)
                            Text('Posición: ${user.position!}', style: const TextStyle(fontSize: 16)),
                          if (user.teamId != null)
                            FutureBuilder<TeamModel>(
                              future: ref.read(teamRepositoryProvider).getTeamById(user.teamId!),
                              builder: (context, teamSnap) {
                                if (teamSnap.connectionState == ConnectionState.waiting) {
                                  return const Text('Equipo: ...', style: TextStyle(fontSize: 16));
                                }
                                if (teamSnap.hasData) {
                                  return Text('Equipo: ${teamSnap.data!.name}', style: const TextStyle(fontSize: 16));
                                }
                                return const Text('Equipo: desconocido', style: TextStyle(fontSize: 16));
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfilePage(user: user),
                          ),
                        );
                        if (updatedUser != null) {
                          // Puedes actualizar el estado si lo necesitas
                        }
                      },
                      child: const Text('Editar perfil'),
                    ),
                    const Divider(height: 32),
                    const Text('Publicaciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    // Publicaciones del usuario
                    FutureBuilder<List<PostModel>>(
                      future: postController.getPostsByUser(userId),
                      builder: (context, postSnap) {
                        if (postSnap.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final posts = postSnap.data ?? [];
                        if (posts.isEmpty) {
                          return const Text('No has publicado nada aún.');
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return BeautifulPostCard(post: post, user: user);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}