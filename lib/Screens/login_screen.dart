import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swiping_views/Providers/login_provider.dart';
import 'package:swiping_views/Screens/DisplayVideos.dart';


class LoginScreen extends StatelessWidget {


  bool sec = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var visable = Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xfff28b82),
                      // Color(0xffe57373),
                      // Color(0xffd9534f),
                      // Color(0xffc93028),
                      // Color(0xffb52a27),
                      Color(0xff9f1f1f),
                      // Color(0xff8b1717),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 100,),
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 140,),
                        buildEmail(),
                        SizedBox(height: 20,),
                        buildPassword(context),
                        SizedBox(height: 28,),
                        // buildRememberassword(context),
                        SizedBox(height: 30,),
                        buildLoginButton(context),
                        SizedBox(height: 30,),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     buildFacebook(),
                        //     buildGoogle(),
                        //     buildTwitter()
                        //   ],
                        // ),
                        SizedBox(height: 60,),
                        // Text("الشروط والاحكام",style: TextStyle(color: Colors.white,fontSize: 10),)

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10,),
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(

              color: Color(0xffebefff),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
              )]
          ),
          child: TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email,color: Color(0xff4c5166),),
                hintText: 'Email',hintStyle: TextStyle(color: Colors.black38)
            ),

          ),
        ),
      ],
    );
  }
  Widget buildPassword(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Password", style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Color(0xffebefff),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2)
                  )
                ],
              ),
              height: 60,
              child: TextField(
                controller: password,
                obscureText: context.read<LoginProvider>().passVisible,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {

                        context.read<LoginProvider>().passVisiblityChanged();
                      },
                      icon: context.read<LoginProvider>().passVisible ? visableoff : visable,


                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.vpn_key,
                      color: Color(0xff4c5166),
                    ),
                    hintText: "pwd",
                    hintStyle: TextStyle(
                        color: Colors.black38
                    )
                ),
              ),
            )
          ],
        );
      },
    );
  }
  Widget buildRememberassword(BuildContext context){
    return Consumer<LoginProvider>(
      builder: (context, value, child) {
        return Container(
          height: 20,
          child: Row(
            children: [
              Checkbox(
                checkColor: Colors.red,
                activeColor: Colors.white,
                value:  value.rememberMe,
                side: const BorderSide(
                    color: Colors.white
                ),
                onChanged: (value)
                {
                  context.read<LoginProvider>().rememberMeChanged();
                },
              ),
              Text("Remember me", style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),),
            ],
          ),
        );
      },
    );
  }
  // Widget buildForgetPassword(){
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     child: TextButton(child: Text("Forget Password !",
  //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),onPressed: (){},),
  //   );
  // }
  Widget buildLoginButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Consumer<LoginProvider>(
        builder: (context, value, child) {
          return Container(
            height: 48,
            width: double.infinity,
            child:  ElevatedButton(
              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
              onPressed: () async {
                bool success;
                if(email.text.isNotEmpty && password.text.isNotEmpty) {
                  final RegExp emailRegex = RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  );
                  if(emailRegex.hasMatch(email.text)) {
                    success = await value.signIn(email.text, password.text);
                    print('Login Success - $success');
                    if(success){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayVideos(),));
                    }
                  }
                  else{
                    Fluttertoast.showToast(msg: 'Enter a valid Email');
                  }
                }
                else{
                  Fluttertoast.showToast(msg: 'Please Enter Email and Password');
                }
                // Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayVideos(),));
              },
              child:value.isLoading? CircularProgressIndicator() : Text("Login", style: TextStyle(fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),),
            ),
          );
        },
      ),
    );
  }
  // Widget buildFacebook(){
  //   return Container(
  //     height: 50,
  //     width: 50,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Image.asset("assets/facebook.png"),
  //   );
  // }
  // Widget buildGoogle(){
  //   return Container(
  //     height: 50,
  //     width: 50,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Image.asset("assets/search.png"),
  //   );
  // }
  // Widget buildTwitter(){
  //   return Container(
  //     height: 50,
  //     width: 50,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Image.asset("assets/twitter.png"),
  //   );
  // }
}