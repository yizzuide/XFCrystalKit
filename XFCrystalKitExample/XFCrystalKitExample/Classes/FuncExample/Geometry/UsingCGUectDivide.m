//
//  UsingCGUectDivide.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "UsingCGUectDivide.h"

@implementation UsingCGUectDivide

/**
 *  Using CGRectDivide()
 *
 The CGRectDivide() function is terrifically handy. It provides a really simple way to divide and subdivide a rectangle into sections. At each step, you specify how many to slice away and which side to slice it away from. You can cut from any edge, namely CGRectMinXEdge, CGRectMinYEdge, CGRectMaxXEdge, and CGRectMaxYEdge.
 The code slices off the left edge of the rectangle and then divides the remaining portion into two vertical halves. Removing two equal sections from the left and the right further decomposes the bottom section.
 */
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path;
    CGRect remainder;
    CGRect slice;
    
    // Slice a section off the left and color it orange
    CGRectDivide(rect, &slice, &remainder, 80, CGRectMinXEdge); // CGRectMinXEdge：取左边
    [[UIColor orangeColor] set];
    path = [UIBezierPath bezierPathWithRect:slice];
    [path fill];
    
    // Slice the other portion in half horizontally
    // Tint the sliced portion purple
    rect = remainder;
    CGRectDivide(rect, &slice, &remainder, remainder.size.height * 0.5, CGRectMinYEdge);
    [[UIColor purpleColor] set];
    path = [UIBezierPath bezierPathWithRect:slice];
    [path fill];
    
    // Slice a 20-point segment from the bottom left.
    // Draw it in black
    rect = remainder;
    CGRectDivide(rect, &slice, &remainder, 20, CGRectMinXEdge);
    [[UIColor blackColor] set];
    path = [UIBezierPath bezierPathWithRect:slice];
    [path fill];
    
    // And another 20-point segment from the bottom right.
    // Draw it in black
    rect = remainder;
    CGRectDivide(rect, &slice, &remainder, 20, CGRectMaxXEdge); // CGRectMaxXEdge：取右边
    path = [UIBezierPath bezierPathWithRect:slice];
    [path fill];
    
    // Fill the rest in brown
    [[UIColor brownColor] set];
    path = [UIBezierPath bezierPathWithRect:remainder];
    [path fill];
}
@end
