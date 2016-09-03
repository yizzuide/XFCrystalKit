//
//  FillDrawing.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "FillDrawing.h"
#import "XFCrystalKit.h"

@implementation FillDrawing

- (void)drawRect:(CGRect)rect {
    UIImage *sourceImage = [UIImage imageNamed:@"gujian2"];
    CGSize sourceSize = sourceImage.size;
    CGRect destRect = RectByFillingRect(RectMakeRect(CGPointMake(0, 0), sourceSize), rect);
    [sourceImage drawInRect:destRect];
}

@end
