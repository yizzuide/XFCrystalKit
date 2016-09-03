//
//  XFGradientFunc.m
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/13.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "XFGradientFunc.h"
#import "XFCrystalKit.h"
#import "UIBezierPath+XFCommon.h"

UIColor *ScaleColorBrightness(UIColor *color, CGFloat amount)
{
    CGFloat h, s, v, a;
    [color getHue:&h saturation:&s brightness:&v alpha:&a];
    CGFloat v1 = Clamp(v * amount, 0, 1);
    return [UIColor colorWithHue:h saturation:s brightness:v1 alpha:a];
}

void DrawStrokedShadowedShape(UIBezierPath *path, UIColor *baseColor, CGRect dest)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) COMPLAIN_AND_BAIL(@"No context to draw to", nil);
    
    PushDraw(^{
        // 设置外部阴影
        CGContextSetShadow(context, CGSizeMake(4, 4), 4);
        
        // 建立独立绘制层
        PushLayerDraw(^{
            
            // Draw letter gradient (to half brightness)（从明到暗由上至下的线性渐变）
            PushDraw(^{
                XFGradient *innerGradient = [XFGradient gradientFrom:baseColor to:ScaleColorBrightness(baseColor, 0.5)];
                [path addClip];
                [innerGradient drawTopToBottom:path.bounds];
            });
            
            // Add the inner shadow with darker color
            PushDraw(^{
                CGContextSetBlendMode(context, kCGBlendModeMultiply);
                DrawInnerShadow(path, ScaleColorBrightness(baseColor, 0.3), CGSizeMake(0, -2), 2);
            });
            
            // Stroke with reversed gray gradient
            PushDraw(^{
                // 两者会裁出从文字宽度中线到外边缘的交集选择区，所以会把文字挖出中空
                [path clipToStroke:6]; // 裁剪出文字边缘宽度
                [path.inverse addClip]; // 裁剪出文字边缘以外区域
                XFGradient *grayGradient = [XFGradient gradientFrom:WHITE_LEVEL(0.0, 1) to:WHITE_LEVEL(0.5, 1)];
                [grayGradient drawTopToBottom:dest];
            });
            
        });
    });
}

void DrawStrokedShadowedText(NSString *string, NSString *fontFace, UIColor *baseColor, CGRect dest)
{
    // Create text path
    UIBezierPath *text = BezierPathFromStringWithFontFace(string, fontFace, nil);
    FitPathToRect(text, dest);
    DrawStrokedShadowedShape(text, baseColor, dest);
}

//A pair of shadows—a black inner shadow at the top and a white shadow at the bottom—adds to the illusion.
void DrawIndentedPath(UIBezierPath *path, UIColor *primary)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) COMPLAIN_AND_BAIL(@"No context to draw to", nil);
    
    // Draw the black inner shadow at the top
    PushDraw(^{
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeMultiply);
        DrawInnerShadow(path, WHITE_LEVEL(0, 0.4), CGSizeMake(0, 2), 1);
    });
    // Draw the white shadow at the bottom
    DrawShadow(path, WHITE_LEVEL(1, 0.5), CGSizeMake(0, 2), 1);
    
    // Create a bevel effect（增加凹效果）
    BevelPath(path, WHITE_LEVEL(0, 0.4), 2, 0);
    
    // Draw a gradient from light (bottom) to dark (top)
    PushDraw(^{
        [path addClip];
        CGContextSetAlpha(UIGraphicsGetCurrentContext(), 0.3);
        
        UIColor *secondary = ScaleColorBrightness(primary, 0.3);
        XFGradient *gradient = [XFGradient gradientFrom:primary to:secondary];
        [gradient drawBottomToTop:path.bounds];
    });
    
}

void DrawIndentedText(NSString *string, NSString *fontFace, UIColor *primary, CGRect rect)
{
    UIBezierPath *letterPath = BezierPathFromStringWithFontFace(string, fontFace, nil);
    // RotatePath(letterPath, RadiansFromDegrees(-15));
    FitPathToRect(letterPath, rect);
    DrawIndentedPath(letterPath, primary);
}

void DrawGradientOverTexture(UIBezierPath *path, UIImage *texture, XFGradient *gradient, CGFloat alpha)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    if (!texture) COMPLAIN_AND_BAIL(@"Texture cannot be nil", nil);
    if (!gradient) COMPLAIN_AND_BAIL(@"Gradient cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGRect rect = path.bounds;
    PushDraw(^{
        CGContextSetAlpha(context, alpha);
        [path addClip];
        PushLayerDraw(^{
            [texture drawInRect:rect];
            CGContextSetBlendMode(context, kCGBlendModeColor);
            [gradient drawTopToBottom:rect];
        });
    });
}

