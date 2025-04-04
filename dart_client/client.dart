import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const baseUrl = 'http://localhost:3000';

Future<void> getProducts() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final products = jsonDecode(response.body) as List;
      print('\n=== Liste des produits ===');
      if (products.isEmpty) {
        print('Aucun produit disponible');
      } else {
        for (var product in products) {
          print(
            'ID: ${product['id'] ?? 'N/A'}, '
            'Nom: ${product['name']}, '
            'Prix: ${product['price']}',
          );
        }
      }
    } else {
      print('Erreur ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Erreur lors de la récupération des produits: $e');
  }
}

Future<void> addProduct(String name, double price) async {
  try {
    final newProduct = {'name': name, 'price': price};
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newProduct),
    );

    if (response.statusCode == 201) {
      print('Produit ajouté avec succès: ${response.body}');
    } else {
      print('Erreur ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Erreur lors de l\'ajout du produit: $e');
  }
}

Future<void> getOrders() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/orders'));

    if (response.statusCode == 200) {
      final orders = jsonDecode(response.body) as List;
      print('\n=== Liste des commandes ===');
      if (orders.isEmpty) {
        print('Aucune commande disponible');
      } else {
        for (var order in orders) {
          print(
            'Produit: ${order['product']}, '
            'Quantité: ${order['quantity']}, '
            'Date: ${order['date'] ?? 'N/A'}',
          );
        }
      }
    } else {
      print('Erreur ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Erreur lors de la récupération des commandes: $e');
  }
}

Future<void> addOrder(String product, int quantity) async {
  try {
    final newOrder = {
      'product': product,
      'quantity': quantity,
      'date': DateTime.now().toIso8601String(),
    };
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newOrder),
    );

    if (response.statusCode == 201) {
      print('Commande créée avec succès: ${response.body}');
    } else {
      print('Erreur ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Erreur lors de la création de la commande: $e');
  }
}

void main() async {
  print('=== Client Dart pour l\'API de gestion ===');

  // Test des fonctionnalités
  await getProducts();
  await addProduct('Ordinateur portable', 999.99);
  await addProduct('Souris sans fil', 29.99);
  await getProducts();

  await getOrders();
  await addOrder('Ordinateur portable', 1);
  await addOrder('Souris sans fil', 2);
  await getOrders();

  print('\n=== Fin des tests ===');
}
