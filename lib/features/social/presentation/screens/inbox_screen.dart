import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import '../providers/friends_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsState = ref.watch(friendsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Inbox',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (friendsState.requests.isNotEmpty) ...[
              const Text('Friend Requests',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark)),
              const SizedBox(height: 12),
              ...friendsState.requests.map((request) => _buildRequestCard(context, ref, request)),
              const SizedBox(height: 24),
            ],
            
            const Text('Messages',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textDark)),
            const SizedBox(height: 12),
            _buildMessagesList(context, friendsState),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, WidgetRef ref, FriendRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppTheme.pastelBlue,
            child: SvgPicture.asset(request.avatarUrl, width: 35),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textDark),
                ),
                Row(
                  children: [
                    const Icon(LucideIcons.trophy, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      request.league,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(audioManagerProvider).playClick();
                  ref.read(friendsProvider.notifier).declineRequest(request.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.x, color: Colors.red, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  ref.read(audioManagerProvider).playClick();
                  ref.read(friendsProvider.notifier).acceptRequest(request.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You are now friends with ${request.name}!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.check, color: Colors.green, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, FriendsState state) {
    if (state.chatHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Text('No messages yet', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Column(
      children: state.chatHistory.keys.map((friendId) {
        final messages = state.chatHistory[friendId]!;
        final friend = state.friends.firstWhere(
            (f) => f.id == friendId,
            orElse: () => Friend(
                  id: 'unknown',
                  name: 'Unknown User',
                  avatarUrl: 'assets/svg/avatars/starter/octopus.svg',
                  league: 'Unranked',
                  isOnline: false,
                  statusText: '',
                ));

        if (messages.isEmpty || friend.id == 'unknown') return const SizedBox();

        final lastMessage = messages.last;

        return GestureDetector(
          onTap: () => context.push('/chat/${friend.id}', extra: friend),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.pastelBlue,
                      child: SvgPicture.asset(friend.avatarUrl, width: 35),
                    ),
                    if (friend.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            friend.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.textDark),
                          ),
                          Text(
                            _formatTime(lastMessage.timestamp),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: lastMessage.senderId == 'me'
                              ? Colors.grey
                              : AppTheme.textDark,
                          fontWeight: lastMessage.senderId == 'me'
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
