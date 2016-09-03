//
//  XFBezierElement.m
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/7.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "XFBezierElement.h"
#import "XFGeometryFunc.h"

const NSArray *___CGPathElementType;
#define cCGPathElementTypeGet ___CGPathElementType ? @[@"MoveToPoint",\
    @"AddLineToPoint",\
    @"AddQuadCurveToPoint",\
    @"AddCurveToPoint",\
    @"CloseSubpath"] : ___CGPathElementType
// 枚举 to 字串
#define cCGPathElementTypeGetString(type) [cCGPathElementTypeGet objectAtIndex:(type)]
// 字串 to 枚举
#define cCGPathElementTypeEnum(string) ([cCGPathElementTypeGet indexOfObject:string])

@implementation XFBezierElement

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _elementType = kCGPathElementMoveToPoint;
        _point = NULLPOINT;
        _controlPoint1 = NULLPOINT;
        _controlPoint2 = NULLPOINT;
    }
    return self;
}

// Create a BezierElement object that represents
// the data stored in the passed element
/**
 *  struct CGPathElement {
        CGPathElementType type; // 路径类型
        CGPoint *points; // 结点
    };
 */
+ (instancetype) elementWithPathElement:(CGPathElement) element {
    XFBezierElement *newElement = [[self alloc] init];
    newElement.elementType = element.type;
    switch (newElement.elementType)
    {
        case kCGPathElementCloseSubpath:
            break;
        case kCGPathElementMoveToPoint:
        case kCGPathElementAddLineToPoint: {
            newElement.point = element.points[0];
            break;
        }
        case kCGPathElementAddQuadCurveToPoint: {
            newElement.controlPoint1 = element.points[0];
            newElement.point = element.points[1];
            break;
        }
        case kCGPathElementAddCurveToPoint: {
            newElement.controlPoint1 = element.points[0];
            newElement.controlPoint2 = element.points[1];
            newElement.point = element.points[2];
            break;
        }
        default:
        break;
    }
    return newElement;
}

// 复制一个新对象（深度拷贝）
- (instancetype) copyWithZone: (NSZone *) zone
{
    XFBezierElement *theCopy = [[[self class] allocWithZone:zone] init];
    if (theCopy)
    {
        theCopy.elementType = _elementType;
        theCopy.point = _point;
        theCopy.controlPoint1 = _controlPoint1;
        theCopy.controlPoint2 = _controlPoint2;
    }
    return theCopy;
}

- (XFBezierElement *) elementByApplyingBlock: (PathBlock) block
{
    XFBezierElement *output = [self copy];
    if (!block)
        return output;
    
    if (!POINT_IS_NULL(output.point))
        output.point = block(output.point);
    if (!POINT_IS_NULL(output.controlPoint1))
        output.controlPoint1 = block(output.controlPoint1);
    if (!POINT_IS_NULL(output.controlPoint2))
        output.controlPoint2 = block(output.controlPoint2);
    return output;
}

// This is a BezierElement method. The element
// adds itself to the path passed as the argument
- (void)addToPath:(UIBezierPath *)path
{
    switch (self.elementType) {
        case kCGPathElementCloseSubpath:
            [path closePath];
            break;
        case kCGPathElementMoveToPoint:
            [path moveToPoint:self.point];
            break;
        case kCGPathElementAddLineToPoint:
            [path addLineToPoint:self.point];
            break;
        case kCGPathElementAddQuadCurveToPoint:
            [path addQuadCurveToPoint:self.point controlPoint:self.controlPoint1];
            break;
        case kCGPathElementAddCurveToPoint:
            [path addCurveToPoint:self.point controlPoint1:self.controlPoint1 controlPoint2:self.controlPoint2];
            break;
        default:
        break;
    }
}

- (NSString *) stringValue
{
    switch (self.elementType)
    {
        case kCGPathElementCloseSubpath:
            return @"Close Path";
        case kCGPathElementMoveToPoint:
            return [NSString stringWithFormat:@"Move to point %@", POINTSTRING(self.point)];
        case kCGPathElementAddLineToPoint:
            return [NSString stringWithFormat:@"Add line to point %@", POINTSTRING(self.point)];
        case kCGPathElementAddQuadCurveToPoint:
            return [NSString stringWithFormat:@"Add quad curve to point %@ with control point %@", POINTSTRING(self.point), POINTSTRING(self.controlPoint1)];
        case kCGPathElementAddCurveToPoint:
            return [NSString stringWithFormat:@"Add curve to point %@ with control points %@ and %@", POINTSTRING(self.point), POINTSTRING(self.controlPoint1), POINTSTRING(self.controlPoint2)];
    }
    return nil;
}

- (void) showTheCode
{
    switch (self.elementType)
    {
        case kCGPathElementCloseSubpath:
            printf("    [path closePath];\n\n");
            break;
        case kCGPathElementMoveToPoint:
            printf("    [path moveToPoint:CGPointMake(%f, %f)];\n",
                   self.point.x, self.point.y);
            break;
        case kCGPathElementAddLineToPoint:
            printf("    [path addLineToPoint:CGPointMake(%f, %f)];\n",
                   self.point.x, self.point.y);
            break;
        case kCGPathElementAddQuadCurveToPoint:
            printf("    [path addQuadCurveToPoint:CGPointMake(%f, %f) controlPoint:CGPointMake(%f, %f)];\n",
                   self.point.x, self.point.y, self.controlPoint1.x, self.controlPoint1.y);
            break;
        case kCGPathElementAddCurveToPoint:
            printf("    [path addCurveToPoint:CGPointMake(%f, %f) controlPoint1:CGPointMake(%f, %f) controlPoint2:CGPointMake(%f, %f)];\n",
                   self.point.x, self.point.y, self.controlPoint1.x, self.controlPoint1.y, self.controlPoint2.x, self.controlPoint2.y);
            break;
        default:
            break;
    }
}
@end
