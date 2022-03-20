import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:gibsonify_api/gibsonify_api.dart';
import 'package:uuid/uuid.dart';

class GibsonsForm extends Equatable {
  GibsonsForm(
      {String? id,
      this.householdId,
      this.respondentName,
      this.respondentCountryCode,
      this.respondentTelNumberPrefix,
      this.respondentTelNumber,
      this.sensitizationDate,
      this.recallDay,
      this.interviewDate,
      this.interviewStartTime = const InterviewStartTime.pure(),
      this.geoLocation = const GeoLocation.pure(),
      this.pictureChartCollected = const PictureChartCollected.pure(),
      this.pictureChartNotCollectedReason = '',
      this.interviewEndTime = const InterviewEndTime.pure(),
      this.interviewOutcome = const InterviewOutcome.pure(),
      this.interviewOutcomeNotCompletedReason = '',
      this.comments = const Comments.pure(),
      this.foodItems = const <FoodItem>[]})
      : id = id ?? const Uuid().v4();

  final String id;
  final String? householdId;
  final String? respondentName;
  final String? respondentCountryCode;
  final String? respondentTelNumberPrefix;
  final String? respondentTelNumber;
  final String? sensitizationDate;
  final String? recallDay; // TODO: change to an enum
  final String? interviewDate;
  final InterviewStartTime interviewStartTime;
  final GeoLocation geoLocation;
  final PictureChartCollected pictureChartCollected;
  final String pictureChartNotCollectedReason;
  final InterviewEndTime interviewEndTime;
  final InterviewOutcome interviewOutcome;
  final String interviewOutcomeNotCompletedReason;
  final Comments comments;
  final List<FoodItem> foodItems;

  // TODO: add other fields from physical Gibson's form:
  // end of interview, did complete interview in one visit? (bool),
  // date of second visit, reason for second visit...

  // TODO: implement code generation JSON serialization using json_serializable
  // and/or json_annotation

  GibsonsForm.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        householdId = json['householdId'],
        respondentName = json['respondentName'],
        respondentCountryCode = json['respondentCountryCode'],
        respondentTelNumberPrefix = json['respondentTelNumberPrefix'],
        respondentTelNumber = json['respondentTelNumber'],
        sensitizationDate = json['sensitizationDate'],
        recallDay = json['recallDay'],
        interviewDate = json['interviewDate'],
        interviewStartTime =
            InterviewStartTime.fromJson(json['interviewStartTime']),
        geoLocation = GeoLocation.fromJson(json['geoLocation']),
        pictureChartCollected =
            PictureChartCollected.fromJson(json['pictureChartCollected']),
        pictureChartNotCollectedReason = json['pictureChartNotCollectedReason'],
        interviewEndTime = InterviewEndTime.fromJson(json['interviewEndTime']),
        interviewOutcome = InterviewOutcome.fromJson(json['interviewOutcome']),
        interviewOutcomeNotCompletedReason =
            json['interviewOutcomeNotCompletedReason'],
        comments = Comments.fromJson(json['comments']),
        foodItems = _jsonDecodeFoodItems(json['foodItems']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['householdId'] = householdId;
    data['respondentName'] = respondentName;
    data['respondentCountryCode'] = respondentCountryCode;
    data['respondentTelNumberPrefix'] = respondentTelNumberPrefix;
    data['respondentTelNumber'] = respondentTelNumber;
    data['sensitizationDate'] = sensitizationDate;
    data['recallDay'] = recallDay;
    data['interviewDate'] = interviewDate;
    data['interviewStartTime'] = interviewStartTime.toJson();
    data['geoLocation'] = geoLocation.toJson();
    data['pictureChartCollected'] = pictureChartCollected.toJson();
    data['pictureChartNotCollectedReason'] = pictureChartNotCollectedReason;
    data['interviewEndTime'] = interviewEndTime.toJson();
    data['interviewOutcome'] = interviewOutcome.toJson();
    data['interviewOutcomeNotCompletedReason'] =
        interviewOutcomeNotCompletedReason;
    data['comments'] = comments.toJson();
    data['foodItems'] = jsonEncode(foodItems); // This calls toJson on each one
    return data;
  }

