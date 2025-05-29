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
              appBar: AppBar(
                title: const Text('Perfil', style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Foto de perfil centrada y redonda con borde y sombra
                    Center(
                      child: Material(
                        elevation: 6,
                        shape: const CircleBorder(),
                        shadowColor: Colors.deepPurple.withOpacity(0.15),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: Colors.deepPurple.withOpacity(0.08),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                                ? NetworkImage(user.avatarUrl!)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Información centrada y estilizada
                    Center(
                      child: Column(
                        children: [
                          Text(
                            user.username,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          if (user.position != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Chip(
                                label: Text('Posición: ${user.position!}'),
                                backgroundColor: Colors.deepPurple.withOpacity(0.08),
                                labelStyle: const TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                          if (user.teamId != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: FutureBuilder<TeamModel>(
                                future: ref.read(teamRepositoryProvider).getTeamById(user.teamId!),
                                builder: (context, teamSnap) {
                                  if (teamSnap.connectionState == ConnectionState.waiting) {
                                    return const Chip(
                                      label: Text('Equipo: ...'),
                                      backgroundColor: Color(0xFFEDE7F6),
                                      labelStyle: TextStyle(color: Colors.deepPurple),
                                    );
                                  }
                                  if (teamSnap.hasData) {
                                    return Chip(
                                      label: Text('Equipo: ${teamSnap.data!.name}'),
                                      backgroundColor: Colors.deepPurple.withOpacity(0.08),
                                      labelStyle: const TextStyle(color: Colors.deepPurple),
                                    );
                                  }
                                  return const Chip(
                                    label: Text('Equipo: desconocido'),
                                    backgroundColor: Color(0xFFEDE7F6),
                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
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
                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                        label: const Text(
                          'Editar perfil',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.deepPurple.withOpacity(0.2)),
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 36, thickness: 1.2),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Publicaciones',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ),
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
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text('No has publicado nada aún.', style: TextStyle(color: Colors.black54)),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
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