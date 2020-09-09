// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppBarStore on _AppBarStore, Store {
  final _$titleAtom = Atom(name: '_AppBarStore.title');

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$showAtom = Atom(name: '_AppBarStore.show');

  @override
  bool get show {
    _$showAtom.reportRead();
    return super.show;
  }

  @override
  set show(bool value) {
    _$showAtom.reportWrite(value, super.show, () {
      super.show = value;
    });
  }

  final _$shareUrlAtom = Atom(name: '_AppBarStore.shareUrl');

  @override
  String get shareUrl {
    _$shareUrlAtom.reportRead();
    return super.shareUrl;
  }

  @override
  set shareUrl(String value) {
    _$shareUrlAtom.reportWrite(value, super.shareUrl, () {
      super.shareUrl = value;
    });
  }

  final _$_AppBarStoreActionController = ActionController(name: '_AppBarStore');

  @override
  dynamic setAppBar({String title, bool show, String shareUrl}) {
    final _$actionInfo = _$_AppBarStoreActionController.startAction(
        name: '_AppBarStore.setAppBar');
    try {
      return super.setAppBar(title: title, show: show, shareUrl: shareUrl);
    } finally {
      _$_AppBarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
show: ${show},
shareUrl: ${shareUrl}
    ''';
  }
}
