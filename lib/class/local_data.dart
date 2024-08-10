import 'package:flutter/material.dart';
import 'dart:html' as html;

class LocalData{

  loadStoredValue(id) {
      return (html.window.localStorage[id]);
  }

  saveToLocalStorage(id, value) {
    html.window.localStorage[id] = value;
  }

  clearLocalStorage(id) {
    html.window.localStorage.remove(id);
  }
}