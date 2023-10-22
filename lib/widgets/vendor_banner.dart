
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingmall/providers/store_provider.dart';
import 'package:shoppingmall/services/store_service.dart';

class VendorBanner extends StatefulWidget {
  const VendorBanner({Key? key}) : super(key: key);

  @override
  State<VendorBanner> createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {


  int _index = 0;
  int _dataLength = 1;


  @override
  void didChangeDependencies() {
    var _storeProvider = Provider.of<StoreProvider>(context);
    getBannerImageFromDb(_storeProvider);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<QueryDocumentSnapshot>> getBannerImageFromDb(StoreProvider storeProvider) async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore.collection('vendorbanner').where('sellerUid' , isEqualTo: storeProvider.storedetails['uid']).get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: getBannerImageFromDb(_storeProvider), // Specify the type of future
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while data is being fetched.
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle any errors that occur during data fetching.
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Handle the case where no data is available.
                  return Text('No slider images available');
                } else {
                  // Data is available, display the CarouselSlider.
                  List<QueryDocumentSnapshot> sliderImages = snapshot.data!;
                  return CarouselSlider.builder(
                    itemCount: sliderImages.length,
                    itemBuilder: (context, int index, int realIndex) {
                      DocumentSnapshot sliderImage = sliderImages[index];
                      Map<String, dynamic> getImage =
                      sliderImage.data() as Map<String, dynamic>;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          getImage['imageUrl'],
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                    options: CarouselOptions(
                      initialPage: 0,
                      autoPlay: true,
                      height: 180,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _index = index;
                        });
                      },
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 10),
          DotsIndicator(
            dotsCount: _dataLength,
            position: _index.toDouble().round(),
            decorator: DotsDecorator(
              size: const Size.square(5.0),
              activeSize: const Size(18.0, 5.0),
              activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
