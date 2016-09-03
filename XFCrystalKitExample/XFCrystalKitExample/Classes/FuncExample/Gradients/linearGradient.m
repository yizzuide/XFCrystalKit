//
//  linearGradient.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "linearGradient.h"
#import "XFCrystalKit.h"

@implementation linearGradient

- (void)drawRect:(CGRect)rect {
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    XFGradient *linearGradient = [XFGradient gradientFrom:[UIColor greenColor] to:[UIColor purpleColor]];
    
    // 填充具体位置
    //CGContextDrawLinearGradient(context, linearGradient.gradient, CGPointMake(50, 50), CGPointMake(100, 100), 0);
    // 填充具体位置，然后从起始空白外填充
    //CGContextDrawLinearGradient(context, linearGradient.gradient, CGPointMake(50, 50), CGPointMake(100, 100), kCGGradientDrawsBeforeStartLocation);
    // 填充当前区域
    //CGContextDrawLinearGradient(context, linearGradient.gradient, CGPointMake(50, 50), CGPointMake(100, 100), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    // 使用实例方法
    //[linearGradient drawFrom:CGPointMake(50, 50) toPoint:CGPointMake(100, 100) style:0];
    [linearGradient drawTopToBottom:rect];
}
@end
