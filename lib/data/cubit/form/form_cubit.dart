import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vas_reporting/data/model/body/approval_body.dart';
import 'package:vas_reporting/data/model/body/form_ajuan_body.dart';
import 'package:vas_reporting/data/model/body/form_uji_body.dart';
import 'package:vas_reporting/data/model/body/form_vas_body.dart';
import 'package:vas_reporting/data/model/response/form_response.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import '../../repository/form_repository.dart';
part 'form_state.dart';

class FormCubit extends Cubit<FormHasState> {
  FormCubit() : super(FormInitial());

  final FormRepositories repositories = FormRepositories();
  final _repo = FormRepositories();

  Future<void> form({required String token,required FormAjuanBody formBody}) async {
    try {
      emit(FormLoading());
      final value = await repositories.form(token,formBody);
      
      if (value.isSuccess && value.dataResponse is FormResponse) {
        final res = value.dataResponse as FormResponse;
        emit(FormResponseSuccess(res));
      } else {
        print(value.dataResponse);
        emit(FormFailure(message: value.dataResponse));
      }
    } catch (error) {
      emit(FormFailure(message: error.toString()));
    }
  }

  Future<void> formVas({required String token,required FormVasBody formBody}) async {
    try {
      emit(FormLoading());
      final value = await repositories.formVas(token,formBody);
      
      if (value.isSuccess && value.dataResponse is FormResponse) {
        final res = value.dataResponse as FormResponse;
        emit(FormResponseSuccess(res));
      } else {
        print(value.dataResponse);
        emit(FormFailure(message: value.dataResponse));
      }
    } catch (error) {
      emit(FormFailure(message: error.toString()));
    }
  }

  Future<void> formUji({required String token,required FormUjiBody formBody}) async {
    try {
      emit(FormLoading());
      final value = await repositories.formUji(token,formBody);
      
      if (value.isSuccess && value.dataResponse is FormResponse) {
        final res = value.dataResponse as FormResponse;
        emit(FormResponseSuccess(res));
      } else {
        print(value.dataResponse);
        emit(FormFailure(message: value.dataResponse));
      }
    } catch (error) {
      emit(FormFailure(message: error.toString()));
    }
  }
}