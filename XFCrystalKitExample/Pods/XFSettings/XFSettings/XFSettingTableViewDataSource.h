//
//  XFSettingTableViewDataSource.h
//  XFSettings
//
//  Created by 付星 on 16/6/23.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#ifndef XFSettingTableViewDataSource_h
#define XFSettingTableViewDataSource_h

@protocol XFSettingTableViewDataSource <NSObject>

@required
- (NSArray *)settingItems;

@end

#endif /* XFSettingTableViewDataSource_h */
