//
//  XFTableViewAgent.h
//  XFSettings
//
//  Created by 付星 on 16/7/8.
//  Copyright © 2016年 Yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XFSettingsProt;
@interface XFTableViewAgent : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<XFSettingsProt> settingsProt;

@end
