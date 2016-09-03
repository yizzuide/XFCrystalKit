//
//  SimpleMasking.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "SimpleMasking.h"
#import "XFCrystalKit.h"

@implementation SimpleMasking

- (void)drawRect:(CGRect)rect
{
    CGRect inset = CGRectMake(0, 0, 100, 100);
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithOvalInRect:inset];
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:RectInsetByPercent(inset, 0.4)];
    
    // The even-odd rule is essential here to establish
    // the "inside" of the donut
    outerPath.usesEvenOddFillRule =  YES;
    [outerPath appendPath:innerPath];
    FitPathToRect(outerPath, rect);
    // Apply the clip
    [outerPath addClip];
    
    // Draw the image
    UIImage *image = [UIImage imageNamed:@"gujian2"];
    [XFCrystal drawImage:image targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
    
}
@end
