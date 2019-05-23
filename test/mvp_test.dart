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
import 'package:flutter_test/flutter_test.dart';

import 'test_objects.dart';

void main() {
  group('Presenter unit tests -', () {
    TestPresenter presenter;
    TestScreenStateMock screenMock = TestScreenStateMock();
    void callback(TestModel model) {}

    setUp(() {
      presenter = TestPresenter();
    });

    test('should initialize viewModel when the presenter is created.', () {
      expect(presenter.viewModel.counter, INIT_COUNTER);
    });

    group('when calling bind()', () {
      setUp(() {
        presenter.bind(callback, screenMock);
      });

      test('should attach callback', () {
        expect(presenter.callback, callback);
      });

      test('should attach screen', () {
        expect(presenter.screen, screenMock);
      });

      test('should apply initial view model', () {
        presenter.callback =
            (TestModel model) => expect(model.counter, INIT_COUNTER);
      });
    });

    group('when calling unbind()', () {
      setUp(() {
        presenter.viewModel = TestModel();
        presenter.callback = callback;
        presenter.screen = screenMock;
        presenter.unbind();
      });

      test('should release callback', () {
        expect(presenter.callback, isNull);
      });

      test('should release view', () {
        expect(presenter.screen, isNull);
      });

      test('should release view model', () {
        expect(presenter.viewModel, isNull);
      });
    });
  });

  group('Screen widget tests -', () {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    var widget;
    TestPresenterMock presenter;

    setUp(() {
      presenter = TestPresenterMock();

      TestScreen screen = TestScreen(presenter: presenter);
      widget = buildTestableWidget(screen);
    });

    testWidgets('when building widget, should initialize view model',
        (WidgetTester tester) async {
      await tester.pumpWidget(widget);
      // Test this checking the counter initial value displayed on the screen.
      var text = find.text("counter: $INIT_COUNTER");
      expect(text, findsOneWidget);
    });
  });
}
