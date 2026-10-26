
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/routes/app_route.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key
  });
  @override
  State<SignUpPage> createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage>{

  final _formKey = GlobalKey<FormState>();
  bool isHidden = true;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfimController = TextEditingController();

  @override
  void dispose(){
    fullNameController.dispose();
    emailController.dispose();
    passwordConfimController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  // reuseable style
  InputDecoration inputDecoration( String lable){
    return InputDecoration(
      hintText: lable,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
    );
  }
  void createAccount(){
    if(!_formKey.currentState!.validate()){return;}

    final String fullName = fullNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    context.read<AuthBloc>().add(RegisterEvent(fullName: fullName, email: email, password: password));
  }
  @override
  Widget build(BuildContext context){
    return 
     BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthFailureState) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }

    if (state is Authnticated) {
      context.goNamed(AppRoute.home);
    }
  },
  child: 
    Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // title
              SizedBox(height: 15,),
              Text('Create Account', style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,
              ),
              SizedBox(height: 5,),
               Text('Join us and start shopping ', style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w400
              ),),
              SizedBox(height: 24,),

              // creating form 
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Full Name' ,style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600),),
                    TextFormField(
                      controller: fullNameController,
                      decoration: inputDecoration('John Doe'),
                      validator:(value){
                        if(value == null || value.trim().isEmpty){
                          return 'This field is required !';
                        }
                        return null;
                      }
                    ),

                    // email
                    SizedBox(height: 14,),
                    Text('Email' ,style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600),),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputDecoration('user@example.com'),
                      validator:(value){
                        if(value == null || value.trim().isEmpty){
                          return 'This field is required !';
                        }
                        final emailPatter = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if(!emailPatter.hasMatch(value)){
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }
                    ),

                      // password
                    SizedBox(height: 14,),
                    Text('Password' ,style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600),),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isHidden,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        hintText: '••••••••', 
                        suffixIcon: IconButton(
                          onPressed: (){
                          setState(() {
                            isHidden = !isHidden;
                          });
                        }, icon: Icon(isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined))
                      ),
                      
                      validator:(value){
                        if(value == null || value.trim().isEmpty){
                          return 'This field is required !';
                        }
                       if(value.length < 5){
                          return 'Password must be greater than or equal to 6 characters !';
                        }
                        return null;
                      }
                    ),

                    SizedBox(height: 14,),
                    Text('Confirm Password' ,style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600),),
                    TextFormField(
                      controller: passwordConfimController,
                      obscureText: isHidden,
                      decoration: InputDecoration(
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                         hintText: '••••••••', 
                        suffixIcon: Icon(Icons.lock_outline)
                      ),
                      validator:(value){
                        if(value == null || value.trim().isEmpty){
                          return 'This field is required !';
                        }
                       if(value.length < 5){
                          return 'Password must be greater than or equal to 6 characters !';
                        }

                        if(value != passwordController.text){
                          return "Password doesn't match !";
                        }
                        return null;
                      }
                    ),
                    SizedBox(height: 34,),
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                           foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 6, 126, 224),
                          side:  const BorderSide(color: Colors.grey, width: 0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                        ),),
                        onPressed: (){
                          createAccount();
                        }, label: Text('SignUp'),
                    )),

                    SizedBox(height: 20,),
                    Row(  
                      children: [
                        Expanded(child: Divider(thickness: 1,)),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR', style: TextStyle(color: Colors.grey,
                        fontWeight: FontWeight.bold),)),
                        Expanded(child: Divider(thickness: 1,))
                      ],
                    ),
                    SizedBox(height: 20,),

                    SizedBox(
                      height: 52,
                      width: double.infinity,

                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: Colors.white,
                          side:  const BorderSide(color: Colors.grey, width: 0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                        ),
                        icon: Image.asset(
                          'assets/image_copy.png',
                          height: 24,
                          width: 24,
                        ),
                        onPressed: (){}, 

                        label: const Text(
                          'Continue with Google',
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        )),
                     ),

                     SizedBox(height: 15,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: 

                      [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            // color: Colors.grey
                          ),
                          
                        ),
                        TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> SingInPage()));
                        }, child: Text('Login',style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 4, 104, 187)
                        ),))
                      ],
                     )

                  ],

                ))
            ],
          ),
        )),
    ),);
  }
}