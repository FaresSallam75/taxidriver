import 'package:chat/business_logic/notifications/notification_cubit.dart';
import 'package:chat/business_logic/notifications/notification_state.dart';
import 'package:chat/data/model/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: FutureBuilder<List<NotificationModel>>(
          future: context.read<NotificationCubit>().getAllNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final notification = snapshot.data;

            if (notification == null || notification.isEmpty) {
              return const Center(child: Text('No notification found.'));
            }

            return BlocBuilder<NotificationCubit, NotificationsState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: notification.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        context.read<NotificationCubit>().deleteNotification(
                          notification[index].docId.toString(),
                        );
                      },
                      key: Key(notification[index].docId.toString()),
                      child: ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text(notification[index].title!),
                        subtitle: Text(notification[index].body!),
                        trailing: Text(notification[index].time!),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
