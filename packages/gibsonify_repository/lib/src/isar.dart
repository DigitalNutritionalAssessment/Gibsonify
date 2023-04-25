import 'package:gibsonify_api/gibsonify_api.dart';
import 'package:isar/isar.dart';

class IsarRepository {
  final Isar isar;

  IsarRepository({required this.isar});

  static Future<IsarRepository> create() async {
    final isar = await Isar.open([HouseholdSchema, SurveySchema]);
    return IsarRepository(isar: isar);
  }

  Future<List<Household>> readHouseholdsOrderById() async {
    return await isar.households.where().sortByHouseholdId().findAll();
  }

  Future<List<Household>> readHouseholdsOrderBySensitizationDate() async {
    return await isar.households.where().sortBySensitizationDate().findAll();
  }

  Stream<void> watchHouseholds() {
    return isar.households.watchLazy(fireImmediately: true);
  }

  Future<Household?> readHousehold(int id) async {
    return await isar.households.get(id);
  }

  Future<void> saveNewHousehold(Household household) async {
    await isar.writeTxn(() async {
      isar.households.put(household);
    });
  }

  Future<void> deleteHousehold(int id) async {
    await isar.writeTxn(() async {
      isar.households.delete(id);
    });
  }

  Future<void> saveNewRespondent(int id, Respondent respondent) async {
    await isar.writeTxn(() async {
      final household = await isar.households.get(id);
      household!.respondents.add(respondent);
      isar.households.put(household);
    });
  }

  Future<List<Survey>> readSurveys() async {
    return await isar.surveys.where().findAll();
  }

  Future<Survey?> readSurvey(int id) async {
    return await isar.surveys.get(id);
  }

  Future<void> saveSurvey(Survey survey) async {
    await isar.writeTxn(() async {
      isar.surveys.put(survey);
    });
  }

  Future<void> deleteSurvey(int id) async {
    await isar.writeTxn(() async {
      isar.surveys.delete(id);
    });
  }
}
