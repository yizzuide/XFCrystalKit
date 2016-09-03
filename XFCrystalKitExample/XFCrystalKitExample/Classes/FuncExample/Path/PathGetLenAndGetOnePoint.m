//
//  PathGetLenAndGetOnePoint.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "PathGetLenAndGetOnePoint.h"
#import "XFCrystalKit.h"

@implementation PathGetLenAndGetOnePoint

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 120)];
    [path addLineToPoint:CGPointMake(100, 120)];
    [path addQuadCurveToPoint:CGPointMake(160, 25) controlPoint:CGPointMake(50, 50)];
    [path addCurveToPoint:CGPointMake(320, 240) controlPoint1:CGPointMake(300, 25) controlPoint2:CGPointMake(150, 200)];
    
    // 获得总长度
    NSLog(@"%f",path.pathLength);
    
    // 由于计算路径某个点有费cpu性能，所以尽量让计算的同一个位置不要出现两次，把它们提前缓存起来
    CGPoint percentPoint = [path pointAtPercent:0.8 withSlope:nil];
    
    // 获得百分点位置
    NSLog(@"%@",NSStringFromCGPoint(percentPoint));
    
    [path addLineToPoint:percentPoint];
    
    [path stroke:2 color:[UIColor orangeColor]];
    
}
@end
