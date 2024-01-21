import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gpt/models/userModel.dart';
import 'package:gpt/Services/auth_services.dart';
import 'package:gpt/Services/db_service.dart';
import 'package:gpt/exceptions/authexception.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // ignore: non_constant_identifier_names
  final _EmailController = TextEditingController();

  // ignore: non_constant_identifier_names
  final _PasswordController = TextEditingController();

  // ignore: non_constant_identifier_names
  final _UserNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    AuthService auths = AuthService();
    dbService dbs = dbService();

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
                    FadeInUp(duration: const Duration(milliseconds: 1000), child: const Text("Register", style: TextStyle(color: Colors.white, fontSize: 40),)),
                    const SizedBox(height: 10,),
                    FadeInUp(duration: const Duration(milliseconds: 1300), child: const Text("Create a Free Account", style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                                  controller: _UserNameController,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    hintText: "User Name",
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
                            try{
                              // ignore: non_constant_identifier_names
                              final Credentialuser = await auths.createUser(_EmailController.text, _PasswordController.text);
                              final UserModel user = UserModel(username: _UserNameController.text, email: _EmailController.text);
                              user.id = Credentialuser!.uid;
                              await dbs.addUser(user);
                              await auths.sendEmailVerify();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                            }
                            on WeakPasswordAuthException{
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('Your password must be at least 6 characters long',style: TextStyle(fontSize: 14),),
                                  backgroundColor: Colors.black,
                                )
                              );
                            }
                            on EmailAlreadyInUseAuthException
                            {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('This Email is Already in Use , Try to Reset your password',style: TextStyle(fontSize: 14),),
                                  backgroundColor: Colors.black,
                                )
                              );
                            }
                            on InvalidEmailAuthException
                            {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('Please Insert A Valid Email and try again',style: TextStyle(fontSize: 14),),
                                  backgroundColor: Colors.black,
                                )
                              );
                            }
                            on GenericAuthException
                            {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('Failed To Register',style: TextStyle(fontSize: 14),),
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
                            child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        )),
                        const SizedBox(height: 50,),
                                                Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: const Text("Already Have an Account ? ",
                              style: TextStyle(color: Colors.grey),
                              )
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                                },
                                child: const Text("Login",
                                style: TextStyle(color: Color.fromARGB(255, 33, 33, 33)),
                                ),
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
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