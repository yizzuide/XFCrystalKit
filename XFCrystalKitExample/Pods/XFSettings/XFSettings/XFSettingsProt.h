//
//  XFSettingsProt.h
//  XFSettings
//
//  Created by 付星 on 16/7/8.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#ifndef XFSettingsProt_h
#define XFSettingsProt_h

@class XFCellAttrsData;
@protocol XFSettingsProt <NSObject>
/**
 *  数据源
 */
@property (nonnull, nonatomic, strong) NSMutableArray *xf_settingGroups;
/**
 *  全局属性
 */
@property (nonnull,nonatomic, strong) XFCellAttrsData *xf_cellAttrsData;
/**
 *  控制器默认属性
 */
@property(nullable, nonatomic,readonly,strong) UINavigationController *navigationController;
@end

#endif /* XFSettingsProt_h */
