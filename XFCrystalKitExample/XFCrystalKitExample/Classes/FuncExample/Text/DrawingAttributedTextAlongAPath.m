//
//  DrawingAttributedTextAlongAPath.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "DrawingAttributedTextAlongAPath.h"
#import "XFCrystalKit.h"

@implementation DrawingAttributedTextAlongAPath

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *star = BezierInflectedShape(5, 1);
    ScalePath(star, 100, 100);
    
    MovePathCenterToPoint(star, RectGetCenter(rect));
    
    [star stroke:1 color:[UIColor whiteColor]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:@"Thanks to the Core Text framework, all drawing takes place in Quartz space. "];
    
    [attributedString setAttributes:@{
                                      NSFontAttributeName:[UIFont fontWithName:@"Futura" size:15.0f],
                                      } range:NSMakeRange(0, attributedString.length)];
    for (int loc = 0; loc < attributedString.length; loc ++) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f  blue:arc4random() % 255 / 255.f  alpha:1] range:NSMakeRange(loc, 1)];
    }
    
    
    [XFCrystal drawAttributedString:attributedString alongPath:star];
    
    
}
@end
