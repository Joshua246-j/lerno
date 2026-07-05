import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import '../providers/friends_provider.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _searchComplete = false;
  bool _requestSent = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsState = ref.watch(friendsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Friends',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 4,
          onTap: (_) => ref.read(audioManagerProvider).playClick(),
          tabs: const [
            Tab(text: 'My Friends'),
            Tab(text: 'Add Friends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsList(friendsState.friends),
          _buildAddFriends(),
        ],
      ),
    );
  }

  Widget _buildFriendsList(List<Friend> friends) {
    if (friends.isEmpty) {
      return const Center(child: Text('No friends yet!'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppTheme.pastelBlue,
                    child: SvgPicture.asset(friend.avatarUrl, width: 30),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: friend.isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.textDark),
                    ),
                    Text(
                      friend.statusText,
                      style: TextStyle(
                        fontSize: 13,
                        color: friend.isOnline ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(audioManagerProvider).playClick();
                  context.push('/chat/${friend.id}', extra: friend);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    const Text('Chat', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddFriends() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search by username...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchComplete = false;
                          _requestSent = false;
                        });
                      },
                    )
                  : null,
            ),
            onSubmitted: (val) {
              if (val.trim().isEmpty) return;
              ref.read(audioManagerProvider).playClick();
              setState(() {
                _isSearching = true;
                _searchComplete = false;
                _requestSent = false;
              });
              
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    _isSearching = false;
                    _searchComplete = true;
                  });
                }
              });
            },
            onChanged: (val) {
              setState(() {});
            },
          ),
          const SizedBox(height: 40),
          if (_isSearching)
            const CircularProgressIndicator(color: AppTheme.primaryBlue)
          else if (_searchComplete)
            _buildSearchResult()
          else ...[
            const Icon(Icons.people_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Find your friends',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search for a friend\'s username to invite them to a quiz battle!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSearchResult() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.pastelPurple,
                child: SvgPicture.asset('assets/svg/avatars/shop/unicorn.svg', width: 45),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _searchController.text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppTheme.textDark),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.emoji_events, size: 16, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          'Gold I',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _requestSent ? null : () {
                ref.read(audioManagerProvider).playClick();
                ref.read(friendsProvider.notifier).sendFriendRequest('mock_id');
                setState(() {
                  _requestSent = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Friend request sent to ${_searchController.text}!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _requestSent ? Colors.grey : AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _requestSent ? 'Request Sent' : 'Add Friend',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
