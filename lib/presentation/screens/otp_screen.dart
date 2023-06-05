import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/constants/my_colors.dart';
import 'package:maps/constants/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../business_logic/cubit/phone_auth/phone_auth_cubit.dart';

class OtpScreen extends StatelessWidget {
   OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final phoneNumber;
  late String otpCode;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 32,horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                buildintroTexts(),
                const SizedBox(height: 80,),
                buildPinCodeFields(context),
                const SizedBox(height: 60,),
                buildVerifyButtom(context),
                buildPhoneVerificationBloc()
              ],
            ),
          ),
        ),
      ),
    );
  }
   void showProgressIndicator(BuildContext context){
     AlertDialog alertDialog =const AlertDialog(
       backgroundColor: Colors.transparent,
       elevation: 0.0,
       content: Center(
         child: CircularProgressIndicator(
           valueColor: AlwaysStoppedAnimation<Color>(Colors.black,),
         ),
       ),
     );
     showDialog(
         barrierColor: Colors.white.withOpacity(0.0),
         barrierDismissible: false,
         context: context, builder: (context)
     {
       return alertDialog;
     }
     );
   }

   Widget buildintroTexts(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        const Text(
          "Verfiy your phone number",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15,),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text:   TextSpan(
              text: "Enter your 6 digit code numbers sent to ",
              style: const TextStyle(fontSize: 22,color: Colors.black,height: 1.5),
              children: <TextSpan>[
                TextSpan(
                  text: "$phoneNumber",
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }

  Widget buildPinCodeFields(BuildContext context){
    return Container(
      child: PinCodeTextField(
        appContext:context ,
        keyboardType: TextInputType.phone,
        cursorColor: Colors.black,
        autoFocus: true,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          activeColor: MyColors.blue,
          borderWidth: 1,
          inactiveFillColor: Colors.white,
          errorBorderColor: Colors.red,
          selectedFillColor: Colors.white,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: MyColors.lightGrey,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (submittedCode) {
          otpCode = submittedCode;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
  void _login(BuildContext context){
    BlocProvider.of<PhoneAuthCubit>(context).submitOTP(otpCode);
  }

  Widget buildVerifyButtom(BuildContext context){
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          _login(context);

        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(110, 50),
          primary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          "Verify",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildPhoneVerificationBloc(){
    return BlocListener<PhoneAuthCubit, PhoneAuthStates>(
      listenWhen: (pervious, current) {
        return pervious != current;
      },
      listener: (context, state) {
        if (state is PhoneLoading) {
          showProgressIndicator(context);
        }
        if (state is PhoneOtpVerified) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, mapScreen);
        }
        if (state is PhoneOccurredErorr) {
          String erorrMsg = (state).erorrMsg;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(erorrMsg),
            backgroundColor: Colors.black,
            duration: const Duration(milliseconds: 2500),
          ),
          );
        }
      },
      child: Container(),
    );
}
}