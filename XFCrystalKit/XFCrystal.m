//
//  XFCrystal.m
//  XFCrystalKit
//
//  Created by yizzuide on 15/10/21.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

@import CoreText;

#import "XFCrystal.h"
#import "XFGeometryFunc.h"
#import "XFContextFunc.h"
#import "XFBezierFunc.h"
#import "XFGradient.h"
#import "XFGradientFunc.h"
#import "ImageEffects.h"
#import "UIBezierPath+XFElements.h"

#define BITS_PER_COMPONENT  8
#define ARGB_COUNT 4

@implementation XFCrystal

// 文本跟随路径绘制
+ (void)drawAttributedString:(NSAttributedString *)string alongPath:(UIBezierPath *)path
{
    if (!string) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    // Check the points
    if (path.elements.count < 2) return;
    
    // Keep a running tab of how far the glyphs have traveled to
    // be able to calculate the percent along the point path
    float glyphDistance = 0.0f;
    float lineLength = path.pathLength;
    
    for (int loc = 0; loc < string.length; loc++) {
        // Retrieve the character
        NSRange range = NSMakeRange(loc, 1);
        NSAttributedString *item = [string attributedSubstringFromRange:range];
        // Start halfway through each character
        CGRect bounding = [item boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 context:nil];
        glyphDistance += bounding.size.width / 2;
        
        // Find new point on path
        CGPoint slope;
        CGFloat percentConsumed = glyphDistance / lineLength;
        CGPoint targetPoint = [path pointAtPercent:percentConsumed withSlope:&slope];
        
        // Accommodate the forward progress
        glyphDistance += bounding.size.width / 2;
        if (percentConsumed >= 1.0f) break;
        
        // Calculate the rotation
        float angle = atan(slope.y / slope.x);
        if (slope.x < 0) angle += M_PI;
        
        // Draw the glyph
        PushDraw(^{
            // Translate to target on path
            CGContextTranslateCTM(context,targetPoint.x, targetPoint.y);
            // Rotate along the slope
            CGContextRotateCTM(context, angle);
            // Adjust for the character size
            CGContextTranslateCTM(context, -bounding.size.width / 2, -item.size.height / 2);
            // Draw the character
            [item drawAtPoint:CGPointZero];
        });
    }
}

// 填充属性文本到组合路径框内
+ (void)drawAttributedStringInBezierSubpaths:(UIBezierPath *)path attributedString:(NSAttributedString *)attributedString
{
    NSAttributedString *string;
    NSAttributedString *remainder = attributedString;
    
    // Iterate through subpaths, drawing the
    // attributed string into each section
    for (UIBezierPath *subpath in path.subpaths) {
        string = remainder;
        [self drawAttributedStringIntoSubpath:subpath attributedString:string remainder:&remainder];
        if (remainder.length == 0) return;
    }
}
// 填充属性文本到一个子路径框内，剩余的文本返回
+ (void)drawAttributedStringIntoSubpath:(UIBezierPath *)path attributedString:(NSAttributedString *)attributedString remainder:(NSAttributedString **)remainder
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    // Handle vertical mirroring
    UIBezierPath *copy = [path safeCopy];
    MirrorPathVerticallyInContext(copy);
    
    // Establish the framesetter and retrieve the frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           (__bridge CFAttributedStringRef)attributedString);
    CTFrameRef theFrame = CTFramesetterCreateFrame(framesetter,
                                                   CFRangeMake(0, attributedString.length),
                                                   copy.CGPath,
                                                   NULL);
    
    // If the remainder can be dereferenced, calculate
    // the remaining attributed string
    if (remainder)
    {
        CFRange range = CTFrameGetVisibleStringRange(theFrame);
        NSInteger startLocation = range.location + range.length;
        NSInteger extent = attributedString.length - startLocation;
        NSAttributedString *substring = [attributedString attributedSubstringFromRange:
                                         NSMakeRange(startLocation, extent)];
        *remainder = substring;
    }
    
    // Perform the drawing in Quartz coordinates
    PushDraw(^{
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        FlipContextVertically(GetUIKitContextSize());
        CTFrameDraw(theFrame, UIGraphicsGetCurrentContext());
    });
    
    // Clean up the Core Text objects
    CFRelease(theFrame);
    CFRelease(framesetter);
}

