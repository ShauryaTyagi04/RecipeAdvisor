import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_advisor_app/api/auth_api_service.dart';
import 'package:recipe_advisor_app/api/recipe_api_service.dart';
import 'package:recipe_advisor_app/models/recipe_model.dart';
import 'package:recipe_advisor_app/providers/liked_recipes_provider.dart';
import 'package:recipe_advisor_app/widgets/cookbook_container.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen>
    with SingleTickerProviderStateMixin {
  late final RecipeApiService _recipeApiService;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _recipeApiService = RecipeApiService(AuthApiService());
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        Provider.of<LikedRecipesProvider>(context, listen: false)
            .fetchAllCookbookData();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LikedRecipesProvider>(context, listen: false)
          .fetchAllCookbookData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleReorder(int oldIndex, int newIndex, List<Recipe> recipes,
      {required bool isUserCreations}) async {
    final List<Recipe> reorderedList = List.of(recipes);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Recipe item = reorderedList.removeAt(oldIndex);
    reorderedList.insert(newIndex, item);

    final orderedIds = reorderedList.map((recipe) => recipe.id!).toList();
    try {
      if (isUserCreations) {
        await _recipeApiService.updateCreatedRecipesOrder(orderedIds);
      } else {
        await _recipeApiService.updateLikedRecipesOrder(orderedIds);
      }

      if (mounted) {
        Provider.of<LikedRecipesProvider>(context, listen: false)
            .fetchAllCookbookData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Could not save new order. $e')),
        );
        Provider.of<LikedRecipesProvider>(context, listen: false)
            .fetchAllCookbookData();
      }
    }
  }

  Widget _buildRecipeList(List<Recipe> recipes,
      {required bool showLikeButton, required ReorderCallback onReorder}) {
    if (recipes.isEmpty) {
      return Center(
        child: Text(
          showLikeButton
              ? 'You have not liked any AI recipes yet.'
              : 'You have not created any recipes yet.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return CookbookContainer(
          key: ValueKey(recipe.id!),
          index: index,
          recipe: recipe,
          onTap: () {
            Navigator.of(context)
                .pushNamed('/RecipeOutputScreen', arguments: recipe);
          },
        );
      },
      onReorder: onReorder,
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4CC),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: child,
          ),
        );
      },
      clipBehavior: Clip.hardEdge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey.shade700,
        indicatorColor: const Color(0xFFFF7700),
        indicatorWeight: 3.0,
        tabs: const [
          Tab(text: 'My Creations'),
          Tab(text: 'AI Cookbook'),
        ],
      ),
      body: Consumer<LikedRecipesProvider>(
        builder: (context, likedProvider, child) {
          final userCreatedRecipes = likedProvider.createdRecipes;
          final likedAiRecipes = likedProvider
              .getLikedRecipes()
              .where((recipe) => recipe.source == 'AI_GENERATED')
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRecipeList(
                userCreatedRecipes,
                showLikeButton: false,
                onReorder: (oldIndex, newIndex) => _handleReorder(
                    oldIndex, newIndex, userCreatedRecipes,
                    isUserCreations: true),
              ),
              _buildRecipeList(
                likedAiRecipes,
                showLikeButton: true,
                onReorder: (oldIndex, newIndex) => _handleReorder(
                    oldIndex, newIndex, likedAiRecipes,
                    isUserCreations: false),
              ),
            ],
          );
        },
      ),
    );
  }
}
