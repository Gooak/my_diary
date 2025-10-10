enum WeatherEnum {
  sunny('images/sunny.png', '맑음', -3, -2, 35, 35),
  cloud('images/cloud.png', '구름', -11, -3, 35, 35),
  rain('images/rain.png', '먹구름', -11, -3, 35, 35),
  rainning('images/rainning.png', '비', -8, -3, 35, 35),
  snowy('images/snowy.png', '눈', -3, -3, 35, 35);

  final String path;
  final String koreaName;
  final double top;
  final double right;
  final double width;
  final double height;

  const WeatherEnum(
      this.path, this.koreaName, this.top, this.right, this.width, this.height);

  factory WeatherEnum.fromName(String name) {
    return WeatherEnum.values.firstWhere(
      (value) => value.name == name,
    );
  }
}
