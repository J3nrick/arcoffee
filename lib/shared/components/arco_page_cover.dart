import 'package:flutter/cupertino.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_typography.dart';
import 'arco_logo.dart';

/// Full-bleed photographic page opener shared by every top-level page.
/// Photograph with a slow push-in, masthead metadata, an oversized title,
/// and a lede + actions row, all revealed in sequence.
class ArcoPageCover extends StatefulWidget {
  final String index;
  final String kicker;
  final String title;
  final String lede;
  final String imageAsset;
  final String caption;
  final Alignment imageAlignment;
  final List<Widget> actions;
  final double heightFactor;

  const ArcoPageCover({
    super.key,
    required this.index,
    required this.kicker,
    required this.title,
    required this.lede,
    required this.imageAsset,
    this.caption = '',
    this.imageAlignment = Alignment.center,
    this.actions = const [],
    this.heightFactor = 0.82,
  });

  @override
  State<ArcoPageCover> createState() => _ArcoPageCoverState();
}

class _ArcoPageCoverState extends State<ArcoPageCover> with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  late final AnimationController _pushIn = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.isReducedMotion(context)) {
      _intro.value = 1;
      _pushIn.stop();
    } else if (!_intro.isAnimating && _intro.value == 0) {
      _intro.forward();
      _pushIn.forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _pushIn.dispose();
    super.dispose();
  }

  Widget _reveal(Widget child, double start) {
    final curve = CurvedAnimation(
      parent: _intro,
      curve: Interval(start, (start + 0.55).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curve,
      child: child,
      builder: (context, child) => Opacity(
        opacity: curve.value,
        child: Transform.translate(offset: Offset(0, 28 * (1 - curve.value)), child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = AppBreakpoints.isMobile(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final pad = AppBreakpoints.horizontalPadding(context);
    final height = (size.height * widget.heightFactor).clamp(isMobile ? 520.0 : 560.0, 940.0);
    final titleSize = (size.width * (isMobile ? 0.15 : 0.1)).clamp(50.0, 160.0);

    final mastStyle = AppTypography.scoreboard.copyWith(
      fontSize: isMobile ? 10.5 : 12,
      letterSpacing: 2.2,
      fontWeight: FontWeight.w700,
      color: AppColors.warmCream.withValues(alpha: 0.85),
    );

    final lede = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Text(
        widget.lede,
        style: AppTypography.bodyLarge.copyWith(
          fontSize: isMobile ? 15 : 17,
          height: 1.55,
          color: AppColors.warmCream.withValues(alpha: 0.85),
        ),
      ),
    );
    final actions = Wrap(
      spacing: 28,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widget.actions,
    );

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: AnimatedBuilder(
              animation: _pushIn,
              builder: (context, child) => Transform.scale(
                scale: 1.02 + 0.08 * Curves.easeOut.transform(_pushIn.value),
                child: child,
              ),
              child: Image.asset(
                widget.imageAsset,
                fit: BoxFit.cover,
                alignment: widget.imageAlignment,
              ),
            ),
          ),
          // Legibility scrim: the type sits directly on the photograph.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xF00B1B2B), Color(0x990B1B2B), Color(0x260B1B2B)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(pad, isMobile ? 28 : 40, pad, isMobile ? 32 : 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _reveal(
                      Row(
                        children: [
                          const ArcoLogo(height: 18, showText: false, color: AppColors.accentOrange),
                          const SizedBox(width: 14),
                          Text(widget.index, style: mastStyle.copyWith(color: AppColors.accentOrange)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              widget.kicker,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: mastStyle,
                            ),
                          ),
                        ],
                      ),
                      0.0,
                    ),
                    const Spacer(),
                    _reveal(
                      Text(
                        widget.title,
                        style: AppTypography.displayXL.copyWith(
                          fontSize: titleSize,
                          height: 0.88,
                          letterSpacing: -titleSize * 0.045,
                          fontWeight: FontWeight.w900,
                          color: AppColors.warmCream,
                        ),
                      ),
                      0.12,
                    ),
                    SizedBox(height: isMobile ? 20 : 32),
                    _reveal(
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: lede),
                                const SizedBox(width: 48),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (widget.actions.isNotEmpty) actions,
                                    if (widget.caption.isNotEmpty) ...[
                                      const SizedBox(height: 18),
                                      Text(widget.caption, style: mastStyle.copyWith(fontSize: 10.5)),
                                    ],
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                lede,
                                if (widget.actions.isNotEmpty) ...[const SizedBox(height: 24), actions],
                              ],
                            ),
                      0.3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
