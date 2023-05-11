import 'package:prayas/Data/Model/book_model.dart';
import 'package:prayas/Data/Model/chapter_model.dart';
import 'package:prayas/Data/Model/subject_model.dart';

import '../../Data/API/api_constants.dart';
import '../../Data/API/api_manager.dart';

class BookRepository {
  ApiManager apiManager = ApiManager();

  Future<ChapterModel> getChapters(Map<String, String> parameters) async {
    try {
      var response = await apiManager.post(APIConstants.getChapter, parameters);
      var responseMap = ChapterModel.fromJson(response);
      return responseMap;
    } catch (e) {
      rethrow;
    }
  }

  Future<SubjectModel> getSubjects(Map<String, String> parameters) async {
    try {
      var response = await apiManager.post(APIConstants.getSubject, parameters);
      var responseMap = SubjectModel.fromJson(response);
      return responseMap;
    } catch (e) {
      rethrow;
    }
  }
}
