//
//  CreateACustomImage.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "CreateACustomImage.h"
#import "XFCrystalKit.h"

@implementation CreateACustomImage

/**
 *  Here are a few quick things you’ll want to remember about images:
 ▪ You query an image for its extent by inspecting its size property, as in this example. The size is returned in points rather than pixels, so data dimensions may be double the number returned on Retina systems.
 ▪ You transform an image instance to PNG or JPEG data by using the UIImagePNGRepresentation() function or the UIImageJPEGRepresentation() function. These functions return NSData instances containing the compressed image data.
 ▪ You can retrieve an image’s Quartz representation through its CGImage property.The UIImage class is basically a lightweight wrapper around Core Graphics or Core Image images. You need a CGImage reference for many Core Graphics functions. Because this property is not available for images created using Core Image, you must convert the underlying CIImage into a CGImage for use in Core Graphics.
 Note: UIImage supports TIFF, JPEG, GIF, PNG, DIB (that is, BMP), ICO, CUR, and XBM formats. You can load additional formats (like RAW) by using the ImageIO framework.
 *
 */
- (void)drawRect:(CGRect)rect
{
    UIImage *image = [XFCrystal imageContextBuildWithSize:CGSizeMake(100, 100) drawBlock:^(CGContextRef context) {
        [[UIColor greenColor] set];
        UIRectFill(CGRectMake(0, 0, 100, 100));
        [[UIColor redColor] setStroke];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(100, 100)];
        [path stroke];
    } isOpaque:YES];
    
    NSLog(@"%@",NSStringFromCGSize(image.size));
    
    [image drawInRect:RectCenteredInRect(RectMakeRect(CGPointMake(0, 0), image.size),rect)];
}
@end
