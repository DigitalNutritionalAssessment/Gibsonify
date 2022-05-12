import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gibsonify/recipe/recipe.dart';
import 'package:gibsonify_api/gibsonify_api.dart';
import 'package:gibsonify/navigation/navigation.dart';

class RecipeIngredientsScreen extends StatelessWidget {
  final int recipeIndex;
  final String? assignedFoodItemId;
  const RecipeIngredientsScreen(this.recipeIndex,
      {Key? key, this.assignedFoodItemId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(title: const Text('Recipe ingredients')),
          body: RecipeForm(recipeIndex),
          floatingActionButton: Visibility(
            visible: !state.recipes[recipeIndex].saved,
            child: FloatingActionButton.extended(
                heroTag: null,
                label: const Text("New Ingredient"),
                icon: const Icon(Icons.add),
                onPressed: () => {
                      context.read<RecipeBloc>().add(
                          IngredientAdded(recipe: state.recipes[recipeIndex])),
                      Navigator.pushNamed(context, PageRouter.ingredient,
                          arguments: {
                            'recipeIndex': recipeIndex,
                            'ingredientIndex':
                                state.recipes[recipeIndex].ingredients.length,
                          }),
                    }),
          ));
    });
  }
}

class RecipeForm extends StatelessWidget {
  final int recipeIndex;
  const RecipeForm(this.recipeIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            AbsorbPointer(
                absorbing: state.recipes[recipeIndex].saved,
                child: RecipeNameInput(recipeIndex)),
            const SizedBox(height: 10),
            ListTile(
                title: (state.recipes[recipeIndex].ingredients.isNotEmpty)
                    ? const Text('Ingredients:')
                    : const Text('Recipe has no ingredients currently')),
            Ingredients(recipeIndex),
          ],
        ),
      );
    });
  }
}

class RecipeNameInput extends StatelessWidget {
  final int recipeIndex;
  const RecipeNameInput(this.recipeIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.recipes[recipeIndex].name,
          decoration: InputDecoration(
            icon: const Icon(Icons.assignment_rounded),
            labelText: 'Recipe Name',
            helperText: 'A valid recipe name, e.g. Aloo bandhgobhi',
            errorText:
                (isFieldModifiedAndEmpty(state.recipes[recipeIndex].name))
                    ? 'Enter a valid recipe name, e.g. Aloo bandhgobhi'
                    : null,
          ),
          onChanged: (value) {
            context.read<RecipeBloc>().add(RecipeNameChanged(
                name: value, recipe: state.recipes[recipeIndex]));
          },
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class Ingredients extends StatelessWidget {
  final int recipeIndex;
  const Ingredients(this.recipeIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      return Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(2.0),
              itemCount: state.recipes[recipeIndex].ingredients.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        title: (state.recipes[recipeIndex].ingredients[index]
                                    .name ==
                                "Other (please specify)")
                            // TODO: Implement a better implementation for this check
                            // possibly a flag to show customName is chosen
                            ? Text(state.recipes[recipeIndex].ingredients[index]
                                    .customName ??
                                '')
                            : Text(state.recipes[recipeIndex].ingredients[index]
                                    .name ??
                                ''),
                        subtitle: Text(state.recipes[recipeIndex]
                                .ingredients[index].description ??
                            ''),
                        leading: const Icon(Icons.food_bank),
                        trailing:
                            state.recipes[recipeIndex].ingredients[index].saved
                                ? const Icon(Icons.done)
                                : const Icon(Icons.new_releases),
                        onTap: () => {
                              Navigator.pushNamed(
                                  context, PageRouter.ingredient,
                                  arguments: {
                                    'recipeIndex': recipeIndex,
                                    'ingredientIndex': index,
                                  })
                            },
                        onLongPress: state.recipes[recipeIndex].saved
                            ? null
                            : () => showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return IngredientOptions(
                                      recipe: state.recipes[recipeIndex],
                                      ingredient: state.recipes[recipeIndex]
                                          .ingredients[index]);
                                })));
              }));
    });
  }
}

class IngredientOptions extends StatelessWidget {
  final Recipe recipe;
  final Ingredient ingredient;

  const IngredientOptions(
      {Key? key, required this.recipe, required this.ingredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
      final List<Widget> options = [
        const ListTile(title: Text('Ingredient options')),
        const Divider(),
        // ListTile(
        //   leading: const Icon(Icons.copy),
        //   title: const Text('Duplicate'),
        //   onTap: () => {
        //     context.read<RecipeBloc>().add(RecipeDuplicated(
        //         recipe: recipe, employeeNumber: employeeNumber)),
        //     context.read<RecipeBloc>().add(const RecipesSaved()),
        //     Navigator.pop(context, 'Duplicate')
        //   },
        // ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete'),
          onTap: () => {
            context
                .read<RecipeBloc>()
                .add(IngredientDeleted(recipe: recipe, ingredient: ingredient)),
            Navigator.pop(context, 'Delete')
          },
        )
      ];
      return Wrap(children: options);
    });
  }
}
