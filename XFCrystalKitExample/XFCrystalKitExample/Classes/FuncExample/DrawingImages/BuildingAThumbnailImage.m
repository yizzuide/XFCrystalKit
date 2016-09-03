//
//  BuildingAThumbnailImage.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BuildingAThumbnailImage.h"
#import "XFCrystalKit.h"

@implementation BuildingAThumbnailImage

- (void)drawRect:(CGRect)rect {
    UIImage *sourceImage = [UIImage imageNamed:@"gujian2"];
    UIImage *thumbImage = [XFCrystal imageThumbnailBuildFrom:sourceImage targetSize:CGSizeMake(100, 100) useFitting:NO];
    NSLog(@"%@",thumbImage);
    CGRect imageRect = RectCenteredInRect(SizeMakeRect(thumbImage.size),rect);
    [thumbImage drawInRect:imageRect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageRect];
    [[UIColor redColor] set];
    [path stroke];
}
@end
