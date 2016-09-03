//
//  BlurredMasks.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BlurredMasks.h"
#import "XFCrystalKit.h"

@implementation BlurredMasks

- (void)drawRect:(CGRect)rect
{
    // 使用封装方法
    UIImage *result = [XFCrystal imageSoftEdgeWithSize:CGSizeMake(200, 200) sourceImage:[UIImage imageNamed:@"profile"] insetScale:0.9 cornerRadius:10 blurWithRaduis:8];
    
    [XFCrystal drawImage:result targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
    
}

@end
