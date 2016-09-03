//
//  XFContextFunc.m
//  XFCrystalKit
//
//  Created by yizzuide on 15/12/7.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

#import "XFContextFunc.h"
#import "XFGeometryFunc.h"

/* ----------------------------------------- Context操作 ------------------------------------------------- */
// Flip context by supplying the size
// this not require you to supply a context size in points. Quite honestly, it’s a bit of a hack, but it does work because the image it retrieves will use the same size and scale as the context.
void FlipContextVertically(CGSize size) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to flip");
        return;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f); // 垂直翻转内容
    transform = CGAffineTransformTranslate(transform, 0.0f, -size.height); // 垂直翻转上下文
    CGContextConcatCTM(context, transform);
}
void FlipContextHorizontally(CGSize size)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, -1.0f, 1.0f);
    transform = CGAffineTransformTranslate(transform, -size.width, 0.0);
    CGContextConcatCTM(context, transform);
}

// ***** 下面的方法是用于UIGraphicsBeginImageContextWithOptions()创建上下文使用的 ******************************
// Flip context by retrieving image
void FlipImageContextVertically() {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to flip");
        return;
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    FlipContextVertically(image.size);
}
void FlipImageContextHorizontally()
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to flip");
        return;
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    FlipContextHorizontally(image.size);
}

UIImage *ImageMirroredVertically(UIImage *source)
{
    UIGraphicsBeginImageContextWithOptions(source.size, NO, 0.0);
    FlipContextVertically(source.size);
    [source drawInRect:SizeMakeRect(source.size)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// You can also retrieve a context’s size by calling CGBitmapContextGetHeight() and CGBitmapContextGetWidth() and dividing the number of pixels these functions return by the screen scale. This assumes that you’re working with a bitmap context of some kind (like the one created by UIGraphicsBeginImageContextWithOptions()) and that you’re matching the screen’s scale in that context.
CGSize GetUIKitContextSize()
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) {
        return CGSizeZero;
    }
    CGSize size = CGSizeMake(CGBitmapContextGetWidth(context), CGBitmapContextGetHeight(context));
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(size.width / scale, size.height / scale);
}
// ****************************************************************************************************

// Flip the path vertically with respect to the context
void MirrorPathVerticallyInContext(UIBezierPath *path)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        NSLog(@"No context to draw into.");
    CGSize size = GetUIKitContextSize();
    CGRect contextRect = SizeMakeRect(size);
    CGPoint center = RectGetCenter(contextRect);
    
    // Flip path with respect to the context size
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, center.x, center.y);
    t = CGAffineTransformScale(t, 1, -1);
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    [path applyTransform:t];
}

/* ------------------------------------------上下文操作--------------------------------------------- */


void RotateContext(CGSize size, CGFloat theta)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, size.width / 2.0f, size.height / 2.0f);
    CGContextRotateCTM(context, theta);
    CGContextTranslateCTM(context, -size.width / 2.0f, -size.height / 2.0f);
}

void MoveContextByVector(CGPoint vector)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, vector.x, vector.y);
}



