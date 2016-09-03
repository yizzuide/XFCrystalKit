//
//  XFBezierFunc.h
//  XFCrystalKit
//
//  Created by yizzuide on 15/12/7.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFBezierElement.h"
#import "UIBezierPath+XFCommon.h"

#define COMPLAIN_AND_BAIL(_COMPLAINT_, _ARG_) {NSLog(_COMPLAINT_, _ARG_); return;}
#define COMPLAIN_AND_BAIL_NIL(_COMPLAINT_, _ARG_) {NSLog(_COMPLAINT_, _ARG_); return nil;}

typedef void (^DrawingBlock)(CGRect bounds);
typedef void (^DrawingStateBlock)();
void PushDraw(DrawingStateBlock block);
void PushLayerDraw(DrawingStateBlock block);

// Transformations
// Rotating a Path Around Its Center
// Translate path’s origin to its center before applying the transform
void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform);
// Apply transform to its center and return a copy path
UIBezierPath *PathByApplyingTransform(UIBezierPath *path, CGAffineTransform transform);

// Utility
// Rotate path around its center
void RotatePath(UIBezierPath *path, CGFloat theta);
// Scale path to sx, sy
void ScalePath(UIBezierPath *path, CGFloat sx, CGFloat sy);
// Offset a path
void OffsetPath(UIBezierPath *path, CGSize offset);
// Move path to a new origin
void MovePathToPoint(UIBezierPath *path, CGPoint point);
// Center path around a new point
void MovePathCenterToPoint(UIBezierPath *path, CGPoint point);
// Mirror direction...
// Flip horizontally
void MirrorPathHorizontally(UIBezierPath *path);
// Flip vertically
void MirrorPathVertically(UIBezierPath *path);

// Alter
// Fitting a Path to Rect
void FitPathToRect(UIBezierPath *path, CGRect rect);
// Filling a Path to Rect
void AdjustPathToRect(UIBezierPath *path, CGRect destRect);


// Return calculated bounds
CGRect PathBoundingBox(UIBezierPath *path);
// Return calculated bounds taking line width into account
CGRect PathBoundingBoxWithLineWidth(UIBezierPath *path);

// Return the calculated center point (precise layer,for transformations)
CGPoint PathBoundingCenter(UIBezierPath *path);
// Return the center point for the bounds property (general layer)
CGPoint PathCenter(UIBezierPath *path);

// Construct path
// Path Element
// Convert one element to BezierElement and save to array
//void GetBezierElements(void *info, const CGPathElement *element);
// Construct a Bezier path from an element array<BezierElement *>
UIBezierPath *BezierPathWithElements(NSArray *elements);
UIBezierPath *BezierPathWithPoints(NSArray *points);
UIBezierPath *InterpolatedPath(UIBezierPath *path);

// Partial paths
UIBezierPath *CroppedPath(UIBezierPath *path, CGFloat percent);
UIBezierPath *PathFromPercentToPercent(UIBezierPath *path, CGFloat startPercent, CGFloat endPercent);



// Path Attributes
void CopyBezierState(UIBezierPath *source, UIBezierPath *destination);
void CopyBezierDashes(UIBezierPath *source, UIBezierPath *destination);
void AddDashesToPath(UIBezierPath *path);
/**
 *  设置外部阴影
 *
 *  @param color 阴影颜色
 *  @param size  偏移量
 *  @param blur  模糊量 (blur > 0 为模糊)
 */
void SetShadow(UIColor *color, CGSize size, CGFloat blur);
/**
 *  绘制内侧阴影
 *
 *  @param path  源路径
 *  @param color 阴影颜色
 *  @param size  偏移量（这个和设置外部阴影方向相反，因为它实际是给原路径的反转区域设置的）
 *  @param blur  模糊量 (blur > 0 为模糊)
 */
void DrawInnerShadow(UIBezierPath *path, UIColor *color, CGSize size, CGFloat blur);
// 外部阴影
void DrawShadow(UIBezierPath *path, UIColor *color, CGSize size, CGFloat blur);

// 其它Photoshop Style Effects
void EmbossPath(UIBezierPath *path, UIColor *color, CGFloat radius, CGFloat blur);
void BevelPath(UIBezierPath *p,  UIColor *color, CGFloat r, CGFloat theta);
void InnerBevel(UIBezierPath *p,  UIColor *color, CGFloat r, CGFloat theta);
void ExtrudePath(UIBezierPath *path, UIColor *color, CGFloat radius, CGFloat angle);


// String to Path
/**
 *  文本转路径
 *
 *  @param string              文本
 *  @param font                字体
 *  @param ^CharacterDrawBlock 单个字符路径处理回调,并返回每个字符路径宽度，如果返回为0，内容会自动计算
 *
 *  @return UIBezierPath
 */
UIBezierPath *BezierPathFromString(NSString *string, UIFont *font,CGFloat(^CharacterDrawBlock)(UIBezierPath *charPath,NSInteger index));
UIBezierPath *BezierPathFromStringWithFontFace(NSString *string, NSString *fontFace,CGFloat(^CharacterDrawBlock)(UIBezierPath *charPath,NSInteger index));

// N-Gons
// 多边形
UIBezierPath *BezierPolygon(NSUInteger numberOfSides);
// 屈折变化的多边形
UIBezierPath *BezierInflectedShape(NSUInteger numberOfInflections, CGFloat percentInflection);
// 多角星形
UIBezierPath *BezierStarShape(NSUInteger numberOfInflections, CGFloat percentInflection);

// Misc
void ClipToRect(CGRect rect);
void FillRect(CGRect rect, UIColor *color);

/**
 *  Font Fitting 查找最合适在Rect显示的字体
 *
 *  @param string    文本
 *  @param fontFace  字体名
 *  @param rect      文本框
 *  @param tolerance 调整参数（可传1为默认文本框宽度计算），在设置文本段落行高后，可以降低为小数（如：0.7）
 *
 *  @return 合适的字体
 */
UIFont *FontForWrappedString(NSString *string, NSString *fontFace, CGRect rect, CGFloat tolerance);
