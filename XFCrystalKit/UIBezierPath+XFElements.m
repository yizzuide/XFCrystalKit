//
//  UIBezierPath+Elements.m
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/13.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "UIBezierPath+XFElements.h"
#import "XFLinearAlgebraFunc.h"
#import "XFGeometryFunc.h"
#import "XFBezierFunc.h"


#pragma mark - Construction

#pragma mark - Bezier Elements Category -

@implementation UIBezierPath (XFElements)

// Convert one element to BezierElement and save to array
void GetBezierElements(void *info, const CGPathElement *element)
{
    NSMutableArray *bezierElements = (__bridge NSMutableArray *)info;
    if (element)
        [bezierElements addObject:[XFBezierElement elementWithPathElement:*element]];
}

// Retrieve array of component elements
- (NSArray *) elements
{
    NSMutableArray *elements = [NSMutableArray array];
     // Quartz’s CGPathApply() function iterates across all the elements that comprise a path.this enables you to convert a UIBezierPath into an array of its components. This listing converts and collects those path elements along the way. The result is an NSArray of Objective-C BezierElement objects, each representing an original path element.
    CGPathApply(self.CGPath, (__bridge void *)elements, GetBezierElements);
    return elements;
}

#pragma mark - Subpaths
// Return array of component subpaths
- (NSArray<UIBezierPath *> *)subpaths
{
    NSMutableArray<UIBezierPath *> *results = [NSMutableArray array];
    UIBezierPath *current = nil;
    // 获得所有路径元素
    NSArray *elements = self.elements;
    for (XFBezierElement *element in elements) {
        // Close the subpath and add to the results
        if (element.elementType == kCGPathElementCloseSubpath) {
            [current closePath];
            [results addObject:current];
            current = nil;
            continue;
        }
        // Begin new paths on move-to-point
        if (element.elementType == kCGPathElementMoveToPoint) {
            // 上一个子路径添加进去
            if (current)
                [results addObject:current];
            // 创建下一个子路径
            current = [UIBezierPath bezierPath];
            [current moveToPoint:element.point];
            continue;
        }
        // 添加子路径元素
        if (current)
            [element addToPath:current];
        else {
            NSLog(@"Cannot add to nil path: %@", element.stringValue);
            continue;
        }
    }
    // 如果最后不是闭合的路径，也添加进去
    if (current)
        [results addObject:current];
    
    return results;
}


// Only collect those points that have destinations
- (NSArray *) destinationPoints
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *elements = self.elements;
    
    for (XFBezierElement *element in elements)
        if (!POINT_IS_NULL(element.point))
            [array addObject:[NSValue valueWithCGPoint:element.point]];
    
    return array;
}

// Points and interpolated points
- (NSArray *) interpolatedPathPoints
{
    NSMutableArray *points = [NSMutableArray array];
    XFBezierElement *current = nil;
    int overkill = 3;
    for (XFBezierElement *element in self.elements)
    {
        switch (element.elementType)
        {
            case kCGPathElementMoveToPoint:
            case kCGPathElementAddLineToPoint:
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                current = element;
                break;
            case kCGPathElementCloseSubpath:
                current = nil;
                break;
            case kCGPathElementAddCurveToPoint:
            {
                for (int i = 1; i < NUMBER_OF_BEZIER_SAMPLES * overkill; i++)
                {
                    CGFloat percent = (CGFloat) i / (CGFloat) (NUMBER_OF_BEZIER_SAMPLES * overkill);
                    CGPoint p = CubicBezierPoint(percent, current.point, element.controlPoint1, element.controlPoint2, element.point);
                    [points addObject:[NSValue valueWithCGPoint:p]];
                }
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                current = element;
                break;
            }
            case kCGPathElementAddQuadCurveToPoint:
            {
                for (int i = 1; i < NUMBER_OF_BEZIER_SAMPLES * overkill; i++)
                {
                    CGFloat percent = (CGFloat) i / (CGFloat) (NUMBER_OF_BEZIER_SAMPLES * overkill);
                    CGPoint p = QuadBezierPoint(percent, current.point, element.controlPoint1, element.point);
                    [points addObject:[NSValue valueWithCGPoint:p]];
                }
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                current = element;
                break;
            }
        }
    }
    return points;
}

#pragma mark - Array Access

- (NSUInteger) count
{
    return self.elements.count;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    NSArray *elements = self.elements;
    if (idx >= elements.count)
        return nil;
    return elements[idx];
}

#pragma mark - Bounds
- (CGPoint) center
{
    return PathBoundingCenter(self);
}

