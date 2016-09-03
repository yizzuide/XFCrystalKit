//
//  AddingBottomGlow.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "AddingBottomGlow.h"
#import "XFCrystalKit.h"

@implementation AddingBottomGlow

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 200, 50)
                                                    cornerRadius:15];
    FitPathToRect(path, rect);
    ScalePath(path, 0.75, 0.75);
    
    [path fill:[UIColor purpleColor]];
    
    DrawBottomGlow(path, [[UIColor whiteColor] colorWithAlphaComponent:0.75f], 0.35f);
}
@end
