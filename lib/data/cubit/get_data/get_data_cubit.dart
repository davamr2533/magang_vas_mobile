import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vas_reporting/data/model/body/approval_body.dart';
import 'package:vas_reporting/data/model/body/get_data_vas_body.dart';
import 'package:vas_reporting/data/model/response/form_response.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart';
import 'package:vas_reporting/data/model/response/get_data_uji_response.dart';
import 'package:vas_reporting/data/model/response/get_data_vas_response.dart';
import 'package:vas_reporting/data/repository/get_data_repository.dart';
import 'package:vas_reporting/utllis/app_shared_prefs.dart';
part 'get_data_state.dart';

class GetDataCubit extends Cubit<GetDataHasState> {
  GetDataCubit() : super(GetDataInitial());

  final GetDataRepositories repositories = GetDataRepositories();
  final _repo = GetDataRepositories();

 Future<void> getAllData ({required String token}) async {
  try {
    emit(GetDataLoading());
    final value = await repositories.getAllDataa(token);
    
    if (value.isSuccess && value.dataResponse is GetDataResponse) {
      final res = value.dataResponse as GetDataResponse;
      emit(GetDataSuccess(res));
    } else {
       print(value.dataResponse);
      emit(GetDataFailure(message: value.dataResponse));
    }
  } catch (error) {
    emit(GetDataFailure(message: error.toString()));
  }
}
 Future<void> getDataVas ({required String token, GetDataVasBody? body}) async {
  try {
    emit(GetDataLoading());
    final value = await repositories.getDataVas(token, body);
    
    if (value.isSuccess && value.dataResponse is GetDataVasResponse) {
      final res = value.dataResponse as GetDataVasResponse;
      emit(GetDataVasSuccess(res));
    } else {
       print(value.dataResponse);
      emit(GetDataVasFailure(message: value.dataResponse));
    }
  } catch (error) {
    emit(GetDataVasFailure(message: error.toString()));
  }
}
 Future<void> getDataUji ({required String token}) async {
  try {
    emit(GetDataLoading());
    final value = await repositories.getDataUji(token);
    
    if (value.isSuccess && value.dataResponse is GetDataUjiResponse) {
      final res = value.dataResponse as GetDataUjiResponse;
      emit(GetDataUjiSuccess(res));
    } else {
       print(value.dataResponse);
      emit(GetDataUjiFailure(message: value.dataResponse));
    }
  } catch (error) {
    emit(GetDataUjiFailure(message: error.toString()));
  }
}
Future<void> approval({required String token,required ApprovalBody body}) async {
    try {
      emit(ApprovalLoading());
      final value = await repositories.approval(token,body);
      
      if (value.isSuccess && value.dataResponse is FormResponse) {
        final res = value.dataResponse as FormResponse;
        emit(ApprovalSuucess(res));
      } else {
        print(value.dataResponse);
        emit(ApprovalFailure(message: value.dataResponse));
      }
    } catch (error) {
      emit(ApprovalFailure(message: error.toString()));
    }
  }
}