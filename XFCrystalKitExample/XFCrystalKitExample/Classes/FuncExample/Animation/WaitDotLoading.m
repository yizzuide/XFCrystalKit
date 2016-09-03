//
//  WaitDotLoading.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "WaitDotLoading.h"
#import "XFCrystalKit.h"

#define WaitSecond 1.8f // 等待时间
#define ScaleDot 5.f // 路径放大数
#define FrameRate 60.f // 每秒的帧数

@interface WaitDotLoading ()

@property (nonatomic, strong) CADisplayLink *disLink;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat perenctPath;

@end

@implementation WaitDotLoading
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.disLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(setNeedsDisplay)];
        [self.disLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [self.disLink setFrameInterval:1 / FrameRate]; // 设置帧率
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 164, 164)];
    // 使百分长度只计算一次
    if (!self.perenctPath > 0.f) {
        
        CGFloat pathLen = ringPath.pathLength;
        // pathLen / ScaleDot 获得被放大后的路径长
        // ((pathLen / ScaleDot) / (WaitSecond * FrameRate)) 每侦应跑多长
        // ((pathLen / ScaleDot) / (WaitSecond * FrameRate)) / pathLen 每侦应跑总长的百分比
        self.perenctPath = ((pathLen / ScaleDot) / (WaitSecond * FrameRate)) / pathLen;
    }
    
    self.amount += self.perenctPath;
    
    if (self.amount > 1 / ScaleDot) {
        self.amount = 0; // 这里可以让它重复
        //[self.disLink invalidate];
        //self.disLink = nil;
    }
    
    
    MovePathCenterToPoint(ringPath, RectGetCenter(rect));
    // 旋转开始位置
    RotatePath(ringPath, -M_PI_2);
    
    // 底图
    [XFCrystal drawProgressionOfPath:ringPath maxPercent:1 drawTilePathBlock:^(float index, float percent, CGPoint currentPoint, float colorDLevel) {
        // 这里可以使百分比更大上点
        percent = percent * ScaleDot;
        // 不能让百分点超过1，因为point会是(inf,inf),计算矩阵就会闪退
        if (percent > 1.f) {
            return;
        }
        CGPoint slope;
        CGPoint placePoint = [ringPath pointAtPercent:percent withSlope:&slope];
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 15, 15)];
        MovePathCenterToPoint(ovalPath, placePoint);
        //RotatePath(ovalPath, atan2f(slope.y, slope.x));
        [ovalPath fill:[UIColor whiteColor]];
    }];
    
    // 动圈
    [XFCrystal drawProgressionOfPath:ringPath maxPercent:self.amount drawTilePathBlock:^(float index, float percent, CGPoint currentPoint, float colorDLevel) {
        // 这里可以使百分比更大上点
        percent = percent * ScaleDot;
        // 不能让百分点超过1，因为point会是(inf,inf),计算矩阵就会闪退
        if (percent > 1.f) {
            return;
        }
        // 让颜色值更分散一点
        //colorDLevel *= 7;
        CGPoint slope;
        CGPoint placePoint = [ringPath pointAtPercent:percent withSlope:&slope];
        UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 15, 15)];
        MovePathCenterToPoint(ovalPath, placePoint);
        //RotatePath(ovalPath, atan2f(slope.y, slope.x));
        [ovalPath fill:[UIColor redColor]];

    }];
    
}

@end
