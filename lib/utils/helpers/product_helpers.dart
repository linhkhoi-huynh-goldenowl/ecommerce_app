class ProductHelper {
  List getNewsProducts(List products) {
    return products
        .where((element) =>
            (element.createdDate.month == DateTime.now().month &&
                element.createdDate.year == DateTime.now().year))
        .toList();
  }

  List getSaleProducts(List products) {
    return products.where((element) => element.salePercent != null).toList();
  }
}
