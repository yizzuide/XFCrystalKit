//
//  AddingEdgeEffects.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "AddingEdgeEffects.h"
#import "XFCrystalKit.h"

/**
 *  The sine function is compressed to just the last 25% of the gradient. Because the gradient is drawn radially from the center out, a shading effect appears only at the edge.
 *
 */
// 使用延迟的sin前半截曲线
InterpolationBlock block = ^CGFloat (CGFloat percent) {
    CGFloat skippingPercent = 0.75;
    if (percent < skippingPercent)
        return 0;
    CGFloat scaled = (percent - skippingPercent) * (1 / (1 - skippingPercent));
    return sinf(scaled * M_PI);
};

/*You can use this effect to apply easing just at the edges, as shown in Figure 6-9. The interpolation block compresses the easing function, applying it only after a certain percentage has passed—in this case, 50% of the radial distance:*/
// 使用延迟的开始缓冲 (3D环境中强光照的效果)
InterpolationBlock block2 = ^CGFloat (CGFloat percent) {
    CGFloat skippingPercent = 0.5;
    if (percent < skippingPercent)
        return 0;
    CGFloat scaled = (percent - skippingPercent) * (1 / (1 - skippingPercent));
    return EaseIn(scaled, 3);
};

//Basic Easing Background
//Say that you’re looking for a nice round button effect.
InterpolationBlock block3 = ^CGFloat (CGFloat percent) {
    return EaseIn(percent, 3);
};

@implementation AddingEdgeEffects

- (void)drawRect:(CGRect)rect {
    float radius = 100;
    float len = radius * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, len, len)];
    CGPoint center = RectGetCenter(rect);
    MovePathCenterToPoint(path, center);
    [path fill:[UIColor greenColor]];
    [path clipToPath];
    
    XFGradient *gradient = [XFGradient gradientUsingInterpolationBlock:block3
                                                           between:WHITE_LEVEL(0, 0) and:WHITE_LEVEL(0, 1)];
    //CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), gradient.gradient, center, 0, center, radius + 1, 0);
    // radius为第二个点的半径，+1是因为渐变填充时正好的半径在边缘会产生锯齿
    //[gradient drawRadialFrom:center toPoint:center radii:CGPointMake(0, radius + 1) style:0];
    [gradient drawBasicRadial:path.bounds];
}

@end
