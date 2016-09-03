//
//  XFSettingInfoCell.h
//  XFSettings
//
//  Created by Yizzuide on 15/6/26.
//  Copyright © 2015年 Yizzuide. All rights reserved.
//

#import "XFSettingCell.h"

/* @protocol XFSettingInfoCellDelegate <NSObject>

@optional
- (void)settingInfoValueChanged:(UILabel *)rightInfoLabel;

@end */

@class XFSettingInfoItem,XFCellAttrsData;
/**
 *  一个显示右边文字的Cell
 */
@interface XFSettingInfoCell : XFSettingCell//<XFSettingInfoCellDelegate>

@property (nonatomic, weak) UILabel *rightInfoLabel;

/**
 *  子类必须实现这个勾子方法测量rightInfoLabel大小
 *
 */
- (CGSize)rightInfoSize;
@end
