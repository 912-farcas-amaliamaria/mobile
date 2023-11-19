enum Category{
  FOOD,
  OTHER,
  HOUSEHOLD,
  TRIP,
}

extension CategoryExtension on Category {
  static Category fromString(String str) {
    switch (str) {
      case 'FOOD':
        return Category.FOOD;
      case 'OTHER':
        return Category.OTHER;
      case 'HOUSEHOLD':
        return Category.HOUSEHOLD;
      case 'TRIP':
        return Category.TRIP;
      default:
        throw Exception('Unknown category: $str');
    }
  }

  String toShortString() {
    return this.toString().split('.').last;
  }
}