  GibsonsForm copyWith(
      {String? id,
      String? householdId,
      String? respondentName,
      String? respondentCountryCode,
      String? respondentTelNumberPrefix,
      String? respondentTelNumber,
      String? sensitizationDate,
      String? recallDay,
      String? interviewDate,
      InterviewStartTime? interviewStartTime,
      GeoLocation? geoLocation,
      PictureChartCollected? pictureChartCollected,
      String? pictureChartNotCollectedReason,
      InterviewEndTime? interviewEndTime,
      InterviewOutcome? interviewOutcome,
      String? interviewOutcomeNotCompletedReason,
      Comments? comments,
      List<FoodItem>? foodItems}) {
    return GibsonsForm(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        respondentName: respondentName ?? this.respondentName,
        respondentCountryCode:
            respondentCountryCode ?? this.respondentCountryCode,
        respondentTelNumberPrefix:
            respondentTelNumberPrefix ?? this.respondentTelNumberPrefix,
        respondentTelNumber: respondentTelNumber ?? this.respondentTelNumber,
        sensitizationDate: sensitizationDate ?? this.sensitizationDate,
        recallDay: recallDay ?? this.recallDay,
        interviewDate: interviewDate ?? this.interviewDate,
        interviewStartTime: interviewStartTime ?? this.interviewStartTime,
        geoLocation: geoLocation ?? this.geoLocation,
        pictureChartCollected:
            pictureChartCollected ?? this.pictureChartCollected,
        pictureChartNotCollectedReason: pictureChartNotCollectedReason ??
            this.pictureChartNotCollectedReason,
        interviewEndTime: interviewEndTime ?? this.interviewEndTime,
        interviewOutcome: interviewOutcome ?? this.interviewOutcome,
        interviewOutcomeNotCompletedReason:
            interviewOutcomeNotCompletedReason ??
                this.interviewOutcomeNotCompletedReason,
        comments: comments ?? this.comments,
        foodItems: foodItems ?? this.foodItems);
  }

  @override
  String toString() {
    return '\n *** \nGibson\'s Form:\n'
        'UUID: $id\n'
        'HouseholdID: $householdId\n'
        'Repondent Name: $respondentName\n'
        'Repondent Country Code: $respondentCountryCode\n'
        'Respondent Tel Number Prefix: $respondentTelNumberPrefix\n'
        'Respondent Tel Number: $respondentTelNumber\n'
        'Sensitization Date: $sensitizationDate\n'
        'Recall Day: $recallDay\n'
        'Interview Date: $interviewDate\n'
        'Interview Start Time: $interviewStartTime\n'
        'Geo Location: $geoLocation\n'
        'Picture Chart Collected: $pictureChartCollected\n'
        'Picture Chart Not Collected Reason: $pictureChartNotCollectedReason\n'
        'Interview End Time: $interviewEndTime\n'
        'Interview Outcome: $interviewOutcome\n'
        'Interview Outcome Not Completed Reason: '
        '$interviewOutcomeNotCompletedReason\n'
        'Comments: $comments\n'
        'Food Items: $foodItems'
        '\n *** \n';
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        respondentName,
        respondentCountryCode,
        respondentTelNumberPrefix,
        respondentTelNumber,
        sensitizationDate,
        recallDay,
        interviewDate,
        interviewStartTime,
        geoLocation,
        pictureChartCollected,
        pictureChartNotCollectedReason,
        interviewEndTime,
        interviewOutcome,
        interviewOutcomeNotCompletedReason,
        comments,
        foodItems
      ];

  bool isHouseholdIdValid() {
    if (householdId != null) {
      if (householdId!.length >= 10 && householdId!.length <= 15) {
        return true;
      }
    }
    return false;
  }

  bool isRespondentNameValid() {
    return isFieldNotNullAndNotEmpty(respondentName);
  }

  bool isRespondentTelNumberValid() {
    return isFieldNotNullAndNotEmpty(respondentTelNumber);
  }

  bool isSensitizationDateValid() {
    return isFieldNotNullAndNotEmpty(sensitizationDate);
  }

  bool isInterviewDateValid() {
    if (sensitizationDate == null || interviewDate == null) {
      return false;
    }
    try {
      // TODO: refactor sensitizationDate and interviewDate to be DateTime fields
      // so that wouldn't have to parse in this method, just compare
      var parsedSensitizationDate = DateTime.parse(sensitizationDate!);
      var parsedInterviewDate = DateTime.parse(interviewDate!);
      bool isInterviewAtLeastTwoDaysAfterSensitization = parsedInterviewDate
          .subtract(Duration(days: 1))
          .isAfter(parsedSensitizationDate);
      return isInterviewAtLeastTwoDaysAfterSensitization;
    } catch (e) {
      return false;
    }
  }

