//
//  AddingNoiseTexture.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "AddingNoiseTexture.h"
#import "XFCrystalKit.h"

@implementation AddingNoiseTexture

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 200, 50) cornerRadius:15];
    MovePathCenterToPoint(path, RectGetCenter(rect));
    
    // 使用默认生成的噪点
    //[path fillWithNoiseImage:nil fillColor:[UIColor purpleColor]];
    [path fillWithNoiseImage:[UIImage imageNamed:@"noise"] fillColor:[UIColor purpleColor]];
}
@end
