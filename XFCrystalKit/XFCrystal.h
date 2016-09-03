//
//  XFCrystal.h
//  XFCrystalKit
//
//  Created by yizzuide on 15/10/21.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DrawingBlok)(CGContextRef context);
typedef void (^DrawingRectBlok)(CGContextRef context,CGRect rect);


typedef NS_ENUM(NSInteger, XFImageDrawingPattern) {
    XFImageDrawingPatternCenter,
    XFImageDrawingPatternSqueeze,
    XFImageDrawingPatternFitting,
    XFImageDrawingPatternFilling
};


@interface XFCrystal : NSObject

/**
 *  创建自定义色彩BitmapContext
 // 使用Quartz类别的坐标系<默认原点从左下角开始>
 [self quartzGetBitmapImageWithSize:rect.size sourceData:nil colorSpace:NULL drawBlock:^(CGContextRef context) {
     // draw the test rectangle. It will now use the UIKit origin
     // instead of the Quartz origin.
     UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 100, 100) cornerRadius:20];
     
     CGContextAddPath(context, path.CGPath);
     
     CGContextStrokePath(context);
 }];
 *
 *  @param size       图大小
 *  @param sourceData 是否基于bytes图像数据创建，如果从空白创建指定为nil
 *  @param colorSpace 色彩空间，如果是RGB，必须为Null,如果是灰色则传入相应对象
 *  @param drawBlock  绘制回调,在创建的bitmapContext上绘制
 *
 *  @return UIImage 绘制完成的图像
*/
+ (UIImage *)imageFromBitmapBuildWithSize:(CGSize)size sourceData:(NSData *)imageData colorSpace:(CGColorSpaceRef)colorSpace drawBlock:(void( ^ )(CGContextRef context))drawBlock;

/**
 *  通过遮罩路径来绘制内容
 *
 *  @param path      路径
 *  @param drawBlock 绘制回调
 */
+ (void)clipFromPath:(CGPathRef)path drawBlock:(void(^)(CGContextRef context))drawBlock;
/**
 *  在传入的矩形以中心点为原点开始绘制
 *
 *  @param rect      绘制范围
 *  @param drawBlock 绘制回调
 */
+ (void)drawCenterInRect:(CGRect)rect drawBlock:(void(^)(CGContextRef context))drawBlock;
/**
 *  给矩形绘制虚线边框
 *  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:8];
 *  [XFQuartzTools DecorateDashLineWithPath:path.CGPath drawBlock:nil];
 *
 *  @param rect      绘制范围
 *  @param drawBlock 绘制回调
 */
+ (void)decorateDashLineWithPath:(CGPathRef)path drawBlock:(void(^)(CGContextRef context))drawBlock;

/**
 *  使用Core Graphics绘制一张图
 *
 *  @param size      图大小
 *  @param drawBlock 绘制回调
 *  @param opaque    是否为不透明
 *
 *  @return UIImage
 */
+ (UIImage *)imageContextBuildWithSize:(CGSize)size drawBlock:(void(^)(CGContextRef context))drawBlock isOpaque:(BOOL)opaque;
/**
 *  通过原图得到一张目标大小的缩略图
 *
 *  @param sourceImage 原图
 *  @param thumbSize   缩略图大小
 *  @param fitting     是fit还是fill
 *
 *  @return 缩略图
 */
+ (UIImage *)imageThumbnailBuildFrom:(UIImage *)sourceImage targetSize:(CGSize)thumbSize useFitting:(BOOL)fitting;
/**
 *  截取一小块图片
 *
 *  @param sourceImage 原图
 *  @param rect        截取区域
 *
 *  @return 截取图片
 */
+ (UIImage *)imageExtractRectFrom:(UIImage *)sourceImage subRect:(CGRect)rect;
/**
 *  转换彩图到到灰图
 *
 *  @param sourceImage 原图
 *
 *  @return 灰图
 */
+ (UIImage *)imageConvert2GrayFrom:(UIImage *)sourceImage;
/**
 *  根据不同的模式在当前Context绘制图像
 *
 *  @param image   原图
 *  @param rect    目标大小
 *  @param pattern 绘制模式
 */
+ (void)drawImage:(UIImage *)image targetRect:(CGRect)rect drawingPattern:(XFImageDrawingPattern)pattern;
/**
 *  给图像添加文字水印
 *
 *  @param image     原图
 *  @param copyright 水印文字
 *  @param font      字体样式
 *  @param textColor 文字颜色
 *  @param position  放置中心点
 *  @param rotation  旋转弧度 使用M_PI等
 *  @param blendMode 混合模式
 *
 *  @return 加水印图像
 */
+ (UIImage *)imageForWatermarkFrom:(UIImage *)image text:(NSString *)copyright font:(UIFont *)font color:(UIColor *)textColor renderPosition:(CGPoint)position rotation:(CGFloat)rotation blendMode:(CGBlendMode)blendMode;

/**
 *  获得图像bytes数据
 *
 *  @param sourceImage 原图
 *
 *  @return 图像bytes数据
 */
+ (NSData *)imageDataReceiveFromRGBImage:(UIImage *)sourceImage;
/**
 *  从bytes数据创建图像
 *
 *  @param data bytes数据
 *  @param size 图像尺寸
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromBytes:(NSData *)data targetSize:(CGSize)size;
/**
 *  绘制一张使用Auto layout使中心内容对齐的UIImage
 *
 *  @param size      图像大小
 *  @param drawBlock 绘制内容，需返回CGRect类型的AlignmentRectangle(主要内容大小)
 *
 *  @return UIImage
 */
