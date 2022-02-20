import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gibsonify/recipe/recipe.dart';
import 'package:gibsonify/home/home.dart';
import 'dart:convert';

class SyncScreen extends StatelessWidget {
  final _exportSubject = 'Gibsonify collection and recipe data';
  final _exportText = 'Gibsonify collection and recipe data attached as a JSON '
      'string. <br> Data can be pasted into '
      'https://www.convertcsv.com/json-to-csv.htm to obtain a csv file.';
  const SyncScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, homeState) {
      return BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, recipeState) {
        String recipeJson = recipeState.toJson();
        String collectionJson = json.encode({
          'collections':
              homeState.gibsonsForms.map((x) => x!.toJson()).toList(),
        });
        return Scaffold(
          appBar: AppBar(title: const Text('Export Data')),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: null,
                  label: const Text("Share data as JSON"),
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    final directory = await getApplicationDocumentsDirectory();
                    final path = directory.path;

                    final _recipefilePath = '$path/recipe_data.txt';
                    final _recipefile = File(_recipefilePath);
                    _recipefile.writeAsString(recipeJson);

                    final _collectionfilePath = '$path/collection_data.txt';
                    final _collectionfile = File(_collectionfilePath);
                    _collectionfile.writeAsString(collectionJson);

                    await Share.shareFiles(
                        [_recipefilePath, _collectionfilePath],
                        subject: _exportSubject, text: _exportText);
                  },
                )
              ]),
        );
      });
    });
  }
}