// 绘制一段文本到路径框内
+ (void)drawAttributedString:(NSAttributedString *)attributedString inBezierPath:(UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
        COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    // Mirror a copy of the path
    UIBezierPath *copy = [path safeCopy];
    // 翻转路径以应用到Quartz坐标体系
    MirrorPathVerticallyInContext(copy);
    
    // Build a framesetter and extract a frame destination
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           (__bridge CFAttributedStringRef) attributedString);
    CTFrameRef theFrame = CTFramesetterCreateFrame(framesetter,
                                                   CFRangeMake(0, attributedString.length),
                                                   copy.CGPath,
                                                   NULL);
    // Draw into the frame
    PushDraw(^{
        // 清空文字矩阵信息（因为多次UIkit和Core Text的绘制会产生干扰）
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        // 翻转绘制内容
        FlipContextVertically(GetUIKitContextSize());
        CTFrameDraw(theFrame, UIGraphicsGetCurrentContext());
    });
    
    CFRelease(theFrame);
    CFRelease(framesetter);
}

// 返回光栅效果进度的一帧图像（使用Core Image）
+ (UIImage *)imageForTransitionCopyMachineFromImage:(UIImage *)source targetImage:(UIImage *)target progress:(float)progress
{
    CIFilter *transition;
    if (!transition) {
        transition = [CIFilter filterWithName: @"CICopyMachineTransition"];
        [transition setDefaults];
    }
    [transition setValue: [CIImage imageWithCGImage:source.CGImage] forKey: @"inputImage"];
    [transition setValue: [CIImage imageWithCGImage:target.CGImage] forKey: @"inputTargetImage"];
    // Retrieve the current progress
    [transition setValue: @(fmodf(progress, 1.0f)) forKey: @"inputTime"];
    
    // This next bit crops the image to the desired size
    CIFilter *crop = [CIFilter filterWithName: @"CICrop"];
    [crop setDefaults];
    [crop setValue:transition.outputImage
            forKey:@"inputImage"];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat w = source.size.width * scale;
    CGFloat h = source.size.height * scale;
    CIVector *v = [CIVector vectorWithX:0
                                      Y:0
                                      Z:w
                                      W:h];
    [crop setValue:v forKey:@"inputRectangle"];
    CGImageRef cgImageRef = [[CIContext contextWithOptions:nil]
                             createCGImage:crop.outputImage fromRect:crop.outputImage.extent];
    
    // Render the cropped, blurred results
    UIGraphicsBeginImageContextWithOptions(source.size, NO, 0.0);
    // Flip for Quartz drawing
    FlipContextVertically(source.size);
    // Draw the image
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       SizeMakeRect(source.size), cgImageRef);
    // Retrieve the final image
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImageRef);
    
    return result;
}

// 返回一张带倒影的图像
+ (UIImage *)imageReflectionEffectFromSourceImage:(UIImage *)source gap:(CGFloat)gapHeight
{
    //UIImage *source = [UIImage imageNamed:@"profile"];
    UIImage *refImage = GradientMaskedReflectionImage(source);
    return [XFCrystal imageContextBuildWithSize:CGSizeMake(source.size.width, source.size.height * 2 + gapHeight) drawBlock:^(CGContextRef context) {
        [source drawAtPoint:CGPointZero];
        [refImage drawAtPoint:CGPointMake(0, source.size.height + gapHeight)];
    } isOpaque:NO];
}

