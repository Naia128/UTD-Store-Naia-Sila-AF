import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../product/presentation/cubit/product_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(title: const Text("UTD Store - Katalog")),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final p = state.products[index];
                  return ListTile(
                    leading: Image.network(p.image, width: 50),
                    title: Text(p.title), // Sudah otomatis ada [Diskon 10%]
                    subtitle: Text("\$${p.price}"),
                  );
                },
              );
            } else {
              return const Center(child: Text("Terjadi kesalahan"));
            }
          },
        ),
      ),
    );
  }
}