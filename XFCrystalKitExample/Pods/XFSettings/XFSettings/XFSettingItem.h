//
//  XFSettingItem.h
//  XFSettings
//
//  Created by Yizzuide on 15/5/26.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XFSettingPhaseTypeCellInit,
    XFSettingPhaseTypeCellLayout,
    XFSettingPhaseTypeCellInteracted
} XFSettingPhaseType;

typedef void(^SettingItemOptionBlock)(UITableViewCell *cell,XFSettingPhaseType phaseType,id intentData);

@interface XFSettingItem : NSObject
/** 标题*/
@property (nonatomic, copy) NSString *title;
/** 图标*/
@property (nonatomic, copy) NSString *icon;
/** 关联的Cell类*/
@property (nonatomic, assign) Class relatedCellClass;
/** 交互事件Block*/
@property (nonatomic, copy) SettingItemOptionBlock optionBlock;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)settingItemWithDict:(NSDictionary *)dict;
+ (NSMutableArray *)settingItemsWithArray:(NSArray *)arr;

/**
 *  是否是第一个item
 *
 */
- (BOOL)isFirst;
@end
