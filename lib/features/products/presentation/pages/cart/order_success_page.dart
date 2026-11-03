import 'package:ecommerce/core/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({super.key});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  Timer? _redirectTimer;

  @override
  void initState(){
    super.initState();
    _redirectTimer =Timer(const Duration(seconds: 5),(){
      if(mounted){
        context.goNamed(AppRoute.home);
      }
    });
  }

  @override
  void dispose(){
    _redirectTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(title: Text('Order Success'),centerTitle: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            
            child: Container(
              margin: EdgeInsets.only(top: 150),
              padding: EdgeInsets.all(20),
              child: Column(
                
                children: [
                 
                   Icon(
                      Icons.check_circle,
                      size: 109,
                      color: Colors.green,
                      ),
                
                  SizedBox(height: 12,),
                  Text('Order Placed Successfully !'
                  ,style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                  ),),
          
                  SizedBox(height: 4,),
                  Text('Your order #1234321 has been placed.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                  ),),
          
                  SizedBox(height: 34,),
          
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    
                    child: OutlinedButton(
                      
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black87,
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        )
                      ),
                      onPressed: (){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This is in progress')));
                    }, child: Text('View Order')),
                  ),
                  SizedBox(height: 14,),
          
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    
                    child: OutlinedButton(
                      
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        )
                      ),
                      onPressed: (){
                        context.goNamed(AppRoute.home);
                      }, child: Text('Continue Shopping')),
                  ),
          
                  SizedBox(height: 20,),
                  Image.asset(
                    'assets/order_image.jpg',
                    width: double.infinity,
                   fit: BoxFit.contain,
                  )
                ],
              ),
            ),
            
            
          ),
        ),
      ),
      
    );
  }
}