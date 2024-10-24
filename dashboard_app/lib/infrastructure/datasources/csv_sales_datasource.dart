import 'package:csv/csv.dart';
import 'package:dashboard_app/domain/datasources/sales_datasource.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/infrastructure/mappers/csv_sale_mapper.dart';
import 'package:dashboard_app/infrastructure/models/csv/csv_sale.dart';
import 'package:flutter/services.dart';

class CSVSalesDatasource extends SalesDatasource {
  final String csvPath = 'data/sales/retail_sales_dataset.csv';
  final Sale emptySale = Sale(
    transactionID: 0,
    date: DateTime.now(),
    customer: '',
    productCategory: '',
    quantity: 0,
    unitaryPrice: 0,
    total: 0
  );

  @override
  Future<List<Sale>> getDailySales(List<dynamic> salesFilters) async {
    final rawData = await rootBundle.loadString(csvPath);
    List<Sale> sales = _getSales(rawData);
    List<Sale> finalSales = [];
    
    sales = _orderSalesByDate(sales);

    for (int iteration = 0; iteration < sales.length; iteration++) {
      if ((sales[iteration].date).isAfter(
        salesFilters.isNotEmpty
        ? DateTime.parse(salesFilters[0])
        : sales.last.date.subtract(const Duration(days: 1)))
      ) {
        finalSales.add(sales[iteration]);
      }
    }
    
    return finalSales.isNotEmpty ? finalSales : [emptySale];
  }
  
  @override
  Future<List<Sale>> getWeeklySales(List<dynamic> salesFilters) async {
    final rawData = await rootBundle.loadString(csvPath);
    List<Sale> sales = _getSales(rawData);
    List<Sale> finalSales = [];
    
    sales = _orderSalesByDate(sales);
    
    for (int iteration = 0; iteration < sales.length; iteration++) {
      if ((sales[iteration].date).isAfter(
        salesFilters.isNotEmpty
        ? DateTime.parse(salesFilters[0]).subtract(const Duration(days: 1))
        : sales.last.date.subtract(const Duration(days: 7))
      ) && sales[iteration].date.isBefore(
        salesFilters.isNotEmpty
        ? DateTime.parse(salesFilters[0]).add(const Duration(days: 7))
        : sales.last.date.add(const Duration(days: 1))
      )) {
        finalSales.add(sales[iteration]);
      }
    }
    
    return finalSales.isNotEmpty ? finalSales : [emptySale];
  }

  @override
  Future<List<Sale>> getMonthlySales(List<dynamic> salesFilters) async {
    final rawData = await rootBundle.loadString(csvPath);
    List<Sale> sales = _getSales(rawData);
    List<Sale> finalSales = [];
    
    sales = _orderSalesByDate(sales);

    for (int iteration = 0; iteration < sales.length; iteration++) {
      if ((sales[iteration].date).isAfter(
        salesFilters.isNotEmpty
        ? DateTime.parse(salesFilters[0]).subtract(const Duration(days: 1))
        : sales.last.date.subtract(const Duration(days: 28)))
      && sales[iteration].date.isBefore(
        salesFilters.isNotEmpty
        ? DateTime.parse(salesFilters[1]).add(const Duration(days: 1))
        : sales.last.date.add(const Duration(days: 28))
      )) {
        finalSales.add(sales[iteration]);
      }
    }
    
    return finalSales.isNotEmpty ? finalSales : [emptySale];
  }

  @override
  Future<List<Sale>> getTopSellingProducts(List<dynamic> salesFilters) async {
    final rawData = await rootBundle.loadString(csvPath);
    List<Sale> sales = _getSales(rawData);
    
    return sales;
  }

  @override
  Future<List<Sale>> getTopBuyingCustomers(List<dynamic> salesFilters) async {
    final rawData = await rootBundle.loadString(csvPath);
    List<Sale> sales = _getSales(rawData);
    List<Sale> finalSales = [];
    finalSales = _getTopCustomers(sales);

    return finalSales;
  }

  List<Sale> _getSales(String data) {
    List<List<dynamic>> csvData = const CsvToListConverter().convert(data);
    List<Sale> sales = [];
    
    for (int iteration = 1; iteration < csvData.length; iteration++) {
      var csvSale = CSVSale.fromCSV(csvData[iteration]);
      
      sales.add(SaleMapper.csvSaletoEntity(csvSale));
    }

    return sales;
  }

  List<Sale> _orderSalesByDate(List<Sale> sales) {
    sales.sort((a, b) => (a.date).compareTo((b.date)));

    return sales;
  }

  List<Sale> _getTopCustomers(List<Sale> data) {
    List<Sale> provisionalData = List.from(data);
    List<Map<String, dynamic>> repeatedElements = [];
    int cicle = 0;
    List<Sale> topCustomers = [];

    while (cicle < provisionalData.length) {
      Sale element = provisionalData[cicle];
      int ocurrence = 1;

      for (int repetition = 0; repetition < provisionalData.length; repetition++) {
        if (repetition == cicle) {
          continue;
        }
        else if (element.customer == provisionalData[repetition].customer) {
          ocurrence++;
        }
      }
      
      provisionalData.removeWhere((sale) => sale.customer == element.customer);
      repeatedElements.add({element.customer : ocurrence});
    }
    
    repeatedElements.sort((b, a) => (a[a.keys.toList()[0]]).compareTo(b[b.keys.toList()[0]]));
    
    for(int iteration = 0; iteration < 5; iteration++) {
      for(var sale in data.where((element) => element.customer == repeatedElements[iteration].keys.toList()[0])) {
        topCustomers.add(sale);
      }
    }
    
    return topCustomers;
  }
}