//
//  XFBezierFunc.m
//  XFCrystalKit
//
//  Created by yizzuide on 15/12/7.
//  Copyright © 2015年 yizzuide. All rights reserved.
//

@import CoreText;

#import "XFBezierFunc.h"
#import "XFGeometryFunc.h"
#import "XFLinearAlgebraFunc.h"
#import "UIBezierPath+XFElements.h"

void PushDraw(DrawingStateBlock block)
{
    if (!block) return; // nothing to do
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGContextSaveGState(context);
    block();
    CGContextRestoreGState(context);
}

// Improve performance by pre-clipping context
// before beginning layer drawing
void PushLayerDraw(DrawingStateBlock block)
{
    if (!block) return; // nothing to do
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGContextBeginTransparencyLayer(context, NULL);
    block();
    CGContextEndTransparencyLayer(context);
}

#pragma mark - Misc
void ClipToRect(CGRect rect)
{
    [[UIBezierPath bezierPathWithRect:rect] addClip];
}

void FillRect(CGRect rect, UIColor *color)
{
    [[UIBezierPath bezierPathWithRect:rect] fill:color];
}

#pragma mark - Transform
void ApplyCenteredPathTransform(UIBezierPath *path, CGAffineTransform transform)
{
    CGPoint center = PathBoundingCenter(path);
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, center.x, center.y);
    t = CGAffineTransformConcat(transform, t);
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    [path applyTransform:t];
}

UIBezierPath *PathByApplyingTransform(UIBezierPath *path, CGAffineTransform transform)
{
    UIBezierPath *copy = [path copy];
    ApplyCenteredPathTransform(copy, transform);
    return copy;
}

void RotatePath(UIBezierPath *path, CGFloat theta)
{
    CGAffineTransform t = CGAffineTransformMakeRotation(theta);
    ApplyCenteredPathTransform(path, t);
}

void ScalePath(UIBezierPath *path, CGFloat sx, CGFloat sy)
{
    CGAffineTransform t = CGAffineTransformMakeScale(sx, sy);
    ApplyCenteredPathTransform(path, t);
}

void OffsetPath(UIBezierPath *path, CGSize offset)
{
    CGAffineTransform t = CGAffineTransformMakeTranslation(offset.width, offset.height);
    ApplyCenteredPathTransform(path, t);
}

void MovePathToPoint(UIBezierPath *path, CGPoint destPoint)
{
    CGRect bounds = PathBoundingBox(path);
    CGPoint p1 = bounds.origin;
    CGPoint p2 = destPoint;
    CGSize vector = CGSizeMake(p2.x - p1.x, p2.y - p1.y);
    OffsetPath(path, vector);
}

void MovePathCenterToPoint(UIBezierPath *path, CGPoint destPoint)
{
    CGRect bounds = PathBoundingBox(path);
    CGPoint p1 = bounds.origin;
    CGPoint p2 = destPoint;
    CGSize vector = CGSizeMake(p2.x - p1.x, p2.y - p1.y);
    vector.width -= bounds.size.width / 2.0f;
    vector.height -= bounds.size.height / 2.0f;
    OffsetPath(path, vector);
}

void MirrorPathHorizontally(UIBezierPath *path)
{
    CGAffineTransform t = CGAffineTransformMakeScale(-1, 1);
    ApplyCenteredPathTransform(path, t);
}

void MirrorPathVertically(UIBezierPath *path)
{
    CGAffineTransform t = CGAffineTransformMakeScale(1, -1);
    ApplyCenteredPathTransform(path, t);
}

// The path is moved to its new center and then scaled in place down to the proper size.
void FitPathToRect(UIBezierPath *path, CGRect destRect)
{
    CGRect bounds = PathBoundingBox(path);
    CGRect fitRect = RectByFillingRect(bounds, destRect);
    CGFloat scale = AspectScaleFit(bounds.size, destRect);
    
    CGPoint newCenter = RectGetCenter(fitRect);
    MovePathCenterToPoint(path, newCenter);
    ScalePath(path, scale, scale);
}

