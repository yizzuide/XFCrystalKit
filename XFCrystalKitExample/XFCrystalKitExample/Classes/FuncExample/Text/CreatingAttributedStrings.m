//
//  CreatingAttributedStrings.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "CreatingAttributedStrings.h"
#import "XFCrystalKit.h"

@implementation CreatingAttributedStrings

- (void)drawRect:(CGRect)rect
{
    // Create an attributes dictionary
    /*NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
     // Set the font
     attributes[NSFontAttributeName] = [UIFont fontWithName:@"Futura" size:36.0f];
     // Set the foreground color
     attributes[NSForegroundColorAttributeName] = [UIColor orangeColor];
     // Build an attributed string with the dictionary
     NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes: attributes];
     // Draw the attributed string
     [attributedString drawInRect:RectAroundCenter(RectGetCenter(rect), [attributedString size])];*/
    
    
    
    // Mutable Attributed Strings
    // Build mutable attributed string
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:@"Hello World"];
    /*// Set the font
     [attributedString addAttribute:NSFontAttributeName
     value:[UIFont fontWithName:@"Futura" size:36.0f]
     range:NSMakeRange(0, 5)];
     // Set the color
     [attributedString addAttribute:NSForegroundColorAttributeName
     value:[UIColor orangeColor]
     range:NSMakeRange(0, 5)];*/
    [attributedString setAttributes:@{
                                      NSFontAttributeName:[UIFont fontWithName:@"Futura" size:36.0f],
                                      NSForegroundColorAttributeName:[UIColor orangeColor],
                                      NSStrokeColorAttributeName:[UIColor redColor],
                                      NSStrokeWidthAttributeName:@(-2),
                                      NSUnderlineStyleAttributeName:@(NSUnderlineStyleThick | NSUnderlinePatternDash)
                                      } range:NSMakeRange(0, 5)];
    [attributedString drawInRect:RectAroundCenter(RectGetCenter(rect), [attributedString size])];
}

@end
