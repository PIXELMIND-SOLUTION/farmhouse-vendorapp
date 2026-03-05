import 'dart:math' as math;

import 'package:farmhouse_vendor/views/auth/registration_screen.dart';
import 'package:farmhouse_vendor/views/navbar/navbar_screen.dart';
import 'package:flutter/material.dart';

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


class _Particle {
  double x, y, radius, speed, angle, opacity;
  _Particle(
      {required this.x,
      required this.y,
      required this.radius,
      required this.speed,
      required this.angle,
      required this.opacity});
}



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



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _particleCtrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  final _particles = <_Particle>[];
  final _rng = math.Random(99);

  @override
  void initState() {
    super.initState();
    _buildParticles();

    _particleCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();

    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    // Stagger 5 items: logo, title, subtitle, fields card, bottom row
    _fadeAnims = List.generate(5, (i) {
      final start = i * 0.12;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _enterCtrl,
          curve: Interval(start, end, curve: Curves.easeOut)));
    });
    _slideAnims = List.generate(5, (i) {
      final start = i * 0.12;
      final end = (start + 0.5).clamp(0.0, 1.0);
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
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Widget _staggered(int i, Widget child) => FadeTransition(
        opacity: _fadeAnims[i],
        child: SlideTransition(position: _slideAnims[i], child: child),
      );

  InputDecoration _inputDecoration(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: _C.textDim, fontSize: 14, letterSpacing: 0.5),
        prefixIcon: Icon(icon, color: _C.textDim, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _C.cyan, width: 1.5),
        ),
      );

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
              // Background
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.6, -0.6),
                    radius: 1.1,
                    colors: [Color(0xFF0D2240), _C.bg1, _C.bg0],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              // Accent blob top-right
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
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
              // Accent blob bottom-left
              Positioned(
                bottom: -60,
                left: -60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _C.cyan.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Grid
              Opacity(
                opacity: 0.07,
                child: CustomPaint(painter: _GridPainter()),
              ),
              // Particles
              CustomPaint(
                  painter:
                      _ParticlePainter(_particles, _particleCtrl.value)),
              // Content
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.07),

                        // ── Logo ──────────────────────────────────
                        _staggered(
                          0,
                          _LogoHex(size: size.shortestSide * 0.18),
                        ),

                        const SizedBox(height: 28),

                        // ── Title ─────────────────────────────────
                        _staggered(
                          1,
                          Column(children: [
                            ShaderMask(
                              shaderCallback: (b) => const LinearGradient(
                                colors: [_C.cyan, _C.blue, _C.violet],
                                stops: [0.0, 0.5, 1.0],
                              ).createShader(b),
                              child: const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sign in to continue to VFARMS',
                              style: TextStyle(
                                fontSize: 13,
                                color: _C.textMid,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ]),
                        ),

                        SizedBox(height: size.height * 0.05),

                        // ── Input card ────────────────────────────
                        _staggered(
                          2,
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white.withOpacity(0.03),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.07)),
                              boxShadow: [
                                BoxShadow(
                                  color: _C.cyan.withOpacity(0.04),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                // Email
                                TextField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 0.3),
                                  decoration: _inputDecoration(
                                      'Email address', Icons.mail_outline_rounded),
                                ),
                                const SizedBox(height: 14),
                                // Password
                                TextField(
                                  controller: _passCtrl,
                                  obscureText: _obscure,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 0.3),
                                  decoration: _inputDecoration(
                                          'Password', Icons.lock_outline_rounded)
                                      .copyWith(
                                    suffixIcon: GestureDetector(
                                      onTap: () =>
                                          setState(() => _obscure = !_obscure),
                                      child: Icon(
                                        _obscure
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: _C.textDim,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Forgot
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: GestureDetector(
                                //     onTap: () {},
                                //     child: const Text(
                                //       'Forgot password?',
                                //       style: TextStyle(
                                //         fontSize: 12,
                                //         color: _C.cyan,
                                //         letterSpacing: 0.3,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(height: 22),
                                // Sign in button
                                _SignInButton(
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
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Divider ───────────────────────────────
                        _staggered(
                          3,
                          Row(children: [
                            Expanded(
                                child: Divider(
                                    color: Colors.white.withOpacity(0.08))),
          
                            Expanded(
                                child: Divider(
                                    color: Colors.white.withOpacity(0.08))),
                          ]),
                        ),

                        const SizedBox(height: 20),
                        _staggered(
                          4,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.4))),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                                },
                                child: ShaderMask(
                                  shaderCallback: (b) =>
                                      const LinearGradient(
                                    colors: [_C.cyan, _C.blue],
                                  ).createShader(b),
                                  child: const Text(
                                    'Sign up',
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

// ═══════════════════════════════════════════════════════
//  SIGN-IN BUTTON
// ═══════════════════════════════════════════════════════
class _SignInButton extends StatefulWidget {
  final bool loading;
  final VoidCallback onTap;
  const _SignInButton({required this.loading, required this.onTap});

  @override
  State<_SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<_SignInButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _pressAnim = Tween(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn));
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
          // _pressCtrl.reverse();
          // widget.onTap();
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
                        'Sign In',
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
