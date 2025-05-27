// select_team_page.dart
import 'package:flutter/material.dart';

class SelectTeamPage extends StatelessWidget {
  final List<String> userTeams;
  final void Function(String) onTeamSelected;

  const SelectTeamPage({super.key, required this.userTeams, required this.onTeamSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Team')),
      body: ListView.builder(
        itemCount: userTeams.length,
        itemBuilder: (context, index) {
          final teamId = userTeams[index];
          return ListTile(
            title: Text('Team ID: \$teamId'),
            onTap: () {
              onTeamSelected(teamId);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}