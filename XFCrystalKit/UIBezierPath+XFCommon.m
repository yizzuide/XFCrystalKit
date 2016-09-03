//
//  UIBezierPath+XFCommon.m
//  XFCrystalKit
//
//  Created by 付星 on 16/8/18.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "UIBezierPath+XFCommon.h"
#import "UIBezierPath+XFElements.h"
#import "XFBezierFunc.h"

@implementation UIBezierPath (XFCommon)

#pragma mark - Stroking and Filling

- (void) addDashes
{
    AddDashesToPath(self);
}

- (void) addDashes: (NSArray *) pattern
{
    if (!pattern.count) return;
    CGFloat *dashes = malloc(pattern.count * sizeof(CGFloat));
    for (int i = 0; i < pattern.count; i++)
        dashes[i] = [pattern[i] floatValue];
    [self setLineDash:dashes count:pattern.count phase:0];
    free(dashes);
}

- (void) applyPathPropertiesToContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, self.lineCapStyle);
    CGContextSetLineJoin(context, self.lineJoinStyle);
    CGContextSetMiterLimit(context, self.miterLimit);
    CGContextSetFlatness(context, self.flatness);
    
    NSInteger count;
    [self getLineDash:NULL count:&count phase:NULL];
    
    CGFloat phase;
    CGFloat *pattern = malloc(count * sizeof(CGFloat));
    [self getLineDash:pattern count:&count phase:&phase];
    CGContextSetLineDash(context, phase, pattern, count);
    free(pattern);
}


- (void) stroke: (CGFloat) width color: (UIColor *) color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    PushDraw(^{
        if (color) [color setStroke];
        // Store the width
        CGFloat holdWidth = self.lineWidth;
        if (width > 0)
            self.lineWidth = width;
        [self stroke];
        // Restore the width
        self.lineWidth = holdWidth;
    });
}

- (void) stroke: (CGFloat) width
{
    [self stroke:width color:nil];
}

- (void) strokeInside: (CGFloat) width color: (UIColor *) color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    PushDraw(^{
        if (color) [color setStroke];
        CGFloat holdWidth = self.lineWidth;
        if (width > 0)
            self.lineWidth = width * 2;
        else
            self.lineWidth = self.lineWidth * 2;
        [self addClip];
        [self stroke];
        self.lineWidth = holdWidth;
    });
}

/**
 *  Normally, a stroke operation draws the stroke in the center of the path’s edge. This creates a stroke that’s half on one side of that edge and half on the other. Doubling the size ensures that the inside half of the stroke uses exactly the size you specified.
 *
 */
- (void) strokeInside: (CGFloat) width
{
    [self strokeInside:width color:nil];
}

- (void) fill: (UIColor *) fillColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    PushDraw(^{
        if (fillColor)
            [fillColor set];
        [self fill];
    });
}

// Apply color using the specified blend mode
- (void) fill: (UIColor *) fillColor withMode: (CGBlendMode) blendMode {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    PushDraw(^{
        CGContextSetBlendMode(context, blendMode); [self fill:fillColor];
    });
}
// Generate a noise pattern color
UIColor *NoiseColor(UIImage * noiseImage)
{
    if (noiseImage)
        return [UIColor colorWithPatternImage:noiseImage];
    //srandom(time(0));
    CGSize size = CGSizeMake(128, 128);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    for (int j = 0; j < size.height; j++)
        for (int i = 0; i < size.height; i++) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(i, j, 1, 1)];
            CGFloat level = ((double) random() / 10000000000.f);
            [path fill:[UIColor colorWithWhite:level alpha:1]];
        }
    noiseImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:noiseImage];
}
// Screen noise image into the fill
- (void) fillWithNoiseImage:(UIImage *)noiseImage fillColor: (UIColor *) fillColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    [self fill:fillColor];
    [self fill:[NoiseColor(noiseImage) colorWithAlphaComponent:0.5f] withMode:kCGBlendModeScreen];
}

