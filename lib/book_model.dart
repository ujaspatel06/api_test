class BookModel {
  int? result;
  List<Book>? book;
  String? message;

  BookModel({this.result, this.book, this.message});

  BookModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    if (json['Book'] != null) {
      book = <Book>[];
      json['Book'].forEach((v) {
        book!.add(new Book.fromJson(v));
      });
    }
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    if (this.book != null) {
      data['Book'] = this.book!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    return data;
  }
}

class Book {
  int? id;
  String? pdf;
  String? status;
  String? levelName;
  String? subjectName;
  String? chaptersName;

  Book(
      {this.id,
      this.pdf,
      this.status,
      this.levelName,
      this.subjectName,
      this.chaptersName});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pdf = json['pdf'];
    status = json['status'];
    levelName = json['level_name'];
    subjectName = json['subject_name'];
    chaptersName = json['chapters_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pdf'] = this.pdf;
    data['status'] = this.status;
    data['level_name'] = this.levelName;
    data['subject_name'] = this.subjectName;
    data['chapters_name'] = this.chaptersName;
    return data;
  }
}
