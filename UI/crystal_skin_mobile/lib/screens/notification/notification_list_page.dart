import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crystal_skin_mobile/models/notification.dart';
import 'package:crystal_skin_mobile/providers/notification_provider.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({Key? key}) : super(key: key);

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final ScrollController _scrollController = ScrollController();
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _perPage = 10;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

      final params = {
        'userId': Authorization.id!.toString(),
        'pageNumber': _page.toString(),
        'pageSize': _perPage.toString(),
      };

      final response = await notificationProvider.getForPagination(params);
      final newNotifications = response.items;

      setState(() {
        _notifications.addAll(newNotifications);
        if (newNotifications.length < _perPage) {
          _hasMore = false;
        }
        _hasMore = newNotifications.length == _perPage;
        _page++;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom učitavanja notifikacija: ${e.toString()}')),
      );
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadNotifications();
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _page = 1;
      _notifications = [];
      _hasMore = true;
    });
    await _loadNotifications();
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    try {
      final notificationProvider =
      Provider.of<NotificationProvider>(context, listen: false);

      notification.read = true;
      await notificationProvider.update(notification.id, notification);

      setState(() {
        notification.read = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dogodila se greška prilikom označavanja poruke pročitanom: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikacije'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: _notifications.isEmpty && !_isLoading
            ? const Center(child: Text('Nemate notifikacija'))
            : ListView.builder(
          controller: _scrollController,
          itemCount: _notifications.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _notifications.length) {
              return _isLoading
                  ? const Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ))
                  : const SizedBox();
            }

            final notification = _notifications[index];
            return Dismissible(
              key: Key(notification.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                try {
                  final notificationProvider =
                  Provider.of<NotificationProvider>(context, listen: false);
                  await notificationProvider.deleteById(notification.id);

                  setState(() {
                    _notifications.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notifikacija uspješno obrisana'),
                      backgroundColor: Colors.green.shade600,
                    ),

                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: ${e.toString()}')),
                  );
                  setState(() {}); // Rebuild to show the item again
                }
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: notification.read
                      ? Colors.grey
                      : app_color,
                  child: Icon(
                    Icons.notifications,
                    color: notification.read ? Colors.white70 : Colors.white,
                  ),
                ),
                title: Text(
                  notification.message,
                  style: TextStyle(
                    fontWeight: notification.read
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: notification.user != null
                    ? Text('Od: ${notification.user!.email}')
                    : null,
                trailing: notification.read
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.mark_as_unread),
                  onPressed: () => _markAsRead(notification),
                ),
                onTap: () {
                  // Handle notification tap
                  if (!notification.read) {
                    _markAsRead(notification);
                  }
                  // Navigate to relevant screen based on notification
                },
              ),
            );
          },
        ),
      ),
    );
  }
}