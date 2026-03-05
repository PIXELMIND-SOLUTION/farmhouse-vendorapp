import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ═══════════════════════════════════════════════════════
//  SHARED COLOR PALETTE
// ═══════════════════════════════════════════════════════
class _C {
  static const bg0 = Color(0xFF030712);
  static const bg1 = Color(0xFF0B1426);
  static const cyan = Color(0xFF00CFFF);
  static const blue = Color(0xFF3B82F6);
  static const violet = Color(0xFF8B5CF6);
  static const green = Color(0xFF22C55E);
  static const textDim = Color(0xFF4D7A99);
  static const textMid = Color(0xFF7DB8D4);
}

// ═══════════════════════════════════════════════════════
//  PAINTERS (reused from ProfileScreen)
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

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = math.pi / 6 + (math.pi / 3) * i;
      final x = cx + r * math.cos(a), y = cy + r * math.sin(a);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1F38), Color(0xFF120E30)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

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

class _BannerLinePainter extends CustomPainter {
  final double progress;
  const _BannerLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _C.violet.withOpacity(0.07)
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final x = size.width * (i / 7.0);
      canvas.drawLine(
        Offset(x - size.height * 0.5, 0),
        Offset(x + size.height * 0.5, size.height),
        paint,
      );
    }

    final scanY = size.height * ((progress + 0.0) % 1.0);
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      Paint()
        ..color = _C.violet.withOpacity(0.18)
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(_BannerLinePainter o) => o.progress != progress;
}

