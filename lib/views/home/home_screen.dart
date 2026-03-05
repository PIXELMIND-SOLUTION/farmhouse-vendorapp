import 'package:carousel_slider/carousel_slider.dart';
import 'package:farmhouse_vendor/views/home/my_bookings.dart';
import 'package:farmhouse_vendor/views/home/profile_screen.dart';
import 'package:flutter/material.dart';


class Farmhouse {
  final String name;
  final String location;
  final double price;
  final double rating;
  final int reviews;
  final int maxGuests;
  final int bedrooms;
  final List<String> amenities;
  final String tag;
  final Color accentColor;

  const Farmhouse({
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.maxGuests,
    required this.bedrooms,
    required this.amenities,
    required this.tag,
    required this.accentColor,
  });
}

final List<Farmhouse> farmhouses = [
  Farmhouse(
    name: 'The Golden Meadow',
    location: 'Coorg, Karnataka',
    price: 6500,
    rating: 4.9,
    reviews: 238,
    maxGuests: 20,
    bedrooms: 6,
    amenities: ['Pool', 'BBQ', 'Bonfire', 'Parking'],
    tag: 'Popular',
    accentColor: const Color(0xFFF4A228),
  ),
  Farmhouse(
    name: 'Willow Creek Estate',
    location: 'Lonavala, Maharashtra',
    price: 8200,
    rating: 4.7,
    reviews: 175,
    maxGuests: 30,
    bedrooms: 8,
    amenities: ['Pool', 'Gym', 'Chef', 'Bonfire'],
    tag: 'Deal',
    accentColor: const Color(0xFF4CAF82),
  ),
  Farmhouse(
    name: 'Sunset Bluff Retreat',
    location: 'Nainital, Uttarakhand',
    price: 5800,
    rating: 4.8,
    reviews: 312,
    maxGuests: 15,
    bedrooms: 5,
    amenities: ['Trekking', 'Bonfire', 'Parking', 'BBQ'],
    tag: 'New',
    accentColor: const Color(0xFFE05C5C),
  ),
  Farmhouse(
    name: 'Pinewood Heritage',
    location: 'Ooty, Tamil Nadu',
    price: 7100,
    rating: 4.6,
    reviews: 89,
    maxGuests: 25,
    bedrooms: 7,
    amenities: ['Pool', 'Cycling', 'Chef', 'Parking'],
    tag: 'Popular',
    accentColor: const Color(0xFF7B5EA7),
  ),
];

// ── GRADIENT IMAGES (placeholder network images) ─────────────────────────────

const List<String> carouselImages = [
  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
  'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
  'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=800&q=80',
];

const List<String> carouselLabels = [
  'Weekend Getaways',
  'Mountain Escapes',
  'Lakeside Retreats',
];

const List<String> farmhouseNetworkImages = [
  'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=80',
  'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=600&q=80',
  'https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?w=600&q=80',
  'https://images.unsplash.com/photo-1586348943529-beaae6c28db9?w=600&q=80',
];

// ── THEME CONSTANTS ──────────────────────────────────────────────────────────

const Color kPrimary = Color(0xFF1C4532);
const Color kAccent = Color(0xFFF4A228);
const Color kBg = Color(0xFFF9F6F0);
const Color kCard = Color(0xFFFFFFFF);
const Color kText1 = Color(0xFF1A1A2E);
const Color kText2 = Color(0xFF6B7280);
const Color kDivider = Color(0xFFE5E7EB);

const String kFontDisplay = 'Georgia';
const String kFontBody = 'sans-serif';

