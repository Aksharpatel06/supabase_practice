import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostDetailsScreen extends StatefulWidget {
  final String postId;
  const PostDetailsScreen({super.key, required this.postId});

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController commentController = TextEditingController();

  Future<void> addComment() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('comments').insert({
      'post_id': widget.postId,
      'user_id': user.id,
      'comment': commentController.text,
    });
    setState(() {});
    commentController.clear();
  }

  Future<List<Map<String, dynamic>>> fetchComments() async {
    return await supabase.from('comments').select('comment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchComments(),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView(
                  children: snapshot.data!.map((comment) => ListTile(title: Text(comment['comment']))).toList(),
                );
              },
            ),
          ),
          TextField(controller: commentController, decoration: InputDecoration(labelText: 'Add a comment')),
          ElevatedButton(onPressed: addComment, child: Text('Post Comment')),
        ],
      ),
    );
  }
}
