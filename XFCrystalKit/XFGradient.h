//
//  XFGradient.h
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/11.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR_LEVEL(_selector_, _alpha_) [([UIColor _selector_])colorWithAlphaComponent:_alpha_]
//The most commonly used gradients are white-to-black, white-to-clear, and black-to-clear.
//This macro returns a grayscale color at the white and alpha levels you specify. White levels may range from 0 (black) to 1 (white), alpha levels from 0 (clear) to 1 (opaque).
#define WHITE_LEVEL(_amt_, _alpha_) [UIColor colorWithWhite:(_amt_) alpha:(_alpha_)]


// Gradient drawing styles
#define LIMIT_GRADIENT_EXTENT 0
#define BEFORE_START kCGGradientDrawsBeforeStartLocation
#define AFTER_END kCGGradientDrawsAfterEndLocation
#define KEEP_DRAWING kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation

typedef CGFloat (^InterpolationBlock)(CGFloat percent);

/**
 *  这个对CGGradientRef结构体包装的OC类
 */
@interface XFGradient : NSObject

@property (nonatomic, readonly) CGGradientRef gradient;

// Primary entry point for the class. Construct a gradient
// with the supplied colors and locations
+ (instancetype) gradientWithColors: (NSArray *) colorsArray
                          locations: (NSArray *) locationArray;
// 建立从color1到color2的Gradient
+ (instancetype) gradientFrom: (UIColor *) color1 to: (UIColor *) color2;

// 彩虹色的渐变
+ (instancetype) rainbow;
// Build a custom gradient using the supplied block to
// interpolate between the start and end colors
+ (instancetype) gradientUsingInterpolationBlock:(InterpolationBlock) block
                                         between: (UIColor *) c1 and: (UIColor *) c2;
// 各种缓冲渐变快速方法
+ (instancetype) easeInGradientBetween: (UIColor *) c1 and:(UIColor *) c2;
+ (instancetype) easeInOutGradientBetween: (UIColor *) c1 and:(UIColor *) c2;
+ (instancetype) easeOutGradientBetween: (UIColor *) c1 and:(UIColor *) c2;
// 线型光泽渐变
+ (instancetype) linearGloss:(UIColor *) color;

// Linear
// Draw a linear gradient between the two points
- (void) drawFrom: (CGPoint) p1
          toPoint: (CGPoint) p2 style: (int) mask;
- (void) drawFrom:(CGPoint) p1 toPoint: (CGPoint) p2;
- (void) drawTopToBottom: (CGRect) rect;
- (void) drawBottomToTop: (CGRect) rect;
- (void) drawLeftToRight: (CGRect) rect;
// 旋转填充
- (void) drawAlongAngle: (CGFloat) angle in:(CGRect) rect;




// Radial
/**
 *  Draw a radial gradient between the two points
 *
 *  @param p1    起始点
 *  @param p2    终点
 *  @param radii 起点半径与终点半径
 *  @param mask  填充模式
 */
- (void) drawRadialFrom:(CGPoint) p1
                toPoint: (CGPoint) p2 radii: (CGPoint) radii
                  style: (int) mask;
/**
 *  绘制由中心向外扩展的渐变填充
 *
 *  @param p1 起始点
 *  @param p2 终点
 */
- (void) drawRadialFrom: (CGPoint) p1 toPoint: (CGPoint) p2;
/**
 *  在矩形范围内绘制由中心向外扩展的渐变填充(有浑浊效果)
 *
 *  @param rect 矩形范围
 */
- (void) drawBasicRadial: (CGRect) rect;
/**
 *  在矩形范围内绘制由中心向外扩展的渐变填充(有色彩平滑过度效果，精致的)
 *
 *  @param rect 矩形范围
 */
- (void)drawArtisticRadial:(CGRect)rect;

@end
