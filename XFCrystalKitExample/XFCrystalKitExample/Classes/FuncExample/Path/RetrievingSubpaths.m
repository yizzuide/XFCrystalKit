//
//  RetrievingSubpaths.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "RetrievingSubpaths.h"
#import "XFCrystalKit.h"

@implementation RetrievingSubpaths

- (void)drawRect:(CGRect)rect {
    // 参照构造形状
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 164, 164)];
    MovePathCenterToPoint(ringPath, RectGetCenter(rect));
    //[ringPath stroke:0.5 color:[UIColor blackColor]];
    
    // 创建路径组合
    UIBezierPath *pathSet = [UIBezierPath bezierPath];
    CGFloat step = 0.05;
    for (float i = 0.0001; i < 1; i += step) {
        CGPoint slope;
        CGPoint placePoint = [ringPath pointAtPercent:i withSlope:&slope];
        UIBezierPath *ovalPath = [self ovalPath];
        MovePathCenterToPoint(ovalPath, placePoint);
        RotatePath(ovalPath, atan2f(slope.y, slope.x));
        //[ovalPath stroke:1 color:[UIColor blackColor]];
        [pathSet appendPath:ovalPath];
    }
    
    //NSLog(@"%zd",pathSet.subpaths.count);
    // 获得路径的所有子路径
    NSArray<UIBezierPath *> *subPaths = pathSet.subpaths;
    CGFloat colorOffset = 1.f / subPaths.count;
    CGFloat index = 0;
    for (UIBezierPath *sPath in subPaths) {
        // 对每个路径填充颜色变化
        [sPath fill:[UIColor colorWithHue:index saturation:1 brightness:1 alpha:1]];
        index += colorOffset;
    }
}

- (UIBezierPath *)ovalPath
{
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 15, 64)];
}

@end
