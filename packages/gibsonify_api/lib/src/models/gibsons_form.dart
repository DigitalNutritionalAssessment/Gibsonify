import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:gibsonify_api/gibsonify_api.dart';

part 'gibsons_form.g.dart';

enum PhysioStatus { notApplicable, pregnant, lactatingH1, lactatingH2 }

String physioStatusToString(PhysioStatus physioStatus) {
  switch (physioStatus) {
    case PhysioStatus.notApplicable:
      return "N/A";
    case PhysioStatus.pregnant:
      return "Pregnant";
    case PhysioStatus.lactatingH1:
      return "Lactating - 0 to 5 months";
    case PhysioStatus.lactatingH2:
      return "Lactating - 6 to 12 months";
  }
}

@Embedded(inheritance: false)
class GibsonsForm extends Equatable {
  GibsonsForm(
      {String? formId,
      this.employeeNumber,
      this.surveyId,
      this.recallDay, // TODO: rename to recallDayType
      this.interviewDate,
      this.interviewStartTime,
      this.physioStatus = PhysioStatus.notApplicable,
      this.pictureChartCollected,
      this.pictureChartNotCollectedReason,
      this.interviewEndTime,
      this.interviewFinishedInOneVisit,
      this.secondInterviewVisitDate,
      this.secondVisitReason,
      this.interviewOutcome,
      this.interviewOutcomeNotCompletedReason,
      this.comments,
      this.finished = false,
      this.foodItems = const <FoodItem>[]})
      : id = formId ?? const Uuid().v4();

  final String id;
  final String? employeeNumber;
  final String? surveyId;
  final String? recallDay; // TODO: change to an enum
  final String? interviewDate;
  final String? interviewStartTime;
  @Enumerated(EnumType.ordinal32)
  final PhysioStatus physioStatus;
  final String? pictureChartCollected; // TODO: change to a bool
  final String? pictureChartNotCollectedReason;
  final String? interviewEndTime;
  final String? interviewFinishedInOneVisit; // TODO: change to a bool
  final String? secondInterviewVisitDate;
  final String? secondVisitReason;
  final String? interviewOutcome; // TODO: change to an enum
  final String? interviewOutcomeNotCompletedReason;
  final String? comments;
  final bool finished;
  final List<FoodItem> foodItems;

  // TODO: implement code generation JSON serialization using json_serializable
  // and/or json_annotation

  GibsonsForm.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        employeeNumber = json['employeeNumber'],
        surveyId = json['surveyId'],
        recallDay = json['recallDay'],
        interviewDate = json['interviewDate'],
        interviewStartTime = json['interviewStartTime'],
        physioStatus = json['physioStatus'],
        pictureChartCollected = json['pictureChartCollected'],
        pictureChartNotCollectedReason = json['pictureChartNotCollectedReason'],
        interviewEndTime = json['interviewEndTime'],
        interviewFinishedInOneVisit = json['interviewFinishedInOneVisit'],
        secondInterviewVisitDate = json['secondInterviewVisitDate'],
        secondVisitReason = json['secondVisitReason'],
        interviewOutcome = json['interviewOutcome'],
        interviewOutcomeNotCompletedReason =
            json['interviewOutcomeNotCompletedReason'],
        comments = json['comments'],
        finished = json['finished'] == 'true' ? true : false,
        foodItems = _jsonDecodeFoodItems(json['foodItems']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeNumber'] = employeeNumber;
    data['surveyId'] = surveyId;
    data['recallDay'] = recallDay;
    data['interviewDate'] = interviewDate;
    data['interviewStartTime'] = interviewStartTime;
    data['physioStatus'] = physioStatus;
    data['pictureChartCollected'] = pictureChartCollected;
    data['pictureChartNotCollectedReason'] = pictureChartNotCollectedReason;
    data['interviewEndTime'] = interviewEndTime;
    data['interviewFinishedInOneVisit'] = interviewFinishedInOneVisit;
    data['secondInterviewVisitDate'] = secondInterviewVisitDate;
    data['secondVisitReason'] = secondVisitReason;
    data['interviewOutcome'] = interviewOutcome;
    data['interviewOutcomeNotCompletedReason'] =
        interviewOutcomeNotCompletedReason;
    data['comments'] = comments;
    data['finished'] = finished.toString();
    data['foodItems'] = jsonEncode(foodItems); // This calls toJson on each one
    return data;
  }
  // TODO: add a fromCsv constructor

