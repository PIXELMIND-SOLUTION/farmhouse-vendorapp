import 'dart:math' as math;
import 'dart:io';
import 'package:farmhouse_vendor/views/auth/login_screen.dart';
import 'package:farmhouse_vendor/views/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ═══════════════════════════════════════════════════════
//  SHARED COLOR PALETTE
// ═══════════════════════════════════════════════════════
class _C {
  static const bg0 = Color(0xFF030712);
  static const bg1 = Color(0xFF0B1426);
  // static const bg2 = Color(0xFF0F1E38);
  static const cyan = Color(0xFF00CFFF);
  static const blue = Color(0xFF3B82F6);
  static const violet = Color(0xFF8B5CF6);
  static const green = Color(0xFF22C55E);
  static const textDim = Color(0xFF4D7A99);
  static const textMid = Color(0xFF7DB8D4);
}

// ═══════════════════════════════════════════════════════
//  PAINTERS
// ═══════════════════════════════════════════════════════
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 28.0;
    final paint = Paint()..color = Colors.white.withOpacity(0.55);
    for (double x = 0; x < size.width; x += spacing)
      for (double y = 0; y < size.height; y += spacing)
        canvas.drawCircle(Offset(x, y), 0.75, paint);
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

class _HexRingPainter extends CustomPainter {
  final double progress;
  const _HexRingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = size.shortestSide / 2;

    // Outer glow ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = _C.cyan.withOpacity(
          0.12 + 0.06 * math.sin(progress * math.pi * 2),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Hex path
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = math.pi / 6 + (math.pi / 3) * i;
      final x = cx + r * math.cos(a), y = cy + r * math.sin(a);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();

    // Fill
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1F38), Color(0xFF120E30)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Stroke
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_C.cyan.withOpacity(0.9), _C.violet.withOpacity(0.9)],
          stops: [(progress + 0.0) % 1.0, (progress + 0.5) % 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(_HexRingPainter o) => o.progress != progress;
}

