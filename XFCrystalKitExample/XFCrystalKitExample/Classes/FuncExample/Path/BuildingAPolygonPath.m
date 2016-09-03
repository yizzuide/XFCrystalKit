//
//  BuildingAPolygonPath.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BuildingAPolygonPath.h"
#import "XFCrystalKit.h"

@implementation BuildingAPolygonPath

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = BezierPolygon(6);
    FitPathToRect(path, rect);
    ScalePath(path, 0.5, 0.5);
    [path stroke:5 color:[UIColor orangeColor]];
}
@end