void DrawBottomGlow(UIBezierPath *path, UIColor *color, CGFloat percent)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    if (!color) COMPLAIN_AND_BAIL(@"Color cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGRect rect = path.computedBounds;
    CGPoint h1 = RectGetPointAtPercents(rect, 0.5f, 1.0f);
    CGPoint h2 = RectGetPointAtPercents(rect, 0.5f, 1.0f - percent);
    
    XFGradient *gradient = [XFGradient easeInOutGradientBetween:color and:[color colorWithAlphaComponent:0.0f]];
    
    PushDraw(^{
        [path addClip];
        [gradient drawFrom:h1 toPoint:h2];
    });
}

void DrawIconTopLight(UIBezierPath *path, CGFloat percent)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    // Establish an ellipse and move it up to cover just
    // p percent of the parent path
    percent = 1.0f - percent;
    CGRect rect = path.bounds;
    CGRect offset = rect;
    offset.origin.y -= percent * offset.size.height;
    offset = CGRectInset(offset, -offset.size.width * 0.3f, 0);
    
    // Build an oval path
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:offset];
    XFGradient *gradient = [XFGradient gradientFrom:WHITE_LEVEL(1, 0.0) to: WHITE_LEVEL(1, 0.5)];
    
    PushDraw(^{
        // 裁剪它们的交集
        [path addClip];
        [ovalPath addClip];
        
        // Draw gradient
        CGPoint p1 = RectGetPointAtPercents(rect, 0.5, 0.0);
        CGPoint p2 = RectGetPointAtPercents(ovalPath.bounds, 0.5, 1);
        [gradient drawFrom:p1 toPoint:p2];
    });
}

// add Gloss to Button
void DrawButtonGloss(UIBezierPath *path) {
    if (!path) COMPLAIN_AND_BAIL( @"Path cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    // Create a simple white to clear gradient
    XFGradient *gradient = [XFGradient gradientFrom:WHITE_LEVEL(1, 1) to: WHITE_LEVEL(1, 0)];
    // Copy and offset the path by 35% vertically
    UIBezierPath *offset = [UIBezierPath bezierPath];
    [offset appendPath:path];
    CGRect bounding = path.computedBounds;
    OffsetPath(offset, CGSizeMake(0, bounding.size.height * 0.35));
    // Draw from just over the path to its middle
    CGPoint p1 = RectGetPointAtPercents( bounding, 0.5, -0.2);
    CGPoint p2 = RectGetPointAtPercents( bounding, 0.5, 0.5);
    // 这里使用Transparency Layer可以防止CGContextClearRect清空其它层上的填充
    PushLayerDraw(^{
        PushDraw(^{
            // Draw the overlay inside the path bounds
            [path addClip];
            [gradient drawFrom:p1 toPoint:p2];
        });
        PushDraw(^{
            // And then clear away the offset area
            // 这个offset路径不是用来绘制填充的，addClip可以锁定一个区域，配合下面的清空区域方法，可以把锁定的里面渐变颜色清空
            [offset addClip];
            CGContextClearRect(context, bounding);
        });
    });
}

void ApplyMaskToContext(UIImage *mask,CGRect maskRect,BOOL covert2Gray)
{
    if (!mask) COMPLAIN_AND_BAIL(@"Mask cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to apply mask to", nil);
    
    UIImage *gray;
    // Ensure that mask is grayscale
    if (covert2Gray) {
        gray = [XFCrystal imageConvert2GrayFrom:mask];
    }
    
    
    // Clipping takes place in Quartz space, so flip before applying
    FlipContextVertically(maskRect.size);
    CGContextClipToMask(context, maskRect, covert2Gray ? gray.CGImage : mask.CGImage);
    FlipContextVertically(maskRect.size);
}

UIImage *ApplyMaskToImage(UIImage *image, UIImage *mask)
{
    if (!image) COMPLAIN_AND_BAIL_NIL(@"Image cannot be nil", nil);
    if (!mask) COMPLAIN_AND_BAIL_NIL(@"Mask cannot be nil", nil);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    ApplyMaskToContext(mask,SizeMakeRect(image.size),NO);
    [image drawInRect:SizeMakeRect(image.size)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

UIImage *GradientImage(CGSize size, XFGradient *gradient)
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [gradient drawTopToBottom:SizeMakeRect(size)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage *GradientMaskedReflectionImage(UIImage *sourceImage)
{
    UIImage *mirror = ImageMirroredVertically(sourceImage);
    UIImage *gradImage = GradientImage(sourceImage.size, [XFGradient easeInOutGradientBetween:WHITE_LEVEL(1, 0.5) and:WHITE_LEVEL(1, 0.0)]);
    /*
     Instead of passing a grayscale image mask to the third parameter, this function passes a normal RGB image with an alpha channel. When used in this fashion, the image acts as an alpha mask. Alpha levels from the image determine what portions of the clipping area are affected by new updates.*/
    UIImage *masked = ApplyMaskToImage(mirror, gradImage);
    return masked;
}
