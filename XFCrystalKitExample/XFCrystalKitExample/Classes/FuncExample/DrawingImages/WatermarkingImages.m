//
//  WatermarkingImages.m
//  XFCrystalKitExample
//
//  Created by 付星 on 16/8/19.
//  Copyright © 2016年 yizzuide. All rights reserved.
//

#import "WatermarkingImages.h"
#import "XFCrystalKit.h"

@implementation WatermarkingImages

/**
 *  Watermarking an Image
 It uses a blend mode to highlight the watermark while preserving details of the original photo. Because this listing is specific to iOS 7, you must include a text color along with the font attribute when drawing the string. If you do not, the string will “disappear”.
 Other common approaches are using diffuse white overlays with a moderate alpha level and drawing just a logo’s shadow (without drawing the logo itself) onto some part of an image. Path clipping helps with that latter approach。
 
 *
 */
- (void)drawRect:(CGRect)rect {
    UIImage *sourceImage = [UIImage imageNamed:@"gujian2"];
    
    UIImage *distImage = [XFCrystal imageForWatermarkFrom:sourceImage text:@"古剑奇谭" font:[UIFont fontWithName:@"HelveticaNeue" size:48] color:[UIColor greenColor] renderPosition:CGPointMake(sourceImage.size.width * 0.5, sourceImage.size.height * 0.5) rotation:M_PI_2 blendMode:kCGBlendModeOverlay];
    [XFCrystal drawImage:distImage targetRect:rect drawingPattern:XFImageDrawingPatternCenter];
}

@end