  String toCsv(
      String householdId,
      String respondentName,
      String respondentCountryCode,
      String respondentTelNumberPrefix,
      String respondentTelNumber,
      String sensitizationDate,
      String geoLocation) {
    String gibsonsFormInfo =
        '"$id","$employeeNumber","$householdId","$respondentName",'
        '"$respondentCountryCode","$respondentTelNumberPrefix","$respondentTelNumber",'
        '"$sensitizationDate","$recallDay","$interviewDate","$interviewStartTime","$physioStatus"'
        '"$geoLocation","$pictureChartCollected","$pictureChartNotCollectedReason",'
        '"$interviewEndTime","$interviewFinishedInOneVisit","$secondInterviewVisitDate",'
        '"$secondVisitReason","$interviewOutcome","$interviewOutcomeNotCompletedReason",'
        '"$comments","${finished.toString()}",';
    String csv = '';
    for (FoodItem foodItem in foodItems) {
      csv += gibsonsFormInfo + foodItem.toCsv() + '\n';
    }
    return csv;
  }

  GibsonsForm copyWith(
      {String? id,
      String? employeeNumber,
      String? householdId,
      String? surveyId,
      String? recallDay,
      String? interviewDate,
      String? interviewStartTime,
      PhysioStatus? physioStatus,
      String? pictureChartCollected,
      String? pictureChartNotCollectedReason,
      String? interviewEndTime,
      String? interviewFinishedInOneVisit,
      String? secondInterviewVisitDate,
      String? secondVisitReason,
      String? interviewOutcome,
      String? interviewOutcomeNotCompletedReason,
      String? comments,
      bool? finished,
      List<FoodItem>? foodItems}) {
    return GibsonsForm(
        formId: id ?? this.id,
        employeeNumber: employeeNumber ?? this.employeeNumber,
        surveyId: surveyId ?? this.surveyId,
        recallDay: recallDay ?? this.recallDay,
        interviewDate: interviewDate ?? this.interviewDate,
        interviewStartTime: interviewStartTime ?? this.interviewStartTime,
        physioStatus: physioStatus ?? this.physioStatus,
        pictureChartCollected:
            pictureChartCollected ?? this.pictureChartCollected,
        pictureChartNotCollectedReason: pictureChartNotCollectedReason ??
            this.pictureChartNotCollectedReason,
        interviewEndTime: interviewEndTime ?? this.interviewEndTime,
        interviewFinishedInOneVisit:
            interviewFinishedInOneVisit ?? this.interviewFinishedInOneVisit,
        secondInterviewVisitDate:
            secondInterviewVisitDate ?? this.secondInterviewVisitDate,
        secondVisitReason: secondVisitReason ?? this.secondVisitReason,
        interviewOutcome: interviewOutcome ?? this.interviewOutcome,
        interviewOutcomeNotCompletedReason:
            interviewOutcomeNotCompletedReason ??
                this.interviewOutcomeNotCompletedReason,
        comments: comments ?? this.comments,
        finished: finished ?? this.finished,
        foodItems: foodItems ?? this.foodItems);
  }

