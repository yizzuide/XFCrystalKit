//
//  FillingPathWithEvent_OddRule.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "FillingPathWithEvent_OddRule.h"
#import "XFCrystalKit.h"

@implementation FillingPathWithEvent_OddRule

- (void)drawRect:(CGRect)rect
{
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(25, 23, 78, 65)];
    
    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(30, 28.5, 67.5, 54)];
    [rectanglePath appendPath:rectangle2Path];
    
    //// Rectangle 3 Drawing
    UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(42.5, 36.5, 43, 38)];
    [rectanglePath appendPath:rectangle3Path];
    
    [rectanglePath stroke:2 color:[UIColor redColor]];
    
    // 这个填充方式会填充所有空白，埋没里面的路径
    //[rectanglePath fill:[UIColor greenColor]];
    
    // 使用UIKIT方式解决
    /*When you enable a path’s usesEvenOddFillRule property, UIKit uses this calculation to determine which areas lay inside the shape and should be filled and what areas are outside and should not.*/
    rectanglePath.usesEvenOddFillRule = YES;
    [rectanglePath fill:[UIColor greenColor]];
    
    // 这种方式是Quartz uses an even/odd rule，which is an algorithm that determines the degree to which any area is “inside” a path.
    /*CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextAddPath(context, rectanglePath.CGPath);
     CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
     CGContextEOFillPath(context);*/
}
@end
