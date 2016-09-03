//
//  TransformingPaths.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "TransformingPaths.h"
#import "XFCrystalKit.h"

@implementation TransformingPaths

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [self heartPath];
    [path fill:[UIColor greenColor]];
    
    // The Origin Problem
    UIBezierPath *path2 = [path copy];
    // 所有Transform操作都是基于原点（Origin）的
    [path2 applyTransform:CGAffineTransformMakeRotation(M_PI / 9)];
    [path2 fill:[UIColor redColor]];
    
    // fix Origin Problem,using center point
    UIBezierPath *path3 = [path copy];
    RotatePath(path3, M_PI / 9);
    [path3 fill:[UIColor purpleColor]];
    
    UIBezierPath *scalePath = [path copy];
    ScalePath(scalePath, 0.5, 0.5);
    [scalePath fill:[UIColor orangeColor]];
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
