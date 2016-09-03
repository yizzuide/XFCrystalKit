//
//  UIViewController+XFSettings.m
//  XFSettings
//
//  Created by 付星 on 16/6/22.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import "UIViewController+XFSettings.h"
#import <objc/runtime.h>
#import "XFTableViewAgent.h"
#import "XFCellAttrsData.h"
#import "XFSettingTableViewDataSource.h"
#import "XFSettingGroup.h"

@implementation UIViewController (XFSettings)

static void * xfSettings_TableView = (void *)@"xfSettings_TableView";
static void * xfSettings_DataSource = (void *)@"xfSettings_DataSource";
static void * xfSettings_SettingGroups = (void *)@"xfSettings_SettingGroups";
static void * xfSettings_cellAttrsData = (void *)@"xfSettings_cellAttrsData";

static void * xfSettings_Agent = (void *)@"xfSettings_Agent";

- (void)setXf_tableView:(UITableView *)xf_tableView
{
    objc_setAssociatedObject(self, &xfSettings_TableView, xf_tableView, OBJC_ASSOCIATION_ASSIGN);
}

- (UITableView *)xf_tableView
{
    UITableView *view = objc_getAssociatedObject(self, &xfSettings_TableView);
    if(!view){
        UITableViewStyle style = self.xf_cellAttrsData.tableViewStyle;
        view = [[UITableView alloc] initWithFrame:self.view.frame style:style];
        //view.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:view];
        [self setXf_tableView:view];
        return view;
    }
    return view;
}

- (void)setXf_dataSource:(id<XFSettingTableViewDataSource>)xf_dataSource
{
    objc_setAssociatedObject(self, &xfSettings_DataSource, xf_dataSource, OBJC_ASSOCIATION_ASSIGN);
}

- (id<XFSettingTableViewDataSource>)xf_dataSource
{
    return objc_getAssociatedObject(self, &xfSettings_DataSource);
}


- (void)setXf_settingGroups:(NSMutableArray *)xf_settingGroups
{
    objc_setAssociatedObject(self, &xfSettings_SettingGroups, xf_settingGroups, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)xf_settingGroups
{
    NSMutableArray *groups = objc_getAssociatedObject(self, &xfSettings_SettingGroups);
    if (groups == nil) {
        NSArray *source = [self.xf_dataSource settingItems];
        groups = [XFSettingGroup settingGroupsWithArray:source];
        [self setXf_settingGroups:groups];
        
        // 是否取消系统划线
        if (self.xf_cellAttrsData.cellFullLineEnable) {
            self.xf_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    return groups;
}

- (void)setXf_cellAttrsData:(XFCellAttrsData *)xf_cellAttrsData
{
    objc_setAssociatedObject(self, &xfSettings_cellAttrsData, xf_cellAttrsData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XFCellAttrsData *)xf_cellAttrsData
{
    return objc_getAssociatedObject(self, &xfSettings_cellAttrsData);
}

- (void)setXf_agent:(XFTableViewAgent *)xf_agent
{
    objc_setAssociatedObject(self, &xfSettings_Agent, xf_agent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XFTableViewAgent *)xf_agent
{
    XFTableViewAgent *agent = objc_getAssociatedObject(self, &xfSettings_Agent);
    if(!agent){
        agent = [[XFTableViewAgent alloc] init];
        agent.settingsProt = self;
        [self setXf_agent:agent];
        return agent;
    }
    return agent;
}

- (void)xf_setup
{
    self.xf_tableView.dataSource = self.xf_agent;
    self.xf_tableView.delegate = self.xf_agent;
    
    self.xf_tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[xf_tableView]-0-|" options:0 metrics:nil views:@{@"xf_tableView":self.xf_tableView}];
    [self.view addConstraints:hConstraint];
    NSArray *vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[xf_tableView]-0-|" options:0 metrics:nil views:@{@"xf_tableView":self.xf_tableView}];
    [self.view addConstraints:vConstraint];
    
}
@end
