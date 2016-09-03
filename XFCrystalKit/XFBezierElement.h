//
//  XFBezierElement.h
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/7.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

// Block for transforming points
typedef CGPoint (^PathBlock)(CGPoint point);


//Wrapping these path elements in an Objective-C class,simplifies their use. This class hides the intricacies of the point array with its implementation details, such as which item is the destination point and which items are the control points. Each element-based object expresses a consistent set of properties, forming a stepping-stone for many handy UIBezierPath utilities.

/**
 *  这是一个对CGPathElement结构体包装的OC类
 */
@interface XFBezierElement : NSObject
@property (nonatomic, assign) CGPathElementType elementType;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGPoint controlPoint1;
@property (nonatomic, assign) CGPoint controlPoint2;
@property (nonatomic, copy,readonly) NSString *stringValue;

/**
 *  从CGPathElement构建BezierElement
 *
 *  @param element CGPathElement
 *
 *  @return BezierElement
 */
+ (instancetype) elementWithPathElement:(CGPathElement) element;
// Applying transformations
- (XFBezierElement *) elementByApplyingBlock: (PathBlock) block;
/**
 *  添加到UIBezierPath
 *
 *  @param path UIBezierPath
 */
- (void)addToPath:(UIBezierPath *)path;
/**
 *  显示当前element的添加过程
 */
- (void) showTheCode;
@end
