
// ignore_for_file: unused_element_parameter

import 'dart:math' as math;
import 'dart:io';
import 'package:farmhouse_vendor/views/navbar/navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class _C {
  static const bg0 = Color(0xFF030712);
  static const bg1 = Color(0xFF0B1426);
  // static const bg2 = Color(0xFF0F1E38);
  static const cyan = Color(0xFF00CFFF);
  static const blue = Color(0xFF3B82F6);
  static const violet = Color(0xFF8B5CF6);
  static const textDim = Color(0xFF4D7A99);
  static const textMid = Color(0xFF7DB8D4);
}

// ═══════════════════════════════════════════════════════
//  AMENITY MODEL
// ═══════════════════════════════════════════════════════
class _Amenity {
  final String label;
  final IconData icon;
  bool selected;
  // _Amenity({required this.label, required this.icon, this.selected = false});
    _Amenity({required this.label, required this.icon, this.selected = false});

}

// ═══════════════════════════════════════════════════════
//  PARTICLE MODEL
// ═══════════════════════════════════════════════════════
class _Particle {
  double x, y, radius, speed, angle, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.angle,
    required this.opacity,
  });
}

// ═══════════════════════════════════════════════════════
//  PAINTERS
// ═══════════════════════════════════════════════════════
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  const _ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dx = math.cos(p.angle) * p.speed * progress * size.width * 0.5;
      final dy = math.sin(p.angle) * p.speed * progress * size.height * 0.5;
      canvas.drawCircle(
        Offset(p.x * size.width + dx, p.y * size.height + dy),
        p.radius,
        Paint()
          ..color = Colors.white.withOpacity(p.opacity * (1 - progress * 0.4))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter o) => o.progress != progress;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 28.0;
    final paint = Paint()..color = Colors.white.withOpacity(0.6);
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

class _HexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = size.shortestSide / 2;
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
          ..color = _C.cyan.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18));
    canvas.drawPath(
        path,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E2A45), Color(0xFF1A1040)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(
        path,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_C.cyan, _C.violet],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(_HexPainter _) => false;
}

class _LogoHex extends StatelessWidget {
  final double size;
  const _LogoHex({required this.size});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _HexPainter(),
          child: Center(
            child: ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_C.cyan, _C.violet],
              ).createShader(b),
              child: Icon(Icons.bolt_rounded,
                  size: size * 0.44, color: Colors.white),
            ),
          ),
        ),
      );
}

