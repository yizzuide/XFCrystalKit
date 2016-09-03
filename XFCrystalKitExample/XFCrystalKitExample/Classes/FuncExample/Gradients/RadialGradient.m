//
//  RadialGradient.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "RadialGradient.h"
#import "XFCrystalKit.h"

@implementation RadialGradient

- (void)drawRect:(CGRect)rect {
    CGPoint center = RectGetCenter(rect);
    
    // 填充小的半径
    //[[Gradient gradientFrom:[UIColor greenColor] to:[UIColor purpleColor]] drawRadialFrom:CGPointMake(50, 50) toPoint:CGPointMake(200, 150) radii:CGPointMake(5, 20) style:0];
    
    // 填充大的半径（内小外大）
    [[XFGradient gradientFrom:[UIColor greenColor] to:[UIColor cyanColor]] drawRadialFrom:center toPoint:center radii:CGPointMake(5,rect.size.width * 0.5) style:kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation];
    //[[Gradient gradientFrom:[UIColor greenColor] to:[UIColor purpleColor]] drawBasicRadial:rect];
}
@end
