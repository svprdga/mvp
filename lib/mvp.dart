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

library mvp;

import 'package:flutter/material.dart';

/// Base MVP screen, all of your screens should inherit from this class.
///
/// Access [viewModel] property to get the current view state.
///
/// Call [applyState] from the presenter object to apply a given state
/// via its [viewModel] parameter.
abstract class MvpScreen<T extends StatefulWidget, V> extends State<T> {

  MvpScreen() {
    initializeViewModel();
  }

  /// Current state of the screen represented as a view model object.
  V viewModel;

  /// Apply a state to the screen via the [viewModel] parameter.
  void applyState(V viewModel) {
    setState(() {
      this.viewModel = viewModel;
    });
  }

  /// First initialization of the [viewModel] to avoid calling a null object.
  ///
  /// This method is called every time this widget is created, it's important
  /// that the [viewModel] is never null; this is also useful in test
  /// environments when you don't have a presenter that builds the [viewModel].
  ///
  /// Use [MvpPresenter.initializeViewModel] to set the desired default
  /// values of the [viewModel].
  void initializeViewModel();
}

/// Base MVP presenter, all of your presenters should inherit from this class.
///
/// Access [viewModel] property to alter the view state.
/// Access [screen] property to call screen methods.
/// Call [callback] to apply the current [viewModel] in the bound view.
///
/// The screen should call [bind] in the [initState] method to perform the
/// binding with this presenter, and call [unbind] in the [dispose] method
/// to release resources.
abstract class MvpPresenter<V, S> {

  V viewModel;
  S screen;
  Function callback;

  MvpPresenter() {
    initializeViewModel();
  }

  /// This method must be called in the [initState] method of the widget
  /// to bind the view to this presenter.
  ///
  /// After the binding, the presenter can use [callback] to apply the input
  /// [viewModel] object.
  /// Also afther this binding, the presenter can call view methods with the
  /// [screen] property.
  ///
  /// This method will also apply the initial set up of the [viewModel].
  void bind(Function callback, S screen) {
    this.callback = callback;
    this.screen = screen;
    // Apply the base view model right after binding.
    this.callback(viewModel);
  }

  /// This method must be called in the [dispose] method of the widget to
  /// destroy the binding.
  ///
  /// After that unbind, the presenter cannot longer apply [viewModel] stats
  /// nor calling [screen] methods.
  void unbind() {
    this.callback = null;
    this.viewModel = null;
    this.screen = null;
  }

  /// First initialization of the [viewModel] to avoid calling a null object.
  ///
  /// This method is called every time this presenter is created, use it
  /// to set the desired initial values.
  void initializeViewModel();
}
