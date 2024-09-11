import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dags_user/Common/Services/api_services.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/Features/AccountsScreen/provider/user_provider.dart';
import 'package:dags_user/Features/HomeScreen/Provider/carousel_provider.dart';
import 'package:dags_user/Features/HomeScreen/Provider/home_services_notifier.dart';
import 'package:dags_user/main.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:progressive_image/progressive_image.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/image_res.dart';
import '../../AddressScreen/Provider/fetch_address_provider.dart';
import 'Widgets/home_scr_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Location location = new Location();
  bool _isFirstBuild = true;
  final CarouselController _carouselController = CarouselController();
  int _currentCarousel = 0;

  Future<LocationData> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location services are not enabled');
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }
    _locationData = await location.getLocation();
    return _locationData;
  }

  @override
  void didChangeDependencies() async {
    final phoneNumber =
        Global.storageServices.getString(AppConstants.userPhoneNumber);
    String lat = '';
    String long = '';
    String appOpen = OrderModel.isAppOpen;
    if (appOpen.isEmpty) {
      if (kDebugMode) {
        print('screen is opened first time.');
      }
      await _getLocation().then((value) async {
        lat = "${value.latitude}";
        long = "${value.longitude}";
        final String phoneNumber =
            Global.storageServices.getString(AppConstants.userPhoneNumber);
        if (kDebugMode) {
          print("latitude is $lat, longitude is $long");
        }
        bool isSuccess = await API.addAddressFromLocation(
            phoneNumber: phoneNumber, lat: lat, longi: long);
        if (isSuccess) {
          if (kDebugMode) {
            print('location is confirmed added from home screen also.');
          }
        }
      });
    }
    ref.read(servicesProvider.notifier).fetchServices();
    ref.read(addressProvider.notifier).fetchAddress(phoneNumber);
    ref.read(carouselProvider.notifier).fetchCarouselData();
    ref.read(userProvider.notifier).fetchUser();
    OrderModel.isAppOpen = "true value";
    super.didChangeDependencies();
  }

  DropdownMenuItem<String> buildMenuItem(dynamic item) => DropdownMenuItem(
      value: item,
      child: Text(item,
          style: TextStyle(
            color: const Color(0xff1C254E),
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start));

  String? address = '';

  @override
  Widget build(BuildContext context) {
    bool nameSet = Global.storageServices.getNameSet();
    final addressState = ref.watch(addressProvider);
    final carouselData = ref.watch(carouselProvider);
    final user = ref.watch(userProvider);
    List addresses = [];
    List carouselImages = [];
    List carouselDesc = [];
    int carouselServiceIndex = -1;
    if (addressState != null) {
      addresses = addressState.address;
    }
    if (carouselData != null) {
      for (var data in carouselData) {
        carouselImages.add(data.img);
        carouselDesc.add(data.description);
      }
    }
    if (_isFirstBuild && addressState != null) {
      if (addresses.isNotEmpty) {
        address = addresses[0];
        address = address?.trim();
      }
      _isFirstBuild = false;
    }

    String userName = "Explorer";
    if (nameSet) {
      userName = Global.storageServices.getString(AppConstants.userName);
    } else {
      if (user != null) {
        userName = user.name!;
      }
    }
    final services = ref.watch(servicesProvider);
    return DoubleBackToCloseApp(
      snackBar: const SnackBar(
          backgroundColor: AppColors.primaryElement,
          content: textcustomnormal(
            align: TextAlign.left,
            text: 'Tap back again to leave',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontfamily: "Inter",
          )),
      child: Scaffold(
        appBar: buildAppBarWithAction(),
        body: (services.isEmpty)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const textcustomnormal(
                      text: "Fetching Services and getting things ready...",
                      fontSize: 20,
                      fontfamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 5.w,
                        ),
                        termsHeading("Hello, ${userName.split(' ')[0]}"),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.h),
                            child: Icon(
                              Icons.waving_hand,
                              color: Colors.yellow.shade700,
                            ))
                      ],
                    ),
                    (addresses.isNotEmpty)
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: Icon(Icons.location_on,
                                        color: Color(0xff1d254e))),
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(top: 3.h),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.h),
                                        elevation: 0,
                                        value: address,
                                        underline: SizedBox(),
                                        iconSize: 25.h,
                                        items: addresses
                                            .map(buildMenuItem)
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            address = value;
                                          });
                                        },
                                      )),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    dashLine(
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    (carouselImages.isNotEmpty)
                        ? CarouselSlider(
                            carouselController: _carouselController,
                            items: carouselImages.map((i) {
                              if (carouselData != null) {
                                final currentCarousel =
                                    carouselData[_currentCarousel];
                                carouselServiceIndex =
                                    int.parse(currentCarousel.index);
                              }
                              return Builder(
                                builder: (BuildContext context) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Container(
                                      width:
                                          double.infinity, // cover full width
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.white), // add border
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            10), // add border radius
                                      ),
                                      child: GestureDetector(
                                          onTap: () {
                                            if (carouselServiceIndex != -1 &&
                                                carouselServiceIndex < services.length) {
                                              navKey.currentState?.pushNamed(
                                                  "/service_scr",
                                                  arguments: {
                                                    "index":
                                                        carouselServiceIndex
                                                  });
                                            }
                                          },
                                          child: ProgressiveImage(
                                            placeholder: AssetImage(
                                                ImageRes.loadingcarouselimage),
                                            image: NetworkImage(i),
                                            thumbnail: NetworkImage(i),
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            fit: BoxFit.fill,
                                          )
                                          // child: Image.network(
                                          //   i,
                                          //   fit: BoxFit.fill,
                                          //   width: double.maxFinite,
                                          // ),
                                          ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 200.h,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.9,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              pauseAutoPlayOnTouch: true,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                // Handle page change
                                setState(() {
                                  _currentCarousel = index;
                                });
                              },
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Container(
                    //     alignment: Alignment.center,
                    //     height: 250.h,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Container(
                    //           margin: EdgeInsets.only(
                    //             left: 20.h,
                    //             top: 10.h,
                    //           ),
                    //           child: const textcustomnormal(
                    //             text: "What do you want to get done today?",
                    //             fontWeight: FontWeight.w600,
                    //             fontfamily: "Inter",
                    //             color: Colors.black,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         Container(
                    //           height: 180.h,
                    //           margin: EdgeInsets.only(right: 20.w),
                    //           child: ListView.builder(
                    //             itemBuilder: (_, index) {
                    //               return GestureDetector(
                    //                   onTap: () {
                    //                     navKey.currentState?.pushNamed(
                    //                         "/service_scr",
                    //                         arguments: {"index": index});
                    //                   },
                    //                   child: optionRow02(
                    //                       services[index].serviceName!,
                    //                       services[index].serviceIcon!));
                    //             },
                    //             itemCount: 3,
                    //             scrollDirection: Axis.horizontal,
                    //             shrinkWrap: true,
                    //           ),
                    //         )
                    //       ],
                    //     )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const textcustomnormal(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        fontfamily: "Inter",
                        text: "Laundry Services",
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.h),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            crossAxisCount: 2,
                          ),
                          itemCount: services.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                                onTap: () {
                                  navKey.currentState?.pushNamed("/service_scr",
                                      arguments: {"index": index});
                                },
                                child: orderRow(services[index].serviceName!,
                                    services[index].serviceIcon!));
                          }),
                    ),
                    SizedBox(
                      height: 50.h,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
//import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class PilgrimageYatras extends StatefulWidget {
//   const PilgrimageYatras({super.key});
//
//   @override
//   _PilgrimageYatrasState createState() => _PilgrimageYatrasState();
// }
//
// class _PilgrimageYatrasState extends State<PilgrimageYatras> {
//   bool _isSidebarOpen = false;
//   final double _sidebarWidth = 200.0; // Width of the sidebar
//   final ScrollController _scrollController = ScrollController();
//   List<String> carouselImages = [
//     'assets/images/Kashi_Vishwanath.png',
//     'assets/images/Kashi_Vishwanath.png',
//     'assets/images/Kashi_Vishwanath.png',
//   ];
//   final CarouselController _carouselController = CarouselController();
//   int _currentCarousel = 0;
//   void _toggleSidebar() {
//     setState(() {
//       _isSidebarOpen = !_isSidebarOpen;
//       if (_isSidebarOpen) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(130.0),
//         child: Container(
//           height: 280,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.019),
//                 Image.asset('assets/images/Nirvana.png', height: 120),
//                 const Text(
//                   'Trending Destinations',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontFamily: 'Trajan',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Row(
//         children: [
//           GestureDetector(
//             onHorizontalDragUpdate: (details) {
//               if (details.delta.dx > 0) {
//                 setState(() {
//                   _isSidebarOpen = true;
//                 });
//               } else if (details.delta.dx < 0) {
//                 setState(() {
//                   _isSidebarOpen = false;
//                 });
//               }
//               _scrollToTop();
//             },
//             onTap: _toggleSidebar,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               width: _isSidebarOpen ? _sidebarWidth : 0,
//               curve: Curves.easeInOut,
//               child: Visibility(
//                 visible: _isSidebarOpen,
//                 child: Container(
//                   color: Colors.blueGrey.withOpacity(0.8),
//                   child: ListView(
//                     controller: _scrollController,
//                     children: const [
//                       ListTile(title: Text('Sidebar Item 1')),
//                       ListTile(title: Text('Sidebar Item 2')),
//                       ListTile(title: Text('Sidebar Item 3')),
//                       ListTile(title: Text('Sidebar Item 4')),
//                       ListTile(title: Text('Sidebar Item 5')),
//                       ListTile(title: Text('Sidebar Item 6')),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 16),
//                   CarouselSlider(
//                     carouselController: _carouselController,
//                     items: carouselImages.map((i) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return ClipRRect(
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(15)),
//                             child: Container(
//                               width: double.infinity, // cover full width
//                               height: 200, // fixed height
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     width: 1, color: Colors.grey), // add border
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(
//                                     15), // add border radius
//                               ),
//                               child: Image.asset(
//                                 i,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }).toList(),
//                     options: CarouselOptions(
//                       height: 160,
//                       aspectRatio: 16 / 9,
//                       viewportFraction: 0.9,
//                       initialPage: 0,
//                       enableInfiniteScroll: true,
//                       reverse: false,
//                       autoPlay: true,
//                       autoPlayInterval: const Duration(seconds: 3),
//                       autoPlayAnimationDuration:
//                           const Duration(milliseconds: 800),
//                       pauseAutoPlayOnTouch: true,
//                       enlargeCenterPage: true,
//                       onPageChanged: (index, reason) {
//                         // Handle page change
//                         setState(() {
//                           _currentCarousel = index;
//                         });
//                       },
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: carouselImages.asMap().entries.map((entry) {
//                       return GestureDetector(
//                         onTap: () =>
//                             _carouselController.animateToPage(entry.key),
//                         child: Container(
//                           width: 5.0,
//                           height: 5.0,
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 4.0),
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: (Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? Colors.white
//                                       : Colors.black)
//                                   .withOpacity(_currentCarousel == entry.key
//                                       ? 0.9
//                                       : 0.4)),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 16),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Pilgrimage Yatras',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontFamily: 'Trajan',
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         PilgrimageYatrasList(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _scrollToTop() {
//     if (_isSidebarOpen) {
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
// }
//
// class TrendingDestinationsCarousel extends StatelessWidget {
//   const TrendingDestinationsCarousel({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 180,
//       child: PageView(
//         children: const [
//           CarouselItem('assets/images/top.png'),
//           CarouselItem('assets/images/top.png'),
//           CarouselItem('assets/images/top.png'),
//         ],
//       ),
//     );
//   }
// }
//
// class CarouselItem extends StatelessWidget {
//   final String imagePath;
//   const CarouselItem(this.imagePath, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16.0),
//         child: Image.asset(imagePath, fit: BoxFit.cover),
//       ),
//     );
//   }
// }
//
// class PilgrimageYatrasList extends StatelessWidget {
//   const PilgrimageYatrasList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: 4,
//       itemBuilder: (context, index) {
//         return const PilgrimageYatraCard();
//       },
//     );
//   }
// }
//
// class PilgrimageYatraCard extends StatelessWidget {
//   const PilgrimageYatraCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         side: BorderSide(
//           color: Color(0xffD19600),
//           width: 2,
//         ),
//       ),
//       color: Colors.white,
//       elevation: 0,
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.asset('assets/images/2.png',
//                   height: 80, width: 80, fit: BoxFit.cover),
//             ),
//             const SizedBox(width: 15),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   'Varanasi Sarnath Tour Package',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Trajan'),
//                 ),
//                 Text(
//                   'Varanasi Sightseeing Tour',
//                   style:
//                       TextStyle(color: Colors.grey[600], fontFamily: 'Trajan'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(15, 30),
//                       elevation: 0,
//                       backgroundColor: const Color(0xff0B091C),
//                       shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)))),
//                   child: const Text(
//                     'View details',
//                     style: TextStyle(color: Colors.white, fontFamily: 'Trajan'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
