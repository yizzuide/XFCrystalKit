//
//  XFSettingCell.h
//  XFSettings
//
//  Created by Yizzuide on 15/5/26.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSettingItem.h"


@class XFCellAttrsData;
/**
 *  基本功能Cell,可用XFSettingArrowItem和XFSettingSwitchItem模型来区分类型
 */
@interface XFSettingCell : UITableViewCell
/**
 *  Item模型
 */
@property (nonatomic, strong) XFSettingItem *item;
/**
 *  cell属性
 */
@property (nonatomic, strong) XFCellAttrsData *cellAttrsData;

+ (instancetype)settingCellWithTalbeView:(UITableView *)tableView cellColorData:(XFCellAttrsData *)cellAttrsData;
/**
 *  返加不同类型的cell的重用标识字符串
 *
 */
+ (NSString *)settingCellReuseIdentifierString;
@end
