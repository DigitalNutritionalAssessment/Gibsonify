import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

import 'food_item.dart';

class GibsonsForm extends Equatable {
  GibsonsForm(
      {String? id,
      this.householdId = const HouseholdId.pure(),
      this.respondentName = const RespondentName.pure(),
      this.respondentTelNumber = const RespondentTelNumber.pure(),
      this.interviewDate = const InterviewDate.pure(),
      this.interviewStartTime = const InterviewStartTime.pure(),
      this.sensitizationStatus = FormzStatus.pure,
      this.foodItems = const <FoodItem>[]})
      : id = id ?? const Uuid().v4();

  final String id;
  final HouseholdId householdId;
  final RespondentName respondentName;
  final RespondentTelNumber respondentTelNumber;
  final InterviewDate interviewDate;
  final InterviewStartTime interviewStartTime;
  final FormzStatus sensitizationStatus;

  final List<FoodItem> foodItems;

  // TODO: add other fields from physical Gibson's form:
  // end of interview, did complete interview in one visit? (bool),
  // date of second visit, reason for second visit, final outcome of interview,
  // reason for incomplete interview, supervisor comments.
  // And also ask ICRISAT about date of sensitization visit and recall day code.

  // TODO: implement code generation JSON serialization using json_serializable
  // and/or json_annotation

  GibsonsForm.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        householdId = HouseholdId.fromJson(json['householdId']),
        respondentName = RespondentName.fromJson(json['respondentName']),
        respondentTelNumber =
            RespondentTelNumber.fromJson(json['respondentTelNumber']),
        interviewDate = InterviewDate.fromJson(json['interviewDate']),
        interviewStartTime =
            InterviewStartTime.fromJson(json['interviewStartTime']),
        sensitizationStatus = json['sensitizationStatus'] == 'FormzStatus.valid'
            ? FormzStatus.valid
            : FormzStatus.invalid,
        foodItems = _jsonDecodeFoodItems(json['foodItems']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['householdId'] = householdId.toJson();
    data['respondentName'] = respondentName.toJson();
    data['respondentTelNumber'] = respondentTelNumber.toJson();
    data['interviewDate'] = interviewDate.toJson();
    data['interviewStartTime'] = interviewStartTime.toJson();
    data['sensitizationStatus'] = sensitizationStatus.toString();
    data['foodItems'] = jsonEncode(foodItems); // This calls toJson on each one
    return data;
  }

  GibsonsForm copyWith(
      {String? id,
      HouseholdId? householdId,
      RespondentName? respondentName,
      RespondentTelNumber? respondentTelNumber,
      InterviewDate? interviewDate,
      InterviewStartTime? interviewStartTime,
      FormzStatus? sensitizationStatus,
      List<FoodItem>? foodItems}) {
    return GibsonsForm(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        respondentName: respondentName ?? this.respondentName,
        respondentTelNumber: respondentTelNumber ?? this.respondentTelNumber,
        interviewStartTime: interviewStartTime ?? this.interviewStartTime,
        interviewDate: interviewDate ?? this.interviewDate,
        sensitizationStatus: sensitizationStatus ?? this.sensitizationStatus,
        foodItems: foodItems ?? this.foodItems);
  }

  @override
  String toString() {
    return '\n *** \nGibson\'s Form:\n'
        'UUID: $id\n'
        'HouseholdID: $householdId\n'
        'Repondent Name: $respondentName\n'
        'Respondent Tel Number: $respondentTelNumber\n'
        'Interview Date: $interviewDate\n'
        'Interview Start Time: $interviewStartTime\n'
        'Sensitization Status: $sensitizationStatus\n'
        'Food Items: $foodItems'
        '\n *** \n';
  }

  @override
  List<Object> get props => [
        id,
        householdId,
        respondentName,
        respondentTelNumber,
        interviewDate,
        interviewStartTime,
        sensitizationStatus,
        foodItems
      ];
}

List<FoodItem> _jsonDecodeFoodItems(jsonEncodedFoodItems) {
  List<dynamic> partiallyDecodedFoodItems = jsonDecode(jsonEncodedFoodItems);
  List<FoodItem> fullyDecodedFoodItems =
      partiallyDecodedFoodItems.map((e) => FoodItem.fromJson(e)).toList();
  return fullyDecodedFoodItems;
}

enum HouseholdIdValidationError { invalid }

class HouseholdId extends FormzInput<String, HouseholdIdValidationError> {
  const HouseholdId.pure() : super.pure('');
  const HouseholdId.dirty([String value = '']) : super.dirty(value);

  // TODO: Figure out a way to use the pure attribute or maybe drop
  // Formz completely. It might be easier to just have all these values
  // as strings and implement a couple of validator methods in GibsonsForm
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  HouseholdId.fromJson(Map<String, dynamic> json) : super.dirty(json['value']);

  @override
  HouseholdIdValidationError? validator(String value) {
    // TODO: Add validation based on ICRISAT's criteria, currently
    // only checks if at least 2 symbols
    return value.length > 1 ? null : HouseholdIdValidationError.invalid;
  }
}

enum RespondentNameValidationError { invalid }

class RespondentName extends FormzInput<String, RespondentNameValidationError> {
  const RespondentName.pure() : super.pure('');
  const RespondentName.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  RespondentName.fromJson(Map<String, dynamic> json)
      : super.dirty(json['value']);

  @override
  RespondentNameValidationError? validator(String? value) {
    return value?.isNotEmpty == true
        ? null
        : RespondentNameValidationError.invalid;
  }
}

enum RespondentTelNumberValidationError { invalid }

class RespondentTelNumber
    extends FormzInput<String, RespondentTelNumberValidationError> {
  const RespondentTelNumber.pure() : super.pure('');
  const RespondentTelNumber.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  RespondentTelNumber.fromJson(Map<String, dynamic> json)
      : super.dirty(json['value']);

  @override
  RespondentTelNumberValidationError? validator(String? value) {
    // TODO: Add (Regex?) number validation, currently only checks if not empty
    // also probably could be empty? So check if either empty or valid number
    return value?.isNotEmpty == true
        ? null
        : RespondentTelNumberValidationError.invalid;
  }
}

enum InterviewDateValidationError { invalid }

class InterviewDate extends FormzInput<String, InterviewDateValidationError> {
  const InterviewDate.pure() : super.pure('');
  const InterviewDate.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = value;
    data['pure'] = pure.toString();
    return data;
  }

  InterviewDate.fromJson(Map<String, dynamic> json)
      : super.dirty(json['value']);

  @override
  InterviewDateValidationError? validator(String? value) {
    // TODO: Add validation, currently only checks if not empty
    return value?.isNotEmpty == true
        ? null
        : InterviewDateValidationError.invalid;
  }
}

enum InterviewStartTimeValidationError { invalid }

class InterviewStartTime
    extends FormzInput<String, InterviewStartTimeValidationError> {
  const InterviewStartTime.pure() : super.pure('');
  const InterviewStartTime.dirty([String value = '']) : super.dirty(value);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
