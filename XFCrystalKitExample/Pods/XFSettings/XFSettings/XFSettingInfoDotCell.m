//
//  XFSettingInfoDotCell.m
//  XFSettings
//
//  Created by Yizzuide on 15/6/29.
//  Copyright © 2015年 Yizzuide. All rights reserved.
//

#import "XFSettingInfoDotCell.h"
#import "XFCellAttrsData.h"


@implementation XFSettingInfoDotCell


- (void)setItem:(XFSettingItem *)item
{
    [super setItem:item];
    
    
    CALayer *layer = self.rightInfoLabel.layer;
    layer.cornerRadius = 3;
    layer.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.760].CGColor;
}

// 覆盖真实大小，让父类基于这个大小布局
- (CGSize)rightInfoSize
{
    return CGSizeMake(6, 6);
}


- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    self.rightInfoLabel.layer.backgroundColor = self.dotColor ? self.dotColor.CGColor : [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.760].CGColor;
}

@end
