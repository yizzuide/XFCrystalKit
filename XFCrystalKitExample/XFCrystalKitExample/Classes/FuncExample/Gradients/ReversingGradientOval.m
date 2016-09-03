//
//  ReversingGradientOval.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "ReversingGradientOval.h"
#import "XFCrystalKit.h"

@implementation ReversingGradientOval

/**
 *   It creates a gradient from light gray to dark gray and draws it first from top to bottom in the larger shape. Then it reverses direction, drawing again in the other direction, using the smaller shape.
 *  Also adds a finishing touch in drawing a slight black inner shadow (see Chapter 5) at the top of the smaller shape. This shadow emphasizes the point of differentiation between the two drawings but is otherwise completely optional.
 */
- (void)drawRect:(CGRect)rect {
    CGRect outerRect = CGRectMake(0, 0, 150, 150);
    CGRect innerRect = CGRectInset(outerRect, 25, 25);
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithOvalInRect:outerRect];
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:innerRect];
    MovePathCenterToPoint(outerPath, RectGetCenter(rect));
    MovePathCenterToPoint(innerPath, RectGetCenter(rect));
    
    XFGradient *gradient = [XFGradient gradientFrom:WHITE_LEVEL(0.66, 1)  to:WHITE_LEVEL(0.33, 1)];
    
    
    PushDraw(^{
        [outerPath addClip];
        [gradient drawTopToBottom:outerPath.bounds];
    });
    
    PushDraw(^{
        [innerPath addClip];
        [gradient drawBottomToTop:innerPath.bounds];
    });
    
    [innerPath drawInnerShadow:WHITE_LEVEL(0.0, 0.5f) size:CGSizeMake(0, 2) blur:2];
}
@end
