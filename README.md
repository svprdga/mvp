# mvp

Flutter package to build applications using Model View Presenter (MVP) architecture.

## What's MVP?

MVP stands for Model View Presenter.

It is a well known architecture, widely used in app development.
The way it work is as follows:
- We have objects that represents our data (the model).
- We have views which renders the UI components and gathers user input (the view).
- And finally we have components that receives user input and decide what we do with it, updates the model and then tell the view how the render again (the presenter). 

## MVP advantages

- UI operations separated from the application logic.
- Easier to test (in the case of Flutter, unit tests for the presenter, widget tests for the view).

## Usage of this library

Let's say we have our loved counter sample:

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}
```
In this simple app our model is the actual counter value, let's extract the counter var into a dedicated model class:

```dart
class MainModel {
  MainModel({this.counter = 0});
  
  int counter;
} 
```

We need a presenter that will receive the user input (click on the increment counter button), compute the new counter value, and then apply this to the view:

```dart
class MainPresenter extends MvpPresenter<MainModel, MainScreenState> {

  @override
  void initializeViewModel() {
    viewModel = MainModel();
  }

  void incrementButtonClick() {
    viewModel.counter++;
    callback(viewModel);
  }

}
```

Finally, we release the view from the task of computing the new counter value, only receive user input and render the current view model:

```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(title: 'MVP Demo'),
    );
  }
}

class MainScreen extends StatefulWidget {
  final presenter = MainPresenter();

  MainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends MvpScreen<MainScreen, MainModel> {

  @override
  void initializeViewModel() {
    viewModel = MainModel();
  }

  @override
  void initState() {
    super.initState();
    // Always remember to bind the presenter in initState().
    widget.presenter.bind(applyState, this);
  }

  @override
  void dispose() {
    super.dispose();
    // And remember to release presenter binding in dispose().
    widget.presenter.unbind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "${viewModel.counter}",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.presenter.incrementButtonClick();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

 