// ═══════════════════════════════════════════════════════
//  EDIT PROFILE SCREEN
// ═══════════════════════════════════════════════════════
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _hexCtrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _staggerCount = 8;

  File? _avatar;
  final _picker = ImagePicker();
  bool _isSaving = false;

  // ── Form controllers ──────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _farmNameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;
  late final TextEditingController _descCtrl;

  // ── Amenities toggle state ────────────────────────────
  final Map<String, bool> _amenityState = {
    'Swimming Pool': true,
    'BBQ Grill': true,
    'Wi-Fi': true,
    'Bonfire Pit': true,
    'Horse Riding': true,
    'Parking': true,
    'Hot Tub': false,
    'Pet Friendly': false,
    'Hiking Trail': false,
    'Fishing': false,
    'Orchard': false,
    'Kids Play': false,
  };

  static const _amenityIcons = <String, IconData>{
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
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: 'Ravi Kumar');
    _farmNameCtrl = TextEditingController(text: 'Green Horizon Farms');
    _mobileCtrl = TextEditingController(text: '+91 98765 43210');
    _locationCtrl = TextEditingController(text: 'Hyderabad, Telangana');
    _latCtrl = TextEditingController(text: '17.3850° N');
    _lngCtrl = TextEditingController(text: '78.4867° E');
    _descCtrl = TextEditingController(
      text:
          'A serene retreat nestled in the heart of Telangana, offering authentic farm experiences.',
    );

    _hexCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnims = List.generate(_staggerCount, (i) {
      final s = i * 0.10, e = (s + 0.40).clamp(0.0, 1.0);
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _enterCtrl,
          curve: Interval(s, e, curve: Curves.easeOut),
        ),
      );
    });
    _slideAnims = List.generate(_staggerCount, (i) {
      final s = i * 0.10, e = (s + 0.45).clamp(0.0, 1.0);
      return Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(
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
    _nameCtrl.dispose();
    _farmNameCtrl.dispose();
    _mobileCtrl.dispose();
    _locationCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final p = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (p != null) setState(() => _avatar = File(p.path));
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isSaving = false);
    _showSavedSnack();
    Navigator.maybePop(context);
  }

  void _showSavedSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [_C.green.withOpacity(0.20), _C.cyan.withOpacity(0.10)],
            ),
            border: Border.all(color: _C.green.withOpacity(0.45)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: _C.green, size: 18),
              SizedBox(width: 10),
              Text(
                'Profile updated successfully!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                    colors: [Color(0xFF12093A), _C.bg1, _C.bg0],
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
                      colors: [
                        _C.violet.withOpacity(0.18),
                        Colors.transparent,
                      ],
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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Header banner
                        _buildHeader(size),

                        // Avatar overlap spacer
                        const SizedBox(height: 64),

                        // Change photo label
                        _staggered(
                          1,
                          GestureDetector(
                            onTap: _pickAvatar,
                            child: Column(
                              children: [
                                Text(
                                  'Tap to change photo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _C.cyan.withOpacity(0.8),
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  width: 80,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        _C.cyan.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),

                              // Personal Info Section
                              _staggered(
                                2,
                                _SectionCard(
                                  title: 'PERSONAL INFORMATION',
                                  icon: Icons.person_outline_rounded,
                                  children: [
                                    _EditField(
                                      controller: _nameCtrl,
                                      label: 'Full Name',
                                      icon: Icons.badge_outlined,
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'Name is required'
                                              : null,
                                    ),
                                    const SizedBox(height: 14),
                                    _EditField(
                                      controller: _mobileCtrl,
                                      label: 'Mobile Number',
                                      icon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'Mobile is required'
                                              : null,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Farm Details Section
                              _staggered(
                                3,
                                _SectionCard(
                                  title: 'FARM DETAILS',
                                  icon: Icons.agriculture_outlined,
                                  accentColor: _C.blue,
                                  children: [
                                    _EditField(
                                      controller: _farmNameCtrl,
                                      label: 'Farm Name',
                                      icon: Icons.storefront_outlined,
                                      accentColor: _C.blue,
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'Farm name is required'
                                              : null,
                                    ),
                                    const SizedBox(height: 14),
                                    _EditField(
                                      controller: _locationCtrl,
                                      label: 'Location',
                                      icon: Icons.location_on_outlined,
                                      accentColor: _C.blue,
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _EditField(
                                            controller: _latCtrl,
                                            label: 'Latitude',
                                            icon: Icons.my_location_rounded,
                                            accentColor: _C.blue,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _EditField(
                                            controller: _lngCtrl,
                                            label: 'Longitude',
                                            icon: Icons.explore_outlined,
                                            accentColor: _C.blue,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    _EditField(
                                      controller: _descCtrl,
                                      label: 'Farm Description',
                                      icon: Icons.description_outlined,
                                      accentColor: _C.blue,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Amenities Section
                              _staggered(4, _AmenitiesEditCard(
                                amenityState: _amenityState,
                                amenityIcons: _amenityIcons,
                                onToggle: (key, val) =>
                                    setState(() => _amenityState[key] = val),
                              )),

                              const SizedBox(height: 16),
                              const SizedBox(height: 24),

                              // Save / Cancel buttons
                              _staggered(6, _SaveButtons(
                                isSaving: _isSaving,
                                onSave: _handleSave,
                                onCancel: () => Navigator.maybePop(context),
                              )),

                              const SizedBox(height: 36),
                            ],
                          ),
                        ),
                      ],
                    ),
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
              colors: [Color(0xFF1A0A3A), Color(0xFF0D1E44), _C.bg1],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size(size.width, 180),
                painter: _BannerLinePainter(_hexCtrl.value),
              ),
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
                          colors: [_C.violet, _C.blue, _C.cyan],
                        ).createShader(b),
                        child: const Text(
                          'EDIT PROFILE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Balance spacer
                      const SizedBox(width: 38),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Avatar — overlaps banner
        Positioned(
          bottom: -54,
          child: _staggered(
            1,
            GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
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
                                      Color(0xFF180E30),
                                      Color(0xFF0A2A42),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'RK',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: _C.violet,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  // Edit badge
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_C.violet, _C.blue],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _C.violet.withOpacity(0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 54),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
//  SECTION CARD
// ═══════════════════════════════════════════════════════
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color accentColor;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.accentColor = _C.cyan,
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
            Icon(icon, color: accentColor, size: 15),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: accentColor.withOpacity(0.85),
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
        ...children,
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════
//  EDIT FIELD
// ═══════════════════════════════════════════════════════
class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color accentColor;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    this.accentColor = _C.cyan,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
      cursorColor: accentColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 12,
          color: _C.textDim,
          letterSpacing: 0.3,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 11,
          color: accentColor.withOpacity(0.85),
          letterSpacing: 0.5,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14, right: 10),
          child: Icon(icon, color: accentColor, size: 16),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: accentColor.withOpacity(0.04),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: accentColor.withOpacity(0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: accentColor.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: accentColor.withOpacity(0.6), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontSize: 11,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  AMENITIES EDIT CARD
// ═══════════════════════════════════════════════════════
class _AmenitiesEditCard extends StatelessWidget {
  final Map<String, bool> amenityState;
  final Map<String, IconData> amenityIcons;
  final void Function(String, bool) onToggle;

  const _AmenitiesEditCard({
    required this.amenityState,
    required this.amenityIcons,
    required this.onToggle,
  });

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
              const Icon(
                Icons.star_border_rounded,
                color: _C.green,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(
                'AMENITIES',
                style: TextStyle(
                  color: _C.green.withOpacity(0.85),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              Text(
                '${amenityState.values.where((v) => v).length} selected',
                style: const TextStyle(
                  fontSize: 11,
                  color: _C.textDim,
                  letterSpacing: 0.3,
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
            children: amenityState.entries.map((entry) {
              final isOn = entry.value;
              final icon =
                  amenityIcons[entry.key] ?? Icons.check_circle_outline;
              return GestureDetector(
                onTap: () => onToggle(entry.key, !isOn),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: isOn
                        ? const LinearGradient(
                            colors: [Color(0xFF003D55), Color(0xFF1A0A40)],
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.03),
                              Colors.white.withOpacity(0.03),
                            ],
                          ),
                    border: Border.all(
                      color: isOn
                          ? _C.green.withOpacity(0.45)
                          : Colors.white.withOpacity(0.10),
                      width: 1.2,
                    ),
                    boxShadow: isOn
                        ? [
                            BoxShadow(
                              color: _C.green.withOpacity(0.12),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOn ? icon : Icons.add_rounded,
                        color: isOn ? _C.green : _C.textDim,
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 12,
                          color: isOn ? Colors.white : _C.textDim,
                          fontWeight: isOn
                              ? FontWeight.w500
                              : FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
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
//  SAVE / CANCEL BUTTONS
// ═══════════════════════════════════════════════════════
class _SaveButtons extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _SaveButtons({
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Save button
        GestureDetector(
          onTap: isSaving ? null : onSave,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: isSaving
                  ? LinearGradient(
                      colors: [
                        _C.violet.withOpacity(0.5),
                        _C.blue.withOpacity(0.5),
                        _C.cyan.withOpacity(0.5),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    )
                  : const LinearGradient(
                      colors: [_C.violet, _C.blue, _C.cyan],
                      stops: [0.0, 0.5, 1.0],
                    ),
              boxShadow: [
                BoxShadow(
                  color: _C.violet.withOpacity(0.30),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Center(
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Save Changes',
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
        ),
        const SizedBox(height: 12),
        // Cancel button
        GestureDetector(
          onTap: onCancel,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withOpacity(0.04),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.close_rounded,
                  color: _C.textMid,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _C.textMid,
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
}