//
//  XFGeometryFunc.h
//  XFCrystalKit
//
//  Created by yizzuide on 15/12/7.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

// Just because
#define TWO_PI (2 * M_PI)

// Undefined point
#define NULLPOINT CGRectNull.origin
#define POINT_IS_NULL(_POINT_) CGPointEqualToPoint(_POINT_, NULLPOINT)

// General
#define RECTSTRING(_aRect_)      NSStringFromCGRect(_aRect_)
#define POINTSTRING(_aPoint_)    NSStringFromCGPoint(_aPoint_)
#define SIZESTRING(_aSize_)      NSStringFromCGSize(_aSize_)

#define RECT_WITH_SIZE(_SIZE_) (CGRect){.size = _SIZE_}
#define RECT_WITH_POINT(_POINT_) (CGRect){.origin = _POINT_}

// How many points to interpolate
#define NUMBER_OF_BEZIER_SAMPLES 6

// Conversion
/** 角度转弧度 */
CGFloat DegreesFromRadians(CGFloat radians);
/** 弧度转角度 */
CGFloat RadiansFromDegrees(CGFloat degrees);

// Clamping
/** 限制一个值大小*/
CGFloat Clamp(CGFloat a, CGFloat min, CGFloat max);
/** 限制一个点在一个矩形内*/
CGPoint ClampToRect(CGPoint pt, CGRect rect);

// General Geometry
/** 获得矩形的中心点 */
CGPoint RectGetCenter(CGRect rect);
/** 求两点之间的距离*/
CGFloat PointDistanceFromPoint(CGPoint p1, CGPoint p2);

// Construction
/** 从CGPoint和CGSize创建CGRect */
CGRect RectMakeRect(CGPoint origin,CGSize size);
/** 从CGSize创建CGRect */
CGRect SizeMakeRect(CGSize size);
/** 从两点创建CGRect */
CGRect PointsMakeRect(CGPoint p1, CGPoint p2);
/** 从原点创建CGRect */
CGRect OriginMakeRect(CGPoint origin);
/** 从中心点和大小范围创建一个矩形 */
CGRect RectAroundCenter(CGPoint center, CGSize size);
/** 创建一个子矩形在父矩形中居中 */
CGRect RectCenteredInRect(CGRect rect, CGRect containerRect);

// Point Locations
/** 得到距形的百分点位置*/
CGPoint RectGetPointAtPercents(CGRect rect, CGFloat xPercent, CGFloat yPercent);
CGPoint PointAddPoint(CGPoint p1, CGPoint p2);
CGPoint PointSubtractPoint(CGPoint p1, CGPoint p2);

// Cardinal Points
// 得到矩形里的各个点
CGPoint RectGetTopLeft(CGRect rect);
CGPoint RectGetTopRight(CGRect rect);
CGPoint RectGetBottomLeft(CGRect rect);
CGPoint RectGetBottomRight(CGRect rect);
CGPoint RectGetMidTop(CGRect rect);
CGPoint RectGetMidBottom(CGRect rect);
CGPoint RectGetMidLeft(CGRect rect);
CGPoint RectGetMidRight(CGRect rect);

// Aspect and Fitting
/** 创建一个子矩形在父矩形中居中的百分比大小 */
CGRect RectInsetByPercent(CGRect destinationRect,CGFloat percent);

// 图片填充方式Fit与Fill
/** 按比例缩放大小 */
CGSize SizeScaleByFactor(CGSize aSize, CGFloat factor);
/** 获得源Rect到目标Rect的比例大小*/
CGSize  RectGetScale(CGRect sourceRect, CGRect destRect);
/** 计算Fit方式缩放比例 */
CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect);
/** 计算Fit方式填充后的矩形 */
CGRect RectByFittingInRect(CGRect sourceRect,
                           CGRect destinationRect);
/** 计算Fill方式缩放比例 */
CGFloat AspectScaleFill(CGSize sourceSize, CGRect destRect);
/** 计算Fill方式填充后的矩形 */
CGRect RectByFillingRect(CGRect sourceRect, CGRect destinationRect);


/** 基于图片中主要内容Alignment Rectangle布局，忽略图片中装饰内容
 在Auto layout布局中能过[image imageWithAlignmentRectInsets:insets]设置Alignment Rectangle实现对内容的居中对齐
 */
UIEdgeInsets BuildInsets(CGRect alignmentRect, CGRect imageBounds);



// 用于打印各种Transform的值,tx，ty就表示了它的偏移量，所以可以直接打印，下面的方法是要通过计算出来
/** 打印Transform的ScaleX值 */
CGFloat TransformGetXScale(CGAffineTransform t);
/** 打印Transform的ScaleY值 */
CGFloat TransformGetYScale(CGAffineTransform t);
/** 打印Transform的值Rotation */
CGFloat TransformGetRotation(CGAffineTransform t);