// ── HOME SCREEN ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _carouselIndex = 0;
  int _farmhouseCarouselIndex = 0; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildCarousel()),
          SliverToBoxAdapter(child: _buildSectionHeader('My Farmhouses')),
          SliverToBoxAdapter(child: _buildFarmhouseCarousel()), // ← carousel
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ── SLIVER APP BAR ─────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 0,
      floating: true,
      snap: true,
      backgroundColor: kBg,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: kDivider,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'V',
                  style: TextStyle(
                    fontFamily: kFontDisplay,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'FARMS',
                  style: TextStyle(
                    fontFamily: kFontDisplay,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: kAccent,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimary, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/80?img=11'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TOP CAROUSEL ───────────────────────────────────────────────────────────

  Widget _buildCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: carouselImages.length,
            onPageChanged: (i) => setState(() => _carouselIndex = i),
            itemBuilder: (ctx, i) {
              return Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 16 : 8,
                  right: i == carouselImages.length - 1 ? 16 : 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        carouselImages[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: kPrimary.withOpacity(0.3)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.65),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          carouselLabels[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: kFontDisplay,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(carouselImages.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _carouselIndex == i ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _carouselIndex == i ? kPrimary : kDivider,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  // ── SECTION HEADER ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kText1,
              letterSpacing: -0.4,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBookings()),
              );
            },
            child: Text(
              'See all',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kPrimary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FARMHOUSE CAROUSEL (carousel_slider) ───────────────────────────────────

  Widget _buildFarmhouseCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: farmhouses.length,
          options: CarouselOptions(
            height: 300,
            viewportFraction: 0.88,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, reason) {
              setState(() => _farmhouseCarouselIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildFeaturedCard(farmhouses[index], index);
          },
        ),
        const SizedBox(height: 14),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(farmhouses.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _farmhouseCarouselIndex == i ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _farmhouseCarouselIndex == i ? kPrimary : kDivider,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── FEATURED CARD ──────────────────────────────────────────────────────────

  Widget _buildFeaturedCard(Farmhouse f, int imgIndex) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyBookings()),
        );
      },
      child: Container(
        height: 280,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                farmhouseNetworkImages[imgIndex %
                    farmhouseNetworkImages.length],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: kPrimary.withOpacity(0.4)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [const Spacer()]),
                    const Spacer(),
                    Text(
                      f.name,
                      style: const TextStyle(
                        fontFamily: kFontDisplay,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          f.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${f.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: f.accentColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'per night',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: kAccent,
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${f.rating}  (${f.reviews})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


















// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:farmhouse_vendor/model/farmhouse_model.dart'
//     as model; // aliased to avoid clash
// import 'package:farmhouse_vendor/provider/farmhouse_provider.dart';
// import 'package:farmhouse_vendor/views/home/my_bookings.dart';
// import 'package:farmhouse_vendor/views/home/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // ── LOCAL UI MODEL (for static/placeholder cards) ────────────────────────────

// class _FarmhouseCard {
//   final String name;
//   final String location;
//   final double price;
//   final double rating;
//   final int reviews;
//   final int maxGuests;
//   final int bedrooms;
//   final List<String> amenities;
//   final String tag;
//   final Color accentColor;

//   const _FarmhouseCard({
//     required this.name,
//     required this.location,
//     required this.price,
//     required this.rating,
//     required this.reviews,
//     required this.maxGuests,
//     required this.bedrooms,
//     required this.amenities,
//     required this.tag,
//     required this.accentColor,
//   });
// }

// // ── THEME CONSTANTS ──────────────────────────────────────────────────────────

// const Color kPrimary = Color(0xFF1C4532);
// const Color kAccent = Color(0xFFF4A228);
// const Color kBg = Color(0xFFF9F6F0);
// const Color kCard = Color(0xFFFFFFFF);
// const Color kText1 = Color(0xFF1A1A2E);
// const Color kText2 = Color(0xFF6B7280);
// const Color kDivider = Color(0xFFE5E7EB);

// const String kFontDisplay = 'Georgia';
// const String kFontBody = 'sans-serif';

// // ── STATIC DATA ───────────────────────────────────────────────────────────────

// const List<String> carouselImages = [
//   'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
//   'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
//   'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=800&q=80',
// ];

// const List<String> carouselLabels = [
//   'Weekend Getaways',
//   'Mountain Escapes',
//   'Lakeside Retreats',
// ];

// const List<String> farmhouseNetworkImages = [
//   'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=80',
//   'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=600&q=80',
//   'https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?w=600&q=80',
//   'https://images.unsplash.com/photo-1586348943529-beaae6c28db9?w=600&q=80',
// ];

// // ── HOME SCREEN ───────────────────────────────────────────────────────────────

// class HomeScreen extends StatefulWidget {
//   /// Pass the farmhouse ID you want to load from the API.
//   final String farmhouseId;

//   const HomeScreen({super.key, required this.farmhouseId});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _carouselIndex = 0;
//   int _farmhouseCarouselIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch after first frame so the provider is ready
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<FarmhouseProvider>().fetchFarmhouse(
//             farmhouseId: widget.farmhouseId,
//           );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     print('iddddddddddddddddddddddddddddd ${widget.farmhouseId}');
//     return Scaffold(
//       backgroundColor: kBg,
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(),
//           SliverToBoxAdapter(child: _buildCarousel()),
//           SliverToBoxAdapter(child: _buildSectionHeader('My Farmhouses')),
//           SliverToBoxAdapter(child: _buildFarmhouseSection()),
//           const SliverToBoxAdapter(child: SizedBox(height: 24)),
//         ],
//       ),
//     );
//   }

//   // ── SLIVER APP BAR ─────────────────────────────────────────────────────────

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       automaticallyImplyLeading: false,
//       expandedHeight: 0,
//       floating: true,
//       snap: true,
//       backgroundColor: kBg,
//       elevation: 0,
//       scrolledUnderElevation: 1,
//       shadowColor: kDivider,
//       titleSpacing: 20,
//       title: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: kPrimary,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
//           ),
//           const SizedBox(width: 10),
//           RichText(
//             text: const TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'V',
//                   style: TextStyle(
//                     fontFamily: kFontDisplay,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w700,
//                     color: kPrimary,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 TextSpan(
//                   text: 'FARMS',
//                   style: TextStyle(
//                     fontFamily: kFontDisplay,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w400,
//                     color: kAccent,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Spacer(),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfileScreen()),
//               );
//             },
//             child: Container(
//               width: 36,
//               height: 36,
//               margin: const EdgeInsets.only(right: 4),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: kPrimary, width: 2),
//                 image: const DecorationImage(
//                   image: NetworkImage('https://i.pravatar.cc/80?img=11'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── TOP CAROUSEL ───────────────────────────────────────────────────────────

//   Widget _buildCarousel() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 200,
//           child: PageView.builder(
//             itemCount: carouselImages.length,
//             onPageChanged: (i) => setState(() => _carouselIndex = i),
//             itemBuilder: (ctx, i) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   left: i == 0 ? 16 : 8,
//                   right: i == carouselImages.length - 1 ? 16 : 8,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.network(
//                         carouselImages[i],
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) =>
//                             Container(color: kPrimary.withOpacity(0.3)),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.65),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 16,
//                         left: 16,
//                         right: 16,
//                         child: Text(
//                           carouselLabels[i],
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontFamily: kFontDisplay,
//                             fontSize: 22,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: -0.3,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(carouselImages.length, (i) {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               width: _carouselIndex == i ? 20 : 7,
//               height: 7,
//               decoration: BoxDecoration(
//                 color: _carouselIndex == i ? kPrimary : kDivider,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             );
//           }),
//         ),
//         const SizedBox(height: 6),
//       ],
//     );
//   }

//   // ── SECTION HEADER ─────────────────────────────────────────────────────────

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//               color: kText1,
//               letterSpacing: -0.4,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MyBookings()),
//               );
//             },
//             child: Text(
//               'See all',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: kPrimary.withOpacity(0.8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── FARMHOUSE SECTION (provider-driven) ────────────────────────────────────

//   Widget _buildFarmhouseSection() {
//     return Consumer<FarmhouseProvider>(
//       builder: (context, provider, _) {
//         switch (provider.state) {
//           case FarmhouseState.loading:
//             return const SizedBox(
//               height: 300,
//               child: Center(
//                 child: CircularProgressIndicator(color: kPrimary),
//               ),
//             );

//           case FarmhouseState.error:
//             return SizedBox(
//               height: 300,
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.error_outline_rounded,
//                           color: Colors.redAccent, size: 40),
//                       const SizedBox(height: 12),
//                       Text(
//                         provider.errorMessage ?? 'Something went wrong',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(color: kText2, fontSize: 14),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: kPrimary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: () => provider.fetchFarmhouse(
//                           farmhouseId: widget.farmhouseId,
//                         ),
//                         child: const Text('Retry',
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );

//           case FarmhouseState.loaded:
//             final farmhouse = provider.farmhouse!.farmhouse;
//             return _buildLoadedCarousel(farmhouse);

//           case FarmhouseState.idle:
//           default:
//             return const SizedBox(height: 300);
//         }
//       },
//     );
//   }

//   // ── LOADED CAROUSEL (uses real API data) ───────────────────────────────────

//   Widget _buildLoadedCarousel(model.Farmhouse farmhouse) {
//     // Each time-price slot is shown as a carousel item
//     final timePrices = farmhouse.timePrices;

//     if (timePrices.isEmpty) {
//       return SizedBox(
//         height: 300,
//         child: Center(
//           child: Text(
//             'No slots available for ${farmhouse.name}',
//             style: const TextStyle(color: kText2),
//           ),
//         ),
//       );
//     }

//     return Column(
//       children: [
//         CarouselSlider.builder(
//           itemCount: timePrices.length,
//           options: CarouselOptions(
//             height: 300,
//             viewportFraction: 0.88,
//             enlargeCenterPage: true,
//             enlargeFactor: 0.15,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 4),
//             autoPlayAnimationDuration: const Duration(milliseconds: 600),
//             autoPlayCurve: Curves.easeInOut,
//             onPageChanged: (index, reason) {
//               setState(() => _farmhouseCarouselIndex = index);
//             },
//           ),
//           itemBuilder: (context, index, realIndex) {
//             return _buildApiCard(
//               farmhouse: farmhouse,
//               timePrice: timePrices[index],
//               imgIndex: index,
//             );
//           },
//         ),
//         const SizedBox(height: 14),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(timePrices.length, (i) {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               width: _farmhouseCarouselIndex == i ? 20 : 7,
//               height: 7,
//               decoration: BoxDecoration(
//                 color: _farmhouseCarouselIndex == i ? kPrimary : kDivider,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   // ── API-DRIVEN CARD ────────────────────────────────────────────────────────

//   Widget _buildApiCard({
//     required model.Farmhouse farmhouse,
//     required model.TimePrice timePrice,
//     required int imgIndex,
//   }) {
//     final imageUrl = farmhouse.images.isNotEmpty
//         ? farmhouse.images[imgIndex % farmhouse.images.length]
//         : farmhouseNetworkImages[imgIndex % farmhouseNetworkImages.length];

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => MyBookings()),
//         );
//       },
//       child: Container(
//         height: 280,
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(22),
//           boxShadow: [
//             BoxShadow(
//               color: kPrimary.withOpacity(0.18),
//               blurRadius: 24,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(21),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Background image
//               Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) =>
//                     Container(color: kPrimary.withOpacity(0.4)),
//               ),
//               // Gradient overlay
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topRight,
//                     end: Alignment.bottomLeft,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.75),
//                     ],
//                   ),
//                 ),
//               ),
//               // Content
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Slot label badge (top-right)
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: timePrice.isActive
//                               ? kAccent
//                               : Colors.white.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           timePrice.isActive ? timePrice.label : 'Inactive',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     // Farmhouse name
//                     Text(
//                       farmhouse.name,
//                       style: const TextStyle(
//                         fontFamily: kFontDisplay,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // Address
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on_rounded,
//                           color: Colors.white70,
//                           size: 14,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             farmhouse.address,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     // Slot timing
//                     Row(
//                       children: [
//                         const Icon(Icons.access_time_rounded,
//                             color: Colors.white54, size: 13),
//                         const SizedBox(width: 4),
//                         Text(
//                           timePrice.timing,
//                           style: const TextStyle(
//                               color: Colors.white54, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     // Price + rating row
//                     Row(
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '₹${timePrice.price.toStringAsFixed(0)}',
//                               style: const TextStyle(
//                                 color: kAccent,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                             const Text(
//                               'per slot',
//                               style: TextStyle(
//                                 color: Colors.white60,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 16),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 5,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.star_rounded,
//                                 color: kAccent,
//                                 size: 15,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 farmhouse.rating.toStringAsFixed(1),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Spacer(),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }