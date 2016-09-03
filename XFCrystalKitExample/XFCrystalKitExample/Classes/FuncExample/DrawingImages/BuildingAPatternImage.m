//
//  BuildingAPatternImage.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BuildingAPatternImage.h"
#import "XFCrystalKit.h"

@implementation BuildingAPatternImage

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //    UIImage *image = [self buildPattern];
    CGSize targetSize = CGSizeMake(80, 80);
    UIImage *image = [XFCrystal drawPatternColorImageWithSize:targetSize drawBlock:^(CGContextRef context, CGRect rect) {
        // Fill background with pink
        [[UIColor magentaColor] set];
        
        UIRectFill(rect);
        
        // Draw a couple of dogcattle in gray
        [[UIColor grayColor] set];
        
        // First, bigger with interior detail in the top-left.
        // Read more about Bezier path objects in Chapters 4 and 5
        CGRect weeRect = CGRectMake(0, 0, 40, 40);
        UIBezierPath *moof = BuildMoofPath();
        FitPathToRect(moof, weeRect);
        RotatePath(moof, M_PI_4);
        [moof fill];
        
        // Then smaller, flipped around, and offset down and right
        RotatePath(moof, M_PI);
        OffsetPath(moof, CGSizeMake(40, 40));
        ScalePath(moof, 0.5, 0.5);
        [moof fill];
    }];
    UIColor *patternColor = [UIColor colorWithPatternImage:image];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [path fill:patternColor];
}

UIBezierPath *BuildMoofPath()
{
    UIBezierPath* starPath = UIBezierPath.bezierPath;
    [starPath moveToPoint: CGPointMake(171, 36)];
    [starPath addLineToPoint: CGPointMake(179.82, 48.86)];
    [starPath addLineToPoint: CGPointMake(194.78, 53.27)];
    [starPath addLineToPoint: CGPointMake(185.27, 65.64)];
    [starPath addLineToPoint: CGPointMake(185.69, 81.23)];
    [starPath addLineToPoint: CGPointMake(171, 76)];
    [starPath addLineToPoint: CGPointMake(156.31, 81.23)];
    [starPath addLineToPoint: CGPointMake(156.73, 65.64)];
    [starPath addLineToPoint: CGPointMake(147.22, 53.27)];
    [starPath addLineToPoint: CGPointMake(162.18, 48.86)];
    [starPath closePath];
    
    return starPath;
}

- (UIImage *)buildPattern
{
    // Create a small tile
    CGSize targetSize = CGSizeMake(80, 80);
    CGRect targetRect = SizeMakeRect(targetSize);
    
    // Start a new image
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Fill background with pink
    [[UIColor magentaColor] set];
    
    UIRectFill(targetRect);
    
    // Draw a couple of dogcattle in gray
    [[UIColor grayColor] set];
    
    // First, bigger with interior detail in the top-left.
    // Read more about Bezier path objects in Chapters 4 and 5
    CGRect weeRect = CGRectMake(0, 0, 40, 40);
    UIBezierPath *moof = BuildMoofPath();
    FitPathToRect(moof, weeRect);
    RotatePath(moof, M_PI_4);
    [moof fill];
    
    // Then smaller, flipped around, and offset down and right
    RotatePath(moof, M_PI);
    OffsetPath(moof, CGSizeMake(40, 40));
    ScalePath(moof, 0.5, 0.5);
    [moof fill];
    
    // Retrieve and return the pattern image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end
