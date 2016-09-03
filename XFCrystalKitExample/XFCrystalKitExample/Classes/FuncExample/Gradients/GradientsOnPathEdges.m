//
//  GradientsOnPathEdges.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "GradientsOnPathEdges.h"
#import "XFCrystalKit.h"

@interface GradientsOnPathEdges()
@property (nonatomic, strong) UIBezierPath *ovalPath;

@end

@implementation GradientsOnPathEdges

- (void)drawRect:(CGRect)rect{
    if (!self.ovalPath) {
        self.ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 150, 150)];
    }
    MovePathCenterToPoint(self.ovalPath, RectGetCenter(rect));
    
    
    XFGradient *gradient = [XFGradient rainbow];
    
    PushDraw(^{
        // 裁剪出路径的边缘宽度
        [self.ovalPath clipToStroke:15];
        
        // 填充渐变
        [gradient drawArtisticRadial:self.ovalPath.bounds];
    });
    
    [self.ovalPath stroke:1];
    
    // it can test touches point contains
    //CGPathContainsPoint(ovalPath.CGPath, nil, touchPoint, NO);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if(CGPathContainsPoint(self.ovalPath.CGPath, nil, touchPoint, NO)){
        NSLog(@"touch me!");
    }
    
}
@end
