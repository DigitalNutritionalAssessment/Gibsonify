import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:gibsonify/home/home.dart';
import 'package:gibsonify/navigation/navigation.dart';
import 'package:gibsonify/collection/collection.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(title: const Text('Collections')),
            body: ListView.builder(
                padding: const EdgeInsets.all(2.0),
                itemCount: state.gibsonsForms.length,
                itemBuilder: (context, index) {
                  // TODO: Refactor to a standalone widget
                  return Slidable(
                    key: Key(state.gibsonsForms[index]!.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          // TODO: implement deletion confirmation dialog
                          onPressed: (context) => context.read<HomeBloc>().add(
                              GibsonsFormDeleted(
                                  id: state.gibsonsForms[index]!.id)),
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: Card(
                        // Unique key is needed to correctly rebuild after
                        // deleting or modifying this widget and its subwidgets
                        key: Key(state.gibsonsForms[index]!.id),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  key: UniqueKey(),
                                  onTap: () {
                                    context.read<CollectionBloc>().add(
                                        GibsonsFormProvided(
                                            gibsonsForm:
                                                state.gibsonsForms[index]!));
                                    Navigator.pushNamed(
                                        context, PageRouter.collection);
                                  },
                                  readOnly: true,
                                  initialValue: state.gibsonsForms[index]!
                                      .respondentName.value,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.person),
                                    labelText: 'Respondent Name',
                                  ),
                                ),
                                TextFormField(
                                  key: UniqueKey(),
                                  onTap: () {
                                    context.read<CollectionBloc>().add(
                                        GibsonsFormProvided(
                                            gibsonsForm:
                                                state.gibsonsForms[index]!));
                                    Navigator.pushNamed(
                                        context, PageRouter.collection);
                                  },
                                  readOnly: true,
                                  initialValue: state
                                      .gibsonsForms[index]!.interviewDate.value,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.calendar_today),
                                    labelText: 'Interview Date',
                                  ),
                                ),
                              ],
                            ))),
                  );
                }),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                      heroTag: null,
                      label: const Text("New Collection"),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // TODO: Refactor into the Collection Page accepting a
                        // nullable instance of GibsonsForm as argument.
                        // In this case it will be null so a new GibsonsForm
                        // will be initialized
                        context
                            .read<CollectionBloc>()
                            .add(const GibsonsFormCreated());
                        Navigator.pushNamed(context, PageRouter.collection);
                      })
                ]));
      },
    );
  }
}
