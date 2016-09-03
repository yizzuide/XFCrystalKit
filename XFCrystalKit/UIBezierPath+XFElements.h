//
//  UIBezierPath+Elements.h
//  XFCrystalKit
//
//  Created by yizzuide on 16/1/13.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFBezierElement.h"

/*
 UIBezierPath - Elements Category
 */

@interface UIBezierPath (XFElements)
// Path Element
// Retrieve array of component elements
/**
 *  返回所有子路径元素(BezierElement）
 */
@property (nonatomic, readonly) NSArray<XFBezierElement *>  *elements;
/**
 *  所有子路径
 */
@property (nonatomic, readonly) NSArray<UIBezierPath *> *subpaths;

@property (nonatomic, readonly) NSArray *destinationPoints;
@property (nonatomic, readonly) NSArray *interpolatedPathPoints;
/**
 *  路径元素总数
 */
@property (nonatomic, readonly) NSUInteger count;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
/**
 *  路径中心点
 */
@property (nonatomic, readonly) CGPoint center;
/**
 *  真实计算的bounds（去除控制点的区域）
 */
@property (nonatomic, readonly) CGRect computedBounds;
@property (nonatomic, readonly) CGRect computedBoundsWithLineWidth;

/**
 *  逆向整个路径
 *
 *  @return 返回一条逆向的路径
 */
@property (nonatomic, readonly) UIBezierPath *reversed;
/**
 *  外围添加一个无限大的矩形来反转Event/Odd
 *
 */
@property (nonatomic, readonly) UIBezierPath *inverse;
/**
 *  外围添加一个当前路径Bounds的矩形来反转Event/Odd
 *
 */
@property (nonatomic, readonly) UIBezierPath *boundedInverse;

@property (nonatomic, readonly) BOOL subpathIsClosed;
- (BOOL) closeSafely;

// Measure length
/**
 *  路径长度
 */
@property (nonatomic, readonly) CGFloat pathLength;
// Calculate a point that's a given percentage along a path
/**
 *  在路径当中找一个点
 *
 *  @param percent 百分点
 *  @param slope   当前点朝向
 *
 */
- (CGPoint) pointAtPercent: (CGFloat) percent withSlope: (CGPoint *) slope;

// String Representations
- (void) showTheCode;
- (NSString *) stringValue;

// -- Invert path to arbitrary rectangle
/**
 *  添加一个矩形包围原有路径，并应用Event/Odd填充同时反转规则
 *
 */
- (UIBezierPath *) inverseInRect: (CGRect) rect;
@end
