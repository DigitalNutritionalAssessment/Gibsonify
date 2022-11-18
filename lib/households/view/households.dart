import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gibsonify/navigation/navigation.dart';
import 'package:gibsonify_repository/gibsonify_repository.dart';
import 'package:intl/intl.dart';

import '../bloc/households_bloc.dart';

class HouseholdsScreen extends StatelessWidget {
  const HouseholdsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HouseholdsBloc(isarRepository: context.read<IsarRepository>())
            ..add(const HouseholdsPageOpened()),
      child: const HouseholdsView(),
    );
  }
}

class HouseholdsView extends StatelessWidget {
  const HouseholdsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    return BlocBuilder<HouseholdsBloc, HouseholdsState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Households'),
              actions: [
                IconButton(
                    onPressed: () => Navigator.pushNamed(
                        context, PageRouter.collectionsHelp),
                    icon: const Icon(Icons.help))
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(2.0),
                    itemCount: state.households.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        title: Text(state.households[index].householdId),
                        subtitle: Text(formatter
                            .format(state.households[index].sensitizationDate)),
                        onTap: () => Navigator.pushNamed(
                            context, PageRouter.viewHousehold,
                            arguments: {'id': state.households[index].id}),
                        onLongPress: () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return HouseholdOptions(
                                  id: state.households[index].id,
                                  householdId:
                                      state.households[index].householdId);
                            }),
                      ));
                    },
                  ),
                )
              ],
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                      heroTag: null,
                      label: const Text("New household"),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, PageRouter.createHousehold);
                      }),
                ]));
      },
    );
  }
}

class HouseholdOptions extends StatelessWidget {
  const HouseholdOptions(
      {Key? key, required this.id, required this.householdId})
      : super(key: key);

  final int id;
  final String householdId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HouseholdsBloc, HouseholdsState>(
      builder: (context, state) {
        final List<Widget> options = [
          ListTile(title: Text(householdId)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              context
                  .read<HouseholdsBloc>()
                  .add(HouseholdDeleteRequested(id: id));
              Navigator.pop(context);
            },
          )
        ];
        return Wrap(children: options);
      },
    );
  }
}