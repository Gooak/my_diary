class MyPageDataModel {
  int day;
  int diaryCount;
  int calendarCount;
  int todoCount;
  int activeTodoCount;
  MyPageDataModel(
    this.day,
    this.diaryCount,
    this.calendarCount,
    this.todoCount,
    this.activeTodoCount,
  );

  factory MyPageDataModel.createEmtpy() {
    return MyPageDataModel(0, 0, 0, 0, 0);
  }
}
