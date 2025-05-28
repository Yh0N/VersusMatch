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
import 'package:versus_match/presentation/widgets/beautiful_post_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final postController = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 0.5,
                  child: const Icon(Icons.sports_soccer, color: Colors.deepPurple, size: 32),
                );
              },
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'Montserrat',
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                children: [
                  TextSpan(
                    text: 'Versus',
                    style: TextStyle(
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: 'Match',
                    style: TextStyle(
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
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
          // Botón "Crear" con menú popup bonito
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Center(
              child: ElevatedButton.icon(
                key: _menuKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  elevation: 6,
                ),
                icon: const Icon(Icons.add, size: 28, color: Colors.white),
                label: const Text(
                  "Crear",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.1,
                  ),
                ),
                onPressed: () async {
                  final RenderBox button = _menuKey.currentContext!.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                  final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

                  final selected = await showMenu<int>(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy + button.size.height + 8,
                      position.dx + button.size.width,
                      0,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Colors.deepPurple),
                            SizedBox(width: 10),
                            Text("Publicar"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: const [
                            Icon(Icons.sports_kabaddi, color: Colors.orange),
                            SizedBox(width: 10),
                            Text("Retar"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: const [
                            Icon(Icons.group_add, color: Colors.green),
                            SizedBox(width: 10),
                            Text("Crear Equipo"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: const [
                            Icon(Icons.group, color: Colors.blue),
                            SizedBox(width: 10),
                            Text("Unirse a un equipo"),
                          ],
                        ),
                      ),
                    ],
                    color: Color.alphaBlend(
                      Colors.deepPurple.withOpacity(0.07), // toque de morado
                      Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  );

                  if (selected == 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostPage()));
                  } else if (selected == 1) {
                    Navigator.pushNamed(context, '/challenge');
                  } else if (selected == 2) {
                    Navigator.pushNamed(context, CreateTeamPage.routeName);
                  } else if (selected == 3) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const JoinTeamPage()));
                  }
                },
              ),
            ),
          ),
          // El feed de publicaciones
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
                    final userRepo = ref.read(userRepositoryProvider);
                    return FutureBuilder<UserModel>(
                      future: userRepo.getUserById(post.authorId),
                      builder: (context, snapshot) {
                        return BeautifulPostCard(
                          post: post,
                          user: snapshot.data,
                        );
                      },
                    );
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