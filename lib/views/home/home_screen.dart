import 'package:farmhouse_vendor/views/home/my_bookings.dart';
import 'package:flutter/material.dart';

// ── DATA MODEL ──────────────────────────────────────────────────────────────

class Farmhouse {
  final String name;
  final String location;
  final double price;
  final double rating;
  final int reviews;
  final int maxGuests;
  final int bedrooms;
  final List<String> amenities;
  final String tag; // e.g. "Popular", "New", "Deal"
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

const Color kPrimary = Color(0xFF1C4532); // deep forest green
const Color kAccent = Color(0xFFF4A228); // warm amber
const Color kBg = Color(0xFFF9F6F0); // warm off-white
const Color kCard = Color(0xFFFFFFFF);
const Color kText1 = Color(0xFF1A1A2E);
const Color kText2 = Color(0xFF6B7280);
const Color kDivider = Color(0xFFE5E7EB);

const String kFontDisplay = 'Georgia'; // serif display
const String kFontBody = 'sans-serif';

// ── HOME SCREEN ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _carouselIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildCarousel()),
          SliverToBoxAdapter(child: _buildSectionHeader('My Farmhouses')),
          SliverToBoxAdapter(child: _buildFeaturedCard(farmhouses[0], 0)),
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
          // Logo
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
          // Notification bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: kText1,
                  size: 26,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: kAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Avatar
          Container(
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
        ],
      ),
     
    );
  }

 

  // ── CAROUSEL ───────────────────────────────────────────────────────────────

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
                      // gradient overlay
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
                      // label
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carouselLabels[i],
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: kFontDisplay,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
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
        // Dots
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
          Text(
            'See all',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFeaturedCard(Farmhouse f, int imgIndex) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBookings()));
        },
        child: Container(
          height: 280,
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
                // Background image
                Image.network(
                  farmhouseNetworkImages[imgIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: kPrimary.withOpacity(0.4)),
                ),
                // Gradient
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
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: tag + wishlist
                      Row(
                        children: [
                          const Spacer(),
                        
                        ],
                      ),
                      const Spacer(),
                      // Name
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
                      // Location
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
                      // Bottom row
                      Row(
                        children: [
                          // Price
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
                          // Rating
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
      ),
    );
  }
}
