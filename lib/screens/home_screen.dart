import 'package:flutter/material.dart';
import '../api/recipe_api_service.dart';
import '../models/recipe_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final RecipeApiService _apiService = RecipeApiService();

  Recipe? _recipe;
  String? _errorMessage;
  bool _isLoading = false;

  void _getRecipe() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _recipe = null;
      _errorMessage = null;
    });

    try {
      final recipe = await _apiService.queryAgent(_controller.text);
      setState(() {
        _recipe = recipe;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Advisor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter ingredients or a recipe name...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _getRecipe(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getRecipe,
              child: const Text('Get Recipe'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildResultView(),
            ),
          ],
        ),
      ),
    );
  }

  // A helper widget to display the results
  Widget _buildResultView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
          child:
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)));
    }
    if (_recipe != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_recipe!.name,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(_recipe!.description),
            const SizedBox(height: 16),
            Text('Category: ${_recipe!.category}'),
            Text('Cook Time: ${_recipe!.cookTime}'),
            Text('Calories: ${_recipe!.calories.toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
            ..._recipe!.ingredients.map((item) => Text('- $item')),
            const SizedBox(height: 16),
            Text('Instructions', style: Theme.of(context).textTheme.titleLarge),
            ..._recipe!.instructions.asMap().entries.map((entry) {
              return Text('${entry.key + 1}. ${entry.value}');
            }),
          ],
        ),
      );
    }
    return const Center(child: Text('Enter a query above to get started.'));
  }
}
