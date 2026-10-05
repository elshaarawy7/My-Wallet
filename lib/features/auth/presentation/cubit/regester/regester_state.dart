import 'package:my_wallet/features/auth/domain/entity/regester_entity.dart';

class RegesterState {}

class RegesterInitial extends RegesterState {}
class RegesterLoading extends RegesterState {} 
class RegesterSuccess extends RegesterState { 
  final RegesterEntity regesterEntity ; 
  RegesterSuccess(this.regesterEntity) ; 
}
class RegesterErorr extends RegesterState {
  final String erorrMessage ;
  RegesterErorr(this.erorrMessage);
}
