//
//  ClippedGloss.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "ClippedGloss.h"
#import "XFCrystalKit.h"

@implementation ClippedGloss

- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 200, 50)
                                                    cornerRadius:15];
    MovePathCenterToPoint(path, RectGetCenter(rect));
    [path fill:[UIColor orangeColor]];
    
    DrawButtonGloss(path);
}
@end
