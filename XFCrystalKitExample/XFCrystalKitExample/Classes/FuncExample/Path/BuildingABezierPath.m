//
//  BuildingABezierPath.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BuildingABezierPath.h"
#import "XFCrystalKit.h"

@implementation BuildingABezierPath

- (void)drawRect:(CGRect)rect {
    
    // Establish a new path
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // Create the face outline
    // and append it to the path
    CGRect inset = CGRectInset(rect, 32, 32);
    UIBezierPath *faceOutline = [UIBezierPath bezierPathWithOvalInRect:inset];
    [bezierPath appendPath:faceOutline];
    
    // Move in again, for the eyes and mouth
    CGRect insetAgain = CGRectInset(inset, 64, 64);
    
    // Calculate a radius
    CGPoint referencePoint = CGPointMake(CGRectGetMinX(insetAgain), CGRectGetMaxY(insetAgain));
    CGPoint center = RectGetCenter(inset);
    CGFloat radius = PointDistanceFromPoint(referencePoint, center);
    
    // Add a smile from 40 degrees around to 140 degrees
    UIBezierPath *smile = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:RadiansFromDegrees(140) endAngle:RadiansFromDegrees(40) clockwise:NO];
    [bezierPath appendPath:smile];
    
    // Build Eye 1
    CGPoint p1 = CGPointMake(CGRectGetMinX(insetAgain), CGRectGetMinY(insetAgain));
    CGRect eyeRect1 = RectAroundCenter(p1, CGSizeMake(20, 20));
    UIBezierPath *eye1 = [UIBezierPath bezierPathWithRect:eyeRect1];
    [bezierPath appendPath:eye1];
    
    // And Eye 2
    CGPoint p2 = CGPointMake(CGRectGetMaxX(insetAgain), CGRectGetMinY(insetAgain));
    CGRect eyeRect2 = RectAroundCenter(p2, CGSizeMake(20, 20));
    UIBezierPath *eye2 = [UIBezierPath bezierPathWithRect:eyeRect2];
    [bezierPath appendPath:eye2];
    
    // Draw the complete path
    bezierPath.lineWidth = 4;
    [bezierPath stroke];
    
    
}
@end
