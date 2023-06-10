
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';

class ForgetPassword extends StatefulWidget{
  static const id = 'ForgetPassword';
  const ForgetPassword({Key? key}) : super(key: key);


  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();

}

class _ForgetPasswordState extends State<ForgetPassword>{

  final double _headerHeight = 250;

  final GlobalKey<FormState> _forgetkey = GlobalKey<FormState>();
  TextEditingController emailForgetControler = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: RadialGradient(colors: [
            Color(0xAD79D32F),
            Color(0xAD11A1DF)
          ])
        ),
        child:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 250,
              ),
              const SizedBox(height: 50,),
              const Center(
                child: Text("Password Reset",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.amberAccent
                ),
                  ),
                  ),
              const SizedBox(height: 50,),

              Form(
                  key: _forgetkey,
                child: Column(
                  children: [
                    Center(
                      child: CustomTextField(
                        data: Icons.email,
                        hintText: 'Email',
                        controller: emailForgetControler,
                        isObsecre: false,
                    ),
                  ),
                    ElevatedButton(
                        onPressed: () async {
                          if(emailForgetControler.text.isNotEmpty){
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: emailForgetControler.text.toString());
                            Fluttertoast.showToast(msg: 'Password Reset link has been sent');
                          } else{
                            showDialog(context: context, builder: (c){
                              return const ErrorDialog(

                                   message: 'Please Enter valid Email'
                              );
                            });
                          }
                        },
                        child:
                        const Text(
                          'Send'
                        )
                    ),
                    const CircularProgressIndicator()
                ],
          )

              )


            ],
          ),
        ),
      ),
    );
  }

}