// ═══════════════════════════════════════════════════════
//  REGISTRATION SCREEN
// ═══════════════════════════════════════════════════════
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _particleCtrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  // ── Form controllers ─────────────────────────────────
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _farmNameCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  File? _farmImage;
  final _picker = ImagePicker();

  final _particles = <_Particle>[];
  final _rng = math.Random(77);

  // ── Amenities ────────────────────────────────────────
  final List<_Amenity> _amenities = [
    _Amenity(label: 'Swimming Pool', icon: Icons.pool_rounded),
    _Amenity(label: 'Hot Tub',       icon: Icons.hot_tub_rounded),
    _Amenity(label: 'BBQ Grill',     icon: Icons.outdoor_grill_rounded),
    _Amenity(label: 'Wi-Fi',         icon: Icons.wifi_rounded),
    _Amenity(label: 'Parking',       icon: Icons.local_parking_rounded),
    _Amenity(label: 'Pet Friendly',  icon: Icons.pets_rounded),
    _Amenity(label: 'Bonfire Pit',   icon: Icons.local_fire_department_rounded),
    _Amenity(label: 'Hiking Trail',  icon: Icons.terrain_rounded),
    _Amenity(label: 'Fishing',       icon: Icons.set_meal_rounded),
    _Amenity(label: 'Horse Riding',  icon: Icons.emoji_nature_rounded),
    _Amenity(label: 'Orchard',       icon: Icons.park_rounded),
    _Amenity(label: 'Kids Play',     icon: Icons.child_friendly_rounded),
  ];

  static const _staggerCount = 9;

  @override
  void initState() {
    super.initState();
    _buildParticles();

    _particleCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();

    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));

    _fadeAnims = List.generate(_staggerCount, (i) {
      final start = i * 0.09;
      final end = (start + 0.40).clamp(0.0, 1.0);
      return Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _enterCtrl,
          curve: Interval(start, end, curve: Curves.easeOut)));
    });
    _slideAnims = List.generate(_staggerCount, (i) {
      final start = i * 0.09;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _enterCtrl,
              curve: Interval(start, end, curve: Curves.easeOut)));
    });

    _enterCtrl.forward();
  }

  void _buildParticles() {
    for (int i = 0; i < 40; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        radius: _rng.nextDouble() * 1.4 + 0.3,
        speed: _rng.nextDouble() * 0.08 + 0.02,
        angle: _rng.nextDouble() * math.pi * 2,
        opacity: _rng.nextDouble() * 0.3 + 0.05,
      ));
    }
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _particleCtrl.dispose();
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _farmNameCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  // ── Image picker ─────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    final picked =
        await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) setState(() => _farmImage = File(picked.path));
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.bg1,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Farmhouse Image',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4)),
            const SizedBox(height: 16),
            _sheetTile(
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            _sheetTile(
              icon: Icons.camera_alt_outlined,
              label: 'Take a Photo',
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_farmImage != null)
              _sheetTile(
                icon: Icons.delete_outline_rounded,
                label: 'Remove Image',
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _farmImage = null);
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _sheetTile(
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color? color}) {
    final c = color ?? _C.textMid;
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(label, style: TextStyle(color: c, fontSize: 14)),
      onTap: onTap,
    );
  }

  // ── Helpers ──────────────────────────────────────────
  Widget _staggered(int i, Widget child) => FadeTransition(
        opacity: _fadeAnims[i],
        child: SlideTransition(position: _slideAnims[i], child: child),
      );

  InputDecoration _inputDeco(String hint, IconData icon,
          {Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: _C.textDim, fontSize: 14, letterSpacing: 0.5),
        prefixIcon: Icon(icon, color: _C.textDim, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.cyan, width: 1.5),
        ),
      );

  // ── Build ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _C.bg0,
      resizeToAvoidBottomInset: true,
      body: AnimatedBuilder(
        animation: Listenable.merge([_enterCtrl, _particleCtrl]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Background ───────────────────────────
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.6, -0.5),
                    radius: 1.2,
                    colors: [Color(0xFF0D2240), _C.bg1, _C.bg0],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: -80, left: -80,
                child: Container(
                  width: 260, height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      _C.cyan.withOpacity(0.15),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
              Positioned(
                bottom: -60, right: -60,
                child: Container(
                  width: 200, height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      _C.violet.withOpacity(0.14),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
              Opacity(
                  opacity: 0.07,
                  child: CustomPaint(painter: _GridPainter())),
              CustomPaint(
                  painter:
                      _ParticlePainter(_particles, _particleCtrl.value)),

              // ── Content ──────────────────────────────
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.04),

                        // Back + Logo
                        _staggered(
                          0,
                          Row(children: [
                            GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  color: Colors.white.withOpacity(0.05),
                                  border: Border.all(
                                      color: Colors.white
                                          .withOpacity(0.08)),
                                ),
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: _C.textMid, size: 16),
                              ),
                            ),
                            const Spacer(),
                            _LogoHex(size: size.shortestSide * 0.13),
                            const Spacer(),
                            const SizedBox(width: 40),
                          ]),
                        ),

                        const SizedBox(height: 20),

                        // Heading
                        _staggered(
                          1,
                          Column(children: [
                            ShaderMask(
                              shaderCallback: (b) =>
                                  const LinearGradient(
                                colors: [_C.cyan, _C.blue, _C.violet],
                                stops: [0.0, 0.5, 1.0],
                              ).createShader(b),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Register your farm on VFARMS',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: _C.textMid,
                                  letterSpacing: 0.3),
                            ),
                          ]),
                        ),

                        SizedBox(height: size.height * 0.032),

                        // Farmhouse image
                        _staggered(
                          2,
                          _FarmImagePicker(
                            image: _farmImage,
                            onTap: _showImageSourceSheet,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Personal Information
                        _staggered(
                          3,
                          _SectionCard(
                            title: 'PERSONAL INFORMATION',
                            icon: Icons.person_outline_rounded,
                            children: [
                              TextField(
                                controller: _nameCtrl,
                                textCapitalization:
                                    TextCapitalization.words,
                                style: _fieldStyle,
                                decoration: _inputDeco(
                                    'Full Name',
                                    Icons.badge_outlined),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _mobileCtrl,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                style: _fieldStyle,
                                decoration: _inputDeco(
                                    'Mobile Number',
                                    Icons.phone_outlined),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Farm Details
                        _staggered(
                          4,
                          _SectionCard(
                            title: 'FARM DETAILS',
                            icon: Icons.agriculture_outlined,
                            children: [
                              // TextField(
                              //   controller: _farmNameCtrl,
                              //   textCapitalization:
                              //       TextCapitalization.words,
                              //   style: _fieldStyle,
                              //   decoration: _inputDeco(
                              //       'Farm / Business Name',
                              //       Icons.storefront_outlined),
                              // ),
                              const SizedBox(height: 14),
                              // Latitude & Longitude side-by-side
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _latCtrl,
                                      keyboardType:
                                          const TextInputType
                                              .numberWithOptions(
                                              decimal: true,
                                              signed: true),
                                      style: _fieldStyle,
                                      decoration: _inputDeco(
                                          'Latitude',
                                          Icons.my_location_rounded),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _lngCtrl,
                                      keyboardType:
                                          const TextInputType
                                              .numberWithOptions(
                                              decimal: true,
                                              signed: true),
                                      style: _fieldStyle,
                                      decoration: _inputDeco(
                                          'Longitude',
                                          Icons.explore_outlined),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 12,
                                    color: _C.textDim.withOpacity(0.6)),
                                const SizedBox(width: 5),
                                Text(
                                  'e.g.  17.3850° N ,  78.4867° E',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          _C.textDim.withOpacity(0.6),
                                      letterSpacing: 0.3),
                                ),
                              ]),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Amenities
                        _staggered(
                          5,
                          _SectionCard(
                            title: 'AMENITIES',
                            icon: Icons.star_border_rounded,
                            children: [
                              Text(
                                'Select all amenities available at your farm',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _C.textDim.withOpacity(0.85),
                                    letterSpacing: 0.2),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _amenities.map((a) {
                                  return _AmenityChip(
                                    amenity: a,
                                    onToggle: () => setState(
                                        () => a.selected = !a.selected),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Security
                        _staggered(
                          6,
                          _SectionCard(
                            title: 'SECURITY',
                            icon: Icons.shield_outlined,
                            children: [
                              TextField(
                                controller: _passCtrl,
                                obscureText: _obscurePass,
                                style: _fieldStyle,
                                decoration:
                                    _inputDeco('Password',
                                            Icons.lock_outline_rounded)
                                        .copyWith(
                                  suffixIcon: _ToggleVis(
                                    obscure: _obscurePass,
                                    onTap: () => setState(() =>
                                        _obscurePass = !_obscurePass),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _confirmPassCtrl,
                                obscureText: _obscureConfirm,
                                style: _fieldStyle,
                                decoration: _inputDeco(
                                        'Confirm Password',
                                        Icons.lock_outline_rounded)
                                    .copyWith(
                                  suffixIcon: _ToggleVis(
                                    obscure: _obscureConfirm,
                                    onTap: () => setState(() =>
                                        _obscureConfirm =
                                            !_obscureConfirm),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Register button
                        _staggered(
                          7,
                          _RegisterButton(
                            loading: _loading,
                            onTap: () async {
                              setState(() => _loading = true);
                              await Future.delayed(
                                  const Duration(seconds: 2));
                              if (mounted) {
                                setState(() => _loading = false);
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Sign in link
                        _staggered(
                          8,
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white
                                          .withOpacity(0.4))),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.maybePop(context),
                                child: ShaderMask(
                                  shaderCallback: (b) =>
                                      const LinearGradient(
                                    colors: [_C.cyan, _C.blue],
                                  ).createShader(b),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
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
}

// ── Shared text style ────────────────────────────────────
const _fieldStyle = TextStyle(
    color: Colors.white, fontSize: 14, letterSpacing: 0.3);

// ═══════════════════════════════════════════════════════
//  AMENITY CHIP
// ═══════════════════════════════════════════════════════
class _AmenityChip extends StatelessWidget {
  final _Amenity amenity;
  final VoidCallback onToggle;
  const _AmenityChip({required this.amenity, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final sel = amenity.selected;
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: sel
              ? const LinearGradient(
                  colors: [Color(0xFF003D55), Color(0xFF1A0A40)],
                )
              : null,
          color: sel ? null : Colors.white.withOpacity(0.04),
          border: Border.all(
            color: sel
                ? _C.cyan.withOpacity(0.7)
                : Colors.white.withOpacity(0.09),
            width: sel ? 1.5 : 1,
          ),
          boxShadow: sel
              ? [
                  BoxShadow(
                    color: _C.cyan.withOpacity(0.18),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(amenity.icon,
                size: 15,
                color: sel ? _C.cyan : _C.textDim),
            const SizedBox(width: 6),
            Text(
              amenity.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    sel ? FontWeight.w600 : FontWeight.w400,
                color: sel ? Colors.white : _C.textDim,
                letterSpacing: 0.2,
              ),
            ),
            if (sel) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle_rounded,
                  size: 13,
                  color: _C.cyan.withOpacity(0.9)),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  FARM IMAGE PICKER
// ═══════════════════════════════════════════════════════
class _FarmImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  const _FarmImagePicker({required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(
            color: image != null
                ? _C.cyan.withOpacity(0.5)
                : Colors.white.withOpacity(0.08),
            width: image != null ? 1.5 : 1,
          ),
          boxShadow: image != null
              ? [
                  BoxShadow(
                      color: _C.cyan.withOpacity(0.08),
                      blurRadius: 24,
                      spreadRadius: 4)
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(image!, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12, right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _C.cyan.withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_outlined,
                              color: _C.cyan, size: 13),
                          SizedBox(width: 5),
                          Text('Change',
                              style: TextStyle(
                                  color: _C.cyan,
                                  fontSize: 11,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12, left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.agriculture_rounded,
                              color: _C.cyan, size: 13),
                          SizedBox(width: 5),
                          Text('Farmhouse',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  letterSpacing: 0.4)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        _C.cyan.withOpacity(0.12),
                        _C.violet.withOpacity(0.12),
                      ]),
                      border: Border.all(
                          color: _C.cyan.withOpacity(0.3),
                          width: 1.5),
                    ),
                    child: const Icon(Icons.add_a_photo_outlined,
                        color: _C.cyan, size: 26),
                  ),
                  const SizedBox(height: 12),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [_C.cyan, _C.blue],
                    ).createShader(b),
                    child: const Text(
                      'Upload Farmhouse Photo',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to choose from gallery or camera',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.3),
                        letterSpacing: 0.2),
                  ),
                ],
              ),
      ),
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

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: _C.cyan.withOpacity(0.03),
            blurRadius: 30,
            spreadRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
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
          ]),
          const SizedBox(height: 4),
          Divider(color: Colors.white.withOpacity(0.06)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  TOGGLE VISIBILITY
// ═══════════════════════════════════════════════════════
class _ToggleVis extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  const _ToggleVis({required this.obscure, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Icon(
          obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: _C.textDim,
          size: 20,
        ),
      );
}

// ═══════════════════════════════════════════════════════
//  REGISTER BUTTON
// ═══════════════════════════════════════════════════════
class _RegisterButton extends StatefulWidget {
  final bool loading;
  final VoidCallback onTap;
  const _RegisterButton({required this.loading, required this.onTap});

  @override
  State<_RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<_RegisterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _pressAnim = Tween(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {

          Navigator.push(context, MaterialPageRoute(builder: (context)=>NavbarScreen()));

          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _pressAnim,
          builder: (_, __) => Transform.scale(
            scale: _pressAnim.value,
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [_C.cyan, _C.blue, _C.violet],
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _C.cyan.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: widget.loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
}