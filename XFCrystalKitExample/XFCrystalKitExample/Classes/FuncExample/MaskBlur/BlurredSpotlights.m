//
//  BlurredSpotlights.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BlurredSpotlights.h"
#import "XFCrystalKit.h"

@implementation BlurredSpotlights

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIRectFill(rect);
    // Normal
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 100, 100)];
    PushDraw(^{
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
        [XFCrystal drawBlurWithRaduis:8 drawBlock:^(CGContextRef context) {
            [path fill:[UIColor yellowColor]];
            
        }];
    });
    [self drawText:@"Normal" fromPath:path];
    
    
    
    // Hard Light
    MovePathToPoint(path, CGPointMake(120, 10));
    PushDraw(^{
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeHardLight);
        [XFCrystal drawBlurWithRaduis:8 drawBlock:^(CGContextRef context) {
            [path fill:[UIColor yellowColor]];
        }];
    });
    [self drawText:@"Hard Light" fromPath:path];
    
    // Soft Light
    MovePathToPoint(path, CGPointMake(10, 120));
    PushDraw(^{
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSoftLight);
        [XFCrystal drawBlurWithRaduis:8 drawBlock:^(CGContextRef context) {
            [path fill:[UIColor yellowColor]];
        }];
    });
    [self drawText:@"Soft Light" fromPath:path];
    
    
    // Fill
    MovePathToPoint(path, CGPointMake(120, 120));
    [path fill:[UIColor yellowColor]];
    [self drawText:@"Fill" fromPath:path];
}

- (void)drawText:(NSString *)text fromPath:(UIBezierPath *)path
{
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                 NSForegroundColorAttributeName:[UIColor orangeColor]}];
    CGPoint textPoint = CGPointMake(RectGetCenter(path.bounds).x - textSize.width * 0.5, RectGetCenter(path.bounds).y - textSize.height * 0.5);
    [text drawAtPoint:textPoint  withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                  NSForegroundColorAttributeName:[UIColor orangeColor]}];
}
@end
