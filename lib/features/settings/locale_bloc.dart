import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleBloc extends Cubit<Locale> {
  LocaleBloc() : super(const Locale('en'));

  void changeLocale(Locale newLocale) {
    emit(newLocale);
  }
}
