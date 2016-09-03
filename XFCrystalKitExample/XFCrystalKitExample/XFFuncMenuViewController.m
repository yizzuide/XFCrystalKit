//
//  XFFuncMenuViewController.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "XFFuncMenuViewController.h"
#import "UIViewController+XFSettings.h"
#import "XFRenderViewController.h"

@interface XFFuncMenuViewController () <XFSettingTableViewDataSource>

@end

@implementation XFFuncMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // set cell attrs
    XFCellAttrsData *cellAttrsData = [[XFCellAttrsData alloc] init];
    // 设置图标大小
    cellAttrsData.contentIconSize = 20;
    // 设置内容间距
    cellAttrsData.contentEachOtherPadding = 25;
    // 标题文字大小（其它文字会按个大小自动调整）
    cellAttrsData.contentTextMaxSize = 15;
    
    cellAttrsData.cellFullLineEnable = YES;
    cellAttrsData.cellBottomLineColor = [UIColor purpleColor];
    
    // 表格风格
    cellAttrsData.tableViewStyle = UITableViewStyleGrouped;
    
    self.xf_cellAttrsData = cellAttrsData;
    // 设置数据源
    self.xf_dataSource = self;
    // 调用配置设置
    [self xf_setup];
}

- (NSArray *)settingItems
{
    
    NSArray *itemsInfo = self.userInfo[@"items"];
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *cellInfo in itemsInfo) {
        NSString *title = cellInfo[XFSettingItemTitle];
        Class viewClass = cellInfo[@"ViewClass"];
        [items addObject:@{
                           XFSettingItemTitle: title,
                           XFSettingItemClass: [XFSettingArrowItem class],
                           XFSettingItemDestViewControllerClass: [XFRenderViewController class],
                           XFSettingItemDestViewControllerUserInfo: @{@"ViewClass": viewClass}
                           }];
    }
    
    
    NSArray *itemGroups = @[
                            @{
                                XFSettingGroupItems : items
                                }
                            ];
    
    return itemGroups;
}
@end
