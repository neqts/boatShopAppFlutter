import 'dart:convert';

import 'package:boat_shop/admin/admin_upload_items.dart';
import 'package:boat_shop/users/authentitaction/login_screen.dart';
import 'package:boat_shop/users/authentitaction/signup_screen.dart';
import 'package:boat_shop/users/fragments/dashboard_of_fragments.dart';
import 'package:boat_shop/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:boat_shop/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;

import '../users/model/user.dart';

class AdminLoginScreen extends StatefulWidget
{

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}



class _AdminLoginScreenState extends State<AdminLoginScreen>
{
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginAdminNow() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.adminLogin),
        body: {
          "admin_email":emailController.text.trim(),
          "admin_password":passwordController.text.trim(),
        },
      );

      if(res.statusCode == 200) //from flutter app the connection with api to server - success
          {
        var resBodyOfLogin = jsonDecode(res.body);
        if(resBodyOfLogin['success'] == true)
        {
          Fluttertoast.showToast(msg: "Congratulations, you are Login Successfully.");



          Future.delayed(const Duration(microseconds: 20000), ()
          {
            Get.to(AdminUploadItemsScreen());

          });


        }
        else
        {
          Fluttertoast.showToast(msg: "Incorrect email or password, try again.");
        }
      }
    }catch(e)
    {
      print("Error:"+e.toString());
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        backgroundColor: Colors.black,
        body:LayoutBuilder(
          builder: (contex,cons){
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,

              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //login screen header
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 285,
                      child: Image.asset(
                          "images/admin.jpg"),
                    ),

                    //login screen sign in form
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration:const BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(60),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0,-3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30,30,30,8),
                          child: Column(
                            children: [
                              //email-password-login button
                              Form(
                                  key: formKey,
                                  child:Column(
                                    children: [
                                      //email
                                      TextFormField(
                                        controller: emailController,
                                        validator: (val) => val == "" ? "Please write email" : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color:Colors.black,
                                          ),
                                          hintText: "email...",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color:Colors.white60,
                                            ),
                                          ),
                                          enabledBorder:OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color:Colors.white60,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color:Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color:Colors.white60,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),

                                      const SizedBox(height:18,),
                                      //password
                                      Obx(
                                            () => TextFormField(
                                          controller: passwordController,
                                          obscureText: isObsecure.value,
                                          validator: (val) => val == "" ? "Please write password" : null,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.vpn_key_sharp,
                                              color:Colors.black,
                                            ),
                                            suffixIcon: Obx(
                                                  ()=>GestureDetector(
                                                onTap: ()
                                                {
                                                  isObsecure.value = !isObsecure.value;
                                                },
                                                child: Icon(
                                                  isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                                  color:Colors.black,

                                                ),
                                              ),
                                            ),
                                            hintText: "password...",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color:Colors.white60,
                                              ),
                                            ),
                                            enabledBorder:OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color:Colors.white60,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color:Colors.white60,
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color:Colors.white60,
                                              ),
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height:18,),
                                      //button
                                      Material(
                                        color:Colors.black,
                                        borderRadius: BorderRadius.circular(30),
                                        child:InkWell(
                                          onTap: (){
                                            if(formKey.currentState!.validate())
                                            {
                                              loginAdminNow();
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(30),
                                          child:const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 28,
                                            ),
                                            child:Text(
                                              "Login",
                                              style:TextStyle(
                                                color:Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ),
                                    ],
                                  )
                              ),

                              const SizedBox(
                                height: 16,
                              ),
                              //i am not an admin
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                      "I'm not an Admin"
                                  ),
                                  TextButton(
                                    onPressed: ()
                                    {
                                      Get.to(LoginScreen());
                                    },
                                    child: const Text(
                                      "Click here",
                                      style:TextStyle(
                                        color:Colors.indigoAccent,
                                      ),
                                    ),
                                  )
                                ],
                              ),







                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        )
    );
  }
}
