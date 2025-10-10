class SearchText {
  static String ch2pattern(String ch) {
    const int offset = 44032; // '가'의 유니코드 값

    // 한국어 음절
    if (RegExp(r'[가-힣]').hasMatch(ch)) {
      int chCode = ch.codeUnitAt(0) - offset;
      // 종성이 있으면 문자 그대로를 반환
      if (chCode % 28 > 0) {
        return ch;
      }
      int begin = (chCode ~/ 28) * 28 + offset;
      int end = begin + 27;
      return '[\\u${begin.toRadixString(16)}-\\u${end.toRadixString(16)}]';
    }

    // 한글 자음
    if (RegExp(r'[ㄱ-ㅎ]').hasMatch(ch)) {
      Map<String, int> con2syl = {
        'ㄱ': '가'.codeUnitAt(0),
        'ㄲ': '까'.codeUnitAt(0),
        'ㄴ': '나'.codeUnitAt(0),
        'ㄷ': '다'.codeUnitAt(0),
        'ㄸ': '따'.codeUnitAt(0),
        'ㄹ': '라'.codeUnitAt(0),
        'ㅁ': '마'.codeUnitAt(0),
        'ㅂ': '바'.codeUnitAt(0),
        'ㅃ': '빠'.codeUnitAt(0),
        'ㅅ': '사'.codeUnitAt(0),
      };

      int base = con2syl[ch] ??
          ((ch.codeUnitAt(0) - 12613) * 588 + con2syl['ㅅ']!); // 'ㅅ' 코드 보정
      int begin = base;
      int end = begin + 587;
      return '[$ch\\u${begin.toRadixString(16)}-\\u${end.toRadixString(16)}]';
    }

    // 그 외엔 그대로 반환
    return ch;
  }

  //실제로 검색 기능에 쓰이는 정규식 함수
  static RegExp matcher(String input) {
    String pattern = input.split('').map(ch2pattern).join('.*?');
    return RegExp(pattern);
  }
}
