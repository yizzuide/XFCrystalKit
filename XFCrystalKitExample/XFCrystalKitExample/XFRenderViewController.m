//
//  XFRenderViewController.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "XFRenderViewController.h"

@implementation XFRenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    Class viewClass = self.userInfo[@"ViewClass"];
    [self setUpViewFromClass:viewClass];
}

- (void)setUpViewFromClass:(Class)viewClass
{
    UIView *view = [[viewClass alloc] init];
    view.backgroundColor = [UIColor grayColor];
    CGFloat left = ([UIScreen mainScreen].bounds.size.width - 320) * 0.5f;
    CGRect frame = CGRectMake(left, 100, 320, 240);
    view.frame = frame;
    [self.view addSubview:view];
}

@end