#pragma mark - Clippage
- (void) clipToPath
{
    [self addClip];
}

- (void) clipToStroke:(NSUInteger)width
{
    CGPathRef pathRef = CGPathCreateCopyByStrokingPath(self.CGPath, NULL, width, kCGLineCapButt, kCGLineJoinMiter, 4);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGPathRelease(pathRef);
    [clipPath addClip];
}

#pragma mark - Shadow And Glows
- (void)drawOuterShadow:(UIColor *)color size:(CGSize)size blur:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) {
        NSLog(@"Error: No context to draw into");
        return;
    }
    CGContextSaveGState(context);
    // 这里使用路径填充反转并裁剪作用：可以使该方法省去一个用于填充颜色的参数，在CGContextSetShadowWithColor方法后的fill:方法是填充到被裁剪的外围路径里去了
    [self.inverse clipToPath];
    if (color)
        CGContextSetShadowWithColor(context, size, radius, color.CGColor);
    else
        CGContextSetShadow(context, size, radius);
    // 在这里当前路径是填不上的，因为裁剪的区域不在这个路径上面，但又需要这一行，才能做到方法内部管理GState
    [self fill:[UIColor grayColor]];
    CGContextRestoreGState(context);
}
// Drawing a (Better) Inner Shadow (inspired from PixelCut)
- (void)drawInnerShadow:(UIColor *)color size:(CGSize)size blur:(CGFloat)radius
{
    if (!color)
        COMPLAIN_AND_BAIL(@"Color cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    CGContextSaveGState(context);
    // Originally inspired by the PaintCode guys // http://paintcodeapp.com
    // Establish initial offsets
    CGFloat xOffset = size.width;
    CGFloat yOffset = size.height;
    // Adjust the border
    CGRect borderRect = CGRectInset(self.bounds, -radius, -radius);
    borderRect = CGRectOffset(borderRect, -xOffset, -yOffset);
    CGRect unionRect = CGRectUnion(borderRect, self.bounds);
    borderRect = CGRectInset(unionRect, -1.0, -1.0);
    // Tweak the size a tiny bit
    xOffset += round(borderRect.size.width);
    CGSize tweakSize = CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
    // Set the shadow and clip
    CGContextSetShadowWithColor(context, tweakSize, radius, color.CGColor);
    [self addClip];
    // Apply transform
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(borderRect.size.width), 0);
    UIBezierPath *negativePath = [self inverseInRect:borderRect];
    [negativePath applyTransform:transform];
    // Any color would do, use red for testing
    [negativePath fill:color];
    CGContextRestoreGState(context);
}

- (void)drawOuterGlow:(UIColor *)glowColor withRadius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to"); return;
    }
    CGContextSaveGState(context);
    // 这里使用路径填充反转并裁剪作用：可以使该方法省去一个用于填充颜色的参数，在CGContextSetShadowWithColor方法后的fill:方法是填充到被裁剪的外围路径里去了
    [self.inverse clipToPath];
    CGContextSetShadowWithColor(context,CGSizeZero, radius, glowColor.CGColor);
    // 在这里当前路径是填不上的，因为裁剪的区域不在这个路径上面，但又需要这一行，才能做到方法内部管理GState
    [self fill:[UIColor grayColor]];
    CGContextRestoreGState(context);
}

- (void) drawInnerGlow: (UIColor *) fillColor withRadius: (CGFloat) radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    CGContextSaveGState(context);
    [self clipToPath];
    CGContextSetShadowWithColor(context, CGSizeZero, radius, fillColor.CGColor);
    [self.inverse fill:[UIColor grayColor]];
    CGContextRestoreGState(context);
}


#pragma mark - Misc

- (UIBezierPath *) safeCopy
{
    UIBezierPath *p = [UIBezierPath bezierPath];
    [p appendPath:self];
    CopyBezierState(self, p);
    return p;
}
@end
