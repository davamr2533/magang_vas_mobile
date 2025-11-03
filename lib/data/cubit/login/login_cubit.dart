import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vas_reporting/data/model/body/login_body.dart';
import 'package:vas_reporting/data/model/response/login_response.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import '../../repository/login_repository.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final LoginRepositories repositories = LoginRepositories();
  final _repo = LoginRepositories();

 Future<void> login({required LoginBody loginBody}) async {
  try {
    emit(LoginLoading());
    final value = await repositories.login(loginBody);
    
    if (value.isSuccess && value.dataResponse is LoginResponse) {
      final res = value.dataResponse as LoginResponse;
      print(res.customer);
      await SharedPref.setToken('${res.token}');
      await SharedPref.setName('${res.customer?.nama}');
      await SharedPref.setUsername('${res.customer?.username}');
      await SharedPref.setGender('${res.customer?.jeniskelamin}');
      await SharedPref.setDivisi('${res.customer?.divisi}');
      await SharedPref.setPosition('${res.customer?.jabatan}');
      print(res.customer?.nama);
      emit(LoginSuccess(res));
    } else {
       print(value.dataResponse);
      emit(LoginFailure(message: value.dataResponse));
    }
  } catch (error) {
    emit(LoginFailure(message: error.toString()));
  }
}
}