  @override
  String toString() {
    return '\n *** \nGibson\'s Form:\n'
        'UUID: $id\n'
        'Survey ID: $surveyId\n'
        'Employee Number: $employeeNumber\n'
        'Recall Day: $recallDay\n'
        'Interview Date: $interviewDate\n'
        'Interview Start Time: $interviewStartTime\n'
        'Physio Status: $physioStatus\n'
        'Picture Chart Collected: $pictureChartCollected\n'
        'Picture Chart Not Collected Reason: $pictureChartNotCollectedReason\n'
        'Interview End Time: $interviewEndTime\n'
        'Interview finished in one visit: $interviewFinishedInOneVisit\n'
        'Second interview visit date: $secondInterviewVisitDate\n'
        'Second visit reason: $secondVisitReason\n'
        'Interview Outcome: $interviewOutcome\n'
        'Interview Outcome Not Completed Reason: '
        '$interviewOutcomeNotCompletedReason\n'
        'Comments: $comments\n'
        'Finished: $finished\n'
        'Food Items: $foodItems'
        '\n *** \n';
  }

  @override
  @ignore
  List<Object?> get props => [
        id,
        surveyId,
        employeeNumber,
        recallDay,
        interviewDate,
        interviewStartTime,
        physioStatus,
        pictureChartCollected,
        pictureChartNotCollectedReason,
        interviewEndTime,
        interviewFinishedInOneVisit,
        secondInterviewVisitDate,
        secondVisitReason,
        interviewOutcome,
        interviewOutcomeNotCompletedReason,
        comments,
        finished,
        foodItems
      ];

  bool isSurveyIdValid() {
    return isFieldNotNullAndNotEmpty(surveyId);
  }

  bool isRecallDayValid() {
    return isFieldNotNullAndNotEmpty(recallDay);
  }

  bool isInterviewStartTimeValid() {
    return isFieldNotNullAndNotEmpty(interviewStartTime);
  }

  bool isSensitizationValid() {
    bool sensitizationValid =
        isSurveyIdValid() && isRecallDayValid() && isInterviewStartTimeValid();
    return sensitizationValid;
  }

  bool allFoodItemsConfirmed() {
    return foodItems.every((foodItem) => foodItem.confirmed);
  }

  bool isPictureChartCollectedValid() {
    return isFieldNotNullAndNotEmpty(pictureChartCollected);
  }

  bool isPictureChartCollected() {
    return pictureChartCollected?.toLowerCase() == 'yes';
  }

  bool isPictureChartNotCollectedReasonValid() {
    return isFieldNotNullAndNotEmpty(pictureChartNotCollectedReason);
  }

  bool isInterviewEndTimeValid() {
    return isFieldNotNullAndNotEmpty(interviewEndTime);
  }

  bool isInterviewFinishedInOneVisitValid() {
    return isFieldNotNullAndNotEmpty(interviewFinishedInOneVisit);
  }

  bool isInterviewFinishedInOneVisit() {
    return interviewFinishedInOneVisit?.toLowerCase() == 'yes';
  }

  bool isSecondInterviewVisitDateValid() {
    // TODO: add parsing checks to ensure it is after first interview date
    return isFieldNotNullAndNotEmpty(secondInterviewVisitDate);
  }

  bool isSecondVisitReasonValid() {
    return isFieldNotNullAndNotEmpty(secondVisitReason);
  }

  bool isInterviewOutcomeValid() {
    return isFieldNotNullAndNotEmpty(interviewOutcome);
  }

  bool isInterviewOutcomeCompleted() {
    return interviewOutcome?.toLowerCase() == 'completed';
  }

  bool isInterviewOutcomeNotCompletedReasonValid() {
    return isFieldNotNullAndNotEmpty(interviewOutcomeNotCompletedReason);
  }

  bool areCommentsValid() {
    return true; // comments are not mandatory
  }
}

List<FoodItem> _jsonDecodeFoodItems(jsonEncodedFoodItems) {
  List<dynamic> partiallyDecodedFoodItems = jsonDecode(jsonEncodedFoodItems);
  List<FoodItem> fullyDecodedFoodItems =
      partiallyDecodedFoodItems.map((e) => FoodItem.fromJson(e)).toList();
  return fullyDecodedFoodItems;
}
