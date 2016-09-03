//
//  XFCellColorData.m
//  XFSettings
//
//  Created by Yizzuide on 15/9/1.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import "XFCellAttrsData.h"

@implementation XFCellAttrsData

+ (instancetype)cellColorDataWithBackgroundColor:(UIColor *)bgColor selBackgroundColor:(UIColor *)selBgColor {
    XFCellAttrsData *colData = [[XFCellAttrsData alloc] init];
    colData.cellBackgroundColor = bgColor;
    colData.cellSelectedBackgroundColor = selBgColor;
    return colData;
}

+ (instancetype)cellColorDataWithBackgroundView:(UIView *)bgView selBackgroundView:(UIView *)selBgView {
    XFCellAttrsData *colData = [[XFCellAttrsData alloc] init];
    colData.cellBackgroundView = bgView;
    colData.cellSelectedBackgroundView = selBgView;
    return colData;
}
@end
