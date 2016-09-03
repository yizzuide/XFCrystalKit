//
//  MixingLinearRadialGradient.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "MixingLinearRadialGradient.h"
#import "XFCrystalKit.h"

@implementation MixingLinearRadialGradient

- (void)drawRect:(CGRect)rect
{
    CGRect outerRect = CGRectMake(0, 0, 150, 150);
    CGRect innerRect = CGRectInset(outerRect, 25, 25);
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithOvalInRect:outerRect];
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:innerRect];
    MovePathCenterToPoint(outerPath, RectGetCenter(rect));
    MovePathCenterToPoint(innerPath, RectGetCenter(rect));
    
    XFGradient *gradient = [XFGradient gradientFrom:WHITE_LEVEL(0.66, 1)  to:WHITE_LEVEL(0.33, 1)];
    
    // Produce an ease-in-out gradient, as in Listing 6-5 0x76d8eb
    XFGradient *blueGradient = [XFGradient easeInOutGradientBetween:[UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000] and:[UIColor colorWithRed:0.000 green:0.600 blue:0.800 alpha:1.000]];
    
    PushDraw(^{
        [outerPath addClip];
        [gradient drawTopToBottom:outerPath.bounds];
    });
    
    
    PushDraw(^{
        [innerPath addClip];
        // 这个扩散不好
        //[blueGradient drawBasicRadial:innerPath.bounds];
        [blueGradient drawArtisticRadial:innerPath.bounds];
        
    });
    // 使之有凹下去的立体感
    [innerPath drawInnerShadow:WHITE_LEVEL(0.0, 0.5f) size:CGSizeMake(0, 2) blur:2];
}
@end
