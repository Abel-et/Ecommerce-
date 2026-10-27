import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/routes/app_route.dart';
class SingInPage extends StatefulWidget {
  const SingInPage({
    super.key
  });
  @override
  State<SingInPage> createState() => _SingInPageState();

}

class _SingInPageState extends State<SingInPage>{

  final _formKey = GlobalKey<FormState>();
  bool isHidden = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  

  @override
  void dispose(){
  
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(){
    if(!_formKey.currentState!.validate()){
      return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
  }


  // reuseable style
  InputDecoration inputDecoration( String lable){
    return InputDecoration(
      hintText: lable,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
    );
  }
  @override
  Widget build(BuildContext context){
    return BlocListener<AuthBloc, AuthState>(
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
  child:Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
             SizedBox(height: 25,),
              Text('WelCome Back 👋', style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.left,
              ),
              SizedBox(height: 5,),
               Text('Login to your account  ', style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w400
              ),),
              SizedBox(height: 34,),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     Text('Email' ,style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600),),
                     SizedBox(height: 10,),
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
                    SizedBox(height: 17),
                    Text('Password' ,style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600),),
                    SizedBox(height: 10,),
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
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                      
                      onPressed: (){}, child: Text('Forgot Password',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19, color: Colors.blue), textAlign: TextAlign.right,)),

                      ],
                    )
                    ,
                     SizedBox(height: 10,),
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
                          login();
                        }, label: Text('Login'),
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
                        onPressed: (){
                          context.read<AuthBloc>().add(GetAllUsersEvent());
                        }, 

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
                          "Don't have an Account?",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            // color: Colors.grey
                          ),
                          
                        ),
                        TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> SignUpPage()));
                        }, child: Text('SignUp',style: TextStyle(
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