//
//  DrawingReflections.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "DrawingReflections.h"
#import "XFCrystalKit.h"

@implementation DrawingReflections

- (void)drawRect:(CGRect)rect
{
    UIRectFill(rect);
    UIImage *source = [UIImage imageNamed:@"profile"];
    
    UIImage *result = [XFCrystal imageReflectionEffectFromSourceImage:source gap:8];
    [XFCrystal drawImage:result targetRect:rect drawingPattern:XFImageDrawingPatternFitting];
}
@end
