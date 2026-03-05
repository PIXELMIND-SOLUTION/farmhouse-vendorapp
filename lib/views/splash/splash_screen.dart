import 'dart:math' as math;
import 'package:farmhouse_vendor/helper/shared_preference.dart';
import 'package:farmhouse_vendor/views/auth/login_screen.dart';
import 'package:farmhouse_vendor/views/navbar/navbar_screen.dart';
import 'package:flutter/material.dart';

class _C {
  static const bg0 = Color(0xFF030712);
  static const bg1 = Color(0xFF0B1426);
  static const bg2 = Color(0xFF0F1E38);
  static const cyan = Color(0xFF00CFFF);
  static const blue = Color(0xFF3B82F6);
  static const violet = Color(0xFF8B5CF6);
  static const textDim = Color(0xFF4D7A99);
  static const textMid = Color(0xFF7DB8D4);
}

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

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.shortestSide * 0.42;
    for (int i = 0; i < 3; i++) {
      final t = ((progress - i * 0.25) / 0.75).clamp(0.0, 1.0);
      if (t == 0) continue;
      final eased = Curves.easeOutCubic.transform(t);
      canvas.drawCircle(
        center,
        maxR * 0.55 + maxR * 0.45 * eased,
        Paint()
          ..color = _C.cyan.withOpacity((1 - eased) * 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.progress != progress;
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

// ═══════════════════════════════════════════════════════
//  HEX LOGO
// ═══════════════════════════════════════════════════════
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
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E2A45), Color(0xFF1A1040)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_C.cyan, _C.violet],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
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
          child: Icon(
            Icons.bolt_rounded,
            size: size * 0.44,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════
//  SPLASH SCREEN
// ═══════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl,
      _particleCtrl,
      _ringCtrl,
      _logoCtrl,
      _textCtrl,
      _barCtrl,
      _pulseCtrl,
      _exitCtrl;

  late final Animation<double> _bgAnim,
      _logoScale,
      _logoOpacity,
      _logoRotate,
      _titleOpacity,
      _taglineOpacity,
      _barWidth,
      _barOpacity,
      _pulse,
      _exitAnim;
  late final Animation<Offset> _titleSlide, _taglineSlide;

  final _particles = <_Particle>[];
  final _rng = math.Random(42);

  @override
  void initState() {
    super.initState();
    _buildParticles();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeIn);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _logoRotate = Tween(
      begin: -0.3,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _taglineOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
      ),
    );
    _taglineSlide = Tween(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textCtrl,
            curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
          ),
        );

    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _barWidth = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _barCtrl, curve: Curves.easeInOut));
    _barOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _barCtrl,
        curve: const Interval(0.0, 0.15, curve: Curves.easeIn),
      ),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = Tween(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Exit fade-out
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _exitAnim = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));

    // Sequence
    _bgCtrl.forward().then((_) {
      _logoCtrl.forward().then((_) {
        _textCtrl.forward();
        _barCtrl.forward().then((_) => _navigateToLogin());
      });
    });
  }

  void _buildParticles() {
    for (int i = 0; i < 60; i++) {
      _particles.add(
        _Particle(
          x: _rng.nextDouble(),
          y: _rng.nextDouble(),
          radius: _rng.nextDouble() * 1.8 + 0.4,
          speed: _rng.nextDouble() * 0.12 + 0.03,
          angle: _rng.nextDouble() * math.pi * 2,
          opacity: _rng.nextDouble() * 0.5 + 0.1,
        ),
      );
    }
  }

  // Future<void> _navigateToLogin() async {
  //   await _exitCtrl.forward();
  //   if (!mounted) return;
  //   Navigator.of(context).pushReplacement(
  //     PageRouteBuilder(
  //       transitionDuration: const Duration(milliseconds: 700),
  //       pageBuilder: (_, __, ___) => const LoginScreen(),
  //       transitionsBuilder: (_, anim, __, child) => FadeTransition(
  //         opacity: anim,
  //         child: child,
  //       ),
  //     ),
  //   );
  // }

  Future<void> _navigateToLogin() async {
    await _exitCtrl.forward();
    if (!mounted) return;

    final loggedIn = await SharedPrefHelper.isLoggedIn();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) =>
            loggedIn ? const NavbarScreen() : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in [
      _bgCtrl,
      _particleCtrl,
      _ringCtrl,
      _logoCtrl,
      _textCtrl,
      _barCtrl,
      _pulseCtrl,
      _exitCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _C.bg0,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _bgAnim,
          _particleCtrl,
          _ringCtrl,
          _logoCtrl,
          _textCtrl,
          _barCtrl,
          _pulseCtrl,
          _exitAnim,
        ]),
        builder: (context, _) {
          return Opacity(
            opacity: _exitCtrl.isAnimating ? _exitAnim.value : 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background
                Opacity(
                  opacity: _bgAnim.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0, -0.3),
                        radius: 1.2,
                        colors: [_C.bg2, _C.bg1, _C.bg0],
                        stops: [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                // Grid
                Opacity(
                  opacity: _bgAnim.value * 0.12,
                  child: CustomPaint(painter: _GridPainter()),
                ),
                // Particles
                CustomPaint(
                  painter: _ParticlePainter(_particles, _particleCtrl.value),
                ),
                // Rings
                CustomPaint(painter: _RingPainter(_ringCtrl.value)),
                // Content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: _pulse.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Transform.rotate(
                              angle: _logoRotate.value,
                              child: _LogoHex(size: size.shortestSide * 0.26),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.038),
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: ShaderMask(
                            shaderCallback: (b) => const LinearGradient(
                              colors: [_C.cyan, _C.blue, _C.violet],
                              stops: [0.0, 0.5, 1.0],
                            ).createShader(b),
                            child: const Text(
                              'VFARMS',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 10,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _taglineOpacity,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: const Text(
                            'BEYOND INTELLIGENCE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 5,
                              color: _C.textMid,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.09),
                      FadeTransition(
                        opacity: _barOpacity,
                        child: SizedBox(
                          width: size.width * 0.52,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: SizedBox(
                                  height: 2,
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.white.withOpacity(0.08),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: _barWidth.value,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [_C.cyan, _C.violet],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _C.cyan,
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _barWidth.value < 1.0
                                    ? 'Initializing...'
                                    : 'Ready',
                                style: const TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 2.5,
                                  color: _C.textDim,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _taglineOpacity,
                    child: const Text(
                      'v 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 2,
                        color: Color(0xFF2C4A5E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
