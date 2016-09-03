//
//  XFGeometryFunc.m
//  XFCrystalKit
//
//  Created by yizzuide on 15/12/7.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

#import "XFGeometryFunc.h"

#pragma mark - Conversion
// Degrees from radians
CGFloat DegreesFromRadians(CGFloat radians)
{
    return radians * 180.0f / M_PI;
}

// Radians from degrees
CGFloat RadiansFromDegrees(CGFloat degrees)
{
    return degrees * M_PI / 180.0f;
}

#pragma mark - General Geometry
// Retrieving a Rectangle Center
CGPoint RectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}
// 求两点之间的距离
CGFloat PointDistanceFromPoint(CGPoint p1, CGPoint p2)
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    
    return sqrt(dx*dx + dy*dy);
}

#pragma mark - Clamp
CGFloat Clamp(CGFloat a, CGFloat min, CGFloat max)
{
    return fmin(fmax(min, a), max);
}

CGPoint ClampToRect(CGPoint pt, CGRect rect)
{
    CGFloat x = Clamp(pt.x, CGRectGetMinX(rect), CGRectGetMaxX(rect));
    CGFloat y = Clamp(pt.y, CGRectGetMinY(rect), CGRectGetMaxY(rect));
    return CGPointMake(x, y);
}


/* ----------------------------------------- 矩形计算方法 ------------------------------------------------- */
#pragma mark - Construction
// Building Rectangles from Points and Sizes
CGRect RectMakeRect(CGPoint origin,CGSize size)
{
    return (CGRect){.origin = origin, .size = size};
}
// Building Rectangles from Sizes
CGRect SizeMakeRect(CGSize size)
{
    return (CGRect){.origin = CGPointMake(0, 0), .size = size};
}
CGRect PointsMakeRect(CGPoint p1, CGPoint p2)
{
    CGRect rect = CGRectMake(p1.x, p1.y, p2.x - p1.x, p2.y - p1.y);
    return CGRectStandardize(rect);
}
CGRect OriginMakeRect(CGPoint origin)
{
    return (CGRect){.origin = origin};
}
// Creating a Rectangle Around a Target Point
CGRect RectAroundCenter(CGPoint center, CGSize size)
{
    CGFloat halfWidth = size.width * 0.5f;
    CGFloat halfHeight = size.height * 0.5f;
    return CGRectMake(center.x - halfWidth, center.y - halfHeight, size.width, size.height);
}
// Centering a Rectangle
CGRect RectCenteredInRect(CGRect rect, CGRect containerRect)
{
    CGFloat dx = CGRectGetMidX(containerRect) - CGRectGetMidX(rect);
    CGFloat dy = CGRectGetMidY(containerRect) - CGRectGetMidY(rect);
    return CGRectOffset(rect, dx, dy);
}

#pragma mark - Point Location
CGPoint RectGetPointAtPercents(CGRect rect, CGFloat xPercent, CGFloat yPercent)
{
    CGFloat dx = xPercent * rect.size.width;
    CGFloat dy = yPercent * rect.size.height;
    return CGPointMake(rect.origin.x + dx, rect.origin.y + dy);
}

CGPoint PointAddPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CGPoint PointSubtractPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

#pragma mark - Cardinal Points
CGPoint RectGetTopLeft(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMinX(rect),
                       CGRectGetMinY(rect)
                       );
}

CGPoint RectGetTopRight(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMaxX(rect),
                       CGRectGetMinY(rect)
                       );
}

CGPoint RectGetBottomLeft(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMinX(rect),
                       CGRectGetMaxY(rect)
                       );
}

CGPoint RectGetBottomRight(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMaxX(rect),
                       CGRectGetMaxY(rect)
                       );
}

CGPoint RectGetMidTop(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMidX(rect),
                       CGRectGetMinY(rect)
                       );
}

CGPoint RectGetMidBottom(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMidX(rect),
                       CGRectGetMaxY(rect)
                       );
}

CGPoint RectGetMidLeft(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMinX(rect),
                       CGRectGetMidY(rect)
                       );
}

