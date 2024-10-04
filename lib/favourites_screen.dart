import 'package:flutter/material.dart';
import 'package:food_recipe/recipes_model.dart';
import 'package:food_recipe/detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoritesScreen({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Recipes"),
        backgroundColor: Colors.orange,
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(
              child: Text(
                "No favorites added.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return ListTile(
                  leading: Image.network(
                    recipe.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(recipe.name),
                  subtitle: Text("${recipe.cookTimeMinutes} min"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