// 返回一张模糊（柔化）边缘的图像
+ (UIImage *)imageSoftEdgeWithSize:(CGSize)size
                             sourceImage:(UIImage *)source
                              insetScale:(CGFloat)insetScale
                            cornerRadius:(CGFloat)cornerRadius
                          blurWithRaduis:(CGFloat)blurRaduis
{
    // 外框
    CGRect targetRect = SizeMakeRect(size);
    // 内框
    CGRect inset = RectInsetByPercent(targetRect, insetScale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:inset cornerRadius:cornerRadius];
    
    // 获得最后的图片
    return [XFCrystal imageContextBuildWithSize:targetRect.size drawBlock:^(CGContextRef context) {
        //UIRectFrame(targetRect);
        // 创建一个遮罩Rect并在这个Rect绘制内容
        [XFCrystal drawMaskInRect:targetRect maskBlock:^(CGContextRef context, CGRect rect) {
            // 填充整个外框大小为黑色
            FillRect(rect, [UIColor blackColor]);
            if (blurRaduis > 0.f) {
                [XFCrystal drawBlurWithRaduis:blurRaduis drawBlock:^(CGContextRef context) {
                    // 绘制模糊内框大小
                    [path fill:[UIColor whiteColor]]; // blured
                }];
            }else{
                [path fill:[UIColor whiteColor]];// no-blured
            }
            
        } drawBlock:^(CGContextRef context, CGRect rect) {
            [XFCrystal drawImage:source targetRect:rect drawingPattern:XFImageDrawingPatternFilling];
        }];
    } isOpaque:NO];
}

// 在当前Context绘制模糊层
+ (void)drawBlurWithRaduis:(CGFloat)blurRaduis drawBlock:(DrawingBlok)drawBlock
{
    if (!drawBlock) return; // nothing to do
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    // Draw and blur the image
    UIImage *baseImage = [XFCrystal imageContextBuildWithSize:GetUIKitContextSize() drawBlock:drawBlock isOpaque:NO];
    UIImage *blurred = [XFCrystal imageGaussianBlurFrom:baseImage radius:blurRaduis];
    [blurred drawAtPoint:CGPointZero];
}

// 转换成高斯模糊图像
+ (UIImage *)imageGaussianBlurFrom:(UIImage *)image radius:(NSInteger)radius
{
    // 使用Core Image方式，性能是个问题
    /*if (!image) COMPLAIN_AND_BAIL_NIL(
                                      @"Mask cannot be nil", nil);
    // Create Core Image blur filter
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:@(radius) forKey:@"inputRadius"];
    
    // Pass the source image as the input
    [blurFilter setValue:[CIImage imageWithCGImage:
                          image.CGImage] forKey:@"inputImage"];
    // 创建区域模糊滤镜
    CIFilter *crop = [CIFilter filterWithName: @"CICrop"];
    [crop setDefaults];
    [crop setValue:blurFilter.outputImage forKey:@"inputImage"];
    
    // Apply crop
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat w = image.size.width * scale;
    CGFloat h = image.size.height * scale;
    CIVector *v = [CIVector vectorWithX:0 Y:0 Z:w W:h];
    [crop setValue:v forKey:@"inputRectangle"];
    CGImageRef cgImageRef = [[CIContext contextWithOptions:nil]
                             createCGImage:crop.outputImage fromRect:crop.outputImage.extent];
    
    // Render the cropped, blurred results
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    // Flip for Quartz drawing
    FlipContextVertically(image.size);
    // Draw the image
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       SizeMakeRect(image.size), cgImageRef);
    // Retrieve the final image
    UIImage *blurred = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImageRef);
    return blurred;*/
    
    // 使用vimage方式 高效
    return [image blurredImageWithSize:CGSizeMake(radius, radius)];
    
}

// 应用蒙板自定义绘制
+ (void)drawMaskInRect:(CGRect)rect maskBlock:(void (^)(CGContextRef context,CGRect rect))maskBlock drawBlock:(void(^)(CGContextRef context,CGRect rect))drawBlock
{
    PushDraw(^{
        UIImage *mask = [XFCrystal imageContextBuildWithSize:rect.size drawBlock:^(CGContextRef context) {
            maskBlock(context,rect);
        } isOpaque:NO];
        
        // 应用上下文蒙板
        ApplyMaskToContext(mask,rect,YES);
        
        drawBlock(UIGraphicsGetCurrentContext(),rect);
    });
}


