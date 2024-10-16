import 'package:csv/csv.dart';
import 'package:dashboard_app/domain/datasources/sales_datasource.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/infrastructure/mappers/csv_sale_mapper.dart';
import 'package:dashboard_app/infrastructure/models/csv/csv_sale.dart';
import 'package:flutter/services.dart';

class CSVSalesDatasource extends SalesDatasource {
  final String csvPath = 'data/sales/retail_sales_dataset.csv';

  @override
  Future<List<Sale>> getDailySales() async {
    final rawData = await rootBundle.loadString(csvPath);
    List<List<dynamic>> csvData = const CsvToListConverter().convert(rawData);
    List<Sale> sales = [];
    
    for(int iteration = 1; iteration < csvData.length; iteration++) {
      var csvSale = CSVSale.fromCSV(csvData[iteration]);
      
      sales.add(SaleMapper.csvSaletoEntity(csvSale));
    }
    
    return sales;
  }
  
  @override
  Future<List<Sale>> getWeeklySales() async {
    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvPath);
    List<Sale> sales = [];

    for(int iteration = 0; iteration < csvData.length;) {

    }
    
    return sales;
  }

  @override
  Future<List<Sale>> getMonthlySales() async {
    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvPath);
    List<Sale> sales = [];

    for(int iteration = 0; iteration < csvData.length;) {

    }
    
    return sales;
  }

  @override
  Future<List<Sale>> getTopSellingProducts() async {
    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvPath);
    List<Sale> sales = [];

    for(int iteration = 0; iteration < csvData.length;) {

    }
    
    return sales;
  }

  @override
  Future<List<Sale>> getTopBuyingCustomers() async {
    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvPath);
    List<Sale> sales = [];

    for(int iteration = 0; iteration < csvData.length;) {

    }
    
    return sales;
  }
}