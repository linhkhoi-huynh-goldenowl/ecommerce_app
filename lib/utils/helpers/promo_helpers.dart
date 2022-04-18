class PromoHelpers {
  static int getDaysRemain(DateTime dateCheck) {
    return dateCheck.difference(DateTime.now()).inDays;
  }
}
