//
//  Drawing3DLetters.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "Drawing3DLetters.h"
#import "XFCrystalKit.h"

@implementation Drawing3DLetters

- (void)drawRect:(CGRect)rect
{
    NSString *string = @"QUARTZ 2D";
    
    DrawStrokedShadowedText(string, @"Baskerville-Bold", [UIColor orangeColor], rect);
}
@end
