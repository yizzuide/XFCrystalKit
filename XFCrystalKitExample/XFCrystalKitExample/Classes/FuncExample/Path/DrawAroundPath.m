//
//  DrawAroundPath.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "DrawAroundPath.h"
#import "XFCrystalKit.h"

@implementation DrawAroundPath

- (void)drawRect:(CGRect)rect {
    // 绘制线条路径
    UIBezierPath *path = [self heartPath];
    FitPathToRect(path, rect);
    ScalePath(path, 0.75, 0.75);
    
    [path stroke:2 color:[UIColor blackColor]];
    
    // 填充图形路径到线条路径
    CGFloat step = 0.1;
    for (float i = 0; i < 1; i += step) {
        
        // 存储斜线的偏差slope.x = p2.x - p1.x, slope.y = p2.y - p1.y
        CGPoint slope;
        CGPoint placePoint = [path pointAtPercent:i withSlope:&slope];
        UIBezierPath *heartPath = [self heartPath];
        FitPathToRect(heartPath, CGRectMake(0, 0, 32, 32));
        MovePathCenterToPoint(heartPath, placePoint);
        // 旋转方向
        // float angle = atan2( y2-y1, x2-x1 ); 计算目标点的朝向（斜线与x轴的夹角）
        // moveTo的pathElement点是无方向的，所以第一个点没有方向
        RotatePath(heartPath, atan2f(slope.y, slope.x));
        [heartPath fill:[UIColor redColor]];
    }
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
