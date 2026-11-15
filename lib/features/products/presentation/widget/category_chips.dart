import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final String label;
  final bool isSelected; 
  final VoidCallback onTap;
  const CategoryChips({
    super.key,
    required this.label,
    required this.onTap,
    required this.isSelected
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  AnimatedContainer(  
        duration: Duration(milliseconds: 200),
        padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration:  BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected? Colors.transparent: Colors.grey[300]!,
            width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected? FontWeight.bold :FontWeight(300),
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      
    );
  }
}