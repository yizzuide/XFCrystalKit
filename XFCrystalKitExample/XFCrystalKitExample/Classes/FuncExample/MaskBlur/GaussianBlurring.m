//
//  GaussianBlurring.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/20.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "GaussianBlurring.h"
#import "XFCrystalKit.h"

@implementation GaussianBlurring

- (void)drawRect:(CGRect)rect
{
    NSDate *date = [NSDate date];
    UIImage *image = [XFCrystal imageGaussianBlurFrom:[UIImage imageNamed:@"gujian2"] radius:10];
    NSLog(@"Elapsed time: %f",[[NSDate date] timeIntervalSinceDate:date]);
    
    [XFCrystal drawImage:image targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
}
@end
