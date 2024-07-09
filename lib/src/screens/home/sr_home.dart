import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/src/screens/home/ctrl_home.dart';
import 'package:task/src/widgets/category_tab_bar.dart';
import 'package:task/src/widgets/product_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'ESPTILES',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isCategoryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return DefaultTabController(
            length: c.categories.length,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child:
                      CategoryTabBar(categories: c.categories, controller: c),
                ),
                Expanded(
                  child: Obx(() {
                    if (c.isSubcategoryLoading.value &&
                        c.pageIndex.value == 1) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        controller: c.scrollController,
                        itemCount: c.subcategories.length +
                            (c.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == c.subcategories.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            var subcategory = c.subcategories[index];
                            return ProductList(subcategory: subcategory);
                          }
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