  bool isRecallDayValid() {
    return isFieldNotNullAndNotEmpty(recallDay);
  }

  bool allFoodItemsConfirmed() {
    return foodItems.every((foodItem) => foodItem.confirmed);
  }

  bool isPictureChartCollected() {
    return pictureChartCollected.value.toLowerCase() == 'yes';
  }

  bool isInterviewOutcomeCompleted() {
    return interviewOutcome.value.toLowerCase() == 'completed';
  }
}

List<FoodItem> _jsonDecodeFoodItems(jsonEncodedFoodItems) {
  List<dynamic> partiallyDecodedFoodItems = jsonDecode(jsonEncodedFoodItems);
  List<FoodItem> fullyDecodedFoodItems =
      partiallyDecodedFoodItems.map((e) => FoodItem.fromJson(e)).toList();
  return fullyDecodedFoodItems;
}

enum InterviewStartTimeValidationError { invalid }

class InterviewStartTime
    extends FormzInput<String, InterviewStartTimeValidationError> {
  const InterviewStartTime.pure() : super.pure('');
  const InterviewStartTime.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  InterviewStartTime.fromJson(Map<String, dynamic> json)
      : super.dirty(json['value']);

  @override
  InterviewStartTimeValidationError? validator(String? value) {
    // TODO: Add validation, currently only checks if not empty
    return value?.isNotEmpty == true
        ? null
        : InterviewStartTimeValidationError.invalid;
  }
}

enum GeoLocationValidationError { invalid }

class GeoLocation extends FormzInput<String, GeoLocationValidationError> {
  const GeoLocation.pure() : super.pure('');
  const GeoLocation.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  GeoLocation.fromJson(Map<String, dynamic> json) : super.dirty(json['value']);

  @override
  GeoLocationValidationError? validator(String? value) {
    // TODO: Add validation, currently only checks if not empty
    return value?.isNotEmpty == true
        ? null
        : GeoLocationValidationError.invalid;
  }
}

enum PictureChartCollectedValidationError { invalid }

class PictureChartCollected
    extends FormzInput<String, PictureChartCollectedValidationError> {
  const PictureChartCollected.pure() : super.pure('');
  const PictureChartCollected.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  PictureChartCollected.fromJson(Map<String, dynamic> json)
      : super.dirty(json['value']);

  @override
  PictureChartCollectedValidationError? validator(String? value) {
    // TODO: Add validation, currently only checks if not empty
    return value?.isNotEmpty == true
        ? null
        : PictureChartCollectedValidationError.invalid;
  }
}

enum InterviewEndTimeValidationError { invalid }

class InterviewEndTime
    extends FormzInput<String, InterviewEndTimeValidationError> {
  const InterviewEndTime.pure() : super.pure('');
  const InterviewEndTime.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  InterviewEndTime.fromJson(Map<String, dynamic> json)
      : super.dirty(json['value']);

  @override
  InterviewEndTimeValidationError? validator(String? value) {
    // TODO: Add validation, currently only checks if not empty
    return value?.isNotEmpty == true
        ? null
        : InterviewEndTimeValidationError.invalid;
  }
}

enum InterviewOutcomeValidationError { invalid }

class InterviewOutcome
    extends FormzInput<String, InterviewOutcomeValidationError> {
  const InterviewOutcome.pure() : super.pure('');
  const InterviewOutcome.dirty([String value = '']) : super.dirty(value);

  // TODO: update when accepting custom strings for 'other'
  final _allowedRecallDay = const [
    'completed',
    'incomplete',
    'absent',
    'refused',
    'could not locate',
  ];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  InterviewOutcome.fromJson(Map<String, dynamic> json)
      : super.dirty(json['value']);

  @override
  InterviewOutcomeValidationError? validator(String? value) {
    final _lowerCaseValue = (value ?? '').toLowerCase();
    // TODO: refactor with a better null check
    return _allowedRecallDay.contains(_lowerCaseValue)
        ? null
        : InterviewOutcomeValidationError.invalid;
  }
}

enum CommentsValidationError { invalid }

class Comments extends FormzInput<String, CommentsValidationError> {
  const Comments.pure() : super.pure('');
  const Comments.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  Comments.fromJson(Map<String, dynamic> json) : super.dirty(json['value']);

  @override
  CommentsValidationError? validator(String? value) {
    // TODO: Add validation, currently only checks if not empty
    return value?.isNotEmpty == true ? null : CommentsValidationError.invalid;
  }
}