#pragma mark -- 实用图案进度绘制方法
// 绘制路线图案进度
+ (void)drawProgressionOfPath:(UIBezierPath *)patternPath maxPercent:(CGFloat) maxPercent drawTilePathBlock:(void(^)(float index,float percent,CGPoint currentPoint,float colorDLevel))drawTilePathBlock
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    // Bound the percent value (定义取值范围)
    CGFloat maximumPercent = fmaxf(fminf(maxPercent, 1.0f), 0.0f);
    CGContextSaveGState(context);
    
    // One sample every six points (每6点一个样本)
    CGFloat distance = patternPath.pathLength;
    int samples = distance / 6; // 分成六部分
    
    // Change in white level for each sample
    // 颜色增量，samples越长，dLevel值越小，这样后面计算过滤色就更丰富
    float dLevel = 0.75 / (CGFloat) samples;
    
    // 使用一个部分来代替全长路径进行计算（省去循环数量）
    for (float i = 0.001; i <= samples * maximumPercent; i += 1) {
        // Calculate progress and color
        // 计算当前百分点
        CGFloat percent = i / (CGFloat) samples;
        CGPoint point = [patternPath pointAtPercent:percent withSlope:NULL];
        // 绘制进度路径
        drawTilePathBlock(i,percent,point,dLevel);
    }
    CGContextRestoreGState(context);
}

// 绘制一个pattern color image
+ (UIImage *)drawPatternColorImageWithSize:(CGSize)targetSize drawBlock:(void(^)(CGContextRef context,CGRect rect))drawBlock
{
    CGRect targetRect = SizeMakeRect(targetSize);
    UIImage *image = [self imageContextBuildWithSize:targetSize drawBlock:^(CGContextRef context) {
        if (drawBlock) {
            drawBlock(context,targetRect);
        }
    } isOpaque:YES];
    
    return image;
}

// 在某一个Rect中绘制文本
+ (void)drawString:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor centeredInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) NSLog(@"No context to draw into", nil);
    
    // Calculate string size
    CGSize stringSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    // Find the target rectangle
    CGRect target = RectAroundCenter(RectGetCenter(rect), stringSize);
    
    // Draw the string
    CGContextSaveGState(context);
    [textColor set];
    [text drawInRect:target withAttributes:@{NSFontAttributeName:font}];
    CGContextRestoreGState(context);
}

// 绘制一页pdf到某个区域
+ (void)drawPDFPageWithFilePath:(NSString *)pdfPath pageNumber:(NSUInteger)pageNum toTargetRect:(CGRect)destinationRect
{
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:pdfPath]);
    if (pdfRef == NULL)
    {
        NSLog(@"Error loading PDF");
        return;
    }
    // ... use PDF document here
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdfRef, pageNum);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    CGContextSaveGState(context);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Flip the context to Quartz space from UIKit
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
//    transform = CGAffineTransformTranslate(transform, 0.0f, -image.size.height);
    transform = CGAffineTransformTranslate(transform, 0.0f, -destinationRect.size.height);
    CGContextConcatCTM(context, transform);
    
    // Flip the rect, which remains in UIKit space
    CGRect d = CGRectApplyAffineTransform(destinationRect, transform);
    
    // Calculate a rectangle to draw to
    // CGPDFPageGetBoxRect() returns a rectangle representing the page’s dimension
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    CGFloat drawingAspect = AspectScaleFit(pageRect.size, d);
    CGRect drawingRect = RectByFittingInRect(pageRect, d);
    
    // Draw the page outline (optional)
    UIRectFrame(drawingRect);
    
    // Adjust the context to the page draws within
    // the fitting rectangle (drawingRect)
    CGContextTranslateCTM(context,drawingRect.origin.x, drawingRect.origin.y);
    CGContextScaleCTM(context, drawingAspect, drawingAspect);
    
    // Draw the page
    CGContextDrawPDFPage(context, pageRef);
    
    CGContextRestoreGState(context);
    
    CGPDFDocumentRelease(pdfRef);
}

// 创建一个中间内容可拉伸的图像
+ (UIImage *)imageStretchableWithSize:(CGSize)size drawBlock:(UIEdgeInsets ( ^ )(CGContextRef context))drawBlock
{
    
    __block UIEdgeInsets insets;
    UIImage *initialImage = [self imageContextBuildWithSize:size drawBlock:^(CGContextRef context) {
        if (drawBlock) {
            insets = drawBlock(context);
        }
    } isOpaque:NO];
    return [initialImage resizableImageWithCapInsets: insets];
}