// ═══════════════════════════════════════════════════════
//  PROFILE SCREEN
// ═══════════════════════════════════════════════════════
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _hexCtrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _staggerCount = 7;

  File? _avatar;
  final _picker = ImagePicker();

  // ── Mock data ─────────────────────────────────────────
  final String _name = 'Ravi Kumar';
  final String _farmName = 'Green Horizon Farms';
  final String _mobile = '+91 98765 43210';
  final String _location = 'Hyderabad, Telangana';
  final double _rating = 4.8;
  final int _reviews = 124;
  final int _bookings = 58;
  final int _listings = 3;

  final List<String> _amenities = [
    'Swimming Pool',
    'BBQ Grill',
    'Wi-Fi',
    'Bonfire Pit',
    'Horse Riding',
    'Parking',
  ];

  @override
  void initState() {
    super.initState();

    _hexCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnims = List.generate(_staggerCount, (i) {
      final s = i * 0.11, e = (s + 0.40).clamp(0.0, 1.0);
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _enterCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });
    _slideAnims = List.generate(_staggerCount, (i) {
      final s = i * 0.11, e = (s + 0.45).clamp(0.0, 1.0);
      return Tween(begin: const Offset(0, 0.30), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _enterCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _hexCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final p = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (p != null) setState(() => _avatar = File(p.path));
  }

  Widget _staggered(int i, Widget child) => FadeTransition(
    opacity: _fadeAnims[i],
    child: SlideTransition(position: _slideAnims[i], child: child),
  );

  // ── Build ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _C.bg0,
      body: AnimatedBuilder(
        animation: Listenable.merge([_enterCtrl, _hexCtrl]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.6),
                    radius: 1.3,
                    colors: [Color(0xFF0E2444), _C.bg1, _C.bg0],
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
              ),
              // Accent blobs
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [_C.violet.withOpacity(0.14), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -80,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [_C.cyan.withOpacity(0.10), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // Grid
              Opacity(
                opacity: 0.065,
                child: CustomPaint(painter: _GridPainter()),
              ),

              // ── Scrollable content ───────────────────
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Header banner ──────────────────
                      _buildHeader(size),

                      // Name + verified badge (below avatar)
                      const SizedBox(height: 64),
                      _staggered(
                        1,
                        _NameStrip(
                          name: _name,
                          farmName: _farmName,
                          rating: _rating,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            // Stats row
                            _staggered(
                              2,
                              _StatsRow(
                                bookings: _bookings,
                                listings: _listings,
                                reviews: _reviews,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Farm info card
                            _staggered(
                              3,
                              _InfoCard(
                                title: 'FARM INFORMATION',
                                icon: Icons.agriculture_outlined,
                                children: [
                                  _InfoRow(
                                    Icons.storefront_outlined,
                                    'Farm Name',
                                    _farmName,
                                  ),
                                  _InfoRow(
                                    Icons.phone_outlined,
                                    'Mobile',
                                    _mobile,
                                  ),
                                  _InfoRow(
                                    Icons.location_on_outlined,
                                    'Location',
                                    _location,
                                  ),
                                  _InfoRow(
                                    Icons.my_location_rounded,
                                    'Coordinates',
                                    '17.3850° N, 78.4867° E',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Rating card
                            _staggered(
                              4,
                              _RatingCard(rating: _rating, reviews: _reviews),
                            ),

                            const SizedBox(height: 16),

                            // Amenities card
                            _staggered(
                              5,
                              _AmenitiesCard(amenities: _amenities),
                            ),

                            const SizedBox(height: 16),

                            // Action buttons
                            _staggered(
                              6,
                              _ActionButtons(onEdit: () {}, onLogout: () {}),
                            ),

                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Hero header ──────────────────────────────────────
  Widget _buildHeader(Size size) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Banner
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D2A4A), Color(0xFF1A0A3A), _C.bg1],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Decorative lines
              CustomPaint(
                size: Size(size.width, 180),
                painter: _BannerLinePainter(_hexCtrl.value),
              ),
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: _staggered(
                  0,
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: Colors.white.withOpacity(0.06),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: _C.textMid,
                            size: 15,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          colors: [_C.cyan, _C.blue, _C.violet],
                        ).createShader(b),
                        child: const Text(
                          'MY PROFILE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     width: 38,
                      //     height: 38,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(11),
                      //       color: Colors.white.withOpacity(0.06),
                      //       border: Border.all(
                      //         color: Colors.white.withOpacity(0.1),
                      //       ),
                      //     ),
                      //     child: const Icon(
                      //       Icons.settings_outlined,
                      //       color: _C.textMid,
                      //       size: 18,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Avatar — overlaps banner bottom
        Positioned(
          bottom: -54,
          child: _staggered(
            1,
            Column(
              children: [
                GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    children: [
                      // Hex ring
                      SizedBox(
                        width: 104,
                        height: 104,
                        child: AnimatedBuilder(
                          animation: _hexCtrl,
                          builder: (_, __) => CustomPaint(
                            painter: _HexRingPainter(_hexCtrl.value),
                          ),
                        ),
                      ),
                      // Avatar circle
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipOval(
                            child: _avatar != null
                                ? Image.file(_avatar!, fit: BoxFit.cover)
                                : Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF0A2A42),
                                          Color(0xFF180E30),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'RK',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          color: _C.cyan,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      // Camera badge
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [_C.cyan, _C.blue],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _C.cyan.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Spacer for overlap
        const SizedBox(height: 54),
      ],
    );
  }
}

// ── Banner decorative lines painter ──────────────────────
class _BannerLinePainter extends CustomPainter {
  final double progress;
  const _BannerLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _C.cyan.withOpacity(0.07)
      ..strokeWidth = 1;

    // Diagonal lines
    for (int i = 0; i < 8; i++) {
      final x = size.width * (i / 7.0);
      canvas.drawLine(
        Offset(x - size.height * 0.5, 0),
        Offset(x + size.height * 0.5, size.height),
        paint,
      );
    }

    // Animated scan line
    final scanY = size.height * ((progress + 0.0) % 1.0);
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      Paint()
        ..color = _C.cyan.withOpacity(0.18)
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(_BannerLinePainter o) => o.progress != progress;
}

// ═══════════════════════════════════════════════════════
//  NAME + STATUS STRIP  (placed after avatar overlap)
// ═══════════════════════════════════════════════════════
class _NameStrip extends StatelessWidget {
  final String name, farmName;
  final double rating;
  const _NameStrip({
    required this.name,
    required this.farmName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [_C.cyan, _C.blue, _C.violet],
            stops: [0.0, 0.5, 1.0],
          ).createShader(b),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          farmName,
          style: const TextStyle(
            fontSize: 13,
            color: _C.textMid,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        // Verified badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [_C.green.withOpacity(0.15), _C.cyan.withOpacity(0.10)],
            ),
            border: Border.all(color: _C.green.withOpacity(0.4)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, color: _C.green, size: 13),
              SizedBox(width: 5),
              Text(
                'Verified Vendor',
                style: TextStyle(
                  color: _C.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
//  STATS ROW
// ═══════════════════════════════════════════════════════
class _StatsRow extends StatelessWidget {
  final int bookings, listings, reviews;
  const _StatsRow({
    required this.bookings,
    required this.listings,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: _C.cyan.withOpacity(0.04),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            value: '$bookings',
            label: 'Bookings',
            icon: Icons.calendar_month_rounded,
            color: _C.cyan,
          ),
          _vDivider(),
          _StatItem(
            value: '$listings',
            label: 'Listings',
            icon: Icons.home_work_outlined,
            color: _C.blue,
          ),
          _vDivider(),
          _StatItem(
            value: '$reviews',
            label: 'Reviews',
            icon: Icons.star_rounded,
            color: _C.violet,
          ),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.07));
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: _C.textDim,
            letterSpacing: 0.4,
          ),
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════
//  INFO CARD
// ═══════════════════════════════════════════════════════
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.03),
      border: Border.all(color: Colors.white.withOpacity(0.07)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _C.cyan, size: 15),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: _C.textMid,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Divider(color: Colors.white.withOpacity(0.06)),
        const SizedBox(height: 4),
        ...children,
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _C.cyan.withOpacity(0.08),
            border: Border.all(color: _C.cyan.withOpacity(0.15)),
          ),
          child: Icon(icon, color: _C.cyan, size: 16),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: _C.textDim,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════
//  RATING CARD
// ═══════════════════════════════════════════════════════
class _RatingCard extends StatelessWidget {
  final double rating;
  final int reviews;
  const _RatingCard({required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_C.violet.withOpacity(0.12), _C.cyan.withOpacity(0.06)],
        ),
        border: Border.all(color: _C.violet.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          // Big rating number
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ).createShader(b),
                child: Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (i) {
                  final filled = i < rating.floor();
                  final half = !filled && i < rating;
                  return Icon(
                    half ? Icons.star_half_rounded : Icons.star_rounded,
                    color: filled || half
                        ? const Color(0xFFFFD700)
                        : Colors.white.withOpacity(0.15),
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '$reviews reviews',
                style: const TextStyle(
                  fontSize: 11,
                  color: _C.textDim,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Mini bar chart
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [5, 4, 3, 2, 1].map((star) {
              final frac = star == 5
                  ? 0.72
                  : star == 4
                  ? 0.18
                  : star == 3
                  ? 0.06
                  : star == 2
                  ? 0.02
                  : 0.02;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$star',
                      style: const TextStyle(fontSize: 10, color: _C.textDim),
                    ),
                    const SizedBox(width: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 100,
                        height: 6,
                        child: Stack(
                          children: [
                            Container(color: Colors.white.withOpacity(0.06)),
                            FractionallySizedBox(
                              widthFactor: frac,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFD700),
                                      Color(0xFFFFA500),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  AMENITIES CARD
// ═══════════════════════════════════════════════════════
class _AmenitiesCard extends StatelessWidget {
  final List<String> amenities;
  const _AmenitiesCard({required this.amenities});

  static const _icons = <String, IconData>{
    'Swimming Pool': Icons.pool_rounded,
    'Hot Tub': Icons.hot_tub_rounded,
    'BBQ Grill': Icons.outdoor_grill_rounded,
    'Wi-Fi': Icons.wifi_rounded,
    'Parking': Icons.local_parking_rounded,
    'Pet Friendly': Icons.pets_rounded,
    'Bonfire Pit': Icons.local_fire_department_rounded,
    'Hiking Trail': Icons.terrain_rounded,
    'Fishing': Icons.set_meal_rounded,
    'Horse Riding': Icons.emoji_nature_rounded,
    'Orchard': Icons.park_rounded,
    'Kids Play': Icons.child_friendly_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_border_rounded, color: _C.cyan, size: 15),
              const SizedBox(width: 8),
              const Text(
                'AMENITIES',
                style: TextStyle(
                  color: _C.textMid,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.white.withOpacity(0.06)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: amenities.map((a) {
              final icon = _icons[a] ?? Icons.check_circle_outline;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF003D55), Color(0xFF1A0A40)],
                  ),
                  border: Border.all(
                    color: _C.cyan.withOpacity(0.35),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _C.cyan.withOpacity(0.10),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: _C.cyan, size: 13),
                    const SizedBox(width: 6),
                    Text(
                      a,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  ACTION BUTTONS
// ═══════════════════════════════════════════════════════
class _ActionButtons extends StatelessWidget {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0B1426), Color(0xFF030712)],
              ),
              border: Border.all(
                color: const Color(0xFF00CFFF).withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00CFFF).withOpacity(0.25),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logout Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00CFFF), Color(0xFF3B82F6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00CFFF).withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Are you sure you want to logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF7DB8D4), fontSize: 14),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Logout Button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: const Color(0xFFEF4444),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final VoidCallback onEdit, onLogout;
  const _ActionButtons({required this.onEdit, required this.onLogout});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      // // Edit Profile
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfile()),
          );
        },

        // onTap: onEdit,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [_C.cyan, _C.blue, _C.violet],
              stops: [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: _C.cyan.withOpacity(0.28),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_outlined, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () {
          _showLogoutDialog(context);
        },
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
