import 'package:flutter/material.dart';

AppBar myAppBar() => AppBar(
      title: const Text(
        'LibraryMS',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.grey[100],
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    );
