//
//  BevelEffectShape.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BevelEffectShape.h"
#import "XFCrystalKit.h"


@implementation BevelEffectShape

- (void)drawRect:(CGRect)rect {
    UIBezierPath *heartPath = [self heartPath];
    FitPathToRect(heartPath, rect);
    ScalePath(heartPath, 0.75, 0.75);
    // 仿背部光照
    SetShadow(WHITE_LEVEL(1, 0.5), CGSizeMake(2, -2), 0);
    [heartPath fill:[UIColor redColor]];
    // 绘制形状顶部照亮效果
    DrawInnerShadow(heartPath, WHITE_LEVEL(1, 0.5), CGSizeMake(-4, 4), 2);
}

- (UIBezierPath *)heartPath
{
    UIBezierPath* graphic1Path = UIBezierPath.bezierPath;
    [graphic1Path moveToPoint: CGPointMake(90.47, 45.59)];
    [graphic1Path addCurveToPoint: CGPointMake(25.99, 60.35) controlPoint1: CGPointMake(73.77, 8.14) controlPoint2: CGPointMake(26.31, 16.88)];
    [graphic1Path addCurveToPoint: CGPointMake(63.76, 102.68) controlPoint1: CGPointMake(25.82, 84.22) controlPoint2: CGPointMake(48.6, 93.14)];
    [graphic1Path addCurveToPoint: CGPointMake(90.57, 129.99) controlPoint1: CGPointMake(78.46, 111.94) controlPoint2: CGPointMake(88.93, 124.6)];
    [graphic1Path addCurveToPoint: CGPointMake(117.24, 102.43) controlPoint1: CGPointMake(91.97, 124.71) controlPoint2: CGPointMake(103.63, 111.69)];
    [graphic1Path addCurveToPoint: CGPointMake(155.01, 60.09) controlPoint1: CGPointMake(132.12, 92.3) controlPoint2: CGPointMake(155.18, 83.96)];
    [graphic1Path addCurveToPoint: CGPointMake(90.47, 45.59) controlPoint1: CGPointMake(154.69, 16.51) controlPoint2: CGPointMake(106.4, 9.64)];
    [graphic1Path closePath];
    return graphic1Path;
}
@end
