//
//  DrawingTopShine.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "DrawingTopShine.h"
#import "XFCrystalKit.h"

@implementation DrawingTopShine

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 100)
                                                    cornerRadius:15];
    FitPathToRect(path, rect);
    ScalePath(path, 0.75, 0.75);
    
    [path fill:[UIColor redColor]];
    
    DrawIconTopLight(path, 0.35f);
}
@end
