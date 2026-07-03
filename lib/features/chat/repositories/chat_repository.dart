import 'package:firebase_database/firebase_database.dart';
import 'package:lerno/features/chat/domain/models/chat_message.dart';

class ChatRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Generate a unique chat room ID for two users
  String _getChatRoomId(String userA, String userB) {
    return userA.compareTo(userB) > 0 ? '${userA}_$userB' : '${userB}_$userA';
  }

  // Stream messages between current user and friend
  Stream<List<ChatMessage>> streamMessages(
      String currentUserId, String friendId) {
    final roomId = _getChatRoomId(currentUserId, friendId);
    return _db.child('chats/$roomId/messages').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.values.map((v) {
        return ChatMessage.fromJson(Map<String, dynamic>.from(v));
      }).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  // Send a new message
  Future<void> sendMessage(ChatMessage message) async {
    final roomId = _getChatRoomId(message.senderId, message.receiverId);
    final newMessageRef = _db.child('chats/$roomId/messages').push();

    final messageWithId = ChatMessage(
      id: newMessageRef.key ?? DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: message.senderId,
      receiverId: message.receiverId,
      content: message.content,
      timestamp: message.timestamp,
    );

    await newMessageRef.set(messageWithId.toJson());
  }
}
