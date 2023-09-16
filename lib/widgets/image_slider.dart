import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  //const ImageSlider({super.key});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }

  Future getSliderImageFromDb()async{
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore.collection('slider').get();
    return snapshot.docs;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: getSliderImageFromDb(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while data is being fetched.
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle any errors that occur during data fetching.
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data.isEmpty) {
              // Handle the case where no data is available.
              return Text('No slider images available');
            } else {
              // Data is available, display the CarouselSlider.
              List<QueryDocumentSnapshot> sliderImages = snapshot.data;
              return CarouselSlider.builder(
                itemCount: sliderImages.length,
                itemBuilder: (context, int index, int realIndex) {
                  DocumentSnapshot sliderImage = sliderImages[index];
                  Map<String, dynamic> getImage = sliderImage.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.network(getImage['image'],fit: BoxFit.fill),
                  );
                },
                options: CarouselOptions(
                  initialPage: 0,
                  autoPlay: true,
                  height: 150,
                ),
              );
            }
          },
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}