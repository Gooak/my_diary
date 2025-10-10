enum MoodEnum {
  happy('images/happy.png', '기쁨', 0, 0, 25, 25),
  happiness('images/happiness.png', '행복', 0, 0, 25, 25),
  tired('images/tired.png', '지친', 0, 0, 25, 25),
  depressed1('images/depressed1.png', '우울', 0, 0, 25, 25),
  tremble('images/tremble.png', '떨떠름', 0, 0, 25, 25),
  angry('images/angry.png', '화남', 0, 0, 25, 25),
  sad('images/sad.png', '슬픔', 0, 0, 25, 25);

  final String path;
  final String koreaName;
  final double left;
  final double bottom;
  final double width;
  final double height;

  const MoodEnum(this.path, this.koreaName, this.left, this.bottom, this.width,
      this.height);

  factory MoodEnum.fromName(String name) {
    return MoodEnum.values.firstWhere(
      (value) => value.name == name,
    );
  }
}
