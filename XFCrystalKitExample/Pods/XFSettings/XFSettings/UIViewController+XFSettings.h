//
//  UIViewController+XFSettings.h
//  XFSettings
//
//  Created by 付星 on 16/6/22.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSettingsProt.h"

@class XFCellAttrsData,XFTableViewAgent;
@protocol XFSettingTableViewDataSource,XFSettingsProt;

@interface UIViewController (XFSettings) <XFSettingsProt>

@property (nonatomic, weak) UITableView *xf_tableView;
@property (nonatomic, weak) id<XFSettingTableViewDataSource> xf_dataSource;
@property (nonatomic, strong) NSMutableArray *xf_settingGroups;
@property (nonatomic, strong) XFCellAttrsData *xf_cellAttrsData;
/**
 *  建立配置设置
 */
- (void)xf_setup;

@end
