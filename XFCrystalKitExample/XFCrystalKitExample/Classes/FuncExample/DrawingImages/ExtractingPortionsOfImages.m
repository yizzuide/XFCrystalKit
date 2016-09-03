//
//  ExtractingPortionsOfImages.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "ExtractingPortionsOfImages.h"
#import "XFCrystalKit.h"

@implementation ExtractingPortionsOfImages

- (void)drawRect:(CGRect)rect {
    // 块大小
    CGSize block = CGSizeMake(100, 100);
    // Drawing code
    [XFCrystal drawCenterInRect:rect drawBlock:^(CGContextRef context) {
        [[XFCrystal imageExtractRectFrom:[UIImage imageNamed:@"gujian2"] subRect:RectMakeRect(CGPointMake(550, 20),block)] drawAtPoint:CGPointMake(- block.width * 0.5, - block.height * 0.5)];
    }];
}
@end
