import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'post_details_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  /// ✅ Fetch posts that belong to the logged-in user
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    try {
      return await supabase
          .from('posts')
          .select('id, title, content')
          .eq('userid', user.id);
    } catch (e) {
      print('Erorr: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching posts: ${e.toString()}")),
      );
      return [];
    }
  }

  /// ✅ Create a new post in Supabase
  Future<void> createPost() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be logged in to create a post.")),
      );
      return;
    }

    print('user :$user');

    try {
      await supabase.from('posts').insert({
        'userid': user.id,
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Post created successfully!")));

      titleController.clear();
      contentController.clear();
      setState(() {}); // Refresh UI
      Navigator.pop(context);
    } catch (e) {
      print(" Error : ${e.toString()}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchPosts(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No posts found."));
          }

          final posts = snapshot.data!;

          print('$posts');
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post['title']),
                subtitle: Text(post['content']),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailsScreen(postId: post['id']),
                      ),
                    ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('New Post'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: contentController,
                          decoration: InputDecoration(labelText: 'Content'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: createPost,
                        child: Text('Post'),
                      ),
                    ],
                  ),
            ),
        child: Icon(Icons.add),
      ),
    );
  }
}
