//
//  InflectedShapes.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "InflectedShapes.h"
#import "XFCrystalKit.h"

@implementation InflectedShapes

- (void)drawRect:(CGRect)rect
{
    //UIBezierPath *path = BezierInflectedShape(8, -0.5);
    //UIBezierPath *path = BezierInflectedShape(8, 0.5);
    
    UIBezierPath *path = BezierInflectedShape(12, -2.5);
    // 尖角高度限制
    path.miterLimit = 5;
    //UIBezierPath *path = BezierInflectedShape(12, 2.5);
    FitPathToRect(path, rect);
    ScalePath(path, 0.5, 0.5);
    [path stroke:2 color:[UIColor orangeColor]];
    
}

@end
