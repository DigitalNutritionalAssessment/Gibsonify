import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gibsonify/recipe/recipe.dart';
import 'package:gibsonify_api/gibsonify_api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gibsonify/navigation/navigation.dart';

class RecipeProbeScreen extends StatelessWidget {
  final int recipeIndex;
  const RecipeProbeScreen(this.recipeIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
              title: Text(
                  'Probe list for ${state.recipes[recipeIndex].recipeName.value}')),
          floatingActionButton: FloatingActionButton.extended(
              label: const Text("Add probe"),
              icon: const Icon(Icons.add),
              onPressed: () => {
                    context
                        .read<RecipeBloc>()
                        .add(ProbeAdded(recipe: state.recipes[recipeIndex])),
                    Navigator.pushNamed(context, PageRouter.editProbe,
                        arguments: [
                          recipeIndex,
                          state.recipes[recipeIndex].probes.length
                        ])
                  }),
          body: ProbeList(recipeIndex: recipeIndex));
    });
  }
}

class ProbeList extends StatelessWidget {
  final int recipeIndex;

  const ProbeList({Key? key, required this.recipeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(2.0),
                itemCount: state.recipes[recipeIndex].probes.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => DeleteProbe(
                                    recipe: state.recipes[recipeIndex],
                                    probe: state
                                        .recipes[recipeIndex].probes[index]));
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: Card(
                        child: ListTile(
                      title: Text(
                          state.recipes[recipeIndex].probes[index]['probe']),
                      leading: const Icon(Icons.live_help),
                      trailing: Checkbox(
                        value: state.recipes[recipeIndex].probes[index]
                            ['checked'],
                        onChanged: (bool? value) {
                          context.read<RecipeBloc>().add(ProbeChecked(
                              recipe: state.recipes[recipeIndex],
                              probeCheck: value!,
                              probeIndex: index));
                        },
                      ),
                      onTap: () => {
                        Navigator.pushNamed(context, PageRouter.editProbe,
                            arguments: [recipeIndex, index])
                      },
                    )),
                  );
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: state.recipes[recipeIndex].probesChecked
                ? const Text('This is a standard recipe.')
                : const Text('This is a modified recipe.'),
            subtitle: state.recipes[recipeIndex].probesChecked
                ? const Text('Confirm recipe volume on Recipe Details page')
                : const Text(
                    'Add or remove ingredients on the ingredients page'),
            tileColor: state.recipes[recipeIndex].probesChecked
                ? Colors.green
                : Colors.red,
          )
        ],
      );
    });
  }
}

class DeleteProbe extends StatelessWidget {
  final Recipe recipe;
  final Map<String, dynamic> probe;

  const DeleteProbe({Key? key, required this.recipe, required this.probe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      return AlertDialog(
        title: const Text('Delete probe'),
        content: Text('Would you like to delete the ${probe['probe']} probe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              context
                  .read<RecipeBloc>()
                  .add(ProbeDeleted(recipe: recipe, probe: probe)),
              Navigator.pop(context, 'OK')
            },
            child: const Text('OK'),
          ),
        ],
      );
    });
  }
}