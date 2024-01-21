import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gpt/Services/auth_services.dart';
import 'package:gpt/exceptions/authexception.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  // ignore: non_constant_identifier_names
  final _EmailController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _PasswordController = TextEditingController();
  final AuthService auths = AuthService();

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
                    FadeInUp(duration: const Duration(milliseconds: 1000), child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
                    const SizedBox(height: 10,),
                    FadeInUp(duration: const Duration(milliseconds: 1300), child: const Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                        const SizedBox(height: 60,),
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
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                ),
                                child: TextField(
                                  controller: _EmailController,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                ),
                                child: TextField(
                                  controller: _PasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 40,),
                        FadeInUp(duration: const Duration(milliseconds: 1600), child: MaterialButton(
                          onPressed: () async{
                            try
                            {
                              final email = _EmailController.text;
                              final password = _PasswordController.text;
                              await auths.login(email, password);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                            }
                            on GenericAuthException
                            {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('Incorrect Email or Password',style: TextStyle(fontSize: 16),),
                                  backgroundColor: Colors.black,
                                )
                              );
                            }
                              },
                              height: 50,
                              color: const Color.fromARGB(255, 30, 30, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                          child: const Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        )
                        ),
                        const SizedBox(height: 40,),
                        FadeInUp(duration: const Duration(milliseconds: 1500), child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                        const SizedBox(height: 50,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: const Text("New Here ? ",
                              style: TextStyle(color: Colors.grey),
                              )
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamedAndRemoveUntil('/register', (route) => false);
                                },
                                child: const Text("Create An account",
                                style: TextStyle(color: Color.fromARGB(255, 33, 33, 33)),
                                ),
                              )
                            ),
                          ],
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