// 绘制一张使用Auto layout让中心内容对齐的UIImage
+ (UIImage *)imageAlignmentRectangleForAutoLayoutWithSize:(CGSize)size drawBlock:(CGRect ( ^ )(CGContextRef context))drawBlock
{
    
    // 初始化一个中心50大小的框
    CGRect lookAtRect = CGRectMake(0, 0, 50, 50);
    __block CGRect alignmentRect = RectCenteredInRect(lookAtRect, SizeMakeRect(size));
    
    UIImage *initialImage = [self imageContextBuildWithSize:size drawBlock:^(CGContextRef context) {
        if (drawBlock) {
            alignmentRect = drawBlock(context);
        }
    } isOpaque:NO];
    // Build and apply the insets
    UIEdgeInsets insets = BuildInsets(alignmentRect, SizeMakeRect(size));
    return [initialImage imageWithAlignmentRectInsets:insets];
}

// 从bytes数据转为UIImage
+ (UIImage *)imageFromBytes:(NSData *)data targetSize:(CGSize)size
{
    /**
     *  reverses the bytes-to-image scenario, producing images from the bytes you supply. Because of this, you pass those bytes to CGBitmapContextCreate() as the first argument. This tells Quartz not to allocate memory but to use the data you supply as the initial contents of the new context.
     It creates an image from the context, transforming the CGImageRef to a UIImage, and returns that new image instance.
     */
    
    return [XFCrystal imageFromBitmapBuildWithSize:size sourceData:data colorSpace:NULL drawBlock:^(CGContextRef context) {
        // Check data
        int width = size.width;
        int height = size.height;
        if (data.length < (width * height * 4)) {
            NSLog(@"Error: Got %zd bytes. Expected %d bytes", data.length, width * height * 4);
        }
        
        // drawing something
        /*UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:RectAroundCenter(RectGetCenter(RectMakeSize(size)), CGSizeMake(100, 100)) cornerRadius:20];
        
        CGContextAddPath(context, path.CGPath);
        
        CGContextStrokePath(context);*/
    }];
    
}

// 获得图像bytes数据
+ (NSData *)imageDataReceiveFromRGBImage:(UIImage *)sourceImage
{
    if (sourceImage == nil) {
        return nil;
    }
    /**
     *  This function draws an image into a context and then uses CGBitmapContextGetData() to retrieve the source bytes. It copies those bytes into an NSData instance and returns that instance to the caller.
     Wrapping the output data into an NSData object enables you to bypass issues regarding memory allocation, initialization, and management. Although you may end up using this data in C-based APIs like Accelerate, you’re able to do so from an Objective-C viewpoint.
     */
    __block NSData *data;
    [self imageFromBitmapBuildWithSize:sourceImage.size sourceData:nil colorSpace:NULL drawBlock:^(CGContextRef context) {
        CGContextDrawImage(context, SizeMakeRect(sourceImage.size), sourceImage.CGImage);
        // Draw source into context bytes
        data = [NSData dataWithBytes:CGBitmapContextGetData(context) length:sourceImage.size.width * sourceImage.size.height * 4];
    }];
    return data;
    
}

// 给图像添加文字水印
+ (UIImage *)imageForWatermarkFrom:(UIImage *)image text:(NSString *)copyright font:(UIFont *)font color:(UIColor *)textColor renderPosition:(CGPoint)position rotation:(CGFloat)rotation blendMode:(CGBlendMode)blendMode
{
    // calc a string size
    if (font == nil) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    }
    CGSize size = [copyright sizeWithAttributes:@{NSFontAttributeName: font}];
    
    
    UIImage *watermarkImage =[self imageContextBuildWithSize:image.size drawBlock:^(CGContextRef context) {
        // Draw the original image into the context
        CGRect targetRect = SizeMakeRect(image.size);
        [self drawImage:image targetRect:targetRect drawingPattern:XFImageDrawingPatternSqueeze];
        
        // Rotate the context
        CGPoint imageCenter = RectGetCenter(targetRect);
        CGContextTranslateCTM(context, imageCenter.x, imageCenter.y);
        CGContextRotateCTM(context, rotation);
        CGContextTranslateCTM(context, -imageCenter.x, -imageCenter.y);
        
        
        // Draw the string, using a blend mode
        CGContextSetBlendMode(context, blendMode);
        [copyright drawInRect:RectAroundCenter(position, size) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor}];
    } isOpaque:YES];
    return watermarkImage;
}

