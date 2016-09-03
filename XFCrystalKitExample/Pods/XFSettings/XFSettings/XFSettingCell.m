//
//  XFSettingCell.m
//  XFSettings
//
//  Created by Yizzuide on 15/5/26.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import "XFSettingCell.h"
#import "XFSettingArrowItem.h"
#import "XFSettingSwitchItem.h"
#import "XFSettingTableViewController.h"
#import "XFCellAttrsData.h"

@interface XFSettingCell ()

@property (nonatomic, weak) UISwitch *switchView;
@property (nonatomic, weak) UIImageView *arrowIcon;

@property (nonatomic, weak) UIView *bottomLineView;
@end

@implementation XFSettingCell

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        UISwitch *swithView= [[UISwitch alloc] init];
        [swithView addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = swithView;
        
        _switchView = swithView;
    }
    return _switchView;
}
 - (UIImageView *)arrowIcon
{
    if (_arrowIcon == nil) {
        UIImageView *arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 12)];
        arrowIcon.contentMode = UIViewContentModeCenter;
        self.accessoryView = arrowIcon;
        _arrowIcon = arrowIcon;
    }
    return _arrowIcon;
}
- (UIView *)bottomLineView
{
    if (_bottomLineView == nil) {
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = [UIColor grayColor];
        [self addSubview:bottomLineView];
        _bottomLineView = bottomLineView;
    }
    return _bottomLineView;
}

- (void)setItem:(XFSettingItem *)item
{
    _item = item;
    
    // 执行初始化
    if (item.optionBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            item.optionBlock(self,XFSettingPhaseTypeCellInit,nil);
        });
    }

    self.textLabel.text = item.title;
    self.textLabel.font = [UIFont systemFontOfSize:(self.cellAttrsData.contentTextMaxSize > 1.f ? self.cellAttrsData.contentTextMaxSize : 13)];
    self.textLabel.textColor = self.cellAttrsData.contentTitleTextColor ? self.cellAttrsData.contentTitleTextColor : [UIColor blackColor];
    
    // 有的设置栏没有图标
    if (item.icon.length) {
        self.imageView.image = [UIImage imageNamed:item.icon];
    }
    
    // 设置辅助视图类型
    Class itemClass = [item class];
    // 如果是带有向右箭头的cell
    if ([item isKindOfClass:[XFSettingArrowItem class]]) {
        XFSettingArrowItem *arrowItem = (XFSettingArrowItem *)item;
        if (arrowItem.destVCClass) {
            // 如果有自定义的图标
            if (arrowItem.arrowIcon) {
                self.arrowIcon.image = [UIImage imageNamed:arrowItem.arrowIcon];
            }else{ // 否则用系统默认
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
        }
    }else if (itemClass == [XFSettingSwitchItem class]){ // Switch Cell
        self.accessoryType = UITableViewCellAccessoryNone;
        [self switchView];
        // 点击不可选择
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else { // 其它的恢复状态到默认
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    // 如果用户用了cellFullLineEnable
    if (self.cellAttrsData.cellFullLineEnable) {
        [self bottomLineView];
    }
}
// 创建可复用cell
+ (instancetype)settingCellWithTalbeView:(UITableView *)tableView cellColorData:(XFCellAttrsData *)cellAttrsData {
    NSString *ID = [self settingCellReuseIdentifierString];
    
    XFSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
//        NSLog(@"%@",cell);
        cell.cellAttrsData = cellAttrsData;
        // 设置cell属性
        if (cellAttrsData.cellBackgroundColor)
            cell.backgroundColor = cellAttrsData.cellBackgroundColor;
        if (cellAttrsData.cellSelectedBackgroundColor){
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = cellAttrsData.cellSelectedBackgroundColor;
            cell.selectedBackgroundView = view;
        }
        if (cellAttrsData.cellBackgroundView)
            cell.backgroundView = cellAttrsData.cellBackgroundView;
        if (cellAttrsData.cellSelectedBackgroundView)
            cell.selectedBackgroundView = cellAttrsData.cellSelectedBackgroundView;
    }
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
     CGRect titleFrame = self.textLabel.frame;
    // 根据是否有icon来确定titleFrame的位置
    if(self.imageView.image){
        // 调整IconView的位置
        CGRect bounds = self.imageView.bounds;
        CGFloat wh = self.cellAttrsData.contentIconSize > 1.f ? self.cellAttrsData.contentIconSize : 24;
        bounds.size = CGSizeMake(wh, wh);
        self.imageView.bounds = bounds;
        
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin.x = self.cellAttrsData.contentEachOtherPadding > 1.f ? self.cellAttrsData.contentEachOtherPadding : 15;
        self.imageView.frame = imageFrame;
        
        // textLabel
        titleFrame.origin.x = CGRectGetMaxX(imageFrame) + imageFrame.origin.x;
        self.textLabel.frame = titleFrame;
    }else{
       // 如果没有图片就向左靠
        titleFrame.origin.x = self.cellAttrsData.contentEachOtherPadding;
        self.textLabel.frame = titleFrame;
    }
   
    // 如果满横屏填充
    if(self.cellAttrsData.cellFullLineEnable){
        // 画cell底部的线
        CGRect frame = self.bottomLineView.frame;
        frame.size.width = self.frame.size.width;
        frame.size.height = 0.8;
        frame.origin.y = self.frame.size.height - frame.size.height;
        self.bottomLineView.frame = frame;
        // 设置线条颜色
        if (self.cellAttrsData.cellBottomLineColor) {
            self.bottomLineView.backgroundColor = self.cellAttrsData.cellBottomLineColor;
        }
    }else{
        // 调整系统的下划线
        NSUInteger count = self.subviews.count;
        for (int i = 0; i < count; i++) {
            UIView *subView = self.subviews[i];
            if ([subView isMemberOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
                CGRect lineFrame = subView.frame;
                CGFloat lineW = lineFrame.size.width;
                CGFloat lineX = lineFrame.origin.x;
                CGFloat lineY = lineFrame.origin.y;
                // 是否隐藏TopLine
                if (self.cellAttrsData.disableTopLine) {
                    if (self.item.isFirst && lineW == [UIScreen mainScreen].bounds.size.width && lineX == 0 && lineY == 0) {
                        subView.hidden = YES;
                        continue;
                    }
                }
                // 重新计算底部下划线
                if (lineW < [UIScreen mainScreen].bounds.size.width) {
                    lineFrame.origin.x = titleFrame.origin.x;
                    lineFrame.size.width = [UIScreen mainScreen].bounds.size.width - lineFrame.origin.x;
                    subView.frame = lineFrame;
                }
                
                // 设置线条颜色
                if (self.cellAttrsData.cellBottomLineColor) {
                    subView.backgroundColor = self.cellAttrsData.cellBottomLineColor;
                }
            }
        }
    }
}

+ (NSString *)settingCellReuseIdentifierString
{
    return @"setting-cell";
}

- (void)stateChanged:(UISwitch *)switchView {
    if (self.item.optionBlock) {
        self.item.optionBlock(self,XFSettingPhaseTypeCellInteracted,@{@"switchOn":@(switchView.isOn)});
    }
}

@end
