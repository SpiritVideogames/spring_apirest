// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:spring_apirest/services/services.dart';
import 'package:spring_apirest/models/models.dart';

class GetProductsOfCompanyServices extends ChangeNotifier {
  //Cambiar la IP por la conexión que tenga cada uno
  final String _baseUrl = '192.168.164.68:8080';
  List<Product> products = [];

  GetProductsOfCompanyServices();

  getGetProducts(int id) async {
    products.clear();
    String? token = await LoginServices().readToken();
    var response = await Requests.get(
        "http://$_baseUrl/api/user/categories/$id/products",
        headers: {'Authorization': 'Bearer $token'});

    int idProduct = 0;
    String name = "";
    String description = "";
    double price = 0;

    var resp;
    if (response.body.isNotEmpty) {
      final List<dynamic> getProducts = json.decode(response.body);
      for (int i = 0; i < getProducts.length; i++) {
        if (getProducts[i].containsKey("id")) {
          getProducts[i].forEach((key, value) {
            if (key == "id") {
              idProduct = value;
            } else if (key == "name") {
              name = value;
            } else if (key == "description") {
              description = value;
            } else if (key == "price") {
              price = value;
              products.add(Product(
                  id: idProduct,
                  name: name,
                  description: description,
                  price: price));
            }
          });
        } else {
          String? error = '';

          error = 'ERROR TO GET ATTRIBUTES. CHECK ID';

          resp = error;
        }
      }

      resp = products;
      return resp;
    }
  }
}