void AdjustPathToRect(UIBezierPath *path, CGRect destRect)
{
    CGRect bounds = PathBoundingBox(path);
    CGFloat scaleX = destRect.size.width / bounds.size.width;
    CGFloat scaleY = destRect.size.height / bounds.size.height;
    
    CGPoint newCenter = RectGetCenter(destRect);
    MovePathCenterToPoint(path, newCenter);
    ScalePath(path, scaleX, scaleY);
}


#pragma mark - Bounds
CGRect PathBoundingBox(UIBezierPath *path)
{
    return CGPathGetPathBoundingBox(path.CGPath);
}

CGRect PathBoundingBoxWithLineWidth(UIBezierPath *path)
{
    CGRect bounds = PathBoundingBox(path);
    return CGRectInset(bounds, -path.lineWidth / 2.0f, -path.lineWidth / 2.0f);
}

CGPoint PathBoundingCenter(UIBezierPath *path)
{
    return RectGetCenter(PathBoundingBox(path));
}

CGPoint PathCenter(UIBezierPath *path)
{
    return RectGetCenter(path.bounds);
}

#pragma mark - Path Attributes
void AddDashesToPath(UIBezierPath *path)
{
    CGFloat dashes[] = {6, 2};
    // The array specifies, in points, the on/off patterns used when drawing a stroke. This example draws lines of 6 points followed by spaces of 2 points.
    // The phase of a dash indicates the amount it is offset from the beginning of the drawing.
    [path setLineDash:dashes count:2 phase:0];
}

void CopyBezierDashes(UIBezierPath *source, UIBezierPath *destination)
{
    NSInteger count;
    [source getLineDash:NULL count:&count phase:NULL];
    
    CGFloat phase;
    CGFloat *pattern = malloc(count * sizeof(CGFloat));
    [source getLineDash:pattern count:&count phase:&phase];
    [destination setLineDash:pattern count:count phase:phase];
    free(pattern);
}

void CopyBezierState(UIBezierPath *source, UIBezierPath *destination)
{
    destination.lineWidth = source.lineWidth;
    destination.lineCapStyle = source.lineCapStyle;
    destination.lineJoinStyle = source.lineJoinStyle;
    destination.miterLimit = source.miterLimit;
    destination.flatness = source.flatness;
    destination.usesEvenOddFillRule = source.usesEvenOddFillRule;
    CopyBezierDashes(source, destination);
}

// 设置阴影
void SetShadow(UIColor *color, CGSize size, CGFloat blur)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) {
        NSLog(@"Error: No context to draw into");
        return;
    }
    if (color)
        CGContextSetShadowWithColor(context, size, blur, color.CGColor);
    else
        CGContextSetShadow(context, size, blur);
}
// 设置内侧阴影
void DrawInnerShadow(UIBezierPath *path, UIColor *color, CGSize size, CGFloat blur)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    // Build shadow
    CGContextSaveGState(context);
    
    SetShadow(color, CGSizeMake(size.width, size.height), blur);
    // Clip to the original path
    [path addClip];
    // Fill the inverted path
    [path.inverse fill:color];
    
    CGContextRestoreGState(context);
}

