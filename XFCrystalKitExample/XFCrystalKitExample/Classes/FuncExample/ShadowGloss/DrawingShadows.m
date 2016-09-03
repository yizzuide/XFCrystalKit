//
//  DrawingShadows.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "DrawingShadows.h"
#import "XFCrystalKit.h"

@implementation DrawingShadows

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [self heartPath];
    FitPathToRect(path, rect);
    ScalePath(path, 0.75, 0.75);
    
    NSDate *start = [NSDate date];
    // 存储当前绘制状态
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    SetShadow(nil, CGSizeMake(4, 4), 5);
    [path fill:[UIColor greenColor]];
    NSLog(@"%f seconds", [[NSDate date] timeIntervalSinceDate:start]);
    // 恢复初始绘制状态
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    
    UIBezierPath *path2 = [self heartPath];
    ScalePath(path2, 0.5, 0.5);
    MovePathCenterToPoint(path2, CGPointMake(240, 200));
    [path2 fill:[UIColor redColor]];
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
