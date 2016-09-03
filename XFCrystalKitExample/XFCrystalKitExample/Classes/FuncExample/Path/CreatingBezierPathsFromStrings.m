//
//  CreatingBezierPathsFromStrings.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "CreatingBezierPathsFromStrings.h"
#import "XFCrystalKit.h"

@implementation CreatingBezierPathsFromStrings

- (void)drawRect:(CGRect)rect
{
    /**
     *  Interestingly, font size doesn’t play a role in this particular drawing. The path is proportionately scaled to the destination rectangle, so you can use almost any font to create the source.
     */
    UIFont *font = [UIFont fontWithName:@"Baskerville-Bold" size:16];
    UIBezierPath *path = BezierPathFromString(@"Hello World!", font, ^(UIBezierPath *charPath, NSInteger index) {
        // 修改大小、位置使用形变矩阵，然后再应用颜色
        if (index == 1) {
            // 1.1 单个字符处理
            /*MirrorPathVertically(charPath);
             ScalePath(charPath, 5, 5);
             MovePathCenterToPoint(charPath, RectGetCenter(rect));
             [charPath fill:[UIColor redColor]];*/
            
            // 1.2 特殊处理
            ScalePath(charPath, 0.5, 0.5);
            RotatePath(charPath, M_PI_4);
            return charPath.bounds.size.width * 2;
        }
        return .0;
    });
    
    //NSLog(@"%@",path);
    // 2.同时应用多个文本路径
    FitPathToRect(path, rect);
    [path fill:[UIColor orangeColor]];
    [path strokeInside:2];
}
@end
