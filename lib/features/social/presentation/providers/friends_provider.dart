import 'package:flutter_riverpod/flutter_riverpod.dart';

class Friend {
  final String id;
  final String name;
  final String avatarUrl;
  final String league;
  final bool isOnline;
  final String statusText; // e.g., 'In a Battle', 'Online', 'Offline'

  Friend({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.league,
    required this.isOnline,
    required this.statusText,
  });
}

class ChatMessage {
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}

class FriendsState {
  final List<Friend> friends;
  final Map<String, List<ChatMessage>> chatHistory;

  FriendsState({
    required this.friends,
    required this.chatHistory,
  });

  FriendsState copyWith({
    List<Friend>? friends,
    Map<String, List<ChatMessage>>? chatHistory,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      chatHistory: chatHistory ?? this.chatHistory,
    );
  }
}

class FriendsNotifier extends StateNotifier<FriendsState> {
  FriendsNotifier()
      : super(FriendsState(
          friends: [
            Friend(
              id: '20',
              name: 'Bestie Bob',
              avatarUrl: 'assets/images/avatars/robot.svg',
              league: 'Gold III',
              isOnline: true,
              statusText: 'In a Battle',
            ),
            Friend(
              id: '21',
              name: 'Slowpoke',
              avatarUrl: 'assets/images/avatars/alien.svg',
              league: 'Bronze I',
              isOnline: true,
              statusText: 'Online',
            ),
            Friend(
              id: '22',
              name: 'Luna',
              avatarUrl: 'assets/images/avatars/astronaut.svg',
              league: 'Silver II',
              isOnline: false,
              statusText: 'Offline',
            ),
          ],
          chatHistory: {
            '21': [
              ChatMessage(
                senderId: '21',
                text: 'Hey! Want to play a quiz battle?',
                timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
              ),
            ]
          },
        ));

  void sendMessage(String friendId, String text) {
    final history = Map<String, List<ChatMessage>>.from(state.chatHistory);
    final messages = List<ChatMessage>.from(history[friendId] ?? []);
    
    messages.add(ChatMessage(
      senderId: 'me',
      text: text,
      timestamp: DateTime.now(),
    ));
    
    history[friendId] = messages;
    state = state.copyWith(chatHistory: history);

    // Simulate bot reply
    Future.delayed(const Duration(seconds: 2), () {
      final updatedHistory = Map<String, List<ChatMessage>>.from(state.chatHistory);
      final updatedMessages = List<ChatMessage>.from(updatedHistory[friendId] ?? []);
      
      updatedMessages.add(ChatMessage(
        senderId: friendId,
        text: 'Awesome! Let\'s go!',
        timestamp: DateTime.now(),
      ));
      
      updatedHistory[friendId] = updatedMessages;
      if (mounted) {
        state = state.copyWith(chatHistory: updatedHistory);
      }
    });
  }
}

final friendsProvider = StateNotifierProvider<FriendsNotifier, FriendsState>((ref) {
  return FriendsNotifier();
});
