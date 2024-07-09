import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:task/core/model/product_model.dart';
import 'package:task/src/widgets/custom_snackbar.dart';

class HomeController extends GetxController {
  var isCategoryLoading = true.obs;
  var isSubcategoryLoading = true.obs;
  var isLoadingMore = false.obs;
  var categories = List<CategoryModel>.empty().obs;
  var subcategories = List<SubCategoryModel>.empty().obs;
  var pageIndex = 1.obs;
  var selectedCategoryId = 0.obs;

  var isLoadingMoreProducts = false.obs;
  var products = List<ProductModel>.empty().obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    fetchCategories();
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      loadMoreSubcategories();
    }
  }

  void fetchCategories() async {
    try {
      isCategoryLoading(true);
      var response = await http.post(
        Uri.parse('http://esptiles.imperoserver.in/api/API/Product/DashBoard'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({}),
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        categories.value = List<CategoryModel>.from(jsonData['Result']
                ['Category']
            .map((category) => CategoryModel.fromJson(category)));
        // Fetch subcategories for the first category by default
        if (categories.isNotEmpty) {
          selectedCategoryId.value = categories[0].id;
          await fetchSubcategories(selectedCategoryId.value, 1);
        }
      } else {
        CustomSnackbar.showError('Error', 'Failed to load categories');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    } finally {
      isCategoryLoading(false);
    }
  }

  Future<void> fetchSubcategories(int categoryId, int pageIndex) async {
    try {
      isSubcategoryLoading(true);
      var response = await http.post(
        Uri.parse('http://esptiles.imperoserver.in/api/API/Product/DashBoard'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "CategoryId": categoryId,
          "PageIndex": pageIndex,
        }),
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (pageIndex == 1) {
          subcategories.value = List<SubCategoryModel>.from(jsonData['Result']
                  ['Category']
              .firstWhere(
                  (category) => category['Id'] == categoryId)['SubCategories']
              .map((subcategory) => SubCategoryModel.fromJson(subcategory)));
        } else {
          subcategories.addAll(List<SubCategoryModel>.from(jsonData['Result']
                  ['Category']
              .firstWhere(
                  (category) => category['Id'] == categoryId)['SubCategories']
              .map((subcategory) => SubCategoryModel.fromJson(subcategory))));
        }
      } else {
        CustomSnackbar.showError('Error', 'Failed to load subcategories');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    } finally {
      isSubcategoryLoading(false);
    }
  }

  Future<void> fetchProducts(int subCategoryId, int pageIndex) async {
    try {
      isLoadingMoreProducts(true);
      var response = await http.post(
        Uri.parse(
            'http://esptiles.imperoserver.in/api/API/Product/ProductList'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "SubCategoryId": subCategoryId,
          "PageIndex": pageIndex,
        }),
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (pageIndex == 1) {
          products.value = List<ProductModel>.from(jsonData['Result']['Product']
              .map((product) => ProductModel.fromJson(product)));
        } else {
          products.addAll(List<ProductModel>.from(jsonData['Result']['Product']
              .map((product) => ProductModel.fromJson(product))));
        }
      } else {
        CustomSnackbar.showError('Error', 'Failed to load products');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    } finally {
      isLoadingMoreProducts(false);
    }
  }

  void loadMoreSubcategories() async {
    if (!isLoadingMore.value && !isSubcategoryLoading.value) {
      isLoadingMore(true);
      pageIndex.value++;
      await fetchSubcategories(selectedCategoryId.value, pageIndex.value);
      isLoadingMore(false);
    }
  }
}
