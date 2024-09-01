import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/models/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Team> teams = [];

  Future getTeams() async {
    var response = await http.get(Uri.https('api.balldontlie.io', 'v1/teams'),
    // Send authorization headers to the backend.
  headers: {
    HttpHeaders.authorizationHeader: 'API KEY',
  },
    );
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team =
      Team(eachTeam['abbreviation'], eachTeam['city']);
      teams.add(team);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      body: FutureBuilder(
        future: getTeams(), 
        builder: (context, snapshot) {
          // is it done loading? then show team data
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 25, bottom: 5, right: 25),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ListTile(
                    title: Text(teams[index].abbreviation),
                    subtitle: Text(teams[index].city),
                  ),
                );
              },
            );
          }
          // if it it's still loading, show loading circle
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
    );
  }
}