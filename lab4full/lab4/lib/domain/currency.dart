enum Currency{
  RON,
  USD,
  EUR
}

extension CurrencyExtension on Currency {
  static Currency fromString(String str) {
    switch (str) {
      case 'RON':
        return Currency.RON;
      case 'USD':
        return Currency.USD;
      case 'EUR':
        return Currency.EUR;
      default:
        throw Exception('Unknown currency: $str');
    }
  }

  String toShortString() {
    return this.toString().split('.').last;
  }
}