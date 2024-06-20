import 'package:flutter/material.dart';

class ShoppingCartButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;

  const ShoppingCartButton({
    required this.itemCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Icons.shopping_cart,
            size: 30,
          ),
        ),
        if (itemCount > 0) // Eğer sepet boş değilse, rakamı göster
          Positioned(
            right: 5,
            top: 3,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                '$itemCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
