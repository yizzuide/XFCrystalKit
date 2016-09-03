//
//  BuildingStretchableImages.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "BuildingStretchableImages.h"
#import "XFCrystalKit.h"

@implementation BuildingStretchableImages

- (void)drawRect:(CGRect)rect
{
    CGSize targetSize = CGSizeMake(40, 40);
    
    UIImage *image = [XFCrystal imageStretchableWithSize:targetSize drawBlock:^UIEdgeInsets(CGContextRef context) {
        // Create the outer rounded rectangle
        CGRect targetRect = SizeMakeRect(targetSize);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:12];
        // Fill and stroke it
        [[UIColor purpleColor] setFill];
        [path fill];
        [path stroke];
        // Create the inner rounded rectangle
        UIBezierPath *innerPath = [UIBezierPath bezierPathWithRoundedRect: CGRectInset(targetRect, 4, 4) cornerRadius:8];
        // Stroke it
        [innerPath stroke];
        
        return UIEdgeInsetsMake(12, 12, 12, 12);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = CGRectMake(100, 100, 120, 50);
    imageView.frame = frame;
    imageView.image = image;
    [self addSubview:imageView];
}
@end
