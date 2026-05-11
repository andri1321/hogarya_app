import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Richie',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Color(0xFF4A101D),
          ),
        ),
        Text(
          '@richie.realestate',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 8),
        Text(
          'Pasión por la arquitectura moderna y las propiedades únicas.',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}