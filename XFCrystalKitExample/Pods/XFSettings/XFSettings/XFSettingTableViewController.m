//
//  XFBaseSettingTableViewController.m
//  XFSettings
//
//  Created by Yizzuide on 15/5/27.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import "XFSettingTableViewController.h"
#import "XFSettings.h"

@interface XFSettingTableViewController ()

@property (nonatomic, strong) NSMutableArray *settingGroups;
@end

@implementation XFSettingTableViewController

- (NSMutableArray *)settingGroups
{
    if (_settingGroups == nil) {
        NSArray *source = [self.dataSource settingItems];
        _settingGroups = [XFSettingGroup settingGroupsWithArray:source];
        
        // 是否取消系统划线
        if (self.cellAttrsData.cellFullLineEnable) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    return _settingGroups;
}

// 默认初始化时使用分组
- (instancetype)init
{
    return [self initWithStyle:[self tableViewStyle]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationItem.title = @"设置";
}

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingGroups[section] items].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell的模型
    XFSettingItem *item = [self.settingGroups[indexPath.section] items][indexPath.row];
    // 显示的cell
    XFSettingCell *cell;
    // 如果有自定义的cell类型
    if (item.relatedCellClass) {
        cell = [item.relatedCellClass settingCellWithTalbeView:tableView cellColorData:self.cellAttrsData];
    }else{ // 使用默认类型
        cell = [XFSettingCell settingCellWithTalbeView:tableView cellColorData:self.cellAttrsData];
    }
    // 绑定item
    cell.item = item;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.settingGroups[section] header];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self.settingGroups[section] footer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XFSettingItem *item = [self.settingGroups[indexPath.section] items][indexPath.row];
    // 如果有操作要执行
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle != UITableViewCellSelectionStyleNone) {
        if (item.optionBlock) {
            item.optionBlock([tableView cellForRowAtIndexPath:indexPath],XFSettingPhaseTypeCellInteracted,nil);
        }
    }
    
    
    // 如果是有第二级控制器显示类型
    if ([item isKindOfClass:[XFSettingArrowItem class]]) {
        XFSettingArrowItem *arrowItem = (XFSettingArrowItem *)item;
        Class vcClass = ((XFSettingArrowItem *)arrowItem).destVCClass ;
        if (vcClass) {
            // 通过Class生成对象，如果这个对象不是控制器直接返回
            id object = [[vcClass alloc] init];
            if (![object isKindOfClass:[UIViewController class]]) {
                return;
            }
            UIViewController *controller = object;
            
            // 是否带有参数
            id<XFSettingIntentUserInfo> intent = (id<XFSettingIntentUserInfo>)controller;
            if (arrowItem.destVCUserInfo) {
                if([intent respondsToSelector:@selector(setUserInfo:)])
                    intent.userInfo = arrowItem.destVCUserInfo;
            }
            
            // 设置标题
            controller.title = arrowItem.title;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

// 支持横竖屏配置
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat currentSW = self.view.bounds.size.width;
    CGFloat currentSH = self.view.bounds.size.height;
    [UIView animateWithDuration:duration animations:^{
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            if (currentSW < currentSH) {
                self.tableView.frame = CGRectMake(0, 0, currentSH, currentSW);
            }
        }else{
            if (currentSW > currentSH) {
                self.tableView.frame = CGRectMake(0, 0, currentSH, currentSW);
            }
        }
    }];
}

@end