// 根据不同的模式在当前Context绘制图像
+ (void)drawImage:(UIImage *)image targetRect:(CGRect)rect drawingPattern:(XFImageDrawingPattern)pattern
{
    CGRect drawingRect;
    switch (pattern) {
        case XFImageDrawingPatternCenter: {
            drawingRect = RectAroundCenter(RectGetCenter(rect), image.size);
            break;
        }
        case XFImageDrawingPatternSqueeze: {
            drawingRect = rect;
            break;
        }
        case XFImageDrawingPatternFitting: {
            drawingRect = RectByFittingInRect(SizeMakeRect(image.size), rect);
            break;
        }
        case XFImageDrawingPatternFilling: {
            drawingRect = RectByFillingRect(SizeMakeRect(image.size), rect);
            break;
        }
    }
    [image drawInRect:drawingRect];
}

/*
 this function works by building a new context
 using the source image dimensions. This “device gray”-based context stores
 1 byte per pixel and uses no alpha information.
 */
+ (UIImage *)imageConvert2GrayFrom:(UIImage *)sourceImage
{
    // Establish grayscale color space
    // As with all contexts, it’s up to you to retrieve the results and store the data to an image. Here, the function draws the source image and retrieves a grayscale version, using CGBitmapContextCreateImage().
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    return [self imageFromBitmapBuildWithSize:sourceImage.size sourceData:nil colorSpace:colorSpace drawBlock:^(CGContextRef context) {
        //FlipContextVertically(sourceImage.size);
        [sourceImage drawAtPoint:CGPointMake(0, 0)];
    }];
}

// 截取一小块图片
+ (UIImage *)imageExtractRectFrom:(UIImage *)sourceImage subRect:(CGRect)rect
{
    // Extract image use Core Graphics function
    // 这个方式没有考虑Retina屏
    /*CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, rect);
     if (imageRef != NULL) {
     UIImage *output = [UIImage imageWithCGImage:imageRef];
     CGImageRelease(imageRef);
     return output;
     }
     NSLog(@"Error: Unable to extract subimage");
     return nil;*/
    
    /*
     A drawback occurs when your reference rectangle is defined for a Retina system, and you’re extracting data in terms of Quartz coordinates. For this reason, I’ve included a second function,one that operates entirely in UIKit. Rather than convert rectangles between coordinate systems, this function assumes that the rectangle you’re referencing is defined in points, not pixels. This is important when you’re asking an image for its bounds and then building a rectangle around its center. That “center” for a Retina image may actually be closer to its top-left corner if you’ve forgotten to convert from points to pixels. By staying in UIKit, you sidestep the entire issue, making sure the bit of the picture you’re extracting is the portion you really meant.
     */
    
    // you can use UIKit function
    // This is a little less flaky
    // when moving to and from Retina images
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    // 绘制目标的x,y使用小块rect的负坐标作用：目标destRect大小不变，但左上角向左上移动，这样的话[sourceImage drawInRect:destRect]就会把想要的图像绘制在（0，0）位置，大小也是小块大小，因为整个绘制区域也只有rect大小，所以最后能拿到小块图片
    CGRect destRect = CGRectMake(-rect.origin.x, -rect.origin.y,sourceImage.size.width, sourceImage.size.height);
    [sourceImage drawInRect:destRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 通过原图得到一张目标大小的缩略图
+ (UIImage *)imageThumbnailBuildFrom:(UIImage *)sourceImage targetSize:(CGSize)thumbSize useFitting:(BOOL)fitting
{
    UIGraphicsBeginImageContextWithOptions(thumbSize, NO, 0.0);
    // Establish the output thumbnail rectangle
    CGRect targetRect = SizeMakeRect(thumbSize);
    // Create the source image’s bounding rectangle
    CGRect naturalRect = (CGRect){.size = sourceImage.size};
    // Calculate fitting or filling destination rectangle
    CGRect destinationRect = fitting ? RectByFittingInRect(naturalRect, targetRect) : RectByFillingRect(naturalRect, targetRect);
    // Draw the new thumbnail
    [sourceImage drawInRect:destinationRect];
    // Retrieve and return the new image
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}

// 使用Core Graphics绘制一张图
+ (UIImage *)imageContextBuildWithSize:(CGSize)size drawBlock:(void(^)(CGContextRef context))drawBlock isOpaque:(BOOL)opaque
{
    // Create image context (using the main screen scale)
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0);
    
    // drawImage
    drawBlock(UIGraphicsGetCurrentContext());
    
    // Retrieve image
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
// 给矩形绘制虚线边框
+ (void)decorateDashLineWithPath:(CGPathRef)path drawBlock:(void(^)(CGContextRef context))drawBlock
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat dashes[] = {6,2};
    
    // using Quartz
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(context, 1);
    CGContextSetLineDash(context, 0, dashes, 2);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    if (drawBlock) {
        drawBlock(context);
    }
}

// 在传入的矩形以中心点为原点开始绘制
+ (void)drawCenterInRect:(CGRect)rect drawBlock:(void(^)(CGContextRef context))drawBlock
{
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // save init state
    CGContextSaveGState(context);
    // move to center point
    CGContextTranslateCTM(context, center.x, center.y);
    
    if (drawBlock) {
        drawBlock(context);
    }
    
   // restore init state
    CGContextRestoreGState(context);
}
// 通过遮罩路径来绘制内容
+ (void)clipFromPath:(CGPathRef)path drawBlock:(void(^)(CGContextRef context))drawBlock
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Save the state
    CGContextSaveGState(context);
    // Add the path and clip
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    // Perform clipped drawing here
    if (drawBlock) {
        drawBlock(context);
    }
    
    // Restore the state
    CGContextRestoreGState(context);
}


