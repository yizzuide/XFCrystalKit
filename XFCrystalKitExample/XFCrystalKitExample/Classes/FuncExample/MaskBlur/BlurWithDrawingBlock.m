//
//  BlurWithDrawingBlock.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BlurWithDrawingBlock.h"
#import "XFCrystalKit.h"

#define SEED_RANDOM     {static BOOL seeded = NO; if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}}
#define RANDOM(_X_)     (NSInteger)(random() % _X_)
#define RANDOM_01       floorf(((double)arc4random() / 0x100000000) * 255) / 255.0
#define RANDOM_BOOL     (BOOL)((NSInteger)random() % 2)
#define RANDOM_PT(_RECT_) CGPointMake(floorf(((double)arc4random() / 0x100000000) * _RECT_.size.width), floorf(((double)arc4random() / 0x100000000) * _RECT_.size.height))


@implementation BlurWithDrawingBlock

- (void) drawRandomCircles: (int) count withHue: (UIColor *) baseColor into: (CGRect) destination
{
    CGSize size = destination.size;
    for (int i = 0; i < count; i++)
    {
        CGPoint point = RANDOM_PT(destination);
        
        NSInteger rWidth = size.width * 0.2;
        CGFloat diameter = size.width * 0.1 + RANDOM(rWidth);
        CGRect circleRect = RectAroundCenter(point, CGSizeMake(diameter, diameter));
        
        UIColor *scaledColor = [ScaleColorBrightness(baseColor, RANDOM_01 + 0.2) colorWithAlphaComponent:0.5];
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
        [path fill:scaledColor];
        UIColor *outerColor = ScaleColorBrightness(scaledColor, 1.25);
        [path stroke:4 color:outerColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    UIColor *targetColor = [UIColor colorWithRed:RANDOM_01 green:RANDOM_01 blue:RANDOM_01 alpha:1.0];
    // 绘制模糊层
    [XFCrystal drawBlurWithRaduis:4 drawBlock:^(CGContextRef context) {
        [self drawRandomCircles:20 withHue:targetColor into:rect];
    }];
    // 前层再绘制一次
    [self drawRandomCircles:20 withHue:targetColor into:rect];
}


@end

