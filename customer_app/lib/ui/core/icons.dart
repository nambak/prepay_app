import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class AppIcons {
  // 탭바
  static const home =
      '<path d="M4 11l8-7 8 7"/><path d="M6 9.5V20h12V9.5"/><path d="M10 20v-5h4v5"/>';
  static const shop =
      '<path d="M12 21s-7-6.2-7-11a7 7 0 0114 0c0 4.8-7 11-7 11z"/><circle cx="12" cy="10" r="2.5"/>';
  static const wallet =
      '<path d="M4 8h14a2 2 0 012 2v8a2 2 0 01-2 2H6a2 2 0 01-2-2V8z"/><path d="M4 8l11-3.5V8"/><path d="M15.5 14h1.5"/>';
  static const heart =
      '<path d="M12 20s-7.5-4.6-7.5-10.2A4.3 4.3 0 0112 7.2a4.3 4.3 0 017.5 2.6C19.5 15.4 12 20 12 20z"/>';
  static const my =
      '<circle cx="12" cy="8.5" r="3.8"/><path d="M4.5 20a7.5 7.5 0 0115 0"/>';

  // 공통
  static const qr =
      '<rect x="4" y="4" width="6" height="6" rx="1.2"/><rect x="14" y="4" width="6" height="6" rx="1.2"/><rect x="4" y="14" width="6" height="6" rx="1.2"/><path d="M14 14h2.5v2.5H14zM17.5 17.5H20V20h-2.5zM14 19.5h1.5M19.5 14H20"/>';
  static const info =
      '<circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 7.8h.01"/>';
  static const phone =
      '<path d="M5 4h4l2 5-2.5 1.5a11 11 0 005 5L15 13l5 2v4a2 2 0 01-2 2A16 16 0 013 6a2 2 0 012-2z"/>';
  static const chevronRight = '<path d="M9 6l6 6-6 6"/>';
  static const chevronUp = '<path d="M6 15l6-6 6 6"/>';
  static const chevronDown = '<path d="M6 9l6 6 6-6"/>';

  // 업종
  static const cafe =
      '<path d="M5 9h11v5a5 5 0 01-5 5h-1a5 5 0 01-5-5z"/><path d="M16 10h1.5a2.5 2.5 0 010 5H16"/><path d="M8.5 3.5v3M12.5 3.5v3"/>';
  static const food =
      '<path d="M7 3v8M5 3v5a2 2 0 004 0V3M7 11v10"/><path d="M17 3c-2 1.5-3 4-3 7h3v11"/>';
  static const bakery =
      '<path d="M4 19h16v-5H4z"/><path d="M4 14c1.3 1 2.7 1 4 0s2.7-1 4 0 2.7 1 4 0 2.7-1 4 0"/><path d="M8 10V7.5M12 10V5.5M16 10V7.5"/>';
  static const beauty =
      '<circle cx="6.5" cy="7" r="2.5"/><circle cx="6.5" cy="17" r="2.5"/><path d="M8.6 8.4L20 18M8.6 15.6L20 6"/>';
  static const store =
      '<path d="M5 8h14l-1 12H6z"/><path d="M9 8V6.5a3 3 0 016 0V8"/>';
}

// 선 아이콘. 색을 안 주면 주변 IconTheme 색을 따름
class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.paths, {
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 1.8,
  });

  final String paths;
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '<svg viewBox="0 0 24 24" fill="none" stroke="black" stroke-width="$strokeWidth" '
      'stroke-linecap="round" stroke-linejoin="round">$paths</svg>',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? IconTheme.of(context).color!,
        BlendMode.srcIn,
      ),
    );
  }
}
