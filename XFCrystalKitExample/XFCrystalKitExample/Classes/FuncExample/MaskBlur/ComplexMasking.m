//
//  ComplexMasking.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "ComplexMasking.h"
#import "XFCrystalKit.h"

@implementation ComplexMasking

- (void)drawRect:(CGRect)rect
{
    /*PushDraw(^{
     UIImage *mask = [XFCrystal imageContextBuildWithSize:rect.size drawBlock:^(CGContextRef context) {
         XFGradient *gradient = [XFGradient gradientFrom:[UIColor whiteColor] to:[UIColor blackColor]];
         [gradient drawBasicRadial:rect];
     } isOpaque:NO];
     
     // 应用上下文蒙板
     ApplyMaskToContext(mask, rect, YES);
     
     [XFCrystal drawImage:[UIImage imageNamed:@"gujian2"] targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
     });*/
    
    
    [XFCrystal drawMaskInRect:rect maskBlock:^(CGContextRef context, CGRect rect) {
        XFGradient *gradient = [XFGradient gradientFrom:[UIColor whiteColor] to:[UIColor blackColor]];
        [gradient drawBasicRadial:rect];
    } drawBlock:^(CGContextRef context, CGRect rect) {
        [XFCrystal drawImage:[UIImage imageNamed:@"gujian2"] targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
    }];
    
}
@end
