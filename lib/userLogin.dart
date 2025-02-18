import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> submitLoginForm () async{
    final String apiString = "http://192.168.18.31:5000/api/auth/userLogin";

    try{
      final response = await http.post(Uri.parse(apiString),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "number": numberController.text,
        "password": passwordController.text,
      })
      );

      if(response.body.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No response from server")),
        );
        return;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if(responseData.containsKey("status") && responseData["status"]== "Success"){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"] ?? "Login Successful")),
        );
      }

    } catch(err){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $err")),
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left:40, top: 120),
              child: Text('Welcome to QuickChat', style: TextStyle(
                color: Colors.white, fontSize: 33
              ),),
            ),
            SingleChildScrollView(
              child:  Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5, right: 35, left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: numberController,
                      decoration: InputDecoration(
                          hintText: 'Enter username',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Enter Password',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(onPressed: submitLoginForm, style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      foregroundColor: Colors.white,

                    ), child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )),
                    Row(
                      children: [
                        TextButton(onPressed: (){Navigator.pushNamed(context, 'register')
                        ;}, child: Text('Dont have account? Signup Here', style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          color: Colors.blue
                        ),
                        )
                        )
                      ],
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