CGPoint RectGetMidRight(CGRect rect)
{
    return CGPointMake(
                       CGRectGetMaxX(rect),
                       CGRectGetMidY(rect)
                       );
}


#pragma mark - Aspect and Fitting

// Creating a Rectangle inset by percent
CGRect RectInsetByPercent(CGRect destinationRect,CGFloat percent)
{
    CGSize SizeScaleByFactor(CGSize aSize, CGFloat factor);
    
    CGSize innerSize = SizeScaleByFactor(destinationRect.size, percent);
    return RectAroundCenter(RectGetCenter(destinationRect), innerSize);
}

// Calculating a Destination by Fitting to a Rectangle
// Multiply the size components by the factor
CGSize SizeScaleByFactor(CGSize aSize, CGFloat factor)
{
    return CGSizeMake(aSize.width * factor, aSize.height * factor);
}

CGSize RectGetScale(CGRect sourceRect, CGRect destRect)
{
    CGSize sourceSize = sourceRect.size;
    CGSize destSize = destRect.size;
    
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    
    return CGSizeMake(scaleW, scaleH);
}

// Calculate scale for fitting a size to a destination
CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect)
{
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return MIN(scaleW, scaleH);
}
// Return a rect fitting a source to a destination
CGRect RectByFittingInRect(CGRect sourceRect,
                           CGRect destinationRect)
{
    CGFloat aspect = AspectScaleFit(sourceRect.size, destinationRect);
    CGSize targetSize = SizeScaleByFactor(sourceRect.size, aspect);
    return RectAroundCenter(RectGetCenter(destinationRect), targetSize);
}
// Calculate scale for filling a destination
CGFloat AspectScaleFill(CGSize sourceSize, CGRect destRect) {
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return MAX(scaleW, scaleH);
}

// Return a rect that fills the destination
CGRect RectByFillingRect(CGRect sourceRect, CGRect destinationRect)
{
    CGFloat aspect = AspectScaleFill(sourceRect.size, destinationRect);
    CGSize targetSize = SizeScaleByFactor(sourceRect.size, aspect);
    return RectAroundCenter(RectGetCenter(destinationRect), targetSize);
}



// Building Edge Insets from Alignment Rectangles used for auto layout.
/*It determines how far the alignment rectangle lies from each edge of the parent rectangle, and it returns a UIEdgeInset structure representing those values. Use this function to build insets from the intrinsic geometry of your core visuals.*/
UIEdgeInsets BuildInsets(CGRect alignmentRect, CGRect imageBounds)
{
    // Ensure alignment rect is fully within source
    CGRect targetRect = CGRectIntersection(alignmentRect, imageBounds);
    // Calculate insets
    UIEdgeInsets insets;
    insets.left = CGRectGetMinX(targetRect) - CGRectGetMinX(imageBounds);
    insets.right = CGRectGetMaxX(imageBounds) - CGRectGetMaxX(targetRect);
    insets.top = CGRectGetMinY(targetRect) - CGRectGetMinY(imageBounds);
    insets.bottom = CGRectGetMaxY(imageBounds) - CGRectGetMaxY(targetRect);
    return insets;
}
/* ----------------------------------------------------------------------------------------------------- */


#pragma mark -  Transforms
/* ----------------------------------用于打印各种Transform的值 --------------------------------------------- */
// It calculates x- and y-scale values as well as rotation, returning these values from the components of the transform structure.
// There’s never any need to calculate the translation (position offset) values. These values are stored for you directly in the tx and ty fields, essentially in “plain text.”
// Extract the x scale from transform
CGFloat TransformGetXScale(CGAffineTransform t) {
    return sqrt(t.a * t.a + t.c * t.c);
}
// Extract the y scale from transform
CGFloat TransformGetYScale(CGAffineTransform t) {
    return sqrt(t.b * t.b + t.d * t.d);
}
// Extract the rotation in radians
CGFloat TransformGetRotation(CGAffineTransform t) {
    return atan2f(t.b, t.a);
}
/* ----------------------------------------------------------------------------------------------------- */
