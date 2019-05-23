// Copyright 2019 David Serrano Canales
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:mvp/mvp.dart';
import 'package:mockito/mockito.dart';

const INIT_COUNTER = 16;

class TestModel {
  TestModel({this.counter = 0});

  int counter;
}

class TestPresenter extends MvpPresenter<TestModel, TestScreenState> {
  @override
  void initializeViewModel() {
    // Initialize the counter for the first time to test that it is created
    // with this setup.
    viewModel = TestModel()..counter = INIT_COUNTER;
  }
}

class TestScreen extends StatefulWidget {
  final TestPresenter presenter;

  TestScreen({Key key, this.presenter}) : super(key: key);

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends MvpScreen<TestScreen, TestModel> {
  @override
  void initializeViewModel() {
    viewModel = TestModel()..counter = INIT_COUNTER;
  }

  @override
  void initState() {
    super.initState();
    widget.presenter.bind(applyState, this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('counter: ${viewModel.counter}'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.presenter.unbind();
  }
}

class TestPresenterMock extends Mock implements TestPresenter {}

class TestScreenStateMock extends Mock implements TestScreenState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}
