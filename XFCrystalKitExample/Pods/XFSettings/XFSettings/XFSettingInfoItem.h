//
//  XFSettingInfoItem.h
//  XFSettings
//
//  Created by Yizzuide on 15/6/26.
//  Copyright © 2015年 Yizzuide. All rights reserved.
//  

#import "XFSettingArrowItem.h"
/**
 *  指定一个cell可有detailText、rightInfo、第二控制器等信息
 */
@interface XFSettingInfoItem : XFSettingArrowItem

@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *rightInfo;
@end
