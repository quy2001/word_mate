import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const Shimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.08),
              ],
              stops: const [
                0.15,
                0.5,
                0.85,
              ],
              begin: Alignment(-1.5 + _controller.value * 3, -0.3),
              end: Alignment(-0.5 + _controller.value * 3, 0.3),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const ShimmerContainer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle 
            ? null 
            : (borderRadius ?? BorderRadius.circular(8.r)),
      ),
    );
  }
}

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              
              // GreetingCard Shimmer
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerContainer(width: 140.w, height: 20.h),
                        SizedBox(height: 8.h),
                        ShimmerContainer(width: 100.w, height: 13.h),
                      ],
                    ),
                    Column(
                      children: [
                        const ShimmerContainer(width: 48, height: 48, shape: BoxShape.circle),
                        SizedBox(height: 6.h),
                        ShimmerContainer(width: 50.w, height: 12.h),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // TodayGoalCard Shimmer
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    const ShimmerContainer(width: 80, height: 80, shape: BoxShape.circle),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerContainer(width: 100.w, height: 16.h),
                          SizedBox(height: 8.h),
                          ShimmerContainer(width: 160.w, height: 12.h),
                          SizedBox(height: 6.h),
                          ShimmerContainer(width: 120.w, height: 12.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // StatsRow Shimmer
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      child: Column(
                        children: [
                          const ShimmerContainer(width: 40, height: 40, shape: BoxShape.circle),
                          SizedBox(height: 12.h),
                          ShimmerContainer(width: 40.w, height: 28.h),
                          SizedBox(height: 8.h),
                          ShimmerContainer(width: 80.w, height: 11.h),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      child: Column(
                        children: [
                          const ShimmerContainer(width: 40, height: 40, shape: BoxShape.circle),
                          SizedBox(height: 12.h),
                          ShimmerContainer(width: 40.w, height: 28.h),
                          SizedBox(height: 8.h),
                          ShimmerContainer(width: 85.w, height: 11.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // DueForReviewCard Shimmer
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerContainer(width: 120.w, height: 17.h),
                        ShimmerContainer(width: 110.w, height: 20.h, borderRadius: BorderRadius.circular(12.r)),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: List.generate(3, (index) {
                        final widths = [90.w, 110.w, 100.w];
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShimmerContainer(width: widths[index], height: 14.h),
                              SizedBox(height: 4.h),
                              ShimmerContainer(width: 60.w, height: 12.h),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20.h),
                    ShimmerContainer(height: 48.h, borderRadius: BorderRadius.circular(30.r)),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
