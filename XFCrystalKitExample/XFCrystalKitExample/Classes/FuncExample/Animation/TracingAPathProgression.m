//
//  TracingAPathProgression.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "TracingAPathProgression.h"
#import "XFCrystalKit.h"

#define DeltaTime 0.01f

@interface TracingAPathProgression ()

@property (nonatomic, strong) CADisplayLink *disLink;
@property (nonatomic, assign) CGFloat amount;
@end

@implementation TracingAPathProgression

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.disLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(setNeedsDisplay)];
        [self.disLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    
    self.amount += DeltaTime;
    if (self.amount > 1) {
        //self.amount = 0; // 这里可以让它重复
        [self.disLink invalidate];
        self.disLink = nil;
    }
    
    // pattern1
    // 创建运行形状
    /*UIBezierPath *path = BezierInflectedShape(8, -0.5);
     FitPathToRect(path, rect);
     ScalePath(path, 0.5, 0.5);
     [XFCrystal drawProgressionOfPath:ringPath maxPercent:self.amount drawTilePathBlock:^(float index, float percent, CGPoint currentPoint, float colorDLevel) {
         NSLog(@"%f",index);
         UIColor *color = [UIColor colorWithWhite:index * colorDLevel alpha:1];
         CGRect r = RectAroundCenter(currentPoint, CGSizeMake(2, 2));
         UIBezierPath *marker = [UIBezierPath bezierPathWithOvalInRect:r];
         [marker fill:color];
     }];
     */
    
    // pattern2
    /*UIBezierPath *ringPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 164, 164)];
     MovePathCenterToPoint(ringPath, RectGetCenter(rect));
     
     [XFCrystal drawProgressionOfPath:ringPath maxPercent:self.amount drawTilePathBlock:^(float index, float percent, CGPoint currentPoint, float colorDLevel) {
         // 这里可以使百分比更大上点
         percent = percent * 5;
         // 不能让百分点超过1，因为point会是(inf,inf),计算矩阵就会闪退
         if (percent > 1.f) {
         return;
         }
         // 让颜色值更分散一点
         colorDLevel *= 7;
         CGPoint slope;
         CGPoint placePoint = [ringPath pointAtPercent:percent withSlope:&slope];
         UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 15, 64)];
         MovePathCenterToPoint(ovalPath, placePoint);
         RotatePath(ovalPath, atan2f(slope.y, slope.x));
         [ovalPath stroke:1 color:[UIColor colorWithHue:index * colorDLevel saturation:1 brightness:1 alpha:1]];
     }];
     */
    
    // pattern3
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 49, 49)];
    MovePathCenterToPoint(ringPath, RectGetCenter(rect));
    
    __weak typeof(self) weakSelf = self;
    [XFCrystal drawProgressionOfPath:ringPath maxPercent:self.amount drawTilePathBlock:^(float index, float percent, CGPoint currentPoint, float colorDLevel) {
        // 这里可以使百分比更大上点
        percent = percent * 2.8;
        // 不能让百分点超过1，因为point会是(inf,inf),计算矩阵就会闪退
        if (percent > 1.f) {
            weakSelf.amount = -0.05f;
            return;
        }
        // 让颜色值更分散一点
        colorDLevel *= 4.5;
        CGPoint slope;
        CGPoint placePoint = [ringPath pointAtPercent:percent withSlope:&slope];
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 5, 15)];
        MovePathCenterToPoint(ovalPath, placePoint);
        RotatePath(ovalPath, atan2f(slope.y, slope.x));
        [ovalPath stroke:1 color:[UIColor colorWithHue:index * colorDLevel saturation:1 brightness:1 alpha:1]];
    }];
    
    
}

@end