// Draw *only* the shadow
void DrawShadow(UIBezierPath *path, UIColor *color, CGSize size, CGFloat blur)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    if (!color) COMPLAIN_AND_BAIL(@"Color cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    // Build shadow
    PushDraw(^{
        SetShadow(color, CGSizeMake(size.width, size.height), blur);
        [path.inverse addClip];
        [path fill:color];
    });
}
#pragma mark - Photoshop Style Effects
UIColor *ContrastColor(UIColor *color)
{
    if (CGColorSpaceGetNumberOfComponents(CGColorGetColorSpace(color.CGColor)) == 3)
    {
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        CGFloat luminance = r * 0.2126f + g * 0.7152f + b * 0.0722f;
        return (luminance > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
    }
    
    CGFloat w, a;
    [color getWhite:&w alpha:&a];
    return (w > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
}
// Create 3d embossed effect
// Typically call with black color at 0.5
void EmbossPath(UIBezierPath *path, UIColor *color, CGFloat radius, CGFloat blur)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    
    UIColor *contrast = ContrastColor(color);
    DrawInnerShadow(path, contrast, CGSizeMake(-radius, radius), blur);
    DrawInnerShadow(path, color, CGSizeMake(radius, -radius), blur);
}

// Half an emboss
void InnerBevel(UIBezierPath *path,  UIColor *color, CGFloat radius, CGFloat theta)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    if (!color) COMPLAIN_AND_BAIL(@"Color cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGFloat x = radius * sin(theta);
    CGFloat y = radius * cos(theta);
    
    UIColor *shadowColor = [color colorWithAlphaComponent:0.5f];
    DrawInnerShadow(path, shadowColor, CGSizeMake(-x, y), 2);
}

// I don't love this
void ExtrudePath(UIBezierPath *path, UIColor *color, CGFloat radius, CGFloat theta)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    if (!color) COMPLAIN_AND_BAIL(@"Color cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    CGFloat x = radius * sin(theta);
    CGFloat y = radius * cos(theta);
    DrawShadow(path, color, CGSizeMake(x, y), 0);
}

// Typically call with black color at 0.5
void BevelPath(UIBezierPath *path,  UIColor *color, CGFloat radius, CGFloat theta)
{
    if (!path) COMPLAIN_AND_BAIL(@"Path cannot be nil", nil);
    if (!color) COMPLAIN_AND_BAIL(@"Color cannot be nil", nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) COMPLAIN_AND_BAIL(@"No context to draw into", nil);
    
    CGFloat x = radius * sin(theta);
    CGFloat y = radius * cos(theta);
    DrawInnerShadow(path, color, CGSizeMake(-x, y), 2);
    DrawShadow(path, color, CGSizeMake(x / 2 , -y / 2), 0);
}


#pragma mark - Text to Path
/**
 *  It transforms its string into individual Core Text glyphs, represented as individual CGPath items. The function adds each letter path to a resulting Bezier path, offsetting itself after each letter by the size of that letter.
 After all the letters are added, the path is mirrored vertically. This converts the Quartz- oriented output into a UIKit-appropriate layout. You can treat these string paths just like any others, setting their line widths, filling them with colors and patterns, and transforming them however you like.
 *
 */
UIBezierPath *BezierPathFromString(NSString *string, UIFont *font,CGFloat(^CharacterDrawBlock)(UIBezierPath *charPath,NSInteger index))
{
    // Initialize path
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!string.length) return path;
    
    // CT is Core Text
    // Create font ref
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (fontRef == NULL)
    {
        NSLog(@"Error retrieving CTFontRef from UIFont");
        return nil;
    }
    
    // Create glyphs
    CGGlyph *glyphs = malloc(sizeof(CGGlyph) * string.length);
    const unichar *chars = (const unichar *)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    // 从c字符串转到象形符号
    BOOL success = CTFontGetGlyphsForCharacters(fontRef, chars,  glyphs, string.length);
    if (!success)
    {
        NSLog(@"Error retrieving string glyphs");
        CFRelease(fontRef);
        free(glyphs);
        return nil;
    }
    
    // Draw each char into path
    for (int i = 0; i < string.length; i++)
    {
        CGGlyph glyph = glyphs[i];
        CGPathRef pathRef = CTFontCreatePathForGlyph(fontRef, glyph, NULL);
        // 如果创建路径成功，只有空格符会不成功
        if (pathRef) {
            UIBezierPath *charPath = [UIBezierPath bezierPathWithCGPath:pathRef];
            //NSLog(@"index: %zd -- w: %f",i,charPath.bounds.size.width);
            CGFloat offsetW = 0.0;
            if (CharacterDrawBlock) {
                offsetW = CharacterDrawBlock(charPath,i);
            }
            [path appendPath:charPath];
            CGPathRelease(pathRef);
            
            if (CharacterDrawBlock) {
                // 使用路径大小计算
                // 使用负数是让整条路径向左移动，再往后追加新子路径
                OffsetPath(path, CGSizeMake(offsetW ? -offsetW : -charPath.bounds.size.width, 0));
            }
            
        }else{ // 如果有空格
            if (CharacterDrawBlock) {
                // 采用文本计算方式
                CGSize size = [[string substringWithRange:NSMakeRange(i, 1)] sizeWithAttributes:@{NSFontAttributeName:font}];
                OffsetPath(path, CGSizeMake(-size.width, 0));
            }
        }
        // 如果外面没有处理，使用这种方式
        if (!CharacterDrawBlock) {
            // 采用文本大小来算
            CGSize size = [[string substringWithRange:NSMakeRange(i, 1)] sizeWithAttributes:@{NSFontAttributeName:font}];
             OffsetPath(path, CGSizeMake(-size.width, 0));
        }
       
    }
    
    // Clean up
    free(glyphs);
    CFRelease(fontRef);
    
    // 由于Quartz坐标系原点是左下角，翻转到UIKit坐标系
    MirrorPathVertically(path);
    return path;
}

