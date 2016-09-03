//
//  XFSettingGroup.h
//  XFSettings
//
//  Created by Yizzuide on 15/5/26.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  模型组
 */
@interface XFSettingGroup : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *footer;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)settingGroupWithDict:(NSDictionary *)dict;
+ (NSMutableArray *)settingGroupsWithArray:(NSArray *)arr;
@end
