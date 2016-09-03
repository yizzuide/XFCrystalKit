//
//  StarShapes.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "StarShapes.h"
#import "XFCrystalKit.h"

@implementation StarShapes

- (void)drawRect:(CGRect)rect
{
    //UIBezierPath *path = BezierStarShape(5, 0.75);
    //UIBezierPath *path = BezierStarShape(8, 0.5);
    //UIBezierPath *path = BezierStarShape(5, -2);
    //UIBezierPath *path = BezierStarShape(9, -2);
    //UIBezierPath *path = BezierStarShape(6,-1.5);
    //FitPathToRect(path, rect);
    //ScalePath(path, 0.5, 0.5);
    //[path stroke:2 color:[UIColor orangeColor]];
    
    /*UIBezierPath *path = BezierStarShape(12, 0.75);
     FitPathToRect(path, rect);
     ScalePath(path, 0.5, 0.5);
     [path fill:[UIColor orangeColor]];*/
    
    UIBezierPath *path = BezierStarShape(12, -2.5);
    FitPathToRect(path, rect);
    ScalePath(path, 0.5, 0.5);
    path.usesEvenOddFillRule = YES;
    [path fill:[UIColor blackColor]];
    
}
@end
