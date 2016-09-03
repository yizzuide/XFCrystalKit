//
//  RectangleUtilities.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "RectangleUtilities.h"
#import "XFCrystalKit.h"

@implementation RectangleUtilities

- (void)drawRect:(CGRect)rect {
    NSString *string = @"Hello World";
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:48];
    
    // Calculate string size
    CGSize stringSize = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    
    // Find the target rectangle
    CGRect target = RectAroundCenter(RectGetCenter(rect), stringSize);
    
    // Draw the string
    [string drawInRect:target withAttributes:@{NSFontAttributeName:font}];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:target];
    path.lineWidth = 1;
    
    [[UIColor greenColor] setStroke];
    [path stroke];
}
@end
