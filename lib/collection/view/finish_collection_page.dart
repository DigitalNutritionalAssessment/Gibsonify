import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gibsonify/collection/collection.dart';
import 'package:gibsonify/home/home.dart';
import 'package:gibsonify_api/gibsonify_api.dart';

class FinishCollectionPage extends StatelessWidget {
  const FinishCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Finish Collection'),
            ),
            resizeToAvoidBottomInset: false,
            body: const SingleChildScrollView(child: FinishCollectionForm()),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                      heroTag: null,
                      label: const Text("Complete Collection"),
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        context
                            .read<CollectionBloc>()
                            .add(const GibsonsFormSaved());
                        context
                            .read<HomeBloc>()
                            .add(const GibsonsFormsLoaded());
                        Navigator.pop(context);
                        Navigator.pop(context);
                      })
                ]));
      },
    );
  }
}

class FinishCollectionForm extends StatelessWidget {
  const FinishCollectionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const <Widget>[
          PictureChartCollectedInput(),
          PictureChartNotCollectedReason(),
          InterviewEndTimeInput(),
          InterviewOutcomeInput(),
          CommentsInput()
        ],
      ),
    );
  }
}

class PictureChartCollectedInput extends StatelessWidget {
  const PictureChartCollectedInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<DropdownMenuItem<String>> dropdownMenuItems = [
      DropdownMenuItem(child: Text(''), value: ''),
      DropdownMenuItem(child: Text('Yes'), value: 'Yes'),
      DropdownMenuItem(child: Text('No'), value: 'No')
    ];
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return DropdownButtonFormField(
            value: state.gibsonsForm.pictureChartCollected.value,
            decoration: InputDecoration(
                icon: const Icon(Icons.photo_size_select_actual_rounded),
                labelText: 'Is picture chart collected',
                helperText: 'Have you collected the picture chart?',
                errorText: state.gibsonsForm.pictureChartCollected.invalid
                    ? 'Select if you collected the picture chart'
                    : null),
            items: dropdownMenuItems,
            onChanged: (String? value) {
              context.read<CollectionBloc>().add(PictureChartCollectedChanged(
                  pictureChartCollected: value ?? ''));
            });
      },
    );
  }
}

class PictureChartNotCollectedReason extends StatelessWidget {
  const PictureChartNotCollectedReason({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return Visibility(
            visible: state.gibsonsForm.pictureChartCollected.valid &&
                !state.gibsonsForm.isPictureChartCollected(),
            child: TextFormField(
              initialValue: state.gibsonsForm.pictureChartNotCollectedReason,
              decoration: InputDecoration(
                icon: const Icon(Icons.device_unknown_outlined),
                labelText: 'Reason for not collecting the picture chart',
                helperText: 'Why did you not collect the picture chart',
                errorText:
                    state.gibsonsForm.pictureChartNotCollectedReason.isEmpty
                        ? 'Choose the reason'
                        : null,
              ),
              onChanged: (value) {
                context.read<CollectionBloc>().add(
                    PictureChartNotCollectedReasonChanged(
                        pictureChartNotCollectedReason: value));
              },
            ));
      },
    );
  }
}

class InterviewEndTimeInput extends StatelessWidget {
  const InterviewEndTimeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return TextFormField(
          readOnly: true,
          key: UniqueKey(),
          initialValue: state.gibsonsForm.interviewEndTime.value,
          decoration: InputDecoration(
            icon: const Icon(Icons.access_time),
            labelText: 'Interview End Time',
            helperText: 'Time at the end of the interview',
            errorText: state.gibsonsForm.interviewEndTime.invalid
                ? 'Choose the end time of the interview'
                : null,
          ),
          onTap: () async {
            var time = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());
            var formattedTime = time?.format(context);
            context.read<CollectionBloc>().add(
                InterviewEndTimeChanged(interviewEndTime: formattedTime ?? ''));
          },
        );
      },
    );
  }
}

class InterviewOutcomeInput extends StatelessWidget {
  const InterviewOutcomeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<DropdownMenuItem<String>> dropdownMenuItems = [
      DropdownMenuItem(child: Text(''), value: ''),
      DropdownMenuItem(child: Text('Completed'), value: 'Completed'),
      DropdownMenuItem(child: Text('Incomplete'), value: 'Incomplete'),
      DropdownMenuItem(child: Text('Absent'), value: 'Absent'),
      DropdownMenuItem(child: Text('Refused'), value: 'Refused'),
      DropdownMenuItem(
          child: Text('Could not locate'), value: 'Could not locate')
    ];
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return DropdownButtonFormField(
            value: state.gibsonsForm.interviewOutcome.value,
            decoration: InputDecoration(
                icon: const Icon(Icons.format_indent_increase_sharp),
                labelText: 'Interview outcome',
                helperText: 'Final result of the interview',
                errorText: state.gibsonsForm.interviewOutcome.invalid
                    ? 'Select interview outcome'
                    : null),
            items: dropdownMenuItems,
            onChanged: (String? value) {
              context
                  .read<CollectionBloc>()
                  .add(InterviewOutcomeChanged(interviewOutcome: value ?? ''));
            });
      },
    );
  }
}

class CommentsInput extends StatelessWidget {
  const CommentsInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.gibsonsForm.comments.value,
          decoration: const InputDecoration(
              icon: Icon(Icons.comment),
              labelText: 'Comments',
              helperText: 'Any relevant extra information'),
          onChanged: (value) {
            context
                .read<CollectionBloc>()
                .add(CommentsChanged(comments: value));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}
