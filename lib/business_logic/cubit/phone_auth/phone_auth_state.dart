part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthStates {}

class PhoneAuthInitial extends PhoneAuthStates {}

class PhoneLoading extends PhoneAuthStates {}

class PhoneOccurredErorr extends PhoneAuthStates {
  final String erorrMsg;

  PhoneOccurredErorr({required this.erorrMsg});
}
class PhoneNumberSubmited extends PhoneAuthStates{}

class PhoneOtpVerified extends PhoneAuthStates{}
