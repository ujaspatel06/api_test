import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prayas/Data/Model/subject_model.dart';

import '../../Data/Model/chapter_model.dart';
import '../../Utils/Widgets/custom_snackbar.dart';
import '../../Utils/constant.dart';
import 'book_repository.dart';

class BookController extends GetxController {
  BookRepository bookRepository = BookRepository();
  RxList<Chapters> chapList = <Chapters>[].obs;
  RxList<Subject> subjectList = <Subject>[].obs;

  var isPasswordShow = true.obs;
  var isLoading = true.obs;

  getChapters({required int subId}) async {
    String userRememberKey = GetStorage().read(AppPreferencesHelper.USER_INFO);
    try {
      isLoading.value = true;
      var response = await bookRepository.getChapters(
          {'remember_token': userRememberKey, "subject_id": subId.toString()});
      if (response.result == 1) {
        chapList.clear();
        chapList.addAll(response.chapters as Iterable<Chapters>);
      } else {
        SnackBars.errorSnackBar(content: response.message!);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  getSubjects() async {
    String userRememberKey = GetStorage().read(AppPreferencesHelper.USER_INFO);
    try {
      isLoading.value = true;
      var response = await bookRepository
          .getSubjects({'remember_token': userRememberKey, "level_id": '4'});
      if (response.result == 1) {
        subjectList.clear();
        subjectList.addAll(response.subject as Iterable<Subject>);
      } else {
        SnackBars.errorSnackBar(content: response.message!);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
