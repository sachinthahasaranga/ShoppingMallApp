import 'package:flutter/material.dart';


class OnBoardScreen extends StatefulWidget {
  //const ({super.key});

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller =PageController(
  initialPage: 0,
);

List<Widget> _pages=[
  Column(
    children: [
      Image.asset('images/enteraddress.png'),
      Text('Set Your Delivery location'),
    ],
  ),
  Column(
    children: [
      Image.asset('images/orderfood.png'),
      Text('Order Online from your favourite Store'),
    ],
  ),
  Column(
    children: [
      Image.asset('images/deliverfood.png'),
      Text('Quick Deliver to your Doorstep'),
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
      ),
    );
  }
}
