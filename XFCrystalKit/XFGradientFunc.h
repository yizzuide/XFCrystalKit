//
//  XFGradientFunc.h
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/13.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFGradient.h"

// 改变颜色亮度
UIColor *ScaleColorBrightness(UIColor *color, CGFloat amount);

// 绘制3D阴影路径
void DrawStrokedShadowedShape(UIBezierPath *path, UIColor *baseColor, CGRect dest);
// 绘制3D阴影文字
void DrawStrokedShadowedText(NSString *string, NSString *fontFace, UIColor *baseColor, CGRect dest);

// 绘制3D凹路径
void DrawIndentedPath(UIBezierPath *path, UIColor *primary);
// 绘制3D凹文字
void DrawIndentedText(NSString *string, NSString *fontFace, UIColor *primary, CGRect rect);
// 填充图片混合渐变
void DrawGradientOverTexture(UIBezierPath *path, UIImage *texture, XFGradient *gradient, CGFloat alpha);
// 绘制底光
void DrawBottomGlow(UIBezierPath *path, UIColor *color, CGFloat percent);
// 绘制图标式顶部光度
void DrawIconTopLight(UIBezierPath *path, CGFloat percent);

// add Gloss to Button
void DrawButtonGloss(UIBezierPath *path);

// 渐变转图像
UIImage *GradientImage(CGSize size, XFGradient *gradient);

// 返回一个线性渐变图像
UIImage *GradientMaskedReflectionImage(UIImage *sourceImage);

/**
 *  通过灰度图像来制作上下文蒙板
 *
 *  @param mask 遮盖层图像
 *  @param maskRect 遮罩大小
 *  @param covert2Gray 遮罩层是否转为灰度
 */
void ApplyMaskToContext(UIImage *mask,CGRect maskRect,BOOL covert2Gray);
/**
 *  返回一张应用图像蒙板图像
 *
 *  @param image 源图像
 *  @param mask  遮盖层图像 （默认遮罩层不会转为灰度，保留RGB和alpha通道）
 *
 *  @return 应用蒙板后的图像
 */
UIImage *ApplyMaskToImage(UIImage *image, UIImage *mask);
