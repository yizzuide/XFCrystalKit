//
//  XFSettings.h
//  XFSettings
//
//  Created by Yizzuide on 15/6/25.
//  Copyright © 2015年 Yizzuide. All rights reserved.
//

#ifndef XFSettings_h
#define XFSettings_h

#import "XFCellAttrsData.h"
#import "XFSettingTableViewController.h"
//#import "UIViewController+XFSettings.h"
#import "XFSettingTableViewDataSource.h"
#import "XFSettingGroup.h"
#import "XFSettingItem.h"
#import "XFSettingArrowItem.h"
#import "XFSettingSwitchItem.h"
#import "XFSettingInfoItem.h"
#import "XFSettingAssistImageItem.h"

#import "XFSettingCell.h"
#import "XFSettingInfoCell.h"
#import "XFSettingInfoCountCell.h"
#import "XFSettingInfoDotCell.h"
#import "XFSettingAssistImageCell.h"





// 组信息
/**
 *  分组头信息
 */
extern NSString * const XFSettingGroupHeader;
/**
 *  每一组的多个Cell
 */
extern NSString * const XFSettingGroupItems;
/**
 *  分组页脚信息
 */
extern NSString * const XFSettingGroupFooter;

// 每个Item的可用配置
/**
 *  Cell的模型类型
 */
extern NSString * const XFSettingItemClass;
/**
 *  Cell标题
 */
extern NSString * const XFSettingItemTitle;
/**
 *  Cell图标
 */
extern NSString * const XFSettingItemIcon;
/**
 *  cell arrow图标
 */
extern NSString * const XFSettingItemArrowIcon;
/**
 *  CellView的类型
 */
extern NSString * const XFSettingItemRelatedCellClass;
/**
 *  第二级跳转控制器Class
 */
extern NSString * const XFSettingItemDestViewControllerClass;
/**
 *  使用XFSettingArrowItem时，第二级跳转控制器传参数信息（新的控制器里添加XFSettingIntentUserInfo协议）
 */
extern NSString * const XFSettingItemDestViewControllerUserInfo;
/**
 *  Cell点击后的执行代码块
 */
extern NSString * const XFSettingOptionActionBlock;
/**
 * 使用XFSettingInfoItem和XFSettingInfoCell时的属性,详细信息
 */
extern NSString * const XFSettingItemAttrDetailText;
/**
 *  使用XFSettingInfoItem和XFSettingInfoCell时的属性,右边辅助信息
 */
extern NSString * const XFSettingItemAttrRightInfo;
/**
 *  使用XFSettingAssistImageItem和XfSettingAssistImageCell时的属性，右边辅助图
 */
extern NSString * const XFSettingItemAttrAssistImageName;


/**
 *  开关交互信息
 */
extern NSString * const XFSettingIntentDataSwitchOn;


@protocol XFSettingIntentUserInfo <NSObject>
@required
@property (nonatomic, strong) NSDictionary *userInfo;

@end


#endif /* XFSettings_h */
