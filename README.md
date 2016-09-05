
![XFCrystalKit logo](./ScreenShot/logo.png)

[![CocoaPods](https://img.shields.io/badge/cocoapods-v1.0.1-brightgreen.svg)](http://cocoadocs.org/docsets/XFSettings)
![Language](https://img.shields.io/badge/language-ObjC-orange.svg)
![License](https://img.shields.io/npm/l/express.svg)
![Version](https://img.shields.io/badge/platform-ios7%2B-green.svg)

A Quartz/UIKit drawing tool for IOS. Include geometry/Context convenient method, image processing, along path drawing, polygon path, gradient fill, 3D inner outer shadow glow render, gauss blur, animation effect, attributed Text Drawing.

Quartz / UIKit 绘画工具箱，汇集常用几何和Context操作方法、图像效果处理、路径绘图、多变形状、渐变填充、3D内外阴影高光渲染、高斯模糊、动画效果及属性文本绘制。

![XFCrystalKit 用例](./ScreenShot/usage.gif)

##安装
###1、使用Cocoapods
```ruby
pod 'XFCrystalKit','1.0.1'
```
###2、手动加入
把 `XFCrystalKit` 目录拖入到工程下.

##开发文档
###基本Rect方法`XFGeometryFunc`
```objc
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

/** 按比例缩放大小 */
CGSize SizeScaleByFactor(CGSize aSize, CGFloat factor);
/** 获得源Rect到目标Rect的比例大小*/
CGSize  RectGetScale(CGRect sourceRect, CGRect destRect);
/** 计算Fit方式缩放比例 */
CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect);
/** 计算Fit方式填充后的矩形 */
CGRect RectByFittingInRect(CGRect sourceRect,CGRect destinationRect);
/** 计算Fill方式缩放比例 */
CGFloat AspectScaleFill(CGSize sourceSize, CGRect destRect);
/** 计算Fill方式填充后的矩形 */
CGRect RectByFillingRect(CGRect sourceRect, CGRect destinationRect);
/** 创建一个子矩形在父矩形中居中的百分比大小 */
CGRect RectInsetByPercent(CGRect destinationRect,CGFloat percent);

/** 获得矩形的中心点 */
CGPoint RectGetCenter(CGRect rect);
/** 求两点之间的距离*/
CGFloat PointDistanceFromPoint(CGPoint p1, CGPoint p2);

// 其它...
```

###绘制类`XFCrystal`
####1、以`image`开头的方法会返回绘制完成的图片，如：
```objc
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
 *  转换成高斯模糊图像
 *
 *  @param image  原图像
 *  @param radius 模糊半径
 *
 *  @return 模糊图像
 */
+ (UIImage *)imageGaussianBlurFrom:(UIImage *)image radius:(NSInteger)radius;
```

####2、以`draw`开头的方法是当前的context上绘制，如：
```objc
/**
 *  根据不同的模式在当前Context绘制图像
 *
 *  @param image   原图
 *  @param rect    目标大小
 *  @param pattern 绘制模式
 */
+ (void)drawImage:(UIImage *)image targetRect:(CGRect)rect drawingPattern:(XFImageDrawingPattern)pattern;
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
```

####3、一个组合多绘制方法例子
```objc
  UIImage *sourceImage = [UIImage imageNamed:@"gujian2"];
  // 创建截取区域
  CGRect clipArea = RectInsetByPercent(rect, 0.75f);
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:clipArea];
  
  [XFCrystal drawClipPath:path.CGPath drawBlock:^(CGContextRef context) {
      // 在截取区域内绘制居中显示灰图
      UIImage *grayImage = [XFCrystal imageConvert2GrayFrom:sourceImage];
      [XFCrystal drawImage:grayImage targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
  }];
```

###`UIBezierPath`扩展分类`UIBezierPath+XFElements`和`UIBezierPath+XFCommon`
```objc
// 路径分解
/**
 *  返回所有子路径元素(BezierElement）
 */
@property (nonatomic, readonly) NSArray<XFBezierElement *>  *elements;
/**
 *  所有子路径
 */
@property (nonatomic, readonly) NSArray<UIBezierPath *> *subpaths;
/**
 *  逆向整个路径
 *
 *  @return 返回一条逆向的路径
 */
@property (nonatomic, readonly) UIBezierPath *reversed;
/**
 *  路径元素总数
 */
@property (nonatomic, readonly) NSUInteger count;
/**
 *  路径长度
 */
@property (nonatomic, readonly) CGFloat pathLength;
/**
 *  在路径当中找一个点
 *
 *  @param percent 百分点
 *  @param slope   当前点朝向
 *
 */
- (CGPoint)pointAtPercent: (CGFloat) percent withSlope: (CGPoint *) slope;

// 路径常用方法
// 状态Block
typedef void (^DrawingStateBlock)();
// Graphics state(GState) save and restore
void PushDraw(DrawingStateBlock block);
// 添加图层所还原
void PushLayerDraw(DrawingStateBlock block);

// 路径填充
- (void) stroke: (CGFloat) width color: (UIColor *) color;
- (void) fill: (UIColor *) fillColor withMode: (CGBlendMode) blendMode;
// 外阴影
- (void)drawOuterShadow:(UIColor *)color size:(CGSize)size blur:(CGFloat)radius;
// 内阴影
- (void)drawInnerShadow:(UIColor *)color size:(CGSize)size blur:(CGFloat)radius;
// 绘制路径外光
- (void)drawOuterGlow:(UIColor *)glowColor withRadius:(CGFloat)radius;
// 绘制路径内光
- (void)drawInnerGlow: (UIColor *) fillColor withRadius: (CGFloat) radius;
```

###路径的构建与Transform类`XFBezierFunc`
```objc
// Path Element
// Construct a Bezier path from an element array<BezierElement *>
UIBezierPath *BezierPathWithElements(NSArray *elements);
UIBezierPath *BezierPathWithPoints(NSArray *points);
UIBezierPath *InterpolatedPath(UIBezierPath *path);

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

// transform
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
```
###渐变类`XFGradient`和绘制渐变函数集`XFGradientFunc`
```objc
// 渐变填充方法
// Linear
// Draw a linear gradient between the two points
- (void) drawFrom: (CGPoint) p1
          toPoint: (CGPoint) p2 style: (int) mask;
- (void) drawFrom:(CGPoint) p1 toPoint: (CGPoint) p2;
- (void) drawTopToBottom: (CGRect) rect;
- (void) drawBottomToTop: (CGRect) rect;
- (void) drawLeftToRight: (CGRect) rect;
// 旋转填充
- (void) drawAlongAngle: (CGFloat) angle in:(CGRect) rect;

// Radial
/**
 *  Draw a radial gradient between the two points
 *
 *  @param p1    起始点
 *  @param p2    终点
 *  @param radii 起点半径与终点半径
 *  @param mask  填充模式
 */
- (void) drawRadialFrom:(CGPoint) p1
                toPoint: (CGPoint) p2 radii: (CGPoint) radii
                  style: (int) mask;
/**
 *  绘制由中心向外扩展的渐变填充
 *
 *  @param p1 起始点
 *  @param p2 终点
 */
- (void) drawRadialFrom: (CGPoint) p1 toPoint: (CGPoint) p2;
/**
 *  在矩形范围内绘制由中心向外扩展的渐变填充(有浑浊效果)
 *
 *  @param rect 矩形范围
 */
- (void) drawBasicRadial: (CGRect) rect;
/**
 *  在矩形范围内绘制由中心向外扩展的渐变填充(有色彩平滑过度效果，精致的)
 *
 *  @param rect 矩形范围
 */
- (void)drawArtisticRadial:(CGRect)rect;

// 其它效果方法
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
```

##Author
Yizzuide, fu837014586@163.com

## License
XFCrystalKit is available under the MIT license. See the LICENSE file for more info.