- (CGRect) computedBounds
{
    return PathBoundingBox(self);
}

- (CGRect) computedBoundsWithLineWidth
{
    return PathBoundingBoxWithLineWidth(self);
}

#pragma mark - Reversal Workaround(逆向路径)
// Reverse eatch subpath
- (UIBezierPath *) reverseSubpath: (UIBezierPath *) subpath
{
    NSArray *elements = subpath.elements;
    NSArray *reversedElements = [[elements reverseObjectEnumerator] allObjects];
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    BOOL closesSubpath = NO; // 是否有closePath
    // Locate the element with the first point
    XFBezierElement *firstElement;
    for (XFBezierElement *e in elements)
    {
        if (!POINT_IS_NULL(e.point)) {
            firstElement = e;
            break;
        }
    }
    // Locate the element with the last point
    XFBezierElement *lastElement;
    for (XFBezierElement *e in reversedElements) {
        if (!POINT_IS_NULL(e.point))
        {
            lastElement = e;
            break;
        }
    }
    // Check for path closure （检查路径的闭口）
    XFBezierElement *element = [elements lastObject];
    if (element.elementType == kCGPathElementCloseSubpath) { // 如果有closePath操作（把原来结束的当起始）
        if (firstElement)
            [newPath moveToPoint:firstElement.point];
        if (lastElement)
            [newPath addLineToPoint:lastElement.point];
        closesSubpath = YES;
    }else {
        [newPath moveToPoint:lastElement.point];
    }
    
    // Iterate backwards （回归） and reconstruct the path （重造路径）
    CFIndex i = 0; // 记录索引
    for (XFBezierElement *element in reversedElements) {
        i++; // 索引跳过第一个Element，因为上面已经添加了
        XFBezierElement *nextElement = nil;
        XFBezierElement *workElement = [element copy];
        if (element.elementType == kCGPathElementCloseSubpath) // 忽略closePath，，因为上面已经添加了
            continue;
        if (element == firstElement) { // 回归到了起始位置，如果有源路径有closePath,手动合并路径（把原来起始的当终点合并）
            if (closesSubpath) [newPath closePath];
            continue;
        }
        if (i < reversedElements.count) {
            nextElement = reversedElements[i];
            if (!POINT_IS_NULL(workElement.controlPoint2)) { // 如果这是一个Bezier curve (贝塞尔曲线)
                // 交换控制点
                CGPoint tmp = workElement.controlPoint1;
                workElement.controlPoint1 = workElement.controlPoint2;
                workElement.controlPoint2 = tmp;
            }
            // 位置点
            workElement.point = nextElement.point;
        }
        // 把起始类型换成添加点类型
        if (element.elementType == kCGPathElementMoveToPoint)
            workElement.elementType = kCGPathElementAddLineToPoint;
        // 转到路径
        [workElement addToPath:newPath];
    }
    return newPath;
}

- (UIBezierPath *) reversed
{
    // [self bezierPathByReversingPath] seriously does not work the
    // way you expect. Radars are filed.
    
    UIBezierPath *reversed = [UIBezierPath bezierPath];
    NSArray *reversedSubpaths = [[self.subpaths reverseObjectEnumerator] allObjects];
    
    for (UIBezierPath *subpath in reversedSubpaths)
    {
        UIBezierPath *p = [self reverseSubpath:subpath];
        if (p)
            [reversed appendPath:p];
    }
    return reversed;
}

#pragma mark - Closing
- (BOOL) subpathIsClosed
{
    NSArray *elements = self.elements;
    
    // A legal closed path must contain 3 elements
    // move, add, close
    if (elements.count < 3)
        return NO;
    
    XFBezierElement *element = [elements lastObject];
    return element.elementType == kCGPathElementCloseSubpath;
}

- (BOOL) closeSafely
{
    NSArray *elements = self.elements;
    if (elements.count < 2)
        return NO;
    
    XFBezierElement *element = [elements lastObject];
    if (element.elementType != kCGPathElementCloseSubpath)
    {
        [self closePath];
        return YES;
    }
    
    return NO;
}


#pragma mark - Show the Code
- (void) showTheCode
{
    
    printf("\n- (UIBezierPath *) buildBezierPath\n");
    printf("{\n");
    printf("    UIBezierPath *path = [UIBezierPath bezierPath];\n\n");
    
    NSArray *elements = self.elements;
    for (XFBezierElement *element in elements)
        [element showTheCode];
    
    printf("    return path;\n");
    printf("}\n\n");
}