// 使用Quartz坐标系的上下文绘制图像
+ (UIImage *)imageFromBitmapBuildWithSize:(CGSize)size sourceData:(NSData *)imageData colorSpace:(CGColorSpaceRef)colorSpace drawBlock:(void( ^ )(CGContextRef context))drawBlock
{
    NSInteger height = size.height;
    NSInteger width = size.width;
    // 是否要创建灰色图
    BOOL gray = YES;
    
    // Create a color space
    if (colorSpace == NULL) {
        gray = NO; // 传NULL要创建RGB图
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    if (colorSpace == NULL)
    {
        NSLog(@"Error allocating color space");
        return nil;
    }
    
    // Create the bitmap context. (Note: in new versions of Xcode, you need to cast the alpha setting.)
    /*
     kCGImageAlphaPremultipliedFirst: This specifies an ARGB byte order, using Quartz-friendly alpha premultiplication. */
    Byte *bytes = (Byte *) imageData.bytes; // 如果从原数据创建
    CGContextRef context = CGBitmapContextCreate(bytes,
                                                 width, height,
                                                 BITS_PER_COMPONENT,
                                                 (gray ? width : width * ARGB_COUNT),
                                                 colorSpace,
                                                 (gray ? (CGBitmapInfo) kCGImageAlphaNone : (CGBitmapInfo) kCGImageAlphaPremultipliedFirst));
    if (context == NULL)
    {
        NSLog(@"Error: Context not created!");
        CGColorSpaceRelease(colorSpace );
        return nil;
    }
    // push to context stack
    UIGraphicsPushContext(context);
    
    // Flip the context vertically
    // 转换成UIKit坐标系
    FlipContextVertically(size);
    
    // 绘制回调
    if (drawBlock) {
        drawBlock(context);
    }
    
    // Pop the context stack
    UIGraphicsPopContext();
    
    // Convert to image
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    // Clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    //    CFRelease(imageRef);
    CGImageRelease(imageRef);
    
    // draw in current context
//    [image drawAtPoint:CGPointMake(0, 0)];
    
    
    return image;
}
@end
