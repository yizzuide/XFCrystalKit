//
//  ImageCutouts.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "ImageCutouts.h"
#import "XFCrystalKit.h"

@implementation ImageCutouts

- (void)drawRect:(CGRect)rect
{
    UIImage *source = [UIImage imageNamed:@"mao"];
    UIBezierPath *paths = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 280, 220)];
    UIBezierPath *imagePath = [UIBezierPath bezierPathWithRect:CGRectMake(20, 56, 120, 80)];
    // 图片文字环绕效果最重要的一行代码!!!
    [paths appendPath:imagePath];
    
    PushDraw(^{
        [imagePath addClip];
        // 缩小填充范围
        CGRect inset = CGRectInset(imagePath.bounds, 5, 5);
        [XFCrystal drawImage:source targetRect:inset drawingPattern:XFImageDrawingPatternFitting];
    });
    
    [paths stroke:1 color:[UIColor orangeColor]];
    
    // 属性文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:@"Thanks(感谢) to the Core Text framework, all drawing takes place in Quartz space. The CGPath you supply must also be defined in Quartz geometry. hat’s why I picked a shape for Figure 8-11 that is not vertically symmetrical. You can handles this drawing issue by copying whatever path you supply and mirroring that copy vertically within the context."];
    // 设置段落格式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.firstLineHeadIndent = 8.0f;
    paragraphStyle.lineSpacing = 5.0f;
    //paragraphStyle.paragraphSpacing = 24.0f; // Big!
    
    
    [attributedString setAttributes:@{
                                      NSFontAttributeName:[UIFont fontWithName:@"Futura" size:10.0f],
                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                      NSParagraphStyleAttributeName:paragraphStyle
                                      } range:NSMakeRange(0, attributedString.length)];
    
    [XFCrystal drawAttributedStringIntoSubpath:paths attributedString:attributedString remainder:nil];
    
}
@end
