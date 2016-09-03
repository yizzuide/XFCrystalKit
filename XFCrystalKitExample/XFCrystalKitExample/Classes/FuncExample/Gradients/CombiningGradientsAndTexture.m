//
//  CombiningGradientsAndTexture.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "CombiningGradientsAndTexture.h"
#import "XFCrystalKit.h"

@implementation CombiningGradientsAndTexture

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 200, 100)];
    MovePathCenterToPoint(path, RectGetCenter(rect));
    UIRectFrame(path.bounds);
    
    XFGradient *gradient = [XFGradient rainbow];
    DrawGradientOverTexture(path, [UIImage imageNamed:@"201812-12062609234378"], gradient, 0.5);
}

@end