UIBezierPath *BezierPathFromStringWithFontFace(NSString *string, NSString *fontFace,CGFloat(^CharacterDrawBlock)(UIBezierPath *charPath,NSInteger index))
{
    UIFont *font = [UIFont fontWithName:fontFace size:16];
    if (!font)
        font = [UIFont systemFontOfSize:16];
    return BezierPathFromString(string, font,CharacterDrawBlock);
}


#pragma mark - Construct path
// Return Bezier path built with the supplied elements
UIBezierPath *BezierPathWithElements(NSArray *elements)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (XFBezierElement *element in elements)
        [element addToPath:path];
    return path;
}


UIBezierPath *InterpolatedPath(UIBezierPath *path)
{
    return BezierPathWithPoints(path.interpolatedPathPoints);
}

#define POINT(_X_) ([(NSValue *)points[_X_] CGPointValue])

// Pass array with NSValue'd CGRect points
UIBezierPath *BezierPathWithPoints(NSArray *points)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!points.count)
        return path;
    [path moveToPoint:POINT(0)];
    for (int i = 1; i < points.count; i++)
        [path addLineToPoint:POINT(i)];
    [path closePath];
    return path;
}

#pragma mark - Partial Path

UIBezierPath *CroppedPath(UIBezierPath *path, CGFloat percent)
{
    NSArray *elements = path.elements;
    if (elements.count == 0) return path;
    
    int targetCount = elements.count * percent;
    NSArray *targetElements = [elements subarrayWithRange:NSMakeRange(0, targetCount)];
    UIBezierPath *outputPath = BezierPathWithElements(targetElements);
    return outputPath;
}

UIBezierPath *PathFromPercentToPercent(UIBezierPath *path, CGFloat startPercent, CGFloat endPercent)
{
    NSArray *elements = path.elements;
    if (elements.count == 0) return path;
    
    int targetCount = elements.count * endPercent;
    NSArray *targetElements = [elements subarrayWithRange:NSMakeRange(0, targetCount)];
    UIBezierPath *outputPath = BezierPathWithElements(targetElements);
    return outputPath;
}

#pragma mark - Polygon Fun
/**
 *  All returned paths use unit sizing—that is, they fit within the {0, 0, 1, 1} rectangle. You size the path as needed. Also, the first point is always placed here at the top of the shape, so if you intend to return a square instead of a diamond, make sure to rotate by 90 degrees.
 *
 */
