//
//  XFFuncMenuViewController.h
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFSettings.h"

@interface XFFuncMenuViewController : UIViewController <XFSettingIntentUserInfo>

@property (nonatomic, strong) NSDictionary *userInfo;
@end
