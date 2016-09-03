//
//  XFLinearAlgebraFunc.h
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/13.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFBezierElement.h"

#define NUMBER_OF_BEZIER_SAMPLES    6

typedef CGFloat (^InterpolationBlock)(CGFloat percent);

// Return Bezier Value
float CubicBezier(float t, float start, float c1, float c2, float end);
float QuadBezier(float t, float start, float c1, float end);

// Return Bezier Point
CGPoint CubicBezierPoint(CGFloat t, CGPoint start, CGPoint c1, CGPoint c2, CGPoint end);
CGPoint QuadBezierPoint(CGFloat t, CGPoint start, CGPoint c1, CGPoint end);

// Calculate Curve Length
float CubicBezierLength(CGPoint start, CGPoint c1, CGPoint c2, CGPoint end);
float QuadBezierLength(CGPoint start, CGPoint c1, CGPoint end);

// Element Distance
CGFloat ElementDistanceFromPoint(XFBezierElement *element, CGPoint point, CGPoint startPoint);

// Linear Interpolation
CGPoint InterpolateLineSegment(CGPoint p1, CGPoint p2, CGFloat percent, CGPoint *slope);

// Interpolate along element
CGPoint InterpolatePointFromElement(XFBezierElement *element, CGPoint point, CGPoint startPoint, CGFloat percent, CGPoint *slope);

// Ease
/**
 *  The three standard easing functions use two arguments: elapsed time and an exponent. The exponent you pass determines the type of easing produced. For standard cubic easing, you pass 3 as the second parameter, for quadratic easing, 2. Passing 1 produces a linear function without easing.
 */
CGFloat EaseIn(CGFloat currentTime, int factor);
CGFloat EaseOut(CGFloat currentTime, int factor);
CGFloat EaseInOut(CGFloat currentTime, int factor);