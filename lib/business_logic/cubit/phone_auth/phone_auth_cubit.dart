import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthStates> {
  late  String verificationId;

  PhoneAuthCubit() : super(PhoneAuthInitial());

  Future<void>submitPhoneNumber(String phoneNumber)async {
    emit(PhoneLoading());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2 $phoneNumber',
      timeout: const Duration(seconds: 15),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async{
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException error)async{
    emit(PhoneOccurredErorr(erorrMsg: error.toString()));

  }

  void codeSent(String verificationId,int?resend){
    print('code sent');
    this.verificationId = verificationId;
    emit(PhoneNumberSubmited());
  }

  void codeAutoRetrievalTimeout(String verificationId){
    print('codeAutoRetrievalTimeout');
  }

  Future<void>submitOTP(String otpCode)async{
    PhoneAuthCredential credential=PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otpCode );
    await signIn(credential);

  }

  Future<void>signIn(PhoneAuthCredential credential)async{
    try{
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerified());
    }catch(error){
      emit(PhoneOccurredErorr(erorrMsg: error.toString()));
    }
  }

  Future<void>logOut()async{
    await FirebaseAuth.instance.signOut();
  }
  User getLogedInUser(){
    User firebaseUser =FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }
}