- (NSString *) stringValue
{
    NSMutableString *string = [NSMutableString stringWithString:@"\n"];
    NSArray *elements = self.elements;
    for (XFBezierElement *element in elements)
        [string appendFormat:@"%@\n", element.stringValue];
    
    return string;
}

#pragma mark - Transformations
// Project point from native to dest
CGPoint adjustPoint(CGPoint p, CGRect native, CGRect dest)
{
    CGFloat scaleX = dest.size.width / native.size.width;
    CGFloat scaleY = dest.size.height / native.size.height;
    
    CGPoint point = PointSubtractPoint(p, native.origin);
    point.x *= scaleX;
    point.y *= scaleY;
    CGPoint destPoint = PointAddPoint(point, dest.origin);
    
    return destPoint;
}

// Adjust points by applying block to each element
- (UIBezierPath *) adjustPathElementsWithBlock: (PathBlock) block
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!block)
    {
        [path appendPath:self];
        return path;
    }
    
    for (XFBezierElement *element in self.elements)
        [[element elementByApplyingBlock:block] addToPath:path];
    
    return path;
}

// Apply transform
- (UIBezierPath *) pathApplyTransform: (CGAffineTransform) transform
{
    UIBezierPath *copy = [UIBezierPath bezierPath];
    [copy appendPath:self];
    
    CGRect bounding = self.computedBounds;
    CGPoint center = RectGetCenter(bounding);
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, center.x, center.y);
    t = CGAffineTransformConcat(transform, t);
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    [copy applyTransform:t];
    
    return copy;
}

- (CGFloat) pathLength
{
    NSArray *elements = self.elements;
    CGPoint current = NULLPOINT;
    CGPoint firstPoint = NULLPOINT;
    float totalPointLength = 0.0f;
    
    for (XFBezierElement *element in elements)
    {
        // 第一条线段是kCGPathElementMoveToPoint类型就会返回0.0
        totalPointLength += ElementDistanceFromPoint(element, current, firstPoint);
        
        if (element.elementType == kCGPathElementMoveToPoint)
            firstPoint = element.point;
        else if (element.elementType == kCGPathElementCloseSubpath)
            firstPoint = NULLPOINT;
        
        if (element.elementType != kCGPathElementCloseSubpath)
            current = element.point;
    }
    
    return totalPointLength;
}


// Calculate a point that's a given percentage along a path
- (CGPoint)pointAtPercent:(CGFloat)percent withSlope:(CGPoint *)slope {
    // Retrieve path elements
    NSArray *elements = self.elements;
    if (percent == 0.0f) {
        XFBezierElement *first = [elements objectAtIndex:0];
        return first.point;
    }
    // Retrieve the full path distance
    float pathLength = self.pathLength;
    float totalDistance = 0.0f;
    // Establish the current and firstPoint states
    CGPoint current = NULLPOINT;
    CGPoint firstPoint = NULLPOINT;
    // Iterate through elements until the percentage
    // no longer overshoots
    for (XFBezierElement *element in elements)
    {
        float distance = ElementDistanceFromPoint(element, current, firstPoint);
        CGFloat proposedTotalDistance = totalDistance + distance;
        CGFloat proposedPercent = proposedTotalDistance / pathLength;
        if (proposedPercent < percent) {
            // Consume and continue
            totalDistance = proposedTotalDistance;
            if (element.elementType == kCGPathElementMoveToPoint)
                firstPoint = element.point;
            current = element.point;
            continue;
        }
        // What percent between p1 and p2?
        // 当前百分比
        CGFloat currentPercent = totalDistance / pathLength;
        // 预期百分比减去当前百分比 = 遗漏的百分比
        CGFloat dPercent = percent - currentPercent;
        // 遗漏的百分比点总长的长度
        CGFloat percentDistance = dPercent * pathLength;
        // 得到占用当前线段的百分比
        CGFloat targetPercent = percentDistance / distance;
        // Return result
        CGPoint point = InterpolatePointFromElement(element, current, firstPoint, targetPercent, slope);
        return point;
    }
    return NULLPOINT;
}

#pragma mark - Inverses
// 添加一个矩形包围原有路径，并应用Event/Odd填充同时反转规则 (路径填充反转)
- (UIBezierPath *) inverseInRect: (CGRect) rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:self];
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];
    path.usesEvenOddFillRule = YES;
    return path;
}

// 外围添加一个无限大的矩形来反转Event/Odd
- (UIBezierPath *) inverse {
    return [self inverseInRect:CGRectInfinite];
}
// 外围添加一个当前路径Bounds的矩形来反转Event/Odd
- (UIBezierPath *) boundedInverse {
    return [self inverseInRect:self.bounds];
}

@end
