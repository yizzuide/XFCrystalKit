//
//  XFGradient.m
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/11.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "XFGradient.h"
#import "XFCrystalKit.h"

// 定义从Core Foundation结构体到OC的ARC管理下对象
typedef __attribute__((NSObject)) CGGradientRef GradientObject;

#pragma mark - Prebuilt
// Return an interpolated color（通过easing函数计算后的变化值amt插入过渡颜色）
UIColor *InterpolateBetweenColors(UIColor *c1, UIColor *c2, CGFloat amt) {
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;
    if (CGColorGetNumberOfComponents(c1.CGColor) == 4)
        [c1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    else {
        [c1 getWhite:&r1 alpha:&a1];
        g1 = r1;
        b1 = r1;
    }
    if (CGColorGetNumberOfComponents(c2.CGColor) == 4)
        [c2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    else {
        [c2 getWhite:&r2 alpha:&a2];
        g2 = r2;
        b2 = r2;
    }
    CGFloat r = (r2 * amt) + (r1 * (1.0 - amt));
    CGFloat g = (g2 * amt) + (g1 * (1.0 - amt));
    CGFloat b = (b2 * amt) + (b1 * (1.0 - amt));
    CGFloat a = (a2 * amt) + (a1 * (1.0 - amt));
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

#pragma mark – Easing Functions

@interface XFGradient ()

@property (nonatomic, strong) GradientObject storedGradient; // 注意这不能加*号，因为它底层还是data struct
@end

@implementation XFGradient

#pragma mark - Internal
- (CGGradientRef) gradient {
    // Expose the internal GradientObject property
    // as a CGGradientRef to the outside world on demand
    return _storedGradient;
}

#pragma mark - Convenience Creation
// Primary entry point for the class. Construct a gradient
// with the supplied colors and locations
+ (instancetype) gradientWithColors: (NSArray *) colorsArray
                          locations: (NSArray *) locationArray {
    // Establish color space
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    if (space == NULL)
    {
        NSLog(@"Error: Unable to create RGB color space");
        return nil;
    }
    // Convert NSNumber *locations array to CGFloat *
    CGFloat locations[locationArray.count];
    for (int i = 0; i < locationArray.count; i++)
        locations[i] = fminf(fmaxf([locationArray[i] floatValue], 0), 1);
    
    // Convert colors array to (id) CGColorRef
    NSMutableArray *colorRefArray = [NSMutableArray array];
    for (UIColor *color in colorsArray)
        [colorRefArray addObject:(id)color.CGColor];
    
    // Build the internal gradient
    CGGradientRef gradientRef = CGGradientCreateWithColors(space, (__bridge CFArrayRef) colorRefArray, locations);
    CGColorSpaceRelease(space);
    if (gradientRef == NULL)
    {
        NSLog(@"Error: Unable to construct CGGradientRef");
        return nil;
    }
    // Build the wrapper, store the gradient, and return
    XFGradient *gradient = [[self alloc] init];
    gradient.storedGradient = gradientRef;
    CGGradientRelease(gradientRef);
    return gradient;
}

+ (instancetype) gradientFrom: (UIColor *) color1 to: (UIColor *) color2
{
    return [self gradientWithColors:@[color1, color2] locations:@[@(0.0f), @(1.0f)]];
}



#pragma mark - Linear
// Draw a linear gradient between the two points
- (void) drawFrom: (CGPoint) p1
          toPoint: (CGPoint) p2 style: (int) mask {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    CGContextDrawLinearGradient(context, self.gradient, p1, p2, mask);
}
- (void) drawFrom:(CGPoint) p1 toPoint: (CGPoint) p2
{
    [self drawFrom:p1 toPoint:p2 style:KEEP_DRAWING];
}
- (void) drawLeftToRight: (CGRect) rect
{
    CGPoint p1 = RectGetMidLeft(rect);
    CGPoint p2 = RectGetMidRight(rect);
    [self drawFrom:p1 toPoint:p2 style:KEEP_DRAWING];
}

- (void) drawTopToBottom: (CGRect) rect
{
    CGPoint p1 = RectGetMidTop(rect);
    CGPoint p2 = RectGetMidBottom(rect);
    [self drawFrom:p1 toPoint:p2 style:KEEP_DRAWING];
}

- (void) drawBottomToTop:(CGRect)rect
{
    CGPoint p1 = RectGetMidBottom(rect);
    CGPoint p2 = RectGetMidTop(rect);
    [self drawFrom:p1 toPoint:p2 style:KEEP_DRAWING];
}
- (void) drawAlongAngle: (CGFloat) theta in:(CGRect) rect
{
    CGPoint center = RectGetCenter(rect);
    CGFloat r = PointDistanceFromPoint(center, RectGetTopRight(rect));
    
    CGFloat phi = theta + M_PI;
    if (phi > TWO_PI)
        phi -= TWO_PI;
    
    CGFloat dx1 = r * sin(theta);
    CGFloat dy1 = r * cos(theta);
    CGFloat dx2 = r * sin(phi);
    CGFloat dy2 = r * cos(phi);
    
    CGPoint p1 = CGPointMake(center.x + dx1, center.y + dy1);
    CGPoint p2 = CGPointMake(center.x + dx2, center.y + dy2);
    [self drawFrom:p1 toPoint:p2];
}




#pragma mark - Radial
// Draw a radial gradient between the two points
- (void) drawRadialFrom:(CGPoint) p1
                toPoint: (CGPoint) p2 radii: (CGPoint) radii
                  style: (int) mask {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    CGContextDrawRadialGradient(context, self.gradient, p1, radii.x, p2, radii.y, mask);
}

- (void) drawRadialFrom: (CGPoint) p1 toPoint: (CGPoint) p2;
{
    [self drawRadialFrom:p1 toPoint:p1 radii:CGPointMake(0, PointDistanceFromPoint(p1, p2)) style:KEEP_DRAWING];
}

- (void) drawBasicRadial: (CGRect) rect
{
    CGPoint p1 = RectGetCenter(rect);
    // 关键是这里取的矩形内圆半径
    CGFloat r = CGRectGetWidth(rect) / 2;
    [self drawRadialFrom:p1 toPoint:p1 radii:CGPointMake(0, r) style:KEEP_DRAWING];
}

- (void)drawArtisticRadial:(CGRect)rect
{
    CGPoint center = RectGetCenter(rect);
    // 关键是这里取的矩形外圆半径
    CGPoint topright = RectGetTopRight(rect);
    CGFloat width = PointDistanceFromPoint(center, topright);
    [self drawRadialFrom:center toPoint:center radii:CGPointMake(0, width) style:KEEP_DRAWING];
}



#pragma mark - Prebuilt
+ (instancetype) rainbow
{
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *locations = [NSMutableArray array];
    int n = 24;
    for (int i = 0; i <= n; i++)
    {
        CGFloat percent = (CGFloat) i / (CGFloat) n;
        CGFloat colorDistance = percent * (CGFloat) (n - 1) / (CGFloat) n;
        UIColor *color = [UIColor colorWithHue:colorDistance saturation:1 brightness:1 alpha:1];
        [colors addObject:color];
        [locations addObject:@(percent)];
    }
    
    return [XFGradient gradientWithColors:colors locations:locations];
}

// Build a custom gradient using the supplied block to
// interpolate between the start and end colors
+ (instancetype) gradientUsingInterpolationBlock:(InterpolationBlock) block
                                         between: (UIColor *) c1 and: (UIColor *) c2
{
    if (!block)
    {
        NSLog(@"Error: No interpolation block");
        return nil;
    }
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *locations = [NSMutableArray array];
    int numberOfSamples = 24;
    for (int i = 0; i <= numberOfSamples; i++)
    {
        CGFloat amt = (CGFloat) i / (CGFloat) numberOfSamples;
        CGFloat percentage = fmin(fmax(0.0, block(amt)), 1.0);
        [colors addObject:InterpolateBetweenColors(c1, c2, percentage)];
        [locations addObject:@(amt)];
    }
    return [XFGradient gradientWithColors:colors locations:locations];
}

+ (instancetype) easeInGradientBetween: (UIColor *) c1 and:(UIColor *) c2
{
    return [self gradientUsingInterpolationBlock:^CGFloat(CGFloat percent) {return EaseIn(percent, 3);} between:c1 and:c2];
}

+ (instancetype) easeInOutGradientBetween: (UIColor *) c1 and:(UIColor *) c2
{
    return [self gradientUsingInterpolationBlock:^CGFloat(CGFloat percent) {return EaseInOut(percent, 3);} between:c1 and:c2];
}

+ (instancetype) easeOutGradientBetween: (UIColor *) c1 and:(UIColor *) c2
{
    return [self gradientUsingInterpolationBlock:^CGFloat(CGFloat percent) {return EaseOut(percent, 3);} between:c1 and:c2];
}

+ (instancetype) linearGloss:(UIColor *) color {
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    // Calculate top gloss as half the core color luminosity
    CGFloat l = (0.299f * r + 0.587f * g + 0.114f * b);
    CGFloat gloss = pow(l, 0.2) * 0.5;
    // Retrieve color values for the bottom gradient
    CGFloat h, s, v;
    [color getHue:&h saturation:&s brightness:&v alpha:NULL];
    s = fminf(s, 0.2f);
    // Rotate the color wheel by 0.6 PI. Dark colors
    // move toward magenta, light ones toward yellow
    CGFloat rHue = ((h < 0.95) && (h > 0.7)) ? 0.67 : 0.17;
    CGFloat phi = rHue * M_PI * 2;
    CGFloat theta = h * M_PI;
    // Interpolate distance to the reference color
    CGFloat dTheta = (theta - phi);
    while (dTheta < 0) dTheta += M_PI * 2;
    while (dTheta > 2 * M_PI) dTheta -= M_PI_2;
    CGFloat factor = 0.7 + 0.3 * cosf(dTheta);
    // Build highlight colors by interpolating between
    // the source color and the reference color
    UIColor *c1 = [UIColor colorWithHue:h * factor + (1 - factor) * rHue saturation:s
                             brightness:v * factor + (1 - factor) alpha:gloss];
    UIColor *c2 = [c1 colorWithAlphaComponent:0];
    // Build and return the final gradient
    NSArray *colors = @[WHITE_LEVEL(1, gloss),
    WHITE_LEVEL(1, 0.2), c2, c1];
    NSArray *locations = @[@(0.0), @(0.5), @(0.5), @(1)];
    return [XFGradient gradientWithColors:colors locations:locations];
}

@end
