//
//  ConvertingAnImageToGrayscale.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "ConvertingAnImageToGrayscale.h"
#import "XFCrystalKit.h"

@implementation ConvertingAnImageToGrayscale

- (void)drawRect:(CGRect)rect {
    
    // 绘制原图居中显示
    UIImage *sourceImage = [UIImage imageNamed:@"gujian2"];
    [XFCrystal drawImage:sourceImage targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
    
    // 创建截取区域
    CGRect clipArea = RectInsetByPercent(rect, 0.75f);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:clipArea];
    
    [XFCrystal drawClipPath:path.CGPath drawBlock:^(CGContextRef context) {
        // 在截取区域内绘制居中显示灰图
        UIImage *grayImage = [XFCrystal imageConvert2GrayFrom:sourceImage];
        [XFCrystal drawImage:grayImage targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
    }];
    // 显示区域大小
    [XFCrystal drawDecorateDashLineWithPath:path.CGPath drawBlock:nil];
    /*[[UIColor purpleColor] set];
     UIRectFrame(clipArea);*/
    
}

@end
