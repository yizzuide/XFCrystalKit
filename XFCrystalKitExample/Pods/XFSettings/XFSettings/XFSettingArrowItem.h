//
//  XFSettingArrowItem.h
//  XFSettings
//
//  Created by Yizzuide on 15/5/26.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import "XFSettingItem.h"

/**
 *  用于跳转控制器
 */
@interface XFSettingArrowItem : XFSettingItem
// 跳转提示图标
@property (nonatomic, copy) NSString *arrowIcon;
// 跳转的目标控制器
@property (nonatomic, assign) Class destVCClass;
// 目标控制器参数信息
@property (nonatomic, strong) NSDictionary *destVCUserInfo;
@end
