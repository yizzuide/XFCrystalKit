//
//  XFSettingGroup.m
//  XFSettings
//
//  Created by Yizzuide on 15/5/26.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import "XFSettingGroup.h"
#import "XFSettingItem.h"

@implementation XFSettingGroup

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //[self setValuesForKeysWithDictionary:dict];
        
        self.header = dict[@"header"];
        self.footer = dict[@"footer"];
        
        self.items = [XFSettingItem settingItemsWithArray:dict[@"items"]];
        
    }
    return self;
}

+ (instancetype)settingGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableArray *)settingGroupsWithArray:(NSArray *)arr
{
    NSMutableArray *mArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        [mArr addObject:[[self alloc] initWithDict:item]];
    }];
    return mArr;
}
@end
