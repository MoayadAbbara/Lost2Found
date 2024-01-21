import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gpt/Services/auth_services.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({super.key});

  @override
  State<EmailVerifyView> createState() => _HomeViewState();
}

class _HomeViewState extends State<EmailVerifyView> {
  AuthService auths = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 14, 14, 14),
                Color.fromARGB(255, 67, 67, 67),
                Color.fromARGB(255, 255, 255, 255)
              ]
            )
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80,),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(duration: const Duration(milliseconds: 1000), child: const Text("Verify Your Email", style: TextStyle(color: Colors.white, fontSize: 40),)),
                    const SizedBox(height: 10,),
                    FadeInUp(duration: const Duration(milliseconds: 1300), child: const Text("A Verification Email Has Sent to Your Email Please Check Your Inbox", style: TextStyle(color: Colors.white, fontSize: 14),)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(duration: const Duration(milliseconds: 1400), child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(
                              color: Color.fromRGBO(88, 75, 68, 0.298),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                        )),
                        const SizedBox(height: 40,),
                        FadeInUp(
                          child: const Center(
                                  child: Icon(Icons.email ,size: 80,),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        FadeInUp(duration: const Duration(milliseconds: 1600), child: MaterialButton(
                              onPressed:(){},
                              height: 50,
                              color: const Color.fromARGB(255, 30, 30, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                          child: const Center(
                            child: Text("Resend Email", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        )
                        ),
                        const SizedBox(height: 30,),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Verify Your Email Then, ",
                              style: TextStyle(color: Colors.grey),
                              ),
                              InkWell(
                                onTap: (){
                                  auths.logout();
                                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                                },
                                child: const Text("Back To Login",
                                style: TextStyle(color: Color.fromARGB(255, 33, 33, 33)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}