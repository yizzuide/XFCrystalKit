//
//  XFTableViewAgent.m
//  XFSettings
//
//  Created by 付星 on 16/7/8.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import "XFTableViewAgent.h"
#import "XFSettings.h"
#import "XFSettingsProt.h"

@implementation XFTableViewAgent

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingsProt.xf_settingGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingsProt.xf_settingGroups[section] items].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell的模型
    XFSettingItem *item = [self.settingsProt.xf_settingGroups[indexPath.section] items][indexPath.row];
    // 显示的cell
    XFSettingCell *cell;
    // 如果有自定义的cell类型
    if (item.relatedCellClass) {
        cell = [item.relatedCellClass settingCellWithTalbeView:tableView cellColorData:self.settingsProt.xf_cellAttrsData];
    }else{ // 使用默认类型
        cell = [XFSettingCell settingCellWithTalbeView:tableView cellColorData:self.settingsProt.xf_cellAttrsData];
    }
    // 绑定item
    cell.item = item;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.settingsProt.xf_settingGroups[section] header];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self.settingsProt.xf_settingGroups[section] footer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XFSettingItem *item = [self.settingsProt.xf_settingGroups[indexPath.section] items][indexPath.row];
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
            
            [self.settingsProt.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
