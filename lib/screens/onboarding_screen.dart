import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shoppingmall/constants.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

double _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/discount.png')),
      Text('Shop Smart, Shop Easy', style: kPageViewTextStyle,textAlign:TextAlign.center,),
    ],
  ),

  Column(
    children: [
      Expanded(child: Image.asset('assets/images/Wishlist.jpg')),
      Text('Your Wishlist, Your Way!', style: kPageViewTextStyle,textAlign:TextAlign.center,),
    ],
  ),

  Column(
    children: [
      Expanded(child: Image.asset('assets/images/find1.jpg')),
      Text('Where Your Dreams Become Products!', style: kPageViewTextStyle,textAlign:TextAlign.center,),
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  //const OnBoardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index){
              setState(() {
                _currentPage = index.toDouble();
              });
            },
          ),
        ),
        SizedBox(height: 20,),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.round(),
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Colors.deepPurple
          ),
        ),
        SizedBox(height: 40,),
      ],
    ) ;
  }
}