+ (UIImage *)imageAlignmentRectangleForAutoLayoutWithSize:(CGSize)size drawBlock:(CGRect ( ^ )(CGContextRef context))drawBlock;
/**
 *  创建一个中间内容可拉伸的图像
 *
 *  @param size      图像大小
 *  @param drawBlock 绘制内容，需返回UIEdgeInsets类型的保护边缘内边框
 *
 *  @return UIImage
 */
+ (UIImage *)imageStretchableWithSize:(CGSize)size drawBlock:(UIEdgeInsets ( ^ )(CGContextRef context))drawBlock;
/**
 *  绘制一页pdf到某个区域
 *
 *  @param pdfPath         pdf路径
 *  @param pageNum         要绘制的页数，下标从1开始
 *  @param destinationRect 绘制的目标位置
 */
+ (void)drawPDFPageWithFilePath:(NSString *)pdfPath pageNumber:(NSUInteger)pageNum toTargetRect:(CGRect)destinationRect;
/**
 *  在某一个Rect中绘制文本
 *
 *  @param text      文本
 *  @param font      字体
 *  @param textColor 文字颜色
 *  @param rect      绘制的目标位置
 */
+ (void)drawString:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor centeredInRect:(CGRect)rect;
/**
 *  绘制一个pattern color image
 *
 *  @param targetSize 目标大小
 *  @param drawBlock  绘制内容
 *
 */
+ (UIImage *)drawPatternColorImageWithSize:(CGSize)targetSize drawBlock:(void(^)(CGContextRef context,CGRect rect))drawBlock;

/**
 *  绘制路线图案进度
 *
 *  @param patternPath   绘制路径
 *  @param maxPercent    百分点
 *  @param drawTilePathBlock 进度小图绘制Block(当前个数,百分点,绘制中心点,颜色变化增量) 如：
 UIColor *color = [UIColor colorWithWhite:index * colorDLevel alpha:1];
 CGRect r = RectAroundCenter(currentPoint, CGSizeMake(2, 2));
 UIBezierPath *marker = [UIBezierPath bezierPathWithOvalInRect:r];
 [marker fill:color];
 */
+ (void)drawProgressionOfPath:(UIBezierPath *)patternPath maxPercent:(CGFloat) maxPercent drawTilePathBlock:(void(^)(float index,float percent,CGPoint currentPoint,float colorDLevel))drawTilePathBlock;

/**
 *  应用蒙板自定义绘制
 *
 *  @param rect      大小
 *  @param maskBlock 蒙板层绘制,可以用渐变填充
 *  @param drawBlock 内容绘制
 */
+ (void)drawMaskInRect:(CGRect)rect maskBlock:(void (^)(CGContextRef context,CGRect rect))maskBlock drawBlock:(void(^)(CGContextRef context,CGRect rect))drawBlock;

/**
 *  转换成高斯模糊图像
 *
 *  @param image  原图像
 *  @param radius 模糊半径
 *
 *  @return 模糊图像
 */
+ (UIImage *)imageGaussianBlurFrom:(UIImage *)image radius:(NSInteger)radius;
/**
 *  在当前Context绘制模糊层
 *
 *  @param blurRaduis 模糊大小
 *  @param drawBlock  绘制内容
 */
+ (void)drawBlurWithRaduis:(CGFloat)blurRaduis drawBlock:(DrawingBlok)drawBlock;

/**
 *  返回一个模糊（柔化）边缘的图像
 *
 *  @param size         图像大小
 *  @param source       源图像
 *  @param insetScale   柔化边缘宽度
 *  @param cornerRadius 圆角
 *  @param blurRaduis   模糊Raduis
 *
 *  @return 模糊（柔化）边缘后的图像
 */
+ (UIImage *)imageSoftEdgeWithSize:(CGSize)size
                             sourceImage:(UIImage *)source
                              insetScale:(CGFloat)insetScale
                            cornerRadius:(CGFloat)cornerRadius
                          blurWithRaduis:(CGFloat)blurRaduis;


/**
 *  返回一张带倒影的图像
 *
 *  @param source 原图
 *  @param gap    间隙高度
 *
 *  @return 带倒影的图像
 */
+ (UIImage *)imageReflectionEffectFromSourceImage:(UIImage *)source gap:(CGFloat)gapHeight;

/**
 *  返回光栅效果进度的一帧图像（使用Core Image）
 *
 *  @param source   源图像
 *  @param target   目标图像
 *  @param progress 当前进度(0.f~1.f)
 *
 *  @return UIImage
 */
+ (UIImage *)imageForTransitionCopyMachineFromImage:(UIImage *)source targetImage:(UIImage *)target progress:(float)progress;
/**
 *  绘制一段文本到路径框内
 *
 *  @param attributedString 属性文本
 *  @param path             路径
 */
+ (void)drawAttributedString:(NSAttributedString *)attributedString inBezierPath:(UIBezierPath *)path;
/**
 *  填充属性文本到一个子路径框内，剩余的文本返回
 *
 *  @param path             填充路径
 *  @param attributedString 文本
 *  @param remainder        剩余文本
 */
+ (void)drawAttributedStringIntoSubpath:(UIBezierPath *)path attributedString:(NSAttributedString *)attributedString remainder:(NSAttributedString **)remainder;

/**
 *  填充属性文本到组合路径框内
 *
 *  @param path             组合路径
 *  @param attributedString 长篇属性文本
 */
+ (void)drawAttributedStringInBezierSubpaths:(UIBezierPath *)path attributedString:(NSAttributedString *)attributedString;

/**
 *  文本跟随路径绘制
 *
 *  @param string 文本
 *  @param path   路径
 */
+ (void)drawAttributedString:(NSAttributedString *)string alongPath:(UIBezierPath *)path;
@end
