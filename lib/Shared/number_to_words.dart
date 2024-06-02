String numberToWords(int number) {
  if (number == 0) return 'nol';

  final units = ['', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan'];
  final teens = ['sepuluh', 'sebelas', 'dua belas', 'tiga belas', 'empat belas', 'lima belas', 'enam belas', 'tujuh belas', 'delapan belas', 'sembilan belas'];
  final tens = ['', '', 'dua puluh', 'tiga puluh', 'empat puluh', 'lima puluh', 'enam puluh', 'tujuh puluh', 'delapan puluh', 'sembilan puluh'];
  final thousands = ['', 'ribu', 'juta', 'miliar', 'triliun'];


  String convertTens(int number) {
    if (number == 10) return 'sepuluh';
    if (number < 10) return units[number];
    if (number < 20) return teens[number - 10];
    return '${tens[number ~/ 10]} ${units[number % 10]}'.trim();
  }

  String convertHundreds(int number) {
    if (number == 100) return 'seratus';
    if (number > 99) {
      return '${units[number ~/ 100]} ratus ${convertTens(number % 100)}'.trim();
    } else {
      return convertTens(number);
    }
  }

  String convert(int number) {
    if (number == 0) return '';

    int thousandIndex = 0;
    String words = '';

    while (number > 0) {
      if (number % 1000 != 0) {
        words = '${convertHundreds(number % 1000)} ${thousands[thousandIndex]} $words'.trim();
      }
      number ~/= 1000;
      thousandIndex++;
    }

    return words.trim();
  }

  return convert(number);
}