UIBezierPath *BezierPolygon(NSUInteger numberOfSides)
{
    if (numberOfSides < 3)
    {
        NSLog(@"Error: Please supply at least 3 sides");
        return nil;
    }
    
    CGRect destinationRect = CGRectMake(0, 0, 1, 1);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = RectGetCenter(destinationRect);
    CGFloat r = 0.5f; // radius
    
    BOOL firstPoint = YES;
    for (int i = 0; i < (numberOfSides - 1); i++)
    {
        // 当前弧度值（M_PI是第一个固定起始值，TWO_PI / numberOfSides是每个点弧度跨度，i * TWO_PI / numberOfSides就是目的位置）
        CGFloat theta = M_PI + i * TWO_PI / numberOfSides;
        // 点到点的弧度
        CGFloat dTheta = TWO_PI / numberOfSides;
        
        // 绘制线的第一个点
        CGPoint p;
        if (firstPoint)
        {
            p.x = center.x + r * sin(theta);
            p.y = center.y + r * cos(theta);
            [path moveToPoint:p];
            firstPoint = NO;
        }
        
        // 绘制线的终点
        p.x = center.x + r * sin(theta + dTheta);
        p.y = center.y + r * cos(theta + dTheta);
        [path addLineToPoint:p];
    }
    
    // 合并到起点
    [path closePath];
    
    return path;
}

/*this fun looks very similar to the polygon generator in above,The difference between the two functions is that this fun creates a curve between its points instead of drawing a straight line. You specify how many curves to create.
 The inflection of that curve is established by two control points. These points are set by the percentInflection parameter you pass to the function. Positive inflections move further away from the center, building lobes around the shape. Negative inflections move toward the center—or even past the center—creating the spikes and loops.
 */
