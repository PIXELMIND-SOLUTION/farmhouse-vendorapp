// import 'dart:math' as math;
// import 'dart:ui';

// import 'package:flutter/material.dart';

// class _C {
//   static const bg0 = Color(0xFF030712);
//   static const bg1 = Color(0xFF0B1426);
//   static const bg2 = Color(0xFF0F1E38);
//   static const cyan = Color(0xFF00CFFF);
//   static const blue = Color(0xFF3B82F6);
//   static const violet = Color(0xFF8B5CF6);
//   static const textDim = Color(0xFF4D7A99);
//   static const textMid = Color(0xFF7DB8D4);
// }

// class _Particle {
//   double x, y, radius, speed, angle, opacity;
//   _Particle(
//       {required this.x,
//       required this.y,
//       required this.radius,
//       required this.speed,
//       required this.angle,
//       required this.opacity});
// }

// class _ParticlePainter extends CustomPainter {
//   final List<_Particle> particles;
//   final double progress;
//   const _ParticlePainter(this.particles, this.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final p in particles) {
//       final dx = math.cos(p.angle) * p.speed * progress * size.width * 0.5;
//       final dy = math.sin(p.angle) * p.speed * progress * size.height * 0.5;
//       canvas.drawCircle(
//         Offset(p.x * size.width + dx, p.y * size.height + dy),
//         p.radius,
//         Paint()
//           ..color = Colors.white.withOpacity(p.opacity * (1 - progress * 0.4))
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(_ParticlePainter o) => o.progress != progress;
// }

// class _RingPainter extends CustomPainter {
//   final double progress;
//   const _RingPainter(this.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final maxR = size.shortestSide * 0.42;
//     for (int i = 0; i < 3; i++) {
//       final t = ((progress - i * 0.25) / 0.75).clamp(0.0, 1.0);
//       if (t == 0) continue;
//       final eased = Curves.easeOutCubic.transform(t);
//       canvas.drawCircle(
//         center,
//         maxR * 0.55 + maxR * 0.45 * eased,
//         Paint()
//           ..color = _C.cyan.withOpacity((1 - eased) * 0.35)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1.5
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(_RingPainter o) => o.progress != progress;
// }

// class _GridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     const spacing = 28.0;
//     final paint = Paint()..color = Colors.white.withOpacity(0.6);
//     for (double x = 0; x < size.width; x += spacing) {
//       for (double y = 0; y < size.height; y += spacing) {
//         canvas.drawCircle(Offset(x, y), 0.8, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(_GridPainter _) => false;
// }

// // ═══════════════════════════════════════════════════════
// //  HEX LOGO
// // ═══════════════════════════════════════════════════════
// class _HexPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2, cy = size.height / 2;
//     final r = size.shortestSide / 2;
//     final path = Path();
//     for (int i = 0; i < 6; i++) {
//       final a = math.pi / 6 + (math.pi / 3) * i;
//       final x = cx + r * math.cos(a), y = cy + r * math.sin(a);
//       i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
//     }
//     path.close();
//     canvas.drawPath(
//         path,
//         Paint()
//           ..color = _C.cyan.withOpacity(0.25)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18));
//     canvas.drawPath(
//         path,
//         Paint()
//           ..shader = const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF0E2A45), Color(0xFF1A1040)],
//           ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
//     canvas.drawPath(
//         path,
//         Paint()
//           ..shader = const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [_C.cyan, _C.violet],
//           ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1.5);
//   }

//   @override
//   bool shouldRepaint(_HexPainter _) => false;
// }

// class _LogoHex extends StatelessWidget {
//   final double size;
//   const _LogoHex({required this.size});

//   @override
//   Widget build(BuildContext context) => SizedBox(
//         width: size,
//         height: size,
//         child: CustomPaint(
//           painter: _HexPainter(),
//           child: Center(
//             child: ShaderMask(
//               shaderCallback: (b) => const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [_C.cyan, _C.violet],
//               ).createShader(b),
//               child: Icon(Icons.bolt_rounded,
//                   size: size * 0.44, color: Colors.white),
//             ),
//           ),
//         ),
//       );
// }