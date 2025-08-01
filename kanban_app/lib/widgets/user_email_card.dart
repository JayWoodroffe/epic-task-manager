// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:kanban_app/models/user.dart';
import 'package:kanban_app/styles/colors.dart';

class UserEmailCard extends StatelessWidget {
  final User user;
  final void Function(BuildContext, User user) onRemoved;
  const UserEmailCard({super.key, required this.user, required this.onRemoved});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(user.email,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: GestureDetector(
                onTap: () {
                  onRemoved(context, user);
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.grey.shade700,
                  size: 30,
                )),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(14)),
    );
  }
}
