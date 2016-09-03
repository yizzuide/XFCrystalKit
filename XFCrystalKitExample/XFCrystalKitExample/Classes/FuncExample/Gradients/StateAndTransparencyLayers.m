//
//  StateAndTransparencyLayers.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "StateAndTransparencyLayers.h"
#import "XFCrystalKit.h"

@implementation StateAndTransparencyLayers

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bodyPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 50)];
    UIBezierPath *wheelPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)];
    
    MovePathCenterToPoint(bodyPath, RectGetCenter(rect));
    MovePathCenterToPoint(wheelPath, RectGetCenter(rect));
    OffsetPath(wheelPath, CGSizeMake(0, 20));
    
    // 裁剪要绘制的区域，防止Layer Draw占用整块drawing buffer
    // 使用CGRectInset包含进阴影区域
    CGRect clipRect = CGRectInset(CGRectUnion(bodyPath.bounds, wheelPath.bounds), -8, -8);
    
    // temporary clipping or any other context-specific state
    // After this block executes, the context returns entirely to its predrawing conditions.
    PushDraw(^{
        // Clip path to bounds union with shadow allowance to improve drawing performance
        [[UIBezierPath bezierPathWithRect:clipRect] addClip];
        
        SetShadow(nil, CGSizeMake(4, 4), 4);
        
        // 使用Transparency Layer的作用，在绘制过程中是关闭阴影的，等一并绘制完成后再交给当前context处理阴影
        // 可以理解为把它们放入一个图层再一并处理
        PushLayerDraw(^{
            [wheelPath fill:[UIColor orangeColor]];
            [bodyPath fill:[UIColor purpleColor]];
        });
    });
    
}
@end