UIBezierPath *BezierInflectedShape(NSUInteger numberOfInflections, CGFloat percentInflection)
{
    if (numberOfInflections < 3)
    {
        NSLog(@"Error: Please supply at least 3 inflections");
        return nil;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect destinationRect = CGRectMake(0, 0, 1, 1);
    CGPoint center = RectGetCenter(destinationRect);
    CGFloat r = 0.5;
    CGFloat rr = r * (1.0 + percentInflection);
    
    BOOL firstPoint = YES;
    for (int i = 0; i < numberOfInflections; i++)
    {
        CGFloat theta = i * TWO_PI / numberOfInflections;
        CGFloat dTheta = TWO_PI / numberOfInflections;
        
        if (firstPoint)
        {
            CGFloat xa = center.x + r * sin(theta);
            CGFloat ya = center.y + r * cos(theta);
            CGPoint pa = CGPointMake(xa, ya);
            [path moveToPoint:pa];
            firstPoint = NO;
        }
        
        // 添加开始点向下控制点
        CGFloat cp1x = center.x + rr * sin(theta + dTheta / 3);
        CGFloat cp1y = center.y + rr * cos(theta + dTheta / 3);
        CGPoint cp1 = CGPointMake(cp1x, cp1y);
        // 添加目标点向上控制点
        CGFloat cp2x = center.x + rr * sin(theta + 2 * dTheta / 3);
        CGFloat cp2y = center.y + rr * cos(theta + 2 * dTheta / 3);
        CGPoint cp2 = CGPointMake(cp2x, cp2y);
        
        // 目标点
        CGFloat xb = center.x + r * sin(theta + dTheta);
        CGFloat yb = center.y + r * cos(theta + dTheta);
        CGPoint pb = CGPointMake(xb, yb);
        
        // 添加三次方贝塞尔曲线
        [path addCurveToPoint:pb controlPoint1:cp1 controlPoint2:cp2];
    }
    
    [path closePath];
    
    return path;
}

UIBezierPath *BezierStarShape(NSUInteger numberOfInflections, CGFloat percentInflection)
{
    if (numberOfInflections < 3)
    {
        NSLog(@"Error: Please supply at least 3 inflections");
        return nil;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect destinationRect = CGRectMake(0, 0, 1, 1);
    CGPoint center = RectGetCenter(destinationRect);
    CGFloat r = 0.5;
    CGFloat rr = r * (1.0 + percentInflection);
    
    BOOL firstPoint = YES;
    for (int i = 0; i < numberOfInflections; i++)
    {
        CGFloat theta = i * TWO_PI / numberOfInflections;
        CGFloat dTheta = TWO_PI / numberOfInflections;
        
        // 添加起始点
        if (firstPoint)
        {
            CGFloat xa = center.x + r * sin(theta);
            CGFloat ya = center.y + r * cos(theta);
            CGPoint pa = CGPointMake(xa, ya);
            [path moveToPoint:pa];
            firstPoint = NO;
        }
        
        // 添加中间转折点（在开始点和目标点的中间位置）
        CGFloat cp1x = center.x + rr * sin(theta + dTheta / 2);
        CGFloat cp1y = center.y + rr * cos(theta + dTheta / 2);
        CGPoint cp1 = CGPointMake(cp1x, cp1y);
        
        // 添加目标点
        CGFloat xb = center.x + r * sin(theta + dTheta);
        CGFloat yb = center.y + r * cos(theta + dTheta);
        CGPoint pb = CGPointMake(xb, yb);
        
        [path addLineToPoint:cp1];
        [path addLineToPoint:pb];
    }
    
    [path closePath];
    
    return path;
}

// Font Fitting 查找最合适在Rect显示的字体
UIFont *FontForWrappedString(NSString *string, NSString *fontFace, CGRect rect, CGFloat tolerance)
{
    if (rect.size.height < 1.0f) return nil;
    
    CGFloat adjustedWidth = tolerance * rect.size.width;
    CGSize measureSize = CGSizeMake(adjustedWidth, CGFLOAT_MAX);
    
    // Initialize the proposed font
    CGFloat fontSize = 1;
    UIFont *proposedFont = [UIFont fontWithName:fontFace size:fontSize];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    attributes[NSFontAttributeName] = proposedFont;
    
    // Measure the target
    CGSize targetSize = [string boundingRectWithSize:measureSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil].size;
    // Double until the size is exceeded
    while (targetSize.height <= rect.size.height){
        // Establish a new proposed font
        fontSize *= 2;
        proposedFont = [UIFont fontWithName:fontFace size:fontSize];
        // Measure the target
        attributes[NSFontAttributeName] = proposedFont;
        targetSize = [string boundingRectWithSize:measureSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil].size;
        // Break when the calculated height is too much
        if (targetSize.height > rect.size.height)
            break;
    }
    
    // Search between the previous and current font sizes
    CGFloat minFontSize = fontSize / 2;
    CGFloat maxFontSize = fontSize;
    
    while (1){
        // Get the midpoint between the two
        CGFloat midPoint = (minFontSize + (maxFontSize - minFontSize) / 2);
        proposedFont = [UIFont fontWithName:fontFace size:midPoint];
        attributes[NSFontAttributeName] = proposedFont;
        targetSize = [string boundingRectWithSize:measureSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil].size;
        
        // Look up one font size
        UIFont *nextFont = [UIFont fontWithName:fontFace size:midPoint + 1];
        attributes[NSFontAttributeName] = nextFont;
        CGSize nextTargetSize = [string boundingRectWithSize:measureSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        // Test both fonts
        CGFloat tooBig = targetSize.height > rect.size.height;
        CGFloat nextIsTooBig = nextTargetSize.height > rect.size.height;
        
        // If the current is sized right
        // but the next is too big, it’s a win
        if (!tooBig && nextIsTooBig)
            return [UIFont fontWithName:fontFace size:midPoint];
        
        // Adjust the search space
        if (tooBig)
            maxFontSize = midPoint;
        else
            minFontSize = midPoint;
    }
    
    // Should never get here
    return [UIFont fontWithName:fontFace size:fontSize / 2];
    
}
