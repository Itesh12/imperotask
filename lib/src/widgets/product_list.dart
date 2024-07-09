import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/core/model/product_model.dart';

class ProductList extends StatelessWidget {
  final SubCategoryModel subcategory;

  const ProductList({super.key, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            subcategory.name,
            style: context.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120, // Height of the product list container
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subcategory.products.length,
            itemBuilder: (context, productIndex) {
              var product = subcategory.products[productIndex];
              return Container(
                width: 120, // Width of each product card
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      product.imageName,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall!.copyWith(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
