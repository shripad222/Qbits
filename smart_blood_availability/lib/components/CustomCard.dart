import 'package:flutter/material.dart';
import 'dart:ui';

/// Premium Custom Card with stunning visuals
/// Just put your content inside and customize dimensions
/// Glass morphism card style
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool enableHoverEffect;
  final bool enableGlow;

  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.enableGlow = false,
    this.enableHoverEffect = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: width,
      height: height,
      onTap: onTap,
      enableBlur: true,
      blurIntensity: 15,
      backgroundColor: Colors.white.withOpacity(0.1),
      borderGradientColors: [
        Colors.white.withOpacity(0.5),
        Colors.white.withOpacity(0.2),
      ],
      child: child,
    );
  }
}

class CustomCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool enableShadow;
  final bool enableGlow;
  final Color? glowColor;
  final bool enableGradientBorder;
  final List<Color>? borderGradientColors;
  final double borderWidth;
  final bool enableHoverEffect;
  final bool enableBlur;
  final double blurIntensity;
  final bool enableShimmer;
  final AlignmentGeometry alignment;

  const CustomCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.onTap,
    this.borderRadius = 24,
    this.enableShadow = true,
    this.enableGlow = false,
    this.glowColor,
    this.enableGradientBorder = true,
    this.borderGradientColors,
    this.borderWidth = 2,
    this.enableHoverEffect = true,
    this.enableBlur = false,
    this.blurIntensity = 10,
    this.enableShimmer = false,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );

    if (widget.enableShimmer) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default gradient
    final defaultGradient = LinearGradient(
      colors: [
        isDark ? const Color(0xFF1a1a2e) : Colors.white,
        isDark ? const Color(0xFF16213e) : const Color(0xFFF8F9FA),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Border gradient colors
    final borderColors = widget.borderGradientColors ?? [
      theme.primaryColor,
      theme.primaryColor.withOpacity(0.5),
      theme.colorScheme.secondary,
    ];

    return Container(
      margin: widget.margin ?? const EdgeInsets.all(8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedScale(
          scale: widget.enableHoverEffect && _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              children: [
                // Glow effect
                if (widget.enableGlow)
                  Container(
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: (widget.glowColor ?? theme.primaryColor).withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: _isHovered ? 8 : 5,
                        ),
                      ],
                    ),
                  ),

                // Main card with gradient border
                Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: widget.enableGradientBorder
                        ? LinearGradient(colors: borderColors)
                        : null,
                    boxShadow: widget.enableShadow
                        ? [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.5)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: _isHovered ? 30 : 20,
                        offset: Offset(0, _isHovered ? 12 : 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: _isHovered ? 15 : 10,
                        offset: Offset(0, _isHovered ? 6 : 4),
                        spreadRadius: 0,
                      ),
                    ]
                        : null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(widget.borderWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.gradient == null ? (widget.backgroundColor ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white)) : null,
                        gradient: widget.gradient ?? defaultGradient,
                        borderRadius: BorderRadius.circular(widget.borderRadius - widget.borderWidth),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.borderRadius - widget.borderWidth),
                        child: Stack(
                          children: [
                            // Blur effect
                            if (widget.enableBlur)
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: widget.blurIntensity,
                                  sigmaY: widget.blurIntensity,
                                ),
                                child: Container(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),

                            // Content
                            Container(
                              padding: widget.padding ?? const EdgeInsets.all(20),
                              alignment: widget.alignment,
                              child: widget.child,
                            ),

                            // Shimmer effect
                            if (widget.enableShimmer)
                              AnimatedBuilder(
                                animation: _shimmerAnimation,
                                builder: (context, child) {
                                  return Positioned.fill(
                                    child: Transform.translate(
                                      offset: Offset(_shimmerAnimation.value * 200, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.white.withOpacity(0.1),
                                              Colors.transparent,
                                            ],
                                            stops: const [0.0, 0.5, 1.0],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                            // Hover shine effect
                            if (_isHovered && widget.enableHoverEffect)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withOpacity(0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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

// ============================================
// PRESET VARIATIONS - Ready to use styles
// ============================================

/// Neon glow card style
class NeonCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? glowColor;
  final VoidCallback? onTap;

  const NeonCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.glowColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: width,
      height: height,
      onTap: onTap,
      enableGlow: true,
      glowColor: glowColor ?? Colors.cyan,
      borderGradientColors: [
        glowColor ?? Colors.cyan,
        (glowColor ?? Colors.cyan).withOpacity(0.5),
        Colors.purple,
      ],
      gradient: LinearGradient(
        colors: [
          const Color(0xFF0a0e27),
          const Color(0xFF1a1a2e),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
}

/// Premium gradient card
class PremiumCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const PremiumCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: width,
      height: height,
      onTap: onTap,
      enableGlow: true,
      gradient: const LinearGradient(
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
          Color(0xFFf093fb),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradientColors: [
        Colors.white.withOpacity(0.8),
        Colors.white.withOpacity(0.4),
      ],
      child: child,
    );
  }
}

/// Shimmer loading card
class ShimmerCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const ShimmerCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: width,
      height: height,
      enableShimmer: true,
      gradient: LinearGradient(
        colors: [
          Colors.grey[300]!,
          Colors.grey[100]!,
        ],
      ),
      child: child,
    );
  }
}