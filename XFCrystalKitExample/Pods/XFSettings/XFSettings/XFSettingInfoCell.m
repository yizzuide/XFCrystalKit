//
//  XFSettingInfoCell.m
//  XFSettings
//
//  Created by Yizzuide on 15/6/26.
//  Copyright © 2015年 Yizzuide. All rights reserved.
//

#import "XFSettingInfoCell.h"
#import "XFSettingInfoItem.h"
#import "XFCellAttrsData.h"

@implementation XFSettingInfoCell

- (UILabel *)rightInfoLabel{
    if (_rightInfoLabel == nil) {
        UILabel *label= [[UILabel alloc] init];
        //label.backgroundColor = [UIColor grayColor];
        label.bounds = CGRectMake(0, 0, 20, 20);
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        _rightInfoLabel = label;
        // 监听右边文字改变
        [_rightInfoLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _rightInfoLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.x = CGRectGetMaxX(self.textLabel.frame)  + (self.cellAttrsData.contentEachOtherPadding > 1.f ? self.cellAttrsData.contentEachOtherPadding * 0.5 : 7.5);
    self.detailTextLabel.frame = detailFrame;
    
    // 根据文字调整大小
    CGRect rightInfoFrame = self.rightInfoLabel.frame;
    CGSize rightInfoSize = [self rightInfoSize];
    rightInfoFrame.size = rightInfoSize;
    rightInfoFrame.origin.x = self.contentView.frame.size.width - rightInfoSize.width - (self.cellAttrsData.contentEachOtherPadding > 1.f ? self.cellAttrsData.contentEachOtherPadding : 15);
    rightInfoFrame.origin.y = (self.contentView.frame.size.height - rightInfoSize.height) * 0.5;
    self.rightInfoLabel.frame = rightInfoFrame;
    
    // 执行自定义布局
    self.item.optionBlock(self,XFSettingPhaseTypeCellLayout,nil);
}

- (CGSize)rightInfoSize
{
    return [self.rightInfoLabel.text sizeWithFont:self.rightInfoLabel.font];
}

+ (NSString *)settingCellReuseIdentifierString
{
    return @"settingInfo-cell";
}

- (void)setItem:(XFSettingItem *)item
{
    [super setItem:item];
    
    XFSettingInfoItem *infoItem = (XFSettingInfoItem *)item;
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:(self.cellAttrsData.contentTextMaxSize > 1.f ? self.cellAttrsData.contentTextMaxSize - 1 : 12)];
    self.detailTextLabel.text = infoItem.detailText;
    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    self.detailTextLabel.textColor = self.cellAttrsData.contentDetailTextColor ? self.cellAttrsData.contentDetailTextColor : [UIColor grayColor];
    
    self.rightInfoLabel.text = infoItem.rightInfo;
    self.rightInfoLabel.font = [UIFont systemFontOfSize:(self.cellAttrsData.contentTextMaxSize > 1.f ? self.cellAttrsData.contentTextMaxSize - 1 : 12)];
    self.rightInfoLabel.textColor = self.cellAttrsData.contentInfoTextColor ? self.cellAttrsData.contentInfoTextColor : [UIColor redColor];
    
    // 如果没有跳转控制器和动作执行代码块
    if (!infoItem.destVCClass && !infoItem.optionBlock) {
        // 使cell不能点击
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if ([self respondsToSelector:@selector(settingInfoValueChanged:)]) {
//        [self settingInfoValueChanged:self.rightInfoLabel];
//    }
//    重新布局
    [self setNeedsLayout];
    
}

- (void)dealloc
{
//    移除侦听
    [self.rightInfoLabel removeObserver:self forKeyPath:@"text"];
}


@end
