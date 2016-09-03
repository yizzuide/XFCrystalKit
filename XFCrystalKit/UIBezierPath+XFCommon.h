//
//  UIBezierPath+XFCommon.h
//  XFCrystalKit
//
//  Created by 付星 on 16/8/18.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (XFCommon)

// Stroke/Fill
// Draw with width
- (void) stroke: (CGFloat) width;
- (void) stroke: (CGFloat) width color: (UIColor *) color;
// Stroking Inside a Path
- (void) strokeInside: (CGFloat) width;
- (void) strokeInside: (CGFloat) width color: (UIColor *) color;

// Fill with supplied color
- (void) fill: (UIColor *) fillColor;
// Apply color using the specified blend mode
- (void) fill: (UIColor *) fillColor withMode: (CGBlendMode) blendMode;
// Screen noise image into the fill
- (void) fillWithNoiseImage:(UIImage *)noiseImage fillColor: (UIColor *) fillColor;

- (void) addDashes;
- (void) addDashes: (NSArray *) pattern;
- (void) applyPathPropertiesToContext;

// Clipping
- (void) clipToPath; // I hate addClip
- (void) clipToStroke: (NSUInteger) width;

// Drawing a Outer Shadow(Manager GState)
- (void)drawOuterShadow:(UIColor *)color size:(CGSize)size blur:(CGFloat)radius;
// Drawing a (Better) Inner Shadow (inspired from PixelCut)
- (void) drawInnerShadow:(UIColor *)color size:(CGSize)size blur:(CGFloat)radius;

// 绘制路径外光
- (void)drawOuterGlow:(UIColor *)glowColor withRadius:(CGFloat)radius;
// 绘制路径内光
- (void) drawInnerGlow: (UIColor *) fillColor withRadius: (CGFloat) radius;

// Util
- (UIBezierPath *) safeCopy;
@end
