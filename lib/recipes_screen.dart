import 'package:flutter/material.dart';
import 'package:food_recipe/detail_screen.dart';
import 'package:food_recipe/recipes_model.dart';
import 'package:food_recipe/services.dart';
import 'favourites_screen.dart';
import 'package:share_plus/share_plus.dart';

class RecipesHomeScreen extends StatefulWidget {
  const RecipesHomeScreen({super.key});

  @override
  State<RecipesHomeScreen> createState() => _RecipesHomeScreenState();
}

class _RecipesHomeScreenState extends State<RecipesHomeScreen> {
  List<Recipe> recipesModel = [];
  List<Recipe> filteredRecipes = [];
  List<Recipe> favoriteRecipes = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  myRecipes() {
    isLoading = true;
    recipesItems().then((value) {
      setState(() {
        recipesModel = value;
        filteredRecipes = recipesModel; // Initially, all recipes are shown
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    myRecipes();
    super.initState();
  }

  void toggleFavorite(Recipe recipe) {
    setState(() {
      if (favoriteRecipes.contains(recipe)) {
        favoriteRecipes.remove(recipe);
      } else {
        favoriteRecipes.add(recipe);
      }
    });
  }

  void filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecipes = recipesModel; // Show all if search is empty
      } else {
        filteredRecipes = recipesModel
            .where((recipe) =>
                recipe.name.toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter by recipe name
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search Recipes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: filterRecipes, // Call filter function on input change
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                "Recipes App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(
                      favoriteRecipes: favoriteRecipes,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share App"),
              onTap: () {
                // Share app link or message
                Share.share(
                  'Check out this amazing Recipes App: https://yourappurl.com',
                  subject: 'Recipes App',
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                final isFavorite = favoriteRecipes.contains(recipe);
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: NetworkImage(recipe.image),
                              fit: BoxFit.fill,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(-5, 7),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              toggleFavorite(recipe); // Toggle favorite
                            },
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                ),
                                Text(
                                  recipe.rating.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  recipe.cookTimeMinutes.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  " min",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
