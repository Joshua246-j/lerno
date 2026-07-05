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

class FriendRequest {
  final String id;
  final String userId;
  final String name;
  final String avatarUrl;
  final String league;

  FriendRequest({
    required this.id,
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.league,
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
  final List<FriendRequest> requests;
  final Map<String, List<ChatMessage>> chatHistory;

  FriendsState({
    required this.friends,
    this.requests = const [],
    required this.chatHistory,
  });

  FriendsState copyWith({
    List<Friend>? friends,
    List<FriendRequest>? requests,
    Map<String, List<ChatMessage>>? chatHistory,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      requests: requests ?? this.requests,
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
              avatarUrl: 'assets/svg/avatars/starter/robot.svg',
              league: 'Gold III',
              isOnline: true,
              statusText: 'In a Battle',
            ),
            Friend(
              id: '21',
              name: 'Slowpoke',
              avatarUrl: 'assets/svg/avatars/shop/alien.svg',
              league: 'Bronze I',
              isOnline: true,
              statusText: 'Online',
            ),
            Friend(
              id: '22',
              name: 'Luna',
              avatarUrl: 'assets/svg/avatars/starter/astronaut.svg',
              league: 'Silver II',
              isOnline: false,
              statusText: 'Offline',
            ),
          ],
          requests: [
            FriendRequest(
              id: 'req1',
              userId: '45',
              name: 'Dr. Einstein',
              avatarUrl: 'assets/svg/avatars/shop/scientist.svg',
              league: 'Legend',
            ),
            FriendRequest(
              id: 'req2',
              userId: '88',
              name: 'Pirate Pete',
              avatarUrl: 'assets/svg/avatars/shop/pirate.svg',
              league: 'Silver I',
            )
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
      final updatedHistory =
          Map<String, List<ChatMessage>>.from(state.chatHistory);
      final updatedMessages =
          List<ChatMessage>.from(updatedHistory[friendId] ?? []);

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

  void acceptRequest(String requestId) {
    final request = state.requests.firstWhere((r) => r.id == requestId);
    final updatedRequests = state.requests.where((r) => r.id != requestId).toList();
    final updatedFriends = List<Friend>.from(state.friends)
      ..add(Friend(
        id: request.userId,
        name: request.name,
        avatarUrl: request.avatarUrl,
        league: request.league,
        isOnline: true,
        statusText: 'Online',
      ));
    
    state = state.copyWith(friends: updatedFriends, requests: updatedRequests);
  }

  void declineRequest(String requestId) {
    final updatedRequests = state.requests.where((r) => r.id != requestId).toList();
    state = state.copyWith(requests: updatedRequests);
  }

  void sendFriendRequest(String userId) {
    // In a real app this would send an API request.
    // For now we just mock success.
  }
}

final friendsProvider =
    StateNotifierProvider<FriendsNotifier, FriendsState>((ref) {
  return FriendsNotifier();
});
