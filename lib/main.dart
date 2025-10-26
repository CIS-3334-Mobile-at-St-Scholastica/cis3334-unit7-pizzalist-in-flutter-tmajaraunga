import 'package:flutter/material.dart';
import 'package:unit7_pizzalist/pizza.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: "Tom's Pizza Place"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

// Declare the list here so it is part of the widget's mutable state
  // and is accessible by the build() and _addPizza() methods.
  List<Pizza> pizzasInOrder = []; // Starts as an empty list

  @override
  void initState() {
    super.initState();
    // Optional: Add a starter pizza for immediate viewing
    pizzasInOrder.add(Pizza("Cheese", 1));
    pizzasInOrder.add(Pizza("Sausage", 2));

  }

  void _addPizza() {
    // TODO: display add pizza Dialog window
    print("addPizza called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // 1. Set the itemCount to the size of the list
          itemCount: pizzasInOrder.length,

          // 2. Set the itemBuilder to define how each pizza looks
          itemBuilder: (BuildContext context, int position) {
            final currentPizza = pizzasInOrder[position];

            // 3. Return a widget to display the pizza (using Card and ListTile)
            return Card(
              elevation: 2.0, // A little shadow
              margin: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                leading: const Icon(Icons.local_pizza, color: Colors.deepOrange),
                // Displays the calculated description
                title: Text(currentPizza.description),
                // Use the getter method for clean price display (Bonus ready!)
                subtitle: Text("Price: ${currentPizza.getPrice()}"),
                // Optional: Show the size index on the right
                trailing: Text(PIZZA_SIZES[currentPizza.size]),
              ),
            );
          }
      ),
      // Floating Action Button will be added in the next step (Step 4)
      floatingActionButton: FloatingActionButton(
        onPressed: _addPizzaSimpler, // Placeholder for the method we define later
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addPizzaSimpler() {
    final TextEditingController toppingsController = TextEditingController();
    int tempSizeIndex = 0; // Local variable to hold the size index

    showDialog<void>(
      context: context,
      // The inner content is self-contained and manages the Slider's state
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Build Your Pizza'),
          content: StatefulBuilder( // Use StatefulBuilder to manage the Slider's state
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: toppingsController,
                    decoration: const InputDecoration(labelText: 'Toppings'),
                  ),
                  const SizedBox(height: 20),
                  Text('Size: ${PIZZA_SIZES[tempSizeIndex]}'),

                  // Use a Slider for simple index selection
                  Slider(
                    value: tempSizeIndex.toDouble(),
                    min: 0,
                    max: (PIZZA_SIZES.length - 1).toDouble(),
                    divisions: PIZZA_SIZES.length - 1,
                    onChanged: (double newValue) {
                      setState(() { // This rebuilds only the AlertDialog's content
                        tempSizeIndex = newValue.round();
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Same logic as before, using the local variables
                final newPizza = Pizza(toppingsController.text.trim(), tempSizeIndex);

                // Update the main app state
                this.setState(() {
                  pizzasInOrder.add(newPizza);
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}