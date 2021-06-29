import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rojnishi/auth.dart';
import 'package:rojnishi/services/notification.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService notify = NotificationService();
  @override
  void initState() {
    Provider.of<NotificationService>(context, listen: false).initialize();
    super.initState();
    notify.sheduledNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Auth();
  